import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thirdproject/diointercept%20.dart';

class Comwidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var inTime;
    SharedPreferences.getInstance().then((item) {
      inTime = item.getString("inTime");
    });
    //plushTime();
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text("출근"),
              Text("$inTime"),
            ],
          ),
          Row(
            spacing: 25,
            children: [
              ElevatedButton(
                  onPressed: (() {
                    checkOut();
                  }),
                  child: Text("1"))
            ],
          ),
        ],
      ),
    );
  }

  void checkOut() {
    var empNo;
    SharedPreferences.getInstance().then((item) {
      var time = DateTime.now();
      item.setString("inTime", time.toString());
      empNo = item.get("empNo");
    });
    DioInterceptor.dio
        .put("http://192.168.0.51:8080/api/commute/checkout/$empNo");
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
