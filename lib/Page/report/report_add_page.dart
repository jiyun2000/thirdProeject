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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('연차 추가💰'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
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
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _contentController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: "시간을 입력하세요",
                      labelText: '시간',
                      border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FutureBuilder<List<DropdownItem<int>>>(
                future: Employeesdio().getAllEmpListToDropDown(widget.empNo),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('에러 발생: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    List<DropdownItem<int>> parser = snapshot.data!;
                    return MultiDropdown(
                      controller: _receiversController,
                      items: parser,
                      // onSelectionChange: (List<int> e) {
                      //   selectedItems.add(e[0]);
                      //   print(selectedItems);
                      // },
                    );
                  } else {
                    return Center(child: Text('데이터 없음'));
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              Text('Selected items: ${selectedItems.join(', ')}'),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await ReportDio().addReport(
                            date,
                            int.parse(_contentController.text),
                            _receiversController.selectedItems,
                            widget.empNo);
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
                      ;
                    },
                    child: Text('등록')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
