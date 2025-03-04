import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thirdproject/Dio/CalendarDio/todayDayOffDio.dart';

class TodayDayOffPage extends StatefulWidget {
  final DateTime dayOffDate;
  const TodayDayOffPage({super.key, required this.dayOffDate});

  @override
  State<StatefulWidget> createState() => _TodayDayOffState();
}

String dayOff = DateFormat("yyyy-MM-dd").format(DateTime.now());

class _TodayDayOffState extends State<TodayDayOffPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('오늘 연차인원'),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: todayDayOffDio().getAllList(DateTime.parse(dayOff)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('error'));
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                List<JsonParser> parsingList = snapshot.data!;
                return ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.ac_unit_sharp),
                      title: Text('${parsingList[index].empNo}'),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 10,
                      thickness: 1,
                    );
                  },
                  itemCount: parsingList.length,
                );
              } else {
                return Center(child: Text('오늘은 전체 직원 출근‼️‼️‼️'));
              }
            },
          )
        ],
      ),
    );
  }
}
