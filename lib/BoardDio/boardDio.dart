import 'package:dio/dio.dart';

class JsonParser {
  final int boardNo;
  final String title;
  final String content;
  final int empNo;
  final String category;
  final DateTime regDate;
  final DateTime modDate;

  JsonParser({
    required this.boardNo,
    required this.title,
    required this.content,
    required this.empNo,
    required this.category,
    required this.regDate,
    required this.modDate
  });

  factory JsonParser.fromJson(Map<String, dynamic> json) => JsonParser(
    boardNo: json['boardNo'], 
    title: json['title'], 
    content: json['content'], 
    empNo: json['empNo'], 
    category: json['category'], 
    regDate: json['regDate'], 
    modDate: json['modDate']);

    Map<String, dynamic> toJson() => {
      "boardNo":boardNo,
      "title":title,
      "content":content,
      "empNo":empNo,
      "category":category,
      "regDate":regDate,
      "modDate":modDate
    };
}

class BoardDio {
  final dio = Dio();

  Future<List<JsonParser>> getAllList() async{
    Response res = await dio.get("http://192.168.0.51:8080/api/board/list");
    List<dynamic> mapRes = res.data;
    List<JsonParser> perserList = mapRes.map((element)=>JsonParser.fromJson(element)).toList();
    return perserList;
  }

  Future<JsonParser> addBoard() async {
    Response res = await dio.post("http://192.168.0.51:8080/api/board/add");
    Map<String, dynamic> mapRes = res.data;
    JsonParser jsonParser = JsonParser.fromJson(mapRes);
    return jsonParser;
  }
  
  Future<JsonParser> readBoard(int boardNo) async {
    Response res = await dio.get("http://192.168.0.51:8080/api/board/read/$boardNo");
    Map<String, dynamic> mapRes = res.data;
    JsonParser jsonParser =JsonParser.fromJson(mapRes);
    return jsonParser;
  }

  Future<JsonParser> modBoard(int boardNo) async {
    Response res = await dio.put("http://192.168.0.51:8080/api/board/$boardNo");
    Map<String, dynamic> mapRes = res.data;
    JsonParser jsonParser =JsonParser.fromJson(mapRes);
    return jsonParser;
  }

}