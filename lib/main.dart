import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController mailContorller = TextEditingController();
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(''),
          centerTitle: true,
        ),
        body: isLoggedIn
            ? BasicApp()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(100),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: SvgPicture.asset(
                          "assets/image/logo.svg",
                          width: 150,
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: '이메일'),
                        controller: mailContorller,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(labelText: '비밀번호'),
                        controller: passwordController,
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 16),
                        child: ElevatedButton(
                          onPressed: () {
                            log("!!!");
                            DioInterceptor.postHttp(
                                "http://localhost:8080/auth",
                                ({
                                  "username": mailContorller.text,
                                  "password": passwordController.text
                                }));
                            if (DioInterceptor.isLogin()) {
                              setState(() {
                                isLoggedIn = true;
                              });
                            } else {
                              print("false");
                            }
                          },
                          child: Text('로그인'),
                        ),
                      )
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
      theme: ThemeData(primaryColor: const Color.fromARGB(255, 255, 255, 255)),
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
      appBar: AppBar(title: Text('DDT'), centerTitle: true, elevation: 0.0),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                  //backgroundImage: AssetImage("assets/image/logo.svg"),
                  ),
              accountEmail: Text("admin"),
              accountName: Text("관리자"),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
              ),
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
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Text('환영합니다 '),
          Center(child: Text('출퇴근 연동시키기')),
          FutureBuilder<int>(
            future: getEmpNo(),
            builder: (context, empNoSnapshot) {
              if (empNoSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (empNoSnapshot.hasError) {
                return Center(child: Text('Error: ${empNoSnapshot.error}'));
              } else if (empNoSnapshot.hasData) {
                int empNo = empNoSnapshot.data!;
                return FutureBuilder(
                  future: emp.EmpScheDio()
                      .readEmpTodo(empNo, DateTime.parse(strToday)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      List<emp.JsonParser> empSchedule = snapshot.data ?? [];
                      if (empSchedule.isEmpty) {
                        return Center(child: Text("오늘 개인 일정 없음"));
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16),
                              leading: Icon(Icons.circle),
                              title: Text(empSchedule[index].scheduleText,
                                  style: TextStyle(fontSize: 16)),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(height: 10, thickness: 1);
                        },
                        itemCount: empSchedule.length,
                      );
                    } else {
                      return Center(child: Text("오늘 개인 일정 없음"));
                    }
                  },
                );
              } else {
                return Center(child: Text("empNo를 불러오는 데 실패했습니다"));
              }
            },
          ),
          FutureBuilder<int>(
            future: getDeptNo(),
            builder: (context, deptNoSnapshot) {
              if (deptNoSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (deptNoSnapshot.hasError) {
                return Center(child: Text('Error : ${deptNoSnapshot.error}'));
              } else if (deptNoSnapshot.hasData) {
                int deptNo = deptNoSnapshot.data!;

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
                      return FutureBuilder(
                        future: dept.DeptScheDio().readDeptTodo(
                            empNo, deptNo, DateTime.parse(strToday)),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            List<dept.JsonParser> deptSchedule = snapshot.data!;
                            if (deptSchedule.isEmpty) {
                              return Center(child: Text("오늘 부서 일정 없음"));
                            }
                            return ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Card(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(16),
                                    leading: Icon(Icons.circle),
                                    title: Text(
                                        deptSchedule[index].scheduleText,
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Divider(height: 10, thickness: 1);
                              },
                              itemCount: deptSchedule.length,
                            );
                          } else {
                            return Center(child: Text("오늘 부서 일정 없음"));
                          }
                        },
                      );
                    } else {
                      return Center(child: Text("empNo를 불러오는 데 실패했습니다"));
                    }
                  },
                );
              }
              return Container();
            },
          )
        ],
      ),
    );
  }
}
