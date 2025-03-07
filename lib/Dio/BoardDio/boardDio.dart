import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:thirdproject/diointercept%20.dart';

class JsonParser {
  final int boardNo;
  final String title;
  final String content;
  final String category;
  final DateTime regDate;
  final DateTime modDate;
  final String mailAddress;

  JsonParser(
      {required this.boardNo,
      required this.title,
      required this.content,
      required this.category,
      required this.regDate,
      required this.modDate,
      required this.mailAddress});

  factory JsonParser.fromJson(Map<String, dynamic> json) => JsonParser(
      boardNo: json['boardNo'],
      title: json['title'],
      content: json['contents'],
      category: json['category'],
      regDate: DateTime.parse(json['regdate']),
      modDate: DateTime.parse(json['moddate']),
      mailAddress: json['mailAddress']);

  Map<String, dynamic> toJson() => {
        "boardNo": boardNo,
        "title": title,
        "content": content,
        "category": category,
        "regDate": regDate,
        "modDate": modDate,
        "mailAddress": mailAddress,
      };
}

class resDto {
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

  resDto(
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

  factory resDto.fromdata(dynamic data) => resDto(
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

class BoardDio {
  final dio = Dio();

  Future<resDto> getAllList() async {
    Response res =
        await DioInterceptor.dio.get("http://192.168.0.51:8080/api/board/list");
    resDto dto = resDto.fromdata(res.data);
    return dto;
  }

  Future<dynamic> addBoard(String title, String contents, String category,
      int empNo, String mailAddress) async {
    var uri = Uri.parse("http://192.168.0.51:8080/api/board/add");

    Map data = {
      'title': title,
      'contents': contents,
      'category': category,
      'empNo': '$empNo',
      'mailAddress': mailAddress
    };
    var body = json.encode(data);
    var response = await DioInterceptor.dio.post(uri.toString(), data: data);
    print(response.data);
    return response.data;
  }

  Future<dynamic> modBoard(String title, String contents, String category,
      String mailAddress, int boardNo) async {
    print('zz');
    var uri = Uri.parse("http://192.168.0.51:8080/api/board/$boardNo");
    print(uri);

    Map data = {
      'title': title,
      'contents': contents,
      'category': category,
      'mailAddress': mailAddress,
      'boardNo': '$boardNo'
    };
    var body = json.encode(data);
    print(body);
    var response = await DioInterceptor.dio.put(uri.toString(), data: data);
    print(response.data);
    return response.data;
  }

  Future<JsonParser> readBoard(int boardNo) async {
    print("readpage");
    Response res = await DioInterceptor.dio
        .get("http://192.168.0.51:8080/api/board/read/$boardNo");
    print(res.data); //맞음
    Map<String, dynamic> mapRes = res.data;
    JsonParser parser = JsonParser.fromJson(mapRes);
    print(parser.boardNo);
    return parser;
  }
}
