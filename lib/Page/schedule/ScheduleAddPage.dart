import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thirdproject/Dio/CalendarDio/calendarDio.dart';
import 'package:thirdproject/Page/schedule/DeptScheduleAdd.dart';

class ScheduleAddPage extends StatefulWidget {
  const ScheduleAddPage({super.key});

  @override
  State<StatefulWidget> createState() => _ScheduleAddState();
}

class _ScheduleAddState extends State<ScheduleAddPage> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _scheduleTextController = TextEditingController();
  final TextEditingController _empNoContorller = TextEditingController();

  DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('개인 일정 등록'),
      ),
      body: Container(
        child: Center(
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
                  controller: _empNoContorller,
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
                child: ElevatedButton(
                  onPressed: () {
                    try {
                      DateTime startDate =
                          format.parse(_startDateController.text);
                      DateTime endDate = format.parse(_endDateController.text);
                      int empNo = int.tryParse(_empNoContorller.text) ?? 0;
                      if (startDate.isBefore(endDate) && empNo > 0) {
                        CalendarDio().addEmpSchedule(startDate, endDate,
                            _scheduleTextController.text, empNo);
                      } else {
                        print("틀림림");
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DeptScheduleAdd()),
          );
        },
        child: Text('부서 일정 등록'),
      ),
    );
  }
}
