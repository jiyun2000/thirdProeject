import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thirdproject/Dio/CalendarDio/calendarDio.dart';
import 'package:thirdproject/Page/BoardPage.dart';
import 'package:thirdproject/Page/SchedulePage.dart';


void main() async {
  runApp( MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
       // ChangeNotifierProvider(create: (_) => CalendarDio()), 
      ],
      child: MaterialApp(
        title: 'Flutter Ddt',
        routes: {
          '/schedule': (context) => const SchedulePage(),
          '/board': (context) => const BoardPage(),
        },
        initialRoute: '/schedule', 
      ),
    );
  }
}
