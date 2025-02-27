import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

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
      startDate: json['startDate'],
      endDate: json['endDate'],
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


class empDto{
  final List<dynamic> empSchedule;
  final List<dynamic> deptSchedule;

  empDto({
    required this.empSchedule,
    required this.deptSchedule
  });

  factory empDto.fromData(dynamic data)=>empDto(
    empSchedule:data['empSchedule'],
    deptSchedule:data['deptSchedule']
  );

  Map<String, dynamic> toJson() => {
    "empSchedule" : empSchedule,
    "deptSchedule" : deptSchedule
  };

}




class CalendarDio {
  final dio = Dio();

  //전체 일정 리스트
  Future<Map<String, dynamic>> findByMap(int empNo, int deptNo) async {

    Response res = await dio.get("http://192.168.0.51:8080/empDeptSchedule/read/$deptNo/$empNo");
    print(res.data);

    print("dio = > ${res.data}");
    return res.data;
  }

  //개인 일정 등록
  Future<Map<String, dynamic>> registerEmp(int empNo) async {
    Response res = await dio
        .post("http://192.168.0.51:8080/empDeptSchedule/register/$empNo");
    print("dio = > ${res.data}");
    return res.data;
  }

  //부서 일정 등록
  Future<Map<String, dynamic>> registerDept(int empNo, int deptNo) async {
    Response res = await dio
        .post("http://192.168.0.51:8080/deptSchedule/register/$deptNo/$empNo");
    print("dio = > ${res.data}");
    return res.data;
  }

  //해당 날짜 일정만 가져오기


  // Future<List<JsonParser>> todaySchedule(int empNo, int deptNo, DateTime selectDate) async {
  //   String formated = (DateFormat("yyyy-MM-dd").format(selectDate));
  //   Response res = await dio.get("http://192.168.0.51:8080/empDeptSchedule/list/$deptNo/$empNo/$formated");
  //   print(res.data);
  //   return res.data;
  // }

  Future<empDto> todaySchedule(int empNo, int deptNo, DateTime selectDate) async {
    String formated = (DateFormat("yyyy-MM-dd").format(selectDate));
    Response res = await dio.get("http://192.168.0.51:8080/empDeptSchedule/list/$deptNo/$empNo/$formated");
    // print(res.data);
    // print(res.data['empSchedule']);
    // print(res.data['empSchedule'][0]['empSchNo']);
    return empDto.fromData(res.data);
  }
}

