import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:thirdproject/Dio/EmpDio/empDetailDio.dart';
import 'package:thirdproject/Dio/ReportDio/reportDio.dart';
import 'package:thirdproject/Page/report/received_report_list_page.dart';
import 'package:file_picker/file_picker.dart'; // ✅ 추가

class NormalReportAddPage extends StatefulWidget {
  final int empNo;
  const NormalReportAddPage({super.key, required this.empNo});

  @override
  State<StatefulWidget> createState() => _NormalReportAddState();
}

class _NormalReportAddState extends State<NormalReportAddPage> {
  final MultiSelectController<int> _receiversController =
      MultiSelectController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController =
      TextEditingController(); // ✅ 제목 입력 추가
  DateTime date = DateTime.now();
  List<int> selectedItems = [];
  List<int> sendingItems = [];
  String? selectedFilePath; // ✅ 선택한 파일 경로 저장

  final ValueNotifier<List<int>> _sendingItemsNotifier = ValueNotifier([]);

  @override
  void dispose() {
    _sendingItemsNotifier.dispose();
    super.dispose();
  }

  // ✅ 파일 선택 함수
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedFilePath = result.files.single.name; // 파일 이름만 저장
      });
    } else {
      setState(() {
        selectedFilePath = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('보고서 추가 ✍️'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // ✅ 제목 입력 필드 추가
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5 >= 250
                    ? MediaQuery.of(context).size.width * 0.5
                    : 250,
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: "제목을 입력하세요",
                    labelText: '제목',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('마감 기한 : '),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime.now(),
                        lastDate:
                            DateTime(date.year + 100, date.month, date.day),
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

              // ✅ 내용 입력 필드 (시간 대신 일반 내용 입력)
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5 >= 250
                    ? MediaQuery.of(context).size.width * 0.5
                    : 250,
                child: TextField(
                  controller: _contentController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "내용을 입력하세요",
                    labelText: '내용',
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
                                      .where((item) =>
                                          !selectedItems.contains(item))
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
              SizedBox(height: 20),

              // ✅ 파일 선택 버튼 추가
              ElevatedButton(
                onPressed: _pickFile,
                child: Text('파일 선택 📂'),
              ),
              if (selectedFilePath != null) ...[
                SizedBox(height: 10),
                Text("선택된 파일: $selectedFilePath"),
              ],
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  try {
                    await ReportDio().addNormalReport(
                      _titleController.text,
                      _contentController.text,
                      date,
                      sendingItems,
                      widget.empNo,
                      selectedFilePath,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReceivedReportListPage(
                          empNo: widget.empNo,
                        ),
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
      ),
    );
  }
}
