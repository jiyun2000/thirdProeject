import 'package:dio/dio.dart';
import 'package:thirdproject/diointercept%20.dart';

class CommuteJsonParser {
  final int commNo;
  final String checkDate;
  final String checkInTime;
  final String checkOutTime;
  final int empNo;

  CommuteJsonParser({
    required this.commNo,
    required this.checkDate,
    required this.checkInTime,
    required this.checkOutTime,
    required this.empNo,
  });

  factory CommuteJsonParser.fromJson(dynamic json) => CommuteJsonParser(
        commNo: json['commNo'],
        checkDate: json['checkDate'],
        checkInTime: json['checkInTime'],
        checkOutTime: json['checkOutTime'] ?? "--:--",
        empNo: json['empNo'],
      );

  Map<String, dynamic> toJson() => {
        "commNo": commNo,
        "checkDate": checkDate,
        "checkInTime": checkInTime,
        "checkOutTime": checkOutTime,
        "empNo": empNo,
      };
}

class CommuteDio {
  final dio = Dio();

  Future<CommuteJsonParser> todayCommute(int empNo) async {
    Response res = await DioInterceptor.dio
        .get("http://192.168.0.14:8080/api/commute/todayCommute/$empNo");

    print("🚀 서버 응답 데이터: ${res.data}");
    print(res.data['checkOutTime']);

    Map<String, dynamic> mapRes = Map<String, dynamic>.from(res.data);
    //checkOutTime이 null이면 "--:--" 기본값 사용
    mapRes['checkOutTime'] = mapRes['checkOutTime'] ?? "--:--";

    CommuteJsonParser jsonParser = CommuteJsonParser.fromJson(mapRes);
    return jsonParser;
  }
}
