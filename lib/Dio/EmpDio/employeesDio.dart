import 'package:dio/dio.dart';

class JsonParser {
  final int empNo;
  final String firstName;
  final String lastName;
  final String mailAddress;
  final String address;
  final String phoneNum;
  final String gender;
  final String citizenId;
  final DateTime hireDate;
  final int salary;
  final int deptNo;
  final int jobNo;
  final DateTime birthday;

  JsonParser({
    required this.empNo,
    required this.firstName,
    required this.lastName,
    required this.mailAddress,
    required this.address,
    required this.phoneNum,
    required this.gender,
    required this.citizenId,
    required this.hireDate,
    required this.salary,
    required this.deptNo,
    required this.jobNo,
    required this.birthday,
  });

  factory JsonParser.fromJson(Map<String, dynamic> json) => JsonParser(
        empNo: json['empNo'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        mailAddress: json['mailAddress'],
        address: json['address'],
        phoneNum: json['phoneNum'],
        gender: json['gender'],
        citizenId: json['citizenId'],
        hireDate: DateTime.parse(json['hireDate']),
        salary: json['salary'],
        deptNo: json['deptNo'],
        jobNo: json['jobNo'],
        birthday: DateTime.parse(json['birthday']),
      );

  Map<String, dynamic> toJson() => {
        "empNo": empNo,
        "firstName": firstName,
        "lastName": lastName,
        "mailAddress": mailAddress,
        "address": address,
        "phoneNum": phoneNum,
        "gender": gender,
        "citizenId": citizenId,
        "hireDate": hireDate,
        "salary": salary,
        "deptNo": deptNo,
        "jobNo": jobNo,
        "birthday": birthday,
      };
}

class Employeesdio {
  final dio = Dio();

  //mypage
  Future<JsonParser> findByEmpNo(int empNo) async {
    Response res =
        await dio.get("http://192.168.0.13:8080/api/employees/read/$empNo");

    Map<String, dynamic> mapRes = res.data;
    JsonParser parser = JsonParser.fromJson(mapRes);

    return parser;
  }
}
