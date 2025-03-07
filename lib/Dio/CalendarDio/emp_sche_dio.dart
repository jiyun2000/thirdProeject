import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:thirdproject/diointercept%20.dart';

class JsonParser {
  final int empSchNo;
  final DateTime startDate;
  final DateTime endDate;
  final String scheduleText;
  final int empNo;

  JsonParser({
    required this.empSchNo,
    required this.startDate,
    required this.endDate,
    required this.scheduleText,
    required this.empNo,
  });

  factory JsonParser.fromJson(Map<String, dynamic> json) => JsonParser(
        empSchNo: json['empSchNo'],
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        scheduleText: json['scheduleText'],
        empNo: json['empNo'],
      );

  Map<String, dynamic> toJson() => {
        "empSchNo": empSchNo,
        "startDate": startDate,
        "endDate": endDate,
        "scheduleText": scheduleText,
        "empNo": empNo,
      };
}

class EmpScheDio {
  final dio = Dio();
  Future<JsonParser> readEmpSche(int empNo, int empSchNo) async {
    Response res = await DioInterceptor.dio
        .get("http://211.248.242.138:8080/empSchedule/read/$empNo/$empSchNo");
    print(res.data); //맞음
    Map<String, dynamic> mapRes = res.data;
    JsonParser parser = JsonParser.fromJson(mapRes);
    print(parser.empSchNo);
    return parser;
  }

  Future<List<JsonParser>> readEmpTodo(int empNo, DateTime selectDate) async {
    print("read Todo dio");
    String formated = (DateFormat("yyyy-MM-dd").format(DateTime.now()));
    print(formated);
    Response res = await DioInterceptor.dio
        .get("http://211.248.242.138:8080/empTodo/read/$empNo/$formated");
    print(res.data);
    print('$empNo');
    Map<String, dynamic> responseData = res.data;
    List<dynamic> empScheduleData = responseData['empSchedule'];
    List<JsonParser> empSchedule =
        empScheduleData.map((element) => JsonParser.fromJson(element)).toList();
    return empSchedule;
  }

  Future<dynamic> modEmpSchedule(DateTime startDate, DateTime endDate,
      String scheduleText, int empNo, int empSchNo) async {
    print("empMod dio");
    var uri =
        Uri.parse("http://211.248.242.138:8080/empSchedule/mod/$empNo/$empSchNo");
    print(uri);

    Map data = {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'scheduleText': scheduleText,
      'empNo': '$empNo',
      'empSchNo': '$empSchNo'
    };
    var body = json.encode(data);
    var response = await DioInterceptor.dio.put(uri.toString(), data: data);
    print(response.data);
    return response.data;
  }

  Future<dynamic> delEmpSch(int empNo, int empSchNo) async {
    print("empMod dio");
    var uri =
        Uri.parse("http://211.248.242.138:8080/empSchedule/$empNo/$empSchNo");
    print(uri);

    var response = await DioInterceptor.dio.delete(uri.toString());
    print(response.data);
    return response.data;
  }
}
