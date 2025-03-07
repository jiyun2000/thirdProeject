import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thirdproject/diointercept%20.dart';
import 'package:thirdproject/geocheck.dart';

class Comwidget extends StatefulWidget {
  @override
  State<Comwidget> createState() => _ComwidgetState();
}

class _ComwidgetState extends State<Comwidget> {
  @override
  String? _inTime;
  String? _outTime;
  Widget build(BuildContext context) {
    GeoCheck.getPermission();
    SharedPreferences.getInstance().then((item) {
      _inTime =
          item.getString("inTime") == null ? "--:--" : item.getString("inTime");
      _outTime = item.getString("outTime") == null
          ? "--:--"
          : item.getString("outTime");
    });
    bool t = true;
    SharedPreferences.getInstance().then((item) {
      t = DateTime.now()
          .isAfter(DateTime.parse(item.getString("inTime").toString()));
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
                    if (t) {
                      return;
                    }
                    set();
                    setState(() {
                      _inTime = DateFormat("hh:MM")
                          .parse(DateTime.now().toString())
                          .toString();
                    });
                  }),
                  child: Text("출근")),
              ElevatedButton(
                  onPressed: (() {
                    if (GeoCheck().getCurrentPosition()) {
                      return;
                    }
                    bool t = true;
                    SharedPreferences.getInstance().then((item) {
                      t = DateTime.now().isAfter(
                          DateTime.parse(item.getString("outTime").toString()));
                    });
                    if (t) {
                      return;
                    }
                    checkOut();
                    setState(() {
                      _outTime = DateFormat("hh:MM")
                          .parse(DateTime.now().toString())
                          .toString();
                    });
                  }),
                  child: Text("퇴근"))
            ],
          ),
        ],
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
        .post("http://192.168.0.51:8080/api/commute/checkout/$empNo");
  }

  void set() async {
    var empNo;
    final sp = await SharedPreferences.getInstance();
    empNo = sp.get("empNo");
    sp.setString("inTime", DateTime.now().toString());
    DioInterceptor.dio.put("http://192.168.0.51:8080/api/commute/set/$empNo");
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
