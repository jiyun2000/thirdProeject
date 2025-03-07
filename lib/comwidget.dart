import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thirdproject/diointercept%20.dart';
import 'package:thirdproject/geocheck.dart';

class Comwidget extends StatefulWidget {

=======
  @override
  State<Comwidget> createState() => _ComwidgetState();
}


  @override
  State<Comwidget> createState() => _ComwidgetState();
}

class _ComwidgetState extends State<Comwidget> {
  String? _inTime = "--:--";
  String? _outTime = "--:--";
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text("출근"),
              Text("$_inTime"),
            ],
          ),
          Row(
            spacing: 25,
            children: [
              ElevatedButton(

                  onPressed: (() {
                    if (GeoCheck().getCurrentPosition()) {
                      return;
                    }
                    try {
                      bool t = true;
                      SharedPreferences.getInstance().then((item) {
                        if (item.getString("inTime") != null) {
                          t = DateTime.now().isAfter(DateTime.parse(
                              item.getString("inTime").toString()));
                        }
                      });
                      if (t) {
                        return;
                      }
                    } catch (e) {
                      print(e.toString());
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
                    try {
                      bool t = true;
                      SharedPreferences.getInstance().then((item) {
                        if (item.getString("outTime") != null) {
                          t = DateTime.now().isAfter(DateTime.parse(
                              item.getString("outTime").toString()));
                        }
                      });
                      if (t) {
                        return;
                      }
                    } catch (e) {
                      print(e.toString());
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
    sp.setString("outTime", DateTime.now().toString());
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
