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
        elevation: 0, 
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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
              ),
            ),
            _buildDrawerItem(Icons.home, '홈', MainPage()),
            _buildDrawerItem(Icons.notifications_none_sharp, '공지사항', BoardPage()),
            _buildDrawerItem(Icons.report, '보고서', ReceivedReportListPage(empNo: 0)),
            _buildDrawerItem(Icons.calendar_month, '일정', CalendarPage()),
            _buildDrawerItem(Icons.travel_explore_sharp, '연차', TodayDayOffPage(dayOffDate: DateFormat("yyyy-MM-dd").parse(dayFormat))),
            _buildDrawerItem(Icons.person, '마이페이지', MyPage()),
            _buildDrawerItem(Icons.logout, '로그아웃', null),
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
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                      children: [
                        Text(
                          DateFormat('yyyy-MM-dd HH:mm').format(jsonParser.modDate),
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          jsonParser.mailAddress,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    Text(
                      jsonParser.content,
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 50),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BoardModPage(BoardNo: '${jsonParser.boardNo}')),
                          );
                        },
                        child: Text('수정'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('돌아가기'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
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


  Widget _buildDrawerItem(IconData icon, String title, Widget? page) {
    return ListTile(
      leading: Icon(icon, color: Colors.purple),
      title: Text(title),
      onTap: () {
        if (page != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        }
      },
    );
  }
}
