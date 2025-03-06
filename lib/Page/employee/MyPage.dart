import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thirdproject/Dio/EmpDio/employeesDio.dart';
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
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Text("🙋‍♀️ 마이 페이지"),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/image/logo.svg"),
              ),
              accountEmail: Text("admin"),
              accountName: Text("관리자"),
              // onDetailsPressed: (){},
              decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  )),
            ),
            ListTile(
              leading: Icon(Icons.home),
              iconColor: Colors.purple,
              focusColor: Colors.purple,
              title: Text('홈'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainPage()));
              },
              // trailing: Icon(Icons.navigate_next),
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
              // trailing: Icon(Icons.navigate_next),
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
                          )),
                );
              },
              // trailing: Icon(Icons.navigate_next),
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
              // trailing: Icon(Icons.navigate_next),
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
                          dayOffDate: DateFormat("yyyy-MM-dd").parse(
                              DateFormat("yyyy-MM-dd")
                                  .format(DateTime.now())))),
                );
              },
              // trailing: Icon(Icons.navigate_next),
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
              // trailing: Icon(Icons.navigate_next),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              iconColor: Colors.purple,
              focusColor: Colors.purple,
              title: Text('로그아웃'),
              onTap: () {},
              // trailing: Icon(Icons.navigate_next),
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
                    return ListView(
                      children: [
                        _buildProfileCard('사원번호', jsonParser.empNo.toString()),
                        _buildProfileCard('이름', '${jsonParser.firstName} ${jsonParser.lastName}'),
                        _buildProfileCard('메일주소', jsonParser.mailAddress),
                        _buildProfileCard('주소', jsonParser.address),
                        _buildProfileCard('전화번호', '${jsonParser.phoneNum.substring(0, 3)}-${jsonParser.phoneNum.substring(3, 7)}-${jsonParser.phoneNum.substring(7, 11)}'),
                        _buildProfileCard('성별', jsonParser.gender == 'm' ? '남성' : '여성'),
                        _buildProfileCard('생일', DateFormat("yyyy-MM-dd").format(jsonParser.birthday)),
                        _buildProfileCard('주민등록번호', '${jsonParser.citizenId.substring(0, 6)}-${jsonParser.citizenId.substring(6)}'),
                        _buildProfileCard('입사일', DateFormat("yyyy-MM-dd").format(jsonParser.hireDate)),
                        _buildProfileCard('부서번호', jsonParser.deptNo.toString()),
                        _buildProfileCard('연봉', jsonParser.salary.toString()),
                        //_buildProfileCard('직책번호', jsonParser.jobNo.toString()),
                        
                        
                      ],
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
        ),
      ),
    );
  }

  Widget _buildDrawerListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildProfileCard(String label, String value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text(
              '$label: ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}