import 'package:dio/dio.dart';
import 'package:thirdproject/diointercept%20.dart';

class JsonParser {
  final int deptNo;
  final String deptName;
  final String deptAddress;

  JsonParser({
    required this.deptNo,
    required this.deptName,
    required this.deptAddress,
  });

  factory JsonParser.fromJson(Map<String, dynamic> json) => JsonParser(
      deptNo: json['deptNo'],
      deptName: json['deptName'],
      deptAddress: json['deptAddress']);

  Map<String, dynamic> toJson() => {
        "deptNo": deptNo,
        "deptName": deptName,
        "deptAddress": deptAddress,
      };
}

class DeparmentDio {
  final dio = Dio();

  Future<JsonParser> findByDept(int deptNo) async {
    print("read dept dio");

    Response res = await DioInterceptor.dio
        .get("http://192.168.0.51:8080/api/deptinfo/read/$deptNo");

    print(res.data);
    Map<String, dynamic> mapRes = res.data;
    JsonParser parser = JsonParser.fromJson(mapRes);
    print(parser.deptName);
    return parser;
  }
}
