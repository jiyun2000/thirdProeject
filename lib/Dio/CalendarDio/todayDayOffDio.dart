import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class JsonParser {
  final int dayOffNo;
  final int offHours;
  final DateTime dayOffDate;
  final int empNo;

  JsonParser(
      {required this.dayOffNo,
      required this.offHours,
      required this.dayOffDate,
      required this.empNo});

  factory JsonParser.fromJson(Map<String, dynamic> json) => JsonParser(
      dayOffNo: json['dayOffNo'],
      offHours: json['offHours'],
      dayOffDate: DateTime.parse(json['dayOffDate']),
      empNo: json['empNo']);

  Map<String, dynamic> toJson() => {
        "dayOffNo": dayOffNo,
        "offHours": offHours,
        "dayOffDate": dayOffDate,
        "empNo": empNo
      };
}

class todayDayOffDio {
  final dio = Dio();

  Future<List<JsonParser>> getAllList(DateTime dayOffDate) async {
    String formated = (DateFormat("yyyy-MM-dd").format(DateTime.now()));
    print("ff$formated"); //잘나옴
    Response res = await dio
        .get("http://192.168.0.13:8080/api/dayoff/todayList/$formated");
    print(res.data); //잘나옴
    print("~~~~~~~~~~~~~~~~`");
    List<dynamic> resBody = res.data;
    List<JsonParser> perserList =
        resBody.map((element) => JsonParser.fromJson(element)).toList();
    return perserList;
  }
}
