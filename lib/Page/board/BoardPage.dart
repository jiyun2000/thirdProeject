import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thirdproject/Dio/BoardDio/boardDio.dart';
import 'package:thirdproject/Page/board/BoardAddPage.dart';
import 'package:thirdproject/Page/board/BoardReadPage.dart';
import 'package:thirdproject/Page/employee/MyPage.dart';
import 'package:thirdproject/Page/report/received_report_list_page.dart';
import 'package:thirdproject/Page/schedule/SchedulePage.dart';
import 'package:thirdproject/Page/schedule/today_dayoff_page.dart';
import 'package:thirdproject/main.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  State<StatefulWidget> createState() => _BoardState();
}
String dayFormat = DateFormat("yyyy-MM-dd").format(DateTime.now());
class _BoardState extends State<BoardPage> {

  Future<int> getEmpNo() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt('empNo') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🎙️공지사항'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/image/logo.svg"),
              ), accountEmail: Text("admin"),
              accountName: Text("관리자"),
              // onDetailsPressed: (){},
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                )
              ),
            ),ListTile(
              leading: Icon(Icons.home),
              iconColor: Colors.purple,
              focusColor: Colors.purple,
              title: Text('홈'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
              },
              // trailing: Icon(Icons.navigate_next),
            ),
            ListTile(
              leading: Icon(Icons.notifications_none_sharp),
              iconColor: Colors.purple,
              focusColor: Colors.purple,
              title: Text('공지사항'),
              onTap: (){
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
              onTap: (){
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
              title: Text('오늘 연차'),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TodayDayOffPage(
                          dayOffDate:
                              DateFormat("yyyy-MM-dd").parse(dayFormat))),
                );
              },
              // trailing: Icon(Icons.navigate_next),
            ),
            ListTile(
              leading: Icon(Icons.person),
              iconColor: Colors.purple,
              focusColor: Colors.purple,
              title: Text('마이페이지'),
              onTap: (){
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
              onTap: (){},
              // trailing: Icon(Icons.navigate_next),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          FutureBuilder<resDto>(
            future: BoardDio().getAllList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('에러 발생: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                print("데이터 존재함");
                resDto parsingList = snapshot.data!;

                return Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: parsingList.dtolist.length,
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        height: 10,
                        thickness: 1,
                      );
                    },
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.circle),
                          //title: Text('${parsingList.dtolist[index]['boardNo']}'),
                          title: Text('${parsingList.dtolist[index]['title']}'),
                          trailing: Text('${parsingList.dtolist[index]['regdate']}'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BoardReadpage(
                                  BoardNo: '${parsingList.dtolist[index]['boardNo']}',
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Center(child: Text('데이터 없어요'));
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BoardAddPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
