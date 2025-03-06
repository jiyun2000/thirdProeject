import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thirdproject/Dio/CalendarDio/calendarDio.dart';
import 'package:thirdproject/Page/schedule/DeptScheduleAdd.dart';
import 'package:thirdproject/Page/schedule/SchedulePage.dart';

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

  Future<void> _selectDateTime(BuildContext context,
      TextEditingController controller, bool isStart) async {
    DateTime now = DateTime.now();
    DateTime initialDate = now;

    if (controller.text.isNotEmpty) {
      initialDate = format.parse(controller.text);
    }

    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (selectedTime != null) {
        DateTime finalDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        controller.text = format.format(finalDateTime);
      }
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('입력 오류'),
          content: Text(message),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('개인 일정 등록'),
      ),
      body: Card(
        color: Colors.white,
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _startDateController,
                  decoration: InputDecoration(
                    labelText: '시작 시간',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () =>
                      _selectDateTime(context, _startDateController, true),
                  readOnly: true,
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
                    labelText: '끝난 시간',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () =>
                      _selectDateTime(context, _endDateController, false),
                  readOnly: true,
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
                    labelText: '사원번호',
                    border: OutlineInputBorder(),
                    enabled: false,
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
                        print("등록완료!");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CalendarPage()));
                      } else if (startDate.isAfter(endDate)) {
                        _showErrorDialog(context, '시작 날짜가 끝나는 날짜보다 클 수 없습니다.');
                      } else {
                        print("사원 번호 오류");
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
        child: Text('부서 일정 등록',),
      ),
    );
  }
}
