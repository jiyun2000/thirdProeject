import 'package:flutter/material.dart';

import 'package:thirdproject/Page/BoardPage.dart';
import 'package:thirdproject/Page/SchedulePage.dart';
import 'package:thirdproject/Page/report/received_report_list_page.dart';

import 'package:thirdproject/Page/TodayDayOffPage.dart';


void main() async {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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

class MainPage extends StatelessWidget {
   MainPage({super.key});
  String strToday = DateFormat("yyyy-mm-dd").format(DateTime.now());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('메인페이지'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CalendarPage()),
                );
              },
              child: const Text('📆일정'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BoardPage()),
                );
              },
              child: const Text('🎙️공지사항'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ReceivedReportListPage()),
                );
              },
              child: const Text('🍔🍟보고서'),

                print(DateFormat("yyyy-MM-dd").parse(strToday)); //이놈이 시간까지 보내는데..

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>   TodayDayOffPage(dayOffDate : DateFormat("yyyy-MM-dd").parse(strToday))),
                );
              },
              child: const Text('🧳연차인원'),

            ),
          ],
        ),
      ),
    );
  }
}
