import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thirdproject/Dio/reportDio/reportDio.dart';
import 'package:thirdproject/Page/board/BoardPage.dart';
import 'package:thirdproject/Page/employee/MyPage.dart';
import 'package:thirdproject/Page/report/normal_report_add_page.dart';
import 'package:thirdproject/Page/report/received_report_list_page.dart';
import 'package:thirdproject/Page/report/report_add_page.dart';
import 'package:thirdproject/Page/report/report_read_page.dart';
import 'package:thirdproject/Page/schedule/SchedulePage.dart';
import 'package:thirdproject/Page/schedule/today_dayoff_page.dart';
import 'package:thirdproject/main.dart';

class SentReportListPage extends StatefulWidget {
  final int empNo;
  const SentReportListPage({super.key, required this.empNo});

  @override
  State<StatefulWidget> createState() => _SentReportListState();
}

class _SentReportListState extends State<SentReportListPage> {
  final ValueNotifier<bool> isDialOpen =
      ValueNotifier(false); // ✅ SpeedDial 상태 변수 추가

  // ✅ 메뉴 클릭 시 닫힌 후 이동하는 함수
  void _navigateAndClose(Function() navigation) {
    isDialOpen.value = false; // ✅ 메뉴 닫기
    Future.delayed(const Duration(milliseconds: 300), navigation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('보낸 보고서', style: TextStyle(fontWeight: FontWeight.bold)),
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
              title: Text('오늘 연차'),
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
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.archive),
                label: const Text('받은 보고서'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReceivedReportListPage(
                        empNo: widget.empNo,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<ResDto>(
                future: ReportDio().getSentList(widget.empNo),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('에러 발생: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('데이터가 없습니다.'));
                  }

                  ResDto parsingList = snapshot.data!;

                  return ListView.separated(
                    itemCount: parsingList.dtolist.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      var report = parsingList.dtolist[index];
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          leading: Icon(
                            report['isDayOff']
                                ? Icons.beach_access
                                : Icons.description,
                            color: Colors.blueAccent,
                          ),
                          title: Text(
                            report['isDayOff'] ? '연차' : '일반',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            report['isDayOff']
                                ? '사용 날짜: ${report['title']} | 시간: ${report['contents']}'
                                : '${report['title']}',
                          ),
                          trailing: Text(
                            '${report['reportStatus']}',
                            style: TextStyle(
                              color: report['reportStatus'] == '진행중'
                                  ? Colors.orange
                                  : report['reportStatus'] == '반려'
                                      ? Colors.red
                                      : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReportReadPage(
                                  empNo: widget.empNo,
                                  reportNo: int.parse('${report['reportNo']}'),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Colors.purple[100],
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        spacing: 10,
        spaceBetweenChildren: 10,
        closeManually: true,
        openCloseDial: isDialOpen, // ✅ 상태 연동

        children: [
          SpeedDialChild(
            child: Icon(Icons.assignment),
            label: '보고서 등록',
            backgroundColor: Colors.purple[100],
            onTap: () => _navigateAndClose(() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NormalReportAddPage(empNo: widget.empNo)));
            }),
          ),
          SpeedDialChild(
            child: Icon(Icons.beach_access),
            label: '연차 등록',
            backgroundColor: Colors.purple[100],
            onTap: () => _navigateAndClose(() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ReportAddPage(empNo: widget.empNo)));
            }),
          ),
        ],
      ),
    );
  }
}
