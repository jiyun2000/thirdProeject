import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thirdproject/diointercept%20.dart';
import 'package:thirdproject/geocheck.dart';

class Comwidget extends StatefulWidget {
  const Comwidget({super.key});

  @override
  State<Comwidget> createState() => _ComwidgetState();
}

class _ComwidgetState extends State<Comwidget> {
  String? _inTime = "--:--";
  String? _outTime = "--:--";
  @override
  Widget build(BuildContext context) {
    GeoCheck.getPermission();
    SharedPreferences.getInstance().then((item) {
      try {
        _inTime = item.getString("inTime") ?? "--:--";
        _outTime = item.getString("outTime") ?? "--:--";
      } catch (e) {
        print("ddddd");
      }
    });

    //plushTime();
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "출근 정보",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "출근 시간: $_inTime",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 8),
            Text(
              "퇴근 시간: $_outTime",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: (() {
                    if (GeoCheck().getCurrentPosition()) {
                      return;
                    }
                    bool t = true;
                    SharedPreferences.getInstance().then((item) {
                      if (item.getString("inTime") == null) return;
                      t = DateTime.now().isAfter(
                          DateTime.parse(item.getString("inTime").toString()));
                    });
                    if (t) {
                      return;
                    }
                    set();
                    setState(() {
                      _inTime = DateFormat("hh:MM").format(DateTime.now());
                    });
                  }),
                  icon: Icon(Icons.login),
                  label: Text("출근"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: (() {
                    if (GeoCheck().getCurrentPosition()) {
                      return;
                    }
                    bool t = true;
                    SharedPreferences.getInstance().then((item) {
                      if (item.getString("outTime") == null) return;
                      t = DateTime.now().isAfter(
                          DateTime.parse(item.getString("inTime").toString()));
                    });
                    if (t) {
                      return;
                    }
                    checkOut();
                    setState(() {
                      _outTime = DateFormat("hh:MM").format(DateTime.now());
                    });
                  }),
                  icon: Icon(Icons.logout),
                  label: Text("퇴근"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  //   return Card(
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Row(
  //           children: [
  //             Text("출근"),
  //             Text("$_inTime"),
  //           ],
  //         ),
  //         Row(
  //           spacing: 25,
  //           children: [
  //             ElevatedButton(
  //                 onPressed: (() {
  //                   if (GeoCheck().getCurrentPosition()) {
  //                     return;
  //                   }
  //                   bool t = true;
  //                   SharedPreferences.getInstance().then((item) {
  //                     if (item.getString("inTime") == null) return;
  //                     t = DateTime.now().isAfter(
  //                         DateTime.parse(item.getString("inTime").toString()));
  //                   });
  //                   if (t) {
  //                     return;
  //                   }
  //                   set();
  //                   setState(() {
  //                     _inTime = DateFormat("hh:MM").format(DateTime.now());
  //                   });
  //                 }),
  //                 child: Text("출근")),
  //             ElevatedButton(
  //                 onPressed: (() {
  //                   if (GeoCheck().getCurrentPosition()) {
  //                     return;
  //                   }
  //                   bool t = true;
  //                   SharedPreferences.getInstance().then((item) {
  //                     if (item.getString("outTime") == null) return;
  //                     t = DateTime.now().isAfter(
  //                         DateTime.parse(item.getString("inTime").toString()));
  //                   });
  //                   if (t) {
  //                     return;
  //                   }
  //                   checkOut();
  //                   setState(() {
  //                     _outTime = DateFormat("hh:MM").format(DateTime.now());
  //                   });
  //                 }),
  //                 child: Text("퇴근"))
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void checkIn() async {
    Object? empNo;
    final sp = await SharedPreferences.getInstance();
    empNo = sp.get("empNo");
    sp.setString("inTime", DateTime.now().toString());
    DioInterceptor.dio.post("http://172.20.10.2:8080/api/commute/set/$empNo");
  }

  void checkOut() async {
    Object? empNo;
    final sp = await SharedPreferences.getInstance();
    empNo = sp.get("empNo");
    sp.setString("outTime", DateTime.now().toString());
    DioInterceptor.dio
        .post("http://172.20.10.2:8080/api/commute/checkout/$empNo");
  }

  void set() async {
    Object? empNo;
    final sp = await SharedPreferences.getInstance();
    empNo = sp.get("empNo");
    sp.setString("inTime", DateTime.now().toString());
    DioInterceptor.dio.put("http://172.20.10.2:8080/api/commute/set/$empNo");
  }

  void plushTime() {
    SharedPreferences.getInstance().then((item) {
      var time = item.getString("inTime");
      if (DateTime.now().isAfter(DateTime.parse(time.toString()))) {
        item.remove("inTime");
      }
    });
  }
}
