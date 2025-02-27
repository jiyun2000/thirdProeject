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

  JsonParser({
    required this.empNo,
    required this.firstName,
    required this.lastName,
    required this.mailAddress,
    required this.address,
    required this.phoneNum,
    required this.gender,
    required this.citizenId,
  });

  factory JsonParser.fromJson(Map<String, dynamic> json) {
    return JsonParser(
      empNo: json['empNo'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      mailAddress: json['mailAddress'],
      address: json['address'],
      phoneNum: json['phoneNum'],
      gender: json['gender'],
      citizenId: json['citizenId'],
    );
  }
}

class Employeesdio {
  final dio = Dio();

  Future<JsonParser?> findByEmpNo(int empNo) async {
    Response res =
        await dio.get("http://192.168.0.13:8080/api/employees/read/$empNo");
    Map<String, dynamic> mapRes = res.data;
    return JsonParser.fromJson(mapRes);
  }
}
