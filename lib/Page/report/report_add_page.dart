import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:thirdproject/Dio/EmpDio/employeesDio.dart';
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

  // UI 업데이트를 위한 ValueNotifier
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
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(date.year + 100, date.month, date.day),
                    );
                    if (selectedDate != null) {
                      date = selectedDate;
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
              width: 200,
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
              future: Employeesdio().getAllEmpListToDropDown(widget.empNo),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('에러 발생: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  List<DropdownItem<int>> parser = snapshot.data!;

                  return Column(
                    children: [
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: MultiDropdown(
                          controller: _receiversController,
                          items: parser,
                          searchEnabled: true,
                          onSelectionChange: (List<int> e) {
                            // 기존 selectedItems와 비교하여 변경된 항목 찾기
                            List<int> addedItems = e
                                .where((item) => !selectedItems.contains(item))
                                .toList();
                            List<int> removedItems = selectedItems
                                .where((item) => !e.contains(item))
                                .toList();

                            // 추가된 값은 sendingItems 마지막에 추가
                            sendingItems.addAll(addedItems);

                            // 빠진 값은 sendingItems에서 제거
                            sendingItems.removeWhere(
                                (item) => removedItems.contains(item));

                            // selectedItems 업데이트
                            selectedItems = List.from(e);

                            // UI 갱신
                            _sendingItemsNotifier.value =
                                List.from(sendingItems);
                          },
                        ),
                      ),
                      SizedBox(height: 20),

                      // 선택된 값들의 label 값을 출력
                      ValueListenableBuilder<List<int>>(
                        valueListenable: _sendingItemsNotifier,
                        builder: (context, value, child) {
                          // sendingItems 리스트의 int 값들을 label 값으로 변환
                          List<String> selectedLabels = value
                              .map((id) => parser
                                  .firstWhere(
                                    (item) => item.value == id,
                                    orElse: () => DropdownItem(
                                        label: '알 수 없음', value: id),
                                  )
                                  .label)
                              .toList();

                          return Text(
                              '보고 순서: ${selectedLabels.join("  ->  ")}');
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
                  // 성공적으로 완료되면 화면 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ReceivedReportListPage(empNo: widget.empNo),
                    ),
                  );
                } catch (e) {
                  // 에러 처리
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
