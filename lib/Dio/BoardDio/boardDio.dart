import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

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
        "modDate": modDate
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
    Response res = await dio.get("http://192.168.0.13:8080/api/board/list");
    // print("list"); //ok
    // print(res.data['dtoList']);
    resDto dto = resDto.fromdata(res.data);
    // print(dto);
    // JsonParser.fromJson(res.data);
    //List<JsonParser> perserList = mapRes.map((element){ log(element); return JsonParser.fromJson(element);}).toList();
    //print(mapRes);
    //print(perserList);
    return dto;
  }

  Future<http.Response> addBoard(String title, String contents, String category,
      int empNo, String mailAddress) async {
    var uri = Uri.parse("http://192.168.0.13:8080/api/board/add");
    Map<String, String> headers = {"Content-Type": "application/json"};

    Map data = {
      'title': title,
      'contents': contents,
      'category': category,
      'empNo': '$empNo',
      'mailAddress': mailAddress
    };
    var body = json.encode(data);
    var response = await http.post(uri, headers: headers, body: body);
    print(response.body);
    return response;
  }

  Future<JsonParser> readBoard(int boardNo) async {
    print("readpage");
    Response res =
        await dio.get("http://192.168.0.13:8080/api/board/read/$boardNo");
    print(res.data); //맞음
    Map<String, dynamic> mapRes = res.data;
    JsonParser parser = JsonParser.fromJson(mapRes);
    print(parser.boardNo);
    return parser;
  }

  Future<JsonParser> modBoard(int boardNo) async {
    Response res = await dio.put("http://192.168.0.13:8080/api/board/$boardNo");
    Map<String, dynamic> mapRes = res.data;
    JsonParser jsonParser = JsonParser.fromJson(mapRes);
    return jsonParser;
  }
}
