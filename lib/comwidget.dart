import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thirdproject/diointercept%20.dart';
import 'package:thirdproject/geocheck.dart';

class Comwidget extends StatefulWidget {
  @override
  State<Comwidget> createState() => _ComwidgetState();
}

class _ComwidgetState extends State<Comwidget> {
  @override
  void initState() {
    super.initState();
    GeoCheck.getPermission();
  }

  @override
  Widget build(BuildContext context) {
    var inTime;
    GeoCheck.getPermission();
    SharedPreferences.getInstance().then((item) {
      inTime = item.getString("inTime");
    });
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
              "출근 시간: $inTime",
              style: TextStyle(fontSize: 16, color: Colors.blue),
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
                    set();
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
                    checkOut();
                  }),
                  icon: Icon(Icons.logout),
                  label: Text("퇴근"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
//       child: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               children: [
//               ],
//             ),
//             Row(
//               spacing: 25,
//               children: [
//                 ElevatedButton(
//                     onPressed: (() {
//                       if (GeoCheck().getCurrentPosition()) {
//                         return;
//                       }
//                       set();
//                     }),
//                     child: Text("출근")),
//                 ElevatedButton(
//                     onPressed: (() {
//                       if (GeoCheck().getCurrentPosition()) {
//                         return;
//                       }
//                       checkOut();
//                     }),
//                     child: Text("퇴근"))
              ],
            ),
          ],
        ),
      ),
    );
  }

  void checkIn() async {
    var empNo;
    final sp = await SharedPreferences.getInstance();
    empNo = sp.get("empNo");
    sp.setString("inTime", DateTime.now().toString());
    DioInterceptor.dio.post("http://192.168.0.51:8080/api/commute/set/$empNo");
  }

  void checkOut() async {
    var empNo;
    final sp = await SharedPreferences.getInstance();
    empNo = sp.get("empNo");
    sp.setString("inTime", DateTime.now().toString());
    DioInterceptor.dio
        .put("http://192.168.0.51:8080/api/commute/checkout/$empNo");
  }

  void set() async {
    var empNo;
    final sp = await SharedPreferences.getInstance();
    empNo = sp.get("empNo");
    sp.setString("inTime", DateTime.now().toString());
    DioInterceptor.dio.post("http://192.168.0.51:8080/api/commute/set/$empNo");
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
