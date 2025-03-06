import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thirdproject/Dio/CalendarDio/emp_sche_dio.dart';

class ScheduleEmpModPage extends StatefulWidget {
  final int empSchNo;

  const ScheduleEmpModPage({super.key, required this.empSchNo});

  @override
  State<StatefulWidget> createState() => _ScheduleEmpModState();
}

class _ScheduleEmpModState extends State<ScheduleEmpModPage> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _scheduleTextController = TextEditingController();
  final TextEditingController _empNoContorller = TextEditingController();
  final TextEditingController _empSchNoController = TextEditingController();

  int? _empNo;

  @override
  void initState() {
    super.initState();
    _loadEmpNo();
  }

  Future<void> _loadEmpNo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _empNo = prefs.getInt("empNo");
      if (_empNo != null) {
        _empNoContorller.text = _empNo.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('📆개인 스케줄 수정', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: EmpScheDio().readEmpSche(1, widget.empSchNo),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('에러 발생: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              JsonParser jsonParser = snapshot.data!;
              _startDateController.text =
                  jsonParser.startDate.toIso8601String();
              _endDateController.text = jsonParser.endDate.toIso8601String();
              _scheduleTextController.text = jsonParser.scheduleText;
              _empNoContorller.text = jsonParser.empNo.toString();
              _empSchNoController.text = widget.empSchNo.toString();

              return ListView(
                children: [
                  TextField(
                    controller: _startDateController,
                    decoration: InputDecoration(labelText: '시작날짜'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _endDateController,
                    decoration: InputDecoration(labelText: '마감날짜'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _scheduleTextController,
                    decoration: InputDecoration(labelText: '내용'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _empNoContorller,
                    decoration: InputDecoration(labelText: '사원번호'),
                    enabled: false,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _empSchNoController,
                    decoration: InputDecoration(labelText: '스케줄번호'),
                    enabled: false,
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        DateTime startDate =
                            DateTime.parse(_startDateController.text);
                        DateTime endDate =
                            DateTime.parse(_endDateController.text);

                        if (startDate.isAfter(endDate)) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('오류'),
                                content: Text('시작 날짜가 마감 날짜보다 늦을 수 없습니다.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('확인'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          EmpScheDio().modEmpSchedule(
                            startDate,
                            endDate,
                            _scheduleTextController.text,
                            int.parse(_empNoContorller.text),
                            int.parse(_empSchNoController.text),
                          );
                        }
                      },
                      child: Text('수정'),
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        print('삭제');
                        EmpScheDio().delEmpSch(
                          int.parse(_empNoContorller.text),
                          int.parse(_empSchNoController.text),
                        );
                        print('삭제되었습니다.');
                      },
                      child: Text('삭제'),
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: Text('데이터x'));
            }
          },
        ),
      ),
    );
  }
}
