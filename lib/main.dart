import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:thirdproject/Dio/CalendarDio/dept_sche_dio.dart' as dept;
import 'package:thirdproject/Dio/CalendarDio/emp_sche_dio.dart' as emp;
import 'package:thirdproject/Dio/EmpDio/employeesDio.dart';
import 'package:thirdproject/Page/board/BoardPage.dart';
import 'package:thirdproject/Page/employee/MyPage.dart';
import 'package:thirdproject/Page/schedule/SchedulePage.dart';
import 'package:thirdproject/Page/report/received_report_list_page.dart';
import 'package:thirdproject/Page/schedule/today_dayoff_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thirdproject/comwidget.dart';
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

  void login() async {
    log("!!!");
    var response = await DioInterceptor.postHttp(
      "http://172.20.10.2:8080/auth",
      {
        "username": mailContorller.text,
        "password": passwordController.text,
      },
    );
    log("await end");
    if (DioInterceptor.isLogin()) {
      setState(() {
        isLoggedIn = true;
      });
      var prefs = await SharedPreferences.getInstance();
      prefs.setString('email', mailContorller.text);
    } else {
      print("로그인 실패");
    }
  }

  Future<String> getEmail() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('email') ?? '이메일 없음';
  }

  Future<String> getName(int empNo) async {
    var jsonParser = await Employeesdio().findByEmpNo(empNo);
    return '${jsonParser.firstName} ${jsonParser.lastName}';
  }

  Future<int> getEmpNo() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt("empNo") ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          // appBar: AppBar(
          //   title: Text('DDT'),
          //   centerTitle: true,
          //   backgroundColor: Colors.black,
          // ),
          body: isLoggedIn
              ? BasicApp()
              : SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(100),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 100),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset("assets/image/logo.svg",
                                  width: 120),
                              SizedBox(height: 30),
                              TextField(
                                controller: mailContorller,
                                decoration: InputDecoration(
                                  labelText: '이메일',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                              SizedBox(height: 20),
                              TextField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: '비밀번호',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                              SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: login,
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  child: Text('로그인',
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))),
        ));
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
          title: Text(''),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.white),
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainApp()));
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<int>>(
        future: Future.wait([getEmpNo(), getDeptNo()]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            int empNo = snapshot.data![0];
            int deptNo = snapshot.data![1];

            return SingleChildScrollView(
              child: Column(
                children: [
                  Text('환영합니다',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Center(child: Comwidget()),
                  _buildScheduleSection(
                    title: "오늘 개인 일정",
                    future: emp.EmpScheDio()
                        .readEmpTodo(empNo, DateTime.parse(strToday)),
                    emptyMessage: "오늘 개인 일정 없음",
                  ),
                  _buildScheduleSection(
                    title: "오늘 부서 일정",
                    future: dept.DeptScheDio()
                        .readDeptTodo(empNo, deptNo, DateTime.parse(strToday)),
                    emptyMessage: "오늘 부서 일정 없음",
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text("데이터를 불러오는 데 실패했습니다"));
          }
        },
      ),
    );
  }
}

Widget _buildScheduleSection({
  required String title,
  required Future<List<dynamic>> future,
  required String emptyMessage,
}) {
  return FutureBuilder(
    future: future,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (snapshot.hasData) {
        List<dynamic> schedule = snapshot.data!;
        if (schedule.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_busy, size: 50, color: Colors.grey),
                SizedBox(height: 10),
                Text(
                  emptyMessage,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading:
                        Icon(Icons.trending_flat, color: Colors.purple[200]),
                    title: Text(schedule[index].scheduleText,
                        style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) =>
              Divider(height: 10, thickness: 1),
          itemCount: schedule.length,
        );
      } else {
        return Container();
      }
    },
  );
}
