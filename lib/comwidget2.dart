import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thirdproject/diointercept%20.dart';
import 'package:thirdproject/geocheck.dart';

class Comwidget2 extends StatelessWidget {
  const Comwidget2({super.key});

  @override
  Widget build(BuildContext context) {
    String? inTime;
    GeoCheck.getPermission();
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
                    if (GeoCheck().getCurrentPosition()) {
                      return;
                    }
                    set();
                  }),
                  child: Text("출근")),
              ElevatedButton(
                  onPressed: (() {
                    if (GeoCheck().getCurrentPosition()) {
                      return;
                    }
                    checkOut();
                  }),
                  child: Text("퇴근"))
            ],
          ),
        ],
      ),
    );
  }

  void checkIn() async {
    Object? empNo;
    final sp = await SharedPreferences.getInstance();
    empNo = sp.get("empNo");
    sp.setString("inTime", DateTime.now().toString());
    DioInterceptor.dio.post("http://192.168.0.109:8080/api/commute/set/$empNo");
  }

  void checkOut() async {
    Object? empNo;
    final sp = await SharedPreferences.getInstance();
    empNo = sp.get("empNo");
    sp.setString("inTime", DateTime.now().toString());
    DioInterceptor.dio
        .put("http://192.168.0.109:8080/api/commute/checkout/$empNo");
  }

  void set() async {
    Object? empNo;
    final sp = await SharedPreferences.getInstance();
    empNo = sp.get("empNo");
    sp.setString("inTime", DateTime.now().toString());
    DioInterceptor.dio.post("http://192.168.0.109:8080/api/commute/set/$empNo");
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
