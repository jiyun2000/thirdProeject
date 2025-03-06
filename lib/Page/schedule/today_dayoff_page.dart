import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thirdproject/Dio/CalendarDio/todayDayOffDio.dart';  
import 'package:table_calendar/table_calendar.dart';
import 'package:thirdproject/Dio/EmpDio/employeesDio.dart';
import 'package:thirdproject/Page/board/BoardPage.dart';
import 'package:thirdproject/Page/employee/MyPage.dart';
import 'package:thirdproject/Page/report/received_report_list_page.dart';
import 'package:thirdproject/Page/schedule/SchedulePage.dart';
import 'package:thirdproject/diointercept%20.dart';
import 'package:thirdproject/main.dart';

// 이벤트 클래스 정의
class Event {
  final int empNo;  // 직원 번호
  final DateTime startDate;  // 시작 날짜
  final DateTime endDate;    // 종료 날짜
  final String title;        // 제목
  final String type;         // 유형 (연차 등)

  Event({
    this.empNo = 0,
    required this.startDate,  
    required this.endDate,    
    required this.title,
    required this.type
  });
}

// 오늘 연차 페이지 클래스
class TodayDayOffPage extends StatefulWidget {
  final DateTime dayOffDate;  // 연차 날짜
  const TodayDayOffPage({super.key, required this.dayOffDate});

  @override
  State<StatefulWidget> createState() => _TodayDayOffState();
}

class _TodayDayOffState extends State<TodayDayOffPage> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late CalendarFormat _calendarFormat;
  List<Event> _deptAllEvents = [];

  // 직원 번호 가져오기
  Future<int> getEmpNo() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt('empNo') ?? 0;
  }

  String strToday = DateFormat("yyyy-MM-dd").format(DateTime.now());

  // 부서 번호 가져오기
  Future<int> getDeptNo() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt("deptNo") ?? 0;
  }

  // 이메일 가져오기
  Future<String> getEmail() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('email') ?? '이메일 없음';
  }

  // 이름 가져오기
  Future<String> getName(int empNo) async {
    var jsonParser = await Employeesdio().findByEmpNo(empNo);
    return '${jsonParser.firstName} ${jsonParser.lastName}';
  }

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.dayOffDate;
    _selectedDay = widget.dayOffDate;
    _calendarFormat = CalendarFormat.month;
    _loadAllDayOffEvents();  // 연차 이벤트 로드
  }

  // 연차 이벤트를 모두 로드하는 함수
  Future<void> _loadAllDayOffEvents() async {
    var result = await todayDayOffDio().getAllDayOffList(); 

    List<Event> events = result.map((e) => Event(
      empNo: e.empNo,
      startDate: e.dayOffDate, 
      endDate: e.dayOffDate,    
      title: '연차',
      type: 'dayoff'
    )).toList();

    setState(() {
      _deptAllEvents = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('연차 사용 인원'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            // 이메일과 이름을 불러오는 FutureBuilder
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
                      if (empNoSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (empNoSnapshot.hasError) {
                        return Center(child: Text('Error: ${empNoSnapshot.error}'));
                      } else if (empNoSnapshot.hasData) {
                        int empNo = empNoSnapshot.data!;
                        return FutureBuilder<String>(
                          future: getName(empNo),
                          builder: (context, nameSnapshot) {
                            if (nameSnapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (nameSnapshot.hasError) {
                              return Center(child: Text('Error: ${nameSnapshot.error}'));
                            } else if (nameSnapshot.hasData) {
                              return UserAccountsDrawerHeader(
                                currentAccountPicture: CircleAvatar(),
                                accountEmail: Text(emailSnapshot.data!),
                                accountName: Text(nameSnapshot.data!),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 255, 255, 255),
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
            // 다른 메뉴 아이템들
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
              title: Text('연차'),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => MainApp()));
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // 테이블 캘린더 표시
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
                List<Event> dayEvents = _deptAllEvents.where((event) {
                  return isSameDay(day, event.startDate); 
                }).toList();

                if (dayEvents.isNotEmpty) {
                  return Container(
                    width: 35,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
            onDaySelected: (selectedDay, focusedDay) async {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });

                String formattedDate = DateFormat("yyyy-MM-dd").format(selectedDay);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TableEvents(
                      selectedDay: formattedDate,
                      type: 'dayoff',  
                    ),
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

// 연차 사용 인원 목록 페이지
class TableEvents extends StatefulWidget {
  final String selectedDay;
  final String type; 

  TableEvents({super.key, required this.selectedDay, required this.type});

  @override
  _TableEventsState createState() => _TableEventsState();
}

class _TableEventsState extends State<TableEvents> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  Future<String> getName(int empNo) async {
    var jsonParser = await Employeesdio().findByEmpNo(empNo);
    return '${jsonParser.firstName} ${jsonParser.lastName}';
  }

  @override
  void initState() {
    super.initState();
    _selectedEvents = ValueNotifier<List<Event>>([]);
    _getEventsForDay(widget.selectedDay);
  }

  // 연차 이벤트를 불러오는 함수
  Future<void> _getEventsForDay(String? day) async {
    if (day == null) return;

    if (widget.type == 'dayoff') {
      var result = await todayDayOffDio().getAllList(DateTime.parse(day));
      List<Event> dayOffevt = result.map((e) => Event(
        empNo: e.empNo,
        startDate: e.dayOffDate,
        endDate: e.dayOffDate,
        title: '연차',
        type: 'dayoff'
      )).toList();

      setState(() {
        _selectedEvents.value = dayOffevt;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('연차 사용 인원 목록'),backgroundColor: Colors.white,),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(16.0),
          child: Text(widget.selectedDay != null ? DateFormat('yyyy년 MM월 dd일').format(DateTime.parse(widget.selectedDay!))
                  : '선택된 날짜 없음',
                  style: TextStyle(fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black))),
          Expanded(child:  ValueListenableBuilder<List<Event>>(
            valueListenable: _selectedEvents,
            builder: (context, events, _) {
              return ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  Event event = events[index];
                    return FutureBuilder(future:getName(event.empNo), 
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(child: CircularProgressIndicator());
                      }else if(snapshot.hasError){
                        return Center(child: Text('Error : ${snapshot.error}'));
                      }else if(snapshot.hasData){
                          return ListTile(
                        title: Text('이름: ${snapshot.data}'),
                      );
                      }
                      return Container();
                    },);
                    
                },
              );
            },
          ),)
         
        ],
      ),
    );
  }
}
