import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JsonParser {
  final int empSchNo;
  final int deptSchNo;
  final DateTime startDate;
  final DateTime endDate;
  final String scheduleText;
  final int empNo;
  final int deptNo;

  JsonParser(
      {required this.empSchNo,
      required this.deptSchNo,
      required this.startDate,
      required this.endDate,
      required this.scheduleText,
      required this.empNo,
      required this.deptNo});

  factory JsonParser.fromJson(Map<String, dynamic> json) => JsonParser(
      empSchNo: json['empSchNo'],
      deptSchNo: json['deptSchNo'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      scheduleText: json['scheduleText'],
      empNo: json['empNo'],
      deptNo: json['deptNo']);

  Map<String, dynamic> toJson() => {
        "empSchNo": empSchNo,
        "deptSchNo": deptSchNo,
        "startDate": startDate,
        "endDate": endDate,
        "scheduleText": scheduleText,
        "empNo": empNo,
        "deptNo": deptNo
      };
}

class empDto {
  final List<dynamic> empSchedule;
  final List<dynamic> deptSchedule;

  empDto({required this.empSchedule, required this.deptSchedule});

  factory empDto.fromData(dynamic data) => empDto(
      empSchedule: data['empSchedule'], deptSchedule: data['deptSchedule']);

  Map<String, dynamic> toJson() =>
      {"empSchedule": empSchedule, "deptSchedule": deptSchedule};
}

class CalendarDio {
  final dio = Dio();

  //전체 일정 리스트
  Future<Map<String, dynamic>> findByMap(int empNo, int deptNo) async {
    Response res = await dio
        .get("http://localhost:8080/empDeptSchedule/read/$deptNo/$empNo");
    print(res.data);

    print("dio = > ${res.data}");
    return res.data;
  }

  //개인 일정 등록
  Future<http.Response> addEmpSchedule(DateTime startDate, DateTime endDate,
      String scheduleText, int empNo) async {
    var uri = Uri.parse("http://localhost:8080/empSchedule/register/$empNo");
    Map<String, String> headers = {"Content-Type": "application/json"};

    Map data = {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'scheduleText': scheduleText,
      'empNo': '$empNo'
    };

    var body = json.encode(data);
    var response = await http.post(uri, headers: headers, body: body);
    print(response.body);
    return response;
  }

  //부서 일정 등록
  Future<http.Response> addDeptSche(DateTime startDate, DateTime endDate,
      String scheduleText, int empNo, int deptNo) async {
    var uri =
        Uri.parse("http://localhost:8080/deptSchedule/register/$deptNo/$empNo");
    Map<String, String> headers = {"Content-Type": "application/json"};

    Map data = {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'scheduleText': scheduleText,
      'empNo': '$empNo',
      'deptNo': '$deptNo'
    };
    var body = json.encode(data);
    var response = await http.post(uri, headers: headers, body: body);
    print(response.body);
    return response;
  }

  //해당 날짜 일정만 가져오기
  Future<empDto> todaySchedule(
      int empNo, int deptNo, DateTime selectDate) async {
    String formated = (DateFormat("yyyy-MM-dd").format(selectDate));
    Response res = await dio.get(
        "http://localhost:8080/empDeptSchedule/list/$deptNo/$empNo/$formated");
    // print(res.data);
    // print(res.data['empSchedule']);
    // print(res.data['empSchedule'][0]['empSchNo']);
    print(res.data);
    print(res.data['deptSchedule']);
    print("zz");
    return empDto.fromData(res.data);
  }
}
