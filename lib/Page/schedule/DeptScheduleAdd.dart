import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thirdproject/Dio/CalendarDio/calendarDio.dart';
import 'package:thirdproject/Page/schedule/ScheduleAddPage.dart';

class DeptScheduleAdd extends StatefulWidget {
  const DeptScheduleAdd({super.key});

  @override
  State<StatefulWidget> createState() => _DeptScheduleState();
}

class _DeptScheduleState extends State<DeptScheduleAdd> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _scheduleTextController = TextEditingController();
  final TextEditingController _empNoController = TextEditingController();
  final TextEditingController _deptNoController = TextEditingController();

  DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('부서 일정 등록'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              width: 200,
              child: TextField(
                controller: _startDateController,
                decoration: InputDecoration(
                  hintText: '시작 시간을 입력하세요 ',
                  labelText: '시작 시간',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _endDateController,
                decoration: InputDecoration(
                  hintText: '끝난 시간을 입력하세요 ',
                  labelText: '끝난 시간',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _scheduleTextController,
                decoration: InputDecoration(
                  hintText: '내용을 입력하세요 ',
                  labelText: '내용',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _empNoController,
                decoration: InputDecoration(
                  hintText: '사원번호를 입력하세요 ',
                  labelText: '사원번호',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _deptNoController,
                decoration: InputDecoration(
                  hintText: '부서번호를를 입력하세요 ',
                  labelText: '부서번호',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  try {
                    DateTime startDate =
                        format.parse(_startDateController.text);
                    DateTime endDate = format.parse(_endDateController.text);
                    int empNo = int.tryParse(_empNoController.text) ?? 0;
                    int deptNo = int.tryParse(_deptNoController.text) ?? 0;
                    if (startDate.isBefore(endDate) && empNo > 0) {
                      CalendarDio().addDeptSche(startDate, endDate,
                          _scheduleTextController.text, empNo, deptNo);
                    } else {
                      print("틀림");
                    }
                  } catch (e) {
                    print("오류 발생: $e");
                  }
                },
                child: Text('등록'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScheduleAddPage()),
          );
        },
        child: Text('개인 일정 등록'),
      ),
    );
  }
}
