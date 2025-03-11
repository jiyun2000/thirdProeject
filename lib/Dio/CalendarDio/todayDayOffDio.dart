import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:thirdproject/diointercept%20.dart';

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
    String formated = DateFormat("yyyy-MM-dd").format(dayOffDate);
    print("formated : $formated");
    Response res = await DioInterceptor.dio
        .get("http://192.168.0.109:8080/api/dayoff/todayList/$formated");

    print("res data");
    print(res.data);

    List<dynamic> resBody = res.data;
    List<JsonParser> perserList =
        resBody.map((element) => JsonParser.fromJson(element)).toList();

    return perserList;
  }

  Future<List<JsonParser>> getAllDayOffList() async {
    Response res = await DioInterceptor.dio
        .get("http://192.168.0.109:8080/api/dayoff/allDayOff");
    print("res data all");
    print(res.data);
    print("res data all");

    List<dynamic> resBody = res.data;
    List<JsonParser> parserList =
        resBody.map((e) => JsonParser.fromJson(e)).toList();
    return parserList;
  }
}
