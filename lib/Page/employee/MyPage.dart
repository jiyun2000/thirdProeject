import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thirdproject/Dio/EmpDio/employeesDio.dart';
import 'package:thirdproject/Dio/deptDio/departmentDio.dart' as dept;
import 'package:thirdproject/Page/board/BoardPage.dart';
import 'package:thirdproject/Page/report/received_report_list_page.dart';
import 'package:thirdproject/Page/schedule/SchedulePage.dart';
import 'package:thirdproject/Page/schedule/today_dayoff_page.dart';
import 'package:thirdproject/diointercept%20.dart';
import 'package:thirdproject/main.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<StatefulWidget> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
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

  Future<String> getDeptName(int deptNo) async {
    var deptJsonParser = await dept.DeparmentDio().findByDept(deptNo);
    return deptJsonParser.deptName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), 
      appBar: AppBar(
        centerTitle: true,
        title: Text("👩‍💻 마이 페이지", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0, 
      ),
      drawer:Drawer(
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<int>(
          future: getEmpNo(),
          builder: (context, empNoSnapshot) {
            if (empNoSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (empNoSnapshot.hasError) {
              return Center(child: Text('Error:${empNoSnapshot.error}'));
            } else if (empNoSnapshot.hasData) {
              int empNo = empNoSnapshot.data!;
              return FutureBuilder(
                future: Employeesdio().findByEmpNo(empNo),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('에러 : ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    JsonParser jsonParser = snapshot.data!;

                    return FutureBuilder(
                      future: getDeptName(jsonParser.deptNo),
                      builder: (context, deptNoSnapshot) {
                        if (deptNoSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (deptNoSnapshot.hasError) {
                          return Center(child: Text('에러 : ${deptNoSnapshot.error}'));
                        } else if (deptNoSnapshot.hasData) {
                          String deptName = deptNoSnapshot.data!;

                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 5,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildProfileRow('|', '사원번호', jsonParser.empNo.toString()),
                                      _buildDivider(),
                                      _buildProfileRow('|', '이름', '${jsonParser.firstName} ${jsonParser.lastName}'),
                                      _buildDivider(),
                                      _buildProfileRow('|', '메일주소', jsonParser.mailAddress),
                                      _buildDivider(),
                                      _buildProfileRow('|', '주소', jsonParser.address),
                                      _buildDivider(),
                                      _buildProfileRow('|', '전화번호', '${jsonParser.phoneNum.substring(0, 3)}-${jsonParser.phoneNum.substring(3, 7)}-${jsonParser.phoneNum.substring(7, 11)}'),
                                      _buildDivider(),
                                      _buildProfileRow('|', '성별', jsonParser.gender == 'm' ? '남성' : '여성'),
                                      _buildDivider(),
                                      _buildProfileRow('|', '생일', DateFormat("yyyy-MM-dd").format(jsonParser.birthday)),
                                      _buildDivider(),
                                      _buildProfileRow('|', '주민등록번호', '${jsonParser.citizenId.substring(0, 6)}-${jsonParser.citizenId.substring(6)}'),
                                      _buildDivider(),
                                      _buildProfileRow('|', '입사일', DateFormat("yyyy-MM-dd").format(jsonParser.hireDate)),
                                      _buildDivider(),
                                      _buildProfileRow('|', '부서명', deptName),
                                      _buildDivider(),
                                      _buildProfileRow('|', '연봉', jsonParser.salary.toString()),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Center(child: Text('데이터를 불러오는 데 실패했습니다.'));
                        }
                      },
                    );
                  } else {
                    return Center(child: Text('사원 정보를 불러오는 데 실패했습니다.'));
                  }
                },
              );
            } else {
              return Center(child: Text('사원 정보를 불러오는 데 실패했습니다.'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildProfileRow(String prefix, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(prefix, style: TextStyle(fontSize: 18, color: Colors.purple)),  
          SizedBox(width: 8),
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(child: Text(value, style: TextStyle(fontSize: 16), overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      thickness: 1,
      color: Colors.grey[300],
    );
  }

  Widget _buildDrawerTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      iconColor: Colors.purple,
      focusColor: Colors.purple,
      title: Text(title),
      onTap: onTap,
    );
  }
}
