import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thirdproject/Dio/commute_dio/commute_dio.dart';
import 'package:thirdproject/diointercept%20.dart';
import 'package:thirdproject/geocheck.dart';

class Comwidget extends StatefulWidget {
  const Comwidget({super.key});

  @override
  State<Comwidget> createState() => _ComwidgetState();
}

class _ComwidgetState extends State<Comwidget> {
  final CommuteDio _commuteDio = CommuteDio(); // CommuteDio 인스턴스 생성

  String _inTime = "--:--";
  String _outTime = "--:--";

  @override
  void initState() {
    super.initState();
    _loadCommuteData();
  }

  Future<void> _loadCommuteData() async {
    final sp = await SharedPreferences.getInstance();
    final empNo = sp.getInt("empNo"); // empNo 가져오기

    if (empNo != null) {
      try {
        final commuteData =
            await _commuteDio.todayCommute(empNo); // CommuteDio 사용

        setState(() {
          _inTime = _formatTime(commuteData.checkInTime);
          _outTime = _formatTime(commuteData.checkOutTime);
        });
      } catch (e) {
        print("출퇴근 정보 불러오기 실패: $e");
      }
    }
  }

  ///날짜 형식 변환 (null 및 빈 문자열 체크)
  String _formatTime(String? time) {
    if (time == null || time.isEmpty) return "--:--";

    try {
      // "HH:mm" 형식 (예: "15:21")을 DateTime 객체로 변환
      DateFormat inputFormat = DateFormat("HH:mm");
      DateTime parsedTime = inputFormat.parse(time);

      // 변환된 시간을 "HH:mm" 형식으로 다시 출력
      return DateFormat("HH:mm").format(parsedTime);
    } catch (e) {
      print("날짜 변환 오류: $e");
      return "--:--"; // 변환 실패 시 기본값 반환
    }
  }

  @override
  Widget build(BuildContext context) {
    GeoCheck.getPermission();

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
                  onPressed: () async {
                    if (await GeoCheck().getCurrentPosition()) return;
                    await checkIn();
                    _loadCommuteData(); // 출근 후 데이터 다시 불러오기
                  },
                  icon: Icon(Icons.login),
                  label: Text("출근"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (await GeoCheck().getCurrentPosition()) return;
                    await checkOut();
                    _loadCommuteData(); // 퇴근 후 데이터 다시 불러오기
                  },
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

  Future<void> checkIn() async {
    final sp = await SharedPreferences.getInstance();
    final empNo = sp.getInt("empNo");

    if (empNo != null) {
      await DioInterceptor.dio
          .post("http://192.168.0.109:8080/api/commute/set/$empNo");
    }
  }

  Future<void> checkOut() async {
    final sp = await SharedPreferences.getInstance();
    final empNo = sp.getInt("empNo");

    if (empNo != null) {
      await DioInterceptor.dio
          .put("http://192.168.0.109:8080/api/commute/checkout/$empNo");
    }
  }
}
