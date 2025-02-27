import 'package:dio/dio.dart';

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
    Response res = await dio
        .get("http://192.168.0.13:8080/api/report/list/received/$receiver");
    print(res.data);
    ResDto dto = ResDto.fromdata(res.data);
    return dto;
  }

  Future<ResDto> getSentList(int sender) async {
    Response res =
        await dio.get("http://192.168.0.13:8080/api/report/list/sent/$sender");
    ResDto dto = ResDto.fromdata(res.data);
    return dto;
  }

  Future<ReportJsonParser> addReport() async {
    Response res = await dio.post("http://192.168.0.13:8080/api/report/add");
    Map<String, dynamic> mapRes = res.data;
    ReportJsonParser jsonParser = ReportJsonParser.fromJson(mapRes);
    print(jsonParser);
    return jsonParser;
  }

  Future<ReportJsonParser> readReport(int reportNo) async {
    Response res =
        await dio.get("http://192.168.0.13:8080/api/report/read/$reportNo");
    Map<String, dynamic> mapRes = res.data;
    ReportJsonParser jsonParser = ReportJsonParser.fromJson(mapRes);
    return jsonParser;
  }

  Future<ReportJsonParser> modReport(int reportNo) async {
    Response res =
        await dio.put("http://192.168.0.13:8080/api/report/$reportNo");
    Map<String, dynamic> mapRes = res.data;
    ReportJsonParser jsonParser = ReportJsonParser.fromJson(mapRes);
    return jsonParser;
  }
}
