import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:thirdproject/diointercept%20.dart';

class JsonParser {
  final int deptSchNo;
  final DateTime startDate;
  final DateTime endDate;
  final String scheduleText;
  final int empNo;
  final int deptNo;

  JsonParser(
      {required this.deptSchNo,
      required this.startDate,
      required this.endDate,
      required this.scheduleText,
      required this.empNo,
      required this.deptNo});

  factory JsonParser.fromJson(Map<String, dynamic> json) => JsonParser(
      deptSchNo: json['deptSchNo'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      scheduleText: json['scheduleText'],
      empNo: json['empNo'],
      deptNo: json['deptNo']);

  Map<String, dynamic> toJson() => {
        "deptSchNo": deptSchNo,
        "startDate": startDate,
        "endDate": endDate,
        "scheduleText": scheduleText,
        "empNo": empNo,
        "deptNo": deptNo
      };

}

class DeptScheDio {
  final dio = Dio();

  Future<dynamic> modDeptSchedule(DateTime startDate, DateTime endDate,
      String scheduleText, int empNo, int deptNo, int deptSchNo) async {
    var uri = Uri.parse(
        "http://localhost:8080/deptSchedule/mod/$deptNo/$empNo/$deptSchNo");
   
    Map data = {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'scheduleText': scheduleText,
      'empNo': '$empNo',
      'deptNo': '$deptNo',
      'deptSchNo': '$deptSchNo'
    };
    var body = json.encode(data);
    var response = await DioInterceptor.dio.put(uri.toString(), data:data);
    print(response.data);
    return response.data;
  }

  Future<JsonParser> readDeptSche(int deptNo, int empNo, int deptSchNo) async {
    Response res = await DioInterceptor.dio.get(
        "http://localhost:8080/deptSchedule/read/$deptNo/$empNo/$deptSchNo");
    print(res.data); //맞음
    Map<String, dynamic> mapRes = res.data;
    JsonParser parser = JsonParser.fromJson(mapRes);
    print(parser.deptSchNo);
    return parser;
  }

  Future<List<JsonParser>> readDeptTodo(
      int empNo, int deptNo, DateTime selectDate) async {
    String formated = DateFormat("yyyy-MM-dd").format(selectDate);
    Response res = await DioInterceptor.dio
        .get("http://localhost:8080/deptTodo/read/$empNo/$deptNo/$formated");
    print(res.data);
    print('empNo : $empNo');
    print('deptNo: $deptNo');
    Map<String, dynamic> responseData = res.data;
    List<dynamic> deptScheduleData = responseData['deptSchedule'];
    List<JsonParser> deptSchedule =
        deptScheduleData.map((e) => JsonParser.fromJson(e)).toList();
    return deptSchedule;
  }

  Future<dynamic> delDeptSche(int deptNo, int deptSchNo) async {
    var uri = Uri.parse(
        "http://localhost:8080/deptSchedule/delete/$deptNo/$deptSchNo");
   
    var response = await DioInterceptor.dio.delete(uri.toString());
    print(response.data);
    return response.data;
  }
}
