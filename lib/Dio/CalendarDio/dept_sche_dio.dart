import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:thirdproject/diointercept.dart';

class JsonParser {
  final int deptSchNo;
  final DateTime startDate;
  final DateTime endDate;
  final String scheduleText;
  final int empNo;
  final int deptNo;

  JsonParser(
      {
      required this.deptSchNo,
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

  Future<http.Response> modDeptSchedule(DateTime startDate, DateTime endDate,
      String scheduleText, int empNo, int deptNo, int deptSchNo) async {
        var uri = Uri.parse(
            "http://192.168.0.51:8080/deptSchedule/mod/$deptNo/$empNo/$deptSchNo");
        Map<String, String> headers = {"Content-Type": "application/json"};

        Map data = {
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
          'scheduleText': scheduleText,
          'empNo': '$empNo',
          'deptNo': '$deptNo',
          'deptSchNo':'$deptSchNo'
        };
        var body = json.encode(data);
        var response = await http.put(uri, headers: headers, body: body);
        print(response.body);
        return response;
  }

   Future<JsonParser> readDeptSche(int deptNo, int empNo, int deptSchNo) async {
    Response res =
        await DioInterceptor.dio.get("http://192.168.0.51:8080/deptSchedule/read/$deptNo/$empNo/$deptSchNo");
    print(res.data); //맞음
    Map<String, dynamic> mapRes = res.data;
    JsonParser parser = JsonParser.fromJson(mapRes);
    print(parser.deptSchNo);
    return parser;
  }

   Future<http.Response> delDeptSche(int deptNo, int deptSchNo) async {
        var uri = Uri.parse(
            "http://192.168.0.51:8080/deptSchedule/delete/$deptNo/$deptSchNo");
        Map<String, String> headers = {"Content-Type": "application/json"};

        var response = await http.delete(uri, headers: headers);
        print(response.body);
        return response;
  }

}