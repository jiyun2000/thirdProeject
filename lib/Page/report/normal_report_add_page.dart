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
  final TextEditingController _titleController = TextEditingController();
  DateTime date = DateTime.now();
  List<int> selectedItems = [];
  List<int> sendingItems = [];
  List<PlatformFile> selectedFiles = []; // 여러 개의 파일 저장

  final ValueNotifier<List<int>> _sendingItemsNotifier = ValueNotifier([]);

  // FocusNode 추가
  final FocusNode _contentFocusNode = FocusNode();
  final FocusNode _titleFocusNode = FocusNode();

  @override
  void dispose() {
    _contentFocusNode.dispose();
    _titleFocusNode.dispose();
    _sendingItemsNotifier.dispose();
    super.dispose();
  }

  // ✅ 여러 개의 파일 선택 함수
  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true, // ✅ 여러 개 선택 가능
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          selectedFiles = result.files; // 전체 파일 리스트 저장
        });
      } else {
        // 사용자가 파일 선택을 취소한 경우
        setState(() {
          selectedFiles = [];
        });
      }
    } catch (e) {
      print('파일 선택 중 오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('보고서 추가 ✍️'),
        backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        // GestureDetector로 화면 터치 시 키보드 내려가도록 설정
        onTap: () {
          // 화면의 다른 부분을 터치하면 포커스를 해제하여 키보드 내려감
          _contentFocusNode.unfocus();
          _titleFocusNode.unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
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

              // ✅ 제목 입력 필드 추가
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5 >= 250
                    ? MediaQuery.of(context).size.width * 0.5
                    : 250,
                child: TextField(
                  controller: _titleController,
                  focusNode: _titleFocusNode, // FocusNode 할당
                  decoration: InputDecoration(
                    hintText: "제목을 입력하세요",
                    labelText: '제목',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // ✅ 내용 입력 필드 (시간 대신 일반 내용 입력)
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5 >= 250
                    ? MediaQuery.of(context).size.width * 0.5
                    : 250,
                child: TextField(
                  controller: _contentController,
                  focusNode: _contentFocusNode, // FocusNode 할당
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
                // 나머지 코드 그대로 유지
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
                onPressed: _pickFiles,
                child: Text('파일 선택 📂'),
              ),
              if (selectedFiles.isNotEmpty) ...[
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: selectedFiles
                      .map((file) => Text("📄 ${file.name}"))
                      .toList(),
                ),
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
                      selectedFiles,
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
