import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thirdproject/Dio/BoardDio/boardDio.dart';
import 'package:thirdproject/Page/board/BoardModPage.dart';
import 'package:thirdproject/Page/board/BoardPage.dart';
import 'package:thirdproject/Page/employee/MyPage.dart';
import 'package:thirdproject/Page/report/received_report_list_page.dart';
import 'package:thirdproject/Page/schedule/SchedulePage.dart';
import 'package:thirdproject/Page/schedule/today_dayoff_page.dart';
import 'package:thirdproject/main.dart';

class BoardReadpage extends StatefulWidget {
  final String BoardNo;

  const BoardReadpage({super.key, required this.BoardNo});

  @override
  State<StatefulWidget> createState() => _BoardState();
}

String dayFormat = DateFormat("yyyy-MM-dd").format(DateTime.now());

class _BoardState extends State<BoardReadpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("🎙️공지사항", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        centerTitle: true,
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
                  color: const Color.fromARGB(255, 255, 255, 255),
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
        child: FutureBuilder(
          future: BoardDio().readBoard(int.parse(widget.BoardNo)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('에러 발생: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              JsonParser jsonParser = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    Text(
                      jsonParser.title,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd HH:mm').format(jsonParser.modDate),
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.left,
                    ),
                    // Text(
                    //   '${jsonParser.category}',
                    //   style: TextStyle(fontSize: 14), textAlign: TextAlign.center,
                    // ),
                    Text(
                      jsonParser.mailAddress,
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 20),
                    Text(' ${jsonParser.content}',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center),
                    SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BoardModPage(
                                        BoardNo: '${jsonParser.boardNo}')));
                          },
                          child: Text('수정')),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BoardPage()));
                          },
                          child: Text('돌아가기')),
                    )
                  ],
                ),
              );
            } else {
              return Center(child: Text('데이터가 없습니다.'));
            }
          },
        ),
      ),
    );
  }
}
