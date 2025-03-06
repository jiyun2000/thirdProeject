import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thirdproject/Dio/CalendarDio/calendarDio.dart';
import 'package:thirdproject/Dio/EmpDio/employeesDio.dart';
import 'package:thirdproject/Page/board/BoardPage.dart';
import 'package:thirdproject/Page/employee/MyPage.dart';
import 'package:thirdproject/Page/report/received_report_list_page.dart';
import 'package:thirdproject/Page/schedule/ScheduleAddPage.dart';
import 'package:thirdproject/Page/schedule/ScheduleDeptModPage.dart';
import 'package:thirdproject/Page/schedule/ScheduleEmpModPage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:thirdproject/Page/schedule/today_dayoff_page.dart';
import 'package:thirdproject/diointercept%20.dart';
import 'package:thirdproject/main.dart';

class Event {
  final String title;
  final String type;
  final int empSchNo;
  final int deptSchNo;
  final DateTime startDate;
  final DateTime endDate;

  Event({
    required this.title,
    required this.type,
    this.empSchNo = 0,
    this.deptSchNo = 0,
    required this.startDate,
    required this.endDate,
  });

  @override
  String toString() => title;
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarState();
}

String dayFormat = DateFormat("yyyy-MM-dd").format(DateTime.now());

class _CalendarState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Event> _allEvents = [];

  Future<int> getEmpNo() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt('empNo') ?? 0;
  }

  Future<int> getDeptNo() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt('deptNo') ?? 0;
  }

  @override
  void initState() {
    super.initState();
    _loadAllEvents();
  }

  void _loadAllEvents() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      int empNo = prefs.getInt("empNo") ?? 0;
      int deptNo = prefs.getInt("deptNo") ?? 0;

      Map<String, dynamic> events =
          await CalendarDio().findByMap(empNo, deptNo);

      List<Event> empEvents = (events['empSchedule'] as List).map((text) {
        DateTime startDate = DateTime.parse(text['startDate']);
        DateTime endDate = DateTime.parse(text['endDate']);
        String dateOnly = text['scheduleText'] + "  " + text['startDate'];
        int empSchNo = text['empSchNo'];
        return Event(
          title: dateOnly,
          type: 'emp',
          empSchNo: empSchNo,
          startDate: startDate,
          endDate: endDate,
        );
      }).toList();

      List<Event> deptEvents = (events['deptSchedule'] as List).map((text) {
        DateTime startDate = DateTime.parse(text['startDate']);
        DateTime endDate = DateTime.parse(text['endDate']);
        String dateOnly = text['scheduleText'] + "  " + text['startDate'];
        int deptSchNo = text['deptSchNo'];
        return Event(
          title: dateOnly,
          type: 'dept',
          deptSchNo: deptSchNo,
          startDate: startDate,
          endDate: endDate,
        );
      }).toList();

      setState(() {
        _allEvents = [...empEvents, ...deptEvents];
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  String strToday = DateFormat("yyyy-MM-dd").format(DateTime.now());

  Future<String> getEmail() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('email') ?? '이메일 없음';
  }

  Future<String> getName(int empNo) async {
    var jsonParser = await Employeesdio().findByEmpNo(empNo);
    return '${jsonParser.firstName} ${jsonParser.lastName}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('📆일정'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            FutureBuilder<String>(
              future: getEmail(),
              builder: (context, emailSnapshot) {
                if (emailSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (emailSnapshot.hasError) {
                  return Center(child: Text('Error: ${emailSnapshot.error}'));
                } else if (emailSnapshot.hasData) {
                  return FutureBuilder<int>(
                    future: getEmpNo(),
                    builder: (context, empNoSnapshot) {
                      if (empNoSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (empNoSnapshot.hasError) {
                        return Center(
                            child: Text('Error: ${empNoSnapshot.error}'));
                      } else if (empNoSnapshot.hasData) {
                        int empNo = empNoSnapshot.data!;
                        return FutureBuilder<String>(
                          future: getName(empNo),
                          builder: (context, nameSnapshot) {
                            if (nameSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (nameSnapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${nameSnapshot.error}'));
                            } else if (nameSnapshot.hasData) {
                              return UserAccountsDrawerHeader(
                                currentAccountPicture: Container(
                                  child: SvgPicture.asset(
                                    "assets/image/logo.svg",
                                  ),
                                ),
                                accountEmail: Text(emailSnapshot.data!),
                                accountName: Text(nameSnapshot.data!),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                  ),
                                ),
                              );
                            } else {
                              return Center(child: Text('이름 실패'));
                            }
                          },
                        );
                      } else {
                        return Center(child: Text('empNo 실패'));
                      }
                    },
                  );
                } else {
                  return Center(child: Text('이메일 실패'));
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.home),
              iconColor: Colors.purple,
              focusColor: Colors.purple,
              title: Text('홈'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications_none_sharp),
              iconColor: Colors.purple,
              focusColor: Colors.purple,
              title: Text('공지사항'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BoardPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.report),
              iconColor: Colors.purple,
              focusColor: Colors.purple,
              title: Text('보고서'),
              onTap: () async {
                var prefs = await SharedPreferences.getInstance();
                int empNo = prefs.getInt("empNo") ?? 0;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReceivedReportListPage(
                      empNo: empNo,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_month),
              iconColor: Colors.purple,
              focusColor: Colors.purple,
              title: Text('일정'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CalendarPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.travel_explore_sharp),
              iconColor: Colors.purple,
              focusColor: Colors.purple,
              title: Text('오늘 연차'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TodayDayOffPage(
                        dayOffDate: DateFormat("yyyy-MM-dd").parse(strToday),
                      ),
                    ));
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              iconColor: Colors.purple,
              focusColor: Colors.purple,
              title: Text('마이페이지'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              iconColor: Colors.purple,
              focusColor: Colors.purple,
              title: Text('로그아웃'),
              onTap: () {
                !DioInterceptor.isLogin();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainApp()));
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2024, 1, 1),
            lastDay: DateTime(2030, 12, 31),
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, List<dynamic> events) {
                List<Event> dayEvents = _allEvents.where((event) {
                  return day.isAfter(
                          event.startDate.subtract(Duration(days: 1))) &&
                      day.isBefore(event.endDate.add(Duration(days: 0)));
                }).toList();

                if (dayEvents.isNotEmpty) {
                  return Container(
                    width: 35,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 253, 158, 158)
                          .withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });

                String formattedDate =
                    DateFormat("yyyy-MM-dd").format(selectedDay);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TableEvents(selectedDay: formattedDate),
                  ),
                );
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
        ],
      ),
    );
  }
}

class TableEvents extends StatefulWidget {
  final String? selectedDay;

  const TableEvents({super.key, this.selectedDay});

  @override
  State<TableEvents> createState() => _TableEventsState();
}

class _TableEventsState extends State<TableEvents> {
  late final ValueNotifier<Future<List<Event>>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _selectedEvents = ValueNotifier(_getEventsForDay(widget.selectedDay));
  }

  Future<List<Event>> _getEventsForDay(String? day) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      int empNo = prefs.getInt("empNo") ?? 0;
      int deptNo = prefs.getInt("deptNo") ?? 0;
      empDto jsonParser = await CalendarDio()
          .todaySchedule(empNo, deptNo, DateTime.parse(day!));

      List<Event> empEvents = jsonParser.empSchedule.map((text) {
        DateTime startDate = DateTime.parse(text['startDate']);
        DateTime endDate = DateTime.parse(text['endDate']);
        String dateOnly = text['scheduleText'] + "  " + text['startDate'];
        int empSchNo = text['empSchNo'];
        return Event(
          title: '[개인]  $dateOnly',
          type: 'emp',
          empSchNo: empSchNo,
          startDate: startDate,
          endDate: endDate,
        );
      }).toList();

      List<Event> deptEvents = jsonParser.deptSchedule.map((text) {
        DateTime startDate = DateTime.parse(text['startDate']);
        DateTime endDate = DateTime.parse(text['endDate']);
        String dateOnly = text['scheduleText'] + "  " + text['startDate'];
        int deptSchNo = text['deptSchNo'];
        return Event(
          title: '[부서]  $dateOnly',
          type: 'dept',
          deptSchNo: deptSchNo,
          startDate: startDate,
          endDate: endDate,
        );
      }).toList();

      return [...empEvents, ...deptEvents];
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('일정'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<Future<List<Event>>>(
              valueListenable: _selectedEvents,
              builder: (context, futureEvents, _) {
                return FutureBuilder<List<Event>>(
                  future: futureEvents,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      List<Event> events = snapshot.data!;
                      return ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          Event event = events[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ListTile(
                              onTap: () {
                                if (event.type == 'emp') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ScheduleEmpModPage(
                                        empSchNo: event.empSchNo,
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ScheduleDeptModPage(
                                        deptSchNo: event.deptSchNo,
                                      ),
                                    ),
                                  );
                                }
                              },
                              title: Text(
                                event.title,
                                style: TextStyle(
                                  color: event.type == 'emp'
                                      ? const Color.fromARGB(251, 0, 0, 0)
                                      : Colors.purple,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(child: Text('오늘은 일정이 없어요'));
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScheduleAddPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
