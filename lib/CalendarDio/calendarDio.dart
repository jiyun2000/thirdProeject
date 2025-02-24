import 'package:dio/dio.dart';

class JsonParser {
  final int empSchNo;
  final int deptSchNo;
  final DateTime startDate;
  final DateTime endDate;
  final String scheduleText;
  final int empNo;
  final int deptNo;

  JsonParser({
    required this.empSchNo,
    required this.deptSchNo,
    required this.startDate,
    required this.endDate,
    required this.scheduleText,
    required this.empNo,
    required this.deptNo
  });

  factory JsonParser.fromJson(Map<String, dynamic> json) => JsonParser(
    empSchNo: json['empSchNo'], 
    deptSchNo: json['deptSchNo'],
    startDate: json['startDate'], 
    endDate: json['endDate'], 
    scheduleText: json['scheduleText'], 
    empNo: json['empNo'],
    deptNo : json['deptNo']);

    Map<String, dynamic> toJson() => {
      "empSchNo":empSchNo,"deptSchNo":deptSchNo, "startDate":startDate,"endDate":endDate,"scheduleText":scheduleText,"empNo":empNo,"deptNo":deptNo
    };
}


class CalendarDio {
  final dio = Dio();

  //전체 일정 리스트
  Future<Map<String, dynamic>> findByMap(int empNo, int deptNo) async {
    Response res = await dio.get("http://192.168.0.51:8080/empDeptSchedule/read/$deptNo/$empNo");
    return res.data;  
  }

  //개인 일정 등록
  Future<Map<String, dynamic>> registerEmp(int empNo) async {
    Response res = await dio.post("http://192.168.0.51:8080/empDeptSchedule/register/$empNo");
    return res.data;
  }

  //부서 일정 등록
  Future<Map<String, dynamic>> registerDept(int empNo, int deptNo) async {
    Response res = await dio.post("http://192.168.0.51:8080/deptSchedule/register/$deptNo/$empNo");
    return res.data;
  }

  //해당 날짜 일정만 가져오기
  Future<JsonParser> todaySchedule(int empNo, int deptNo, DateTime selectDate) async {
  Response res = await dio.get("http://192.168.0.51:8080/empDeptSchedule/list/$deptNo/$empNo/$selectDate");
  print("API Response: ${res.data}");
  return JsonParser.fromJson(res.data);
}

}