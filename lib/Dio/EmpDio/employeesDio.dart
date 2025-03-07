import 'package:dio/dio.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:thirdproject/diointercept%20.dart';

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
    Response res = await DioInterceptor.dio
        .get("http://211.248.242.138:8080/api/employees/read/$empNo");

    Map<String, dynamic> mapRes = res.data;
    JsonParser parser = JsonParser.fromJson(mapRes);

    return parser;
  }


  Future<List<DropdownItem<int>>> getAllEmpListToDropDown(int empNo) async {
    Response res = await DioInterceptor.dio
        .get("http://211.248.242.138:8080/api/employees/list/all");
    List<dynamic> data = List.from(res.data);
    // 서버에서 반환된 리스트 데이터를 JsonParser로 변환
    List<JsonParser> jsonList =
        data.map((item) => JsonParser.fromJson(item)).toList();

    // JsonParser를 DropdownItem으로 변환
    List<DropdownItem<int>> dropdownItems = jsonList
        .where((jsonParser) => jsonParser.empNo != empNo) // empNo 제외
        .map((jsonParser) => DropdownItem<int>(
              value: jsonParser.empNo,
              label: '${jsonParser.firstName}${jsonParser.lastName}',
            ))
        .toList();

    return dropdownItems;
  }

  

}
