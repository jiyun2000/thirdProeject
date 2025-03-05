import 'dart:developer';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:thirdproject/Dio/CalendarDio/dept_sche_dio.dart' as dept;
import 'package:thirdproject/Dio/CalendarDio/emp_sche_dio.dart' as emp;
import 'package:thirdproject/Page/board/BoardPage.dart';
import 'package:thirdproject/Page/employee/MyPage.dart';
import 'package:thirdproject/Page/schedule/SchedulePage.dart';
import 'package:thirdproject/Page/report/received_report_list_page.dart';
import 'package:thirdproject/Page/schedule/today_dayoff_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thirdproject/diointercept%20.dart';

void main() async {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.purple[100], // 메인 색상
        //backgroundColor: Colors.white, // 전체 배경색
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(''),
          centerTitle: true,
          elevation: 0.0,
          //backgroundColor: Colors.purple[100], // 앱바 색상
        ),
        body: isLoggedIn
            ? BasicApp()
            : SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: SvgPicture.asset(
                          "assets/image/logo.svg",
                          width: 150,
                        ),
                      ),
                      SizedBox(height: 20),
                      // 이메일 텍스트 필드
                      Container(
                        width: MediaQuery.of(context).size.width *
                            0.5, // 화면의 60% 너비
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: '이메일',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.email),
                          ),
                          controller: mailController,
                        ),
                      ),
                      SizedBox(height: 20),
                      // 비밀번호 텍스트 필드
                      Container(
                        width: MediaQuery.of(context).size.width *
                            0.5, // 화면의 60% 너비
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: '비밀번호',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.lock),
                          ),
                          controller: passwordController,
                        ),
                      ),
                      SizedBox(height: 30),
                      // 로그인 버튼
                      Container(
                        width: MediaQuery.of(context).size.width *
                            0.5, // 화면의 60% 너비
                        margin: const EdgeInsets.only(top: 16),
                        child: ElevatedButton(
                          onPressed: () {
                            log("로그인 버튼 클릭!");
                            DioInterceptor.postHttp(
                              "http://localhost:8080/auth",
                              ({
                                "username": mailController.text,
                                "password": passwordController.text,
                              }),
                            );
                            if (DioInterceptor.isLogin()) {
                              setState(() {
                                isLoggedIn = true;
                              });
                            } else {
                              print("로그인 실패");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple[100], // 버튼 색상
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            '로그인',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class BasicApp extends StatelessWidget {
  const BasicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DDT Web',
      theme: ThemeData(primaryColor: Colors.white),
      home: MainPage(),
    );
  }
}

String dayFormat = DateFormat("yyyy-MM-dd").format(DateTime.now());

class MainPage extends StatelessWidget {
  MainPage({super.key});
  String strToday = DateFormat("yyyy-MM-dd").format(DateTime.now());

  Future<int> getEmpNo() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt("empNo") ?? 0;
  }

  Future<int> getDeptNo() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt("deptNo") ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DDT',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Make the text bold
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.purple[100], // 앱바 색상
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.purple),
              ),
              accountEmail: Text("메일 주소"),
              accountName: Text("이름"),
              decoration: BoxDecoration(
                color: Colors.purple[100], // 배경 색상
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
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
              title: Text('로그아웃'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Text
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Center(
                  child: Text(
                    '환영합니다!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),

              // Personal Schedule Section
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  '오늘의 개인 일정',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              FutureBuilder<int>(
                future: getEmpNo(),
                builder: (context, empNoSnapshot) {
                  if (empNoSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return _buildLoadingCard();
                  } else if (empNoSnapshot.hasError) {
                    return _buildErrorCard('Error: ${empNoSnapshot.error}');
                  } else if (empNoSnapshot.hasData) {
                    int empNo = empNoSnapshot.data!;
                    return FutureBuilder(
                      future: emp.EmpScheDio()
                          .readEmpTodo(empNo, DateTime.parse(strToday)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return _buildLoadingCard();
                        } else if (snapshot.hasError) {
                          return _buildErrorCard('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          List<emp.JsonParser> empSchedule =
                              snapshot.data ?? [];
                          if (empSchedule.isEmpty) {
                            return _buildEmptyStateCard('오늘 개인 일정 없음');
                          }
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return _buildScheduleCard(
                                  empSchedule[index].scheduleText);
                            },
                            separatorBuilder: (context, index) {
                              return Divider(
                                  height: 10,
                                  thickness: 1,
                                  color: Colors.grey[300]);
                            },
                            itemCount: empSchedule.length,
                          );
                        } else {
                          return _buildEmptyStateCard('오늘 개인 일정 없음');
                        }
                      },
                    );
                  } else {
                    return _buildErrorCard('empNo를 불러오는 데 실패했습니다');
                  }
                },
              ),

              SizedBox(
                height: 30,
              ),
              // Department Schedule Section
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 16.0),
                child: Text(
                  '오늘의 부서 일정',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              FutureBuilder<int>(
                future: getDeptNo(),
                builder: (context, deptNoSnapshot) {
                  if (deptNoSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return _buildLoadingCard();
                  } else if (deptNoSnapshot.hasError) {
                    return _buildErrorCard('Error: ${deptNoSnapshot.error}');
                  } else if (deptNoSnapshot.hasData) {
                    int deptNo = deptNoSnapshot.data!;
                    return FutureBuilder<int>(
                      future: getEmpNo(),
                      builder: (context, empNoSnapshot) {
                        if (empNoSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return _buildLoadingCard();
                        } else if (empNoSnapshot.hasError) {
                          return _buildErrorCard(
                              'Error: ${empNoSnapshot.error}');
                        } else if (empNoSnapshot.hasData) {
                          int empNo = empNoSnapshot.data!;
                          return FutureBuilder(
                            future: dept.DeptScheDio().readDeptTodo(
                                empNo, deptNo, DateTime.parse(strToday)),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return _buildLoadingCard();
                              } else if (snapshot.hasError) {
                                return _buildErrorCard(
                                    'Error: ${snapshot.error}');
                              } else if (snapshot.hasData) {
                                List<dept.JsonParser> deptSchedule =
                                    snapshot.data!;
                                if (deptSchedule.isEmpty) {
                                  return _buildEmptyStateCard('오늘 부서 일정 없음');
                                }
                                return ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return _buildScheduleCard(
                                        deptSchedule[index].scheduleText);
                                  },
                                  separatorBuilder: (context, index) {
                                    return Divider(
                                        height: 10,
                                        thickness: 1,
                                        color: Colors.grey[300]);
                                  },
                                  itemCount: deptSchedule.length,
                                );
                              } else {
                                return _buildEmptyStateCard('오늘 부서 일정 없음');
                              }
                            },
                          );
                        } else {
                          return _buildErrorCard('empNo를 불러오는 데 실패했습니다');
                        }
                      },
                    );
                  } else {
                    return _buildErrorCard('deptNo를 불러오는 데 실패했습니다');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper method to build a schedule card
Widget _buildScheduleCard(String scheduleText) {
  return Card(
    margin: EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 4,
    child: ListTile(
      contentPadding: EdgeInsets.all(16),
      leading: Icon(Icons.circle, color: Colors.purple[300]),
      title: Text(
        scheduleText,
        style: TextStyle(fontSize: 16),
      ),
    ),
  );
}

// Helper method to build loading state card
Widget _buildLoadingCard() {
  return Card(
    margin: EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 4,
    child: ListTile(
      contentPadding: EdgeInsets.all(16),
      title: Center(child: CircularProgressIndicator()),
    ),
  );
}

// Helper method to build error state card
Widget _buildErrorCard(String message) {
  return Card(
    margin: EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 4,
    child: ListTile(
      contentPadding: EdgeInsets.all(16),
      title: Center(child: Text(message, style: TextStyle(color: Colors.red))),
    ),
  );
}

// Helper method to build empty state card
Widget _buildEmptyStateCard(String message) {
  return Card(
    margin: EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 4,
    child: ListTile(
      contentPadding: EdgeInsets.all(16),
      title: Center(child: Text(message, style: TextStyle(color: Colors.grey))),
    ),
  );
}
