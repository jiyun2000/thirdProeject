import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:thirdproject/diointercept%20.dart';

class ReportJsonParser {
  final int reportNo;
  final String deadLine;
  final String title;
  final String contents;
  final String reportingDate;
  final String reportStatus;
  final int sender;
  final List<dynamic> receivers;
  final bool isDayOff;
  final List<dynamic> files;
  final List<dynamic> uploadFileNames;

  ReportJsonParser(
      {required this.reportNo,
      required this.deadLine,
      required this.title,
      required this.contents,
      required this.reportingDate,
      required this.reportStatus,
      required this.sender,
      required this.receivers,
      required this.isDayOff,
      required this.files,
      required this.uploadFileNames});

  factory ReportJsonParser.fromJson(dynamic json) => ReportJsonParser(
      reportNo: json['reportNo'],
      deadLine: json['deadLine'],
      title: json['title'],
      contents: json['contents'],
      reportingDate: json['reportingDate'],
      reportStatus: json['reportStatus'],
      sender: json['sender'],
      receivers: json['receivers'],
      files: json['files'],
      uploadFileNames: json['uploadFileNames'],
      isDayOff: json['isDayOff']);

  Map<String, dynamic> toJson() => {
        "reportNo": reportNo,
        "deadLine": deadLine,
        "title": title,
        "contents": contents,
        "reportingDate": reportingDate,
        "reportStatus": reportStatus,
        "sender": sender,
        "receivers": receivers,
        "isDayOff": isDayOff,
        "files": files,
        "uploadFileNames": uploadFileNames
      };
}

class ResDto {
  final List<dynamic> dtolist;
  final Map<String, dynamic> pageReqDto;
  final int totalCount;
  final List<dynamic> pageNumList;
  final bool prev;
  final bool next;
  final int prevPage;
  final int nextPage;
  final int totalPage;
  final int current;

  ResDto(
      {required this.dtolist,
      required this.pageReqDto,
      required this.totalCount,
      required this.pageNumList,
      required this.prev,
      required this.next,
      required this.prevPage,
      required this.nextPage,
      required this.totalPage,
      required this.current});

  factory ResDto.fromdata(dynamic data) => ResDto(
      dtolist: data['dtoList'],
      pageReqDto: data['pageRequestDTO'],
      totalCount: data['totalCount'],
      pageNumList: data['pageNumList'],
      prev: data['prev'],
      next: data['next'],
      prevPage: data['prevPage'],
      nextPage: data['nextPage'],
      totalPage: data['totalPage'],
      current: data['current']);
}

class ReportDio {
  final dio = Dio();

  Future<ResDto> getReceivedList(int receiver) async {
    Response res = await DioInterceptor.dio
        .get("http://192.168.0.51:8080/api/report/list/received/$receiver");
    ResDto dto = ResDto.fromdata(res.data);
    return dto;
  }

  Future<ResDto> getSentList(int sender) async {
    print(sender);
    Response res = await DioInterceptor.dio
        .get("http://192.168.0.51:8080/api/report/list/sent/$sender");
    ResDto dto = ResDto.fromdata(res.data);
    return dto;
  }

  Future<http.Response> addReport(
      DateTime title, int contents, List<int> receivers, int empNo) async {
    var uri =
        Uri.parse("http://192.168.0.51:8080/api/report/register/mobile/$empNo");
    Map<String, String> headers = {"Content-Type": "application/json"};

    String formattedDate = DateFormat('yyyy-MM-dd').format(title);
    List<String> rList = receivers.map((item) => item.toString()).toList();
    Map data = {
      'isDayOff': 'true',
      'deadLine': formattedDate,
      'title': formattedDate,
      'contents': '$contents',
      'reportStatus': '진행중',
      'receivers': rList
    };
    var body = json.encode(data);
    var response = await http.post(uri, headers: headers, body: body);
    return response;
  }

  Future<void> addNormalReport(String title, String contents, DateTime deadLine,
      List<int> receivers, int empNo, List<PlatformFile> file) async {
    var uri = "http://192.168.0.51:8080/api/report/register/$empNo";

    String formattedDate = DateFormat('yyyy-MM-dd').format(deadLine);
    List<String> rList = receivers.map((item) => item.toString()).toList();

    // Create FormData for non-file fields
    FormData formData = FormData.fromMap({
      'isDayOff': 'false',
      'contents': contents,
      'reportStatus': '진행중',
      'receivers': rList,
      'deadLine': formattedDate,
      'title': title,
    });

    // Add files if provided
    if (file.isNotEmpty) {
      for (var e in file) {
        if (e.path != null) {
          formData.files.add(MapEntry(
            'files',
            await MultipartFile.fromFile(e.path!),
          ));
        } else {
          print("Error: File path is null for ${e.name}");
        }
      }
    }

    try {
      dio.options.contentType = 'multipart/form-data';
      dio.options.maxRedirects.isFinite;

      await dio.post(uri, data: formData);
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<ReportJsonParser> readReport(int reportNo) async {
    Response res = await DioInterceptor.dio
        .get("http://192.168.0.51:8080/api/report/read/$reportNo");
    Map<String, dynamic> mapRes = res.data;
    ReportJsonParser jsonParser = ReportJsonParser.fromJson(mapRes);
    return jsonParser;
  }

  Future<ReportJsonParser> modReport(int reportNo, String reportStatus) async {
    try {
      // 1️⃣ 기존 데이터를 가져옴
      ReportJsonParser reportData = await readReport(reportNo);

      // 2️⃣ 기존 데이터를 Map 형태로 변환
      Map<String, dynamic> reportMap = reportData.toJson();

      // 3️⃣ reportStatus 값만 변경
      reportMap["reportStatus"] = reportStatus;

      // 4️⃣ 서버에 PUT 요청으로 수정된 데이터 전송
      Response res = await DioInterceptor.dio.put(
        "http://192.168.0.51:8080/api/report/modify/$reportNo",
        data: reportMap, // 수정된 데이터 전송
      );

      // 5️⃣ 요청이 성공했으면 최신 데이터 다시 가져오기
      if (res.statusCode == 200) {
        return await readReport(reportNo);
      } else {
        throw Exception("보고서 수정 실패 (응답 코드: ${res.statusCode})");
      }
    } catch (e) {
      throw Exception("보고서 수정 중 오류 발생: $e");
    }
  }
}
