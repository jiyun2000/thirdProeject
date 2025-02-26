import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:thirdproject/Dio/BoardDio/boardDio.dart';

class BoardReadpage extends StatefulWidget {
  final String BoardNo;

  BoardReadpage({super.key, required this.BoardNo});

  @override
  State<StatefulWidget> createState() => _BoardState();
}

class _BoardState extends State<BoardReadpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("공지사항"),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: BoardDio().readBoard(int.parse(widget.BoardNo)), 
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('에러 발생: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                JsonParser jsonParser = snapshot.data!;
                return Center(
                  child: Text(
                    '${jsonParser.content}',
                  ),
                );
              } else {
                return Center(child: Text('데이터가 없습니다.'));
              }
            },
          ),
        ],
      ),
    );
  }
}
