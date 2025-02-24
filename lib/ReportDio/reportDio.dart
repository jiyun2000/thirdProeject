import 'dart:io';

import 'package:dio/dio.dart';

class ReportJsonParser {
  final int reportNo;
  final String deadLine;
  final String title;
  final String contents;
  final String reportStatus;
  final DateTime reportingDate;
  final int sender;
  final int receivers;
  final List<File> files;
  final List<String> uploadFileNames;

  ReportJsonParser({
    required this.reportNo,
    required this.deadLine,
    required this.title,
    required this.contents,
    required this.reportStatus,
    required this.reportingDate,
    required this.sender,
    required this.receivers,
    required this.files,
    required this.uploadFileNames,
  });

  factory ReportJsonParser.fromJson(Map<String, dynamic> json) {
    return ReportJsonParser(
      reportNo: json['reportNo'],
      deadLine: json['deadLine'],
      title: json['title'],
      contents: json['contents'],
      reportStatus: json['reportStatus'],
      reportingDate: json['reportingDate'],
      sender: json['sender'],
      receivers: json['receivers'],
      files: json['files'],
      uploadFileNames: json['uploadFileNames'],
    );
  }
}

class Reportdio {
  final dio = Dio();

  Future<ReportJsonParser?> getReceivedListByEmpNo(int receivers) async {
    Response res = await dio
        .get("http://10.0.2.2:8080/api/report/list/received/$receivers");
    Map<String, dynamic> mapRes = res.data;
    return ReportJsonParser.fromJson(mapRes);
  }
}
