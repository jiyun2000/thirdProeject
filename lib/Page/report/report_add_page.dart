import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:thirdproject/Dio/EmpDio/empDetailDio.dart';
import 'package:thirdproject/Dio/ReportDio/reportDio.dart';
import 'package:thirdproject/Page/report/received_report_list_page.dart';

class ReportAddPage extends StatefulWidget {
  final int empNo;
  const ReportAddPage({super.key, required this.empNo});

  @override
  State<StatefulWidget> createState() => _ReportAddState();
}

class _ReportAddState extends State<ReportAddPage> {
  final MultiSelectController<int> _receiversController =
      MultiSelectController();
  final TextEditingController _contentController = TextEditingController();
  DateTime date = DateTime.now();
  List<int> selectedItems = [];
  List<int> sendingItems = [];
  int count = 0;

  final ValueNotifier<List<int>> _sendingItemsNotifier = ValueNotifier([]);

  @override
  void dispose() {
    _sendingItemsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('연차 추가💰'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('사용할 날짜 : '),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(date.year + 100, date.month, date.day),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        date = selectedDate;
                      });
                    }
                  },
                  child: Text(
                    "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5 >= 250
                  ? MediaQuery.of(context).size.width * 0.5
                  : 250,
              child: TextField(
                controller: _contentController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "시간을 입력하세요",
                  labelText: '시간',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            FutureBuilder<List<DropdownItem<int>>>(
              future: EmpDetailDio().getAllEmpListToDropDown(widget.empNo),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('에러 발생: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  List<DropdownItem<int>> parser = snapshot.data!;

                  return Column(
                    children: [
                      Wrap(
                        children: [
                          SizedBox(
                            width:
                                MediaQuery.of(context).size.width * 0.5 >= 250
                                    ? MediaQuery.of(context).size.width * 0.5
                                    : 250,
                            child: MultiDropdown(
                              controller: _receiversController,
                              items: parser,
                              searchEnabled: true,
                              onSelectionChange: (List<int> e) {
                                List<int> addedItems = e
                                    .where(
                                        (item) => !selectedItems.contains(item))
                                    .toList();
                                List<int> removedItems = selectedItems
                                    .where((item) => !e.contains(item))
                                    .toList();

                                sendingItems.addAll(addedItems);
                                sendingItems.removeWhere(
                                    (item) => removedItems.contains(item));

                                selectedItems = List.from(e);
                                _sendingItemsNotifier.value =
                                    List.from(sendingItems);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ValueListenableBuilder<List<int>>(
                        valueListenable: _sendingItemsNotifier,
                        builder: (context, value, child) {
                          List<String> selectedLabels = value
                              .map((id) => parser
                                  .firstWhere((item) => item.value == id,
                                      orElse: () => DropdownItem(
                                          label: '알 수 없음', value: id))
                                  .label)
                              .toList();
                          return Text(
                            '보고 순서: \n${selectedLabels.join("\n->  ")}',
                            softWrap: true,
                          );
                        },
                      ),
                    ],
                  );
                } else {
                  return Center(child: Text('데이터 없음'));
                }
              },
            ),
            SizedBox(width: 200),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ReportDio().addReport(
                    date,
                    int.parse(_contentController.text),
                    sendingItems,
                    widget.empNo,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReceivedReportListPage(),
                    ),
                  );
                } catch (e) {
                  print('에러 발생: $e');
                }
              },
              child: Text('등록'),
            ),
          ],
        ),
      ),
    );
  }
}
