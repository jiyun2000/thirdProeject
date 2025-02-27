import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thirdproject/Dio/BoardDio/boardDio.dart';

class BoardReadpage extends StatefulWidget {
  final String BoardNo;

  const BoardReadpage({super.key, required this.BoardNo});

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: BoardDio().readBoard(int.parse(widget.BoardNo)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('에러 발생: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              JsonParser jsonParser = snapshot.data!;
              return ListView(
                children: [
                  Text(
                    '제목: ${jsonParser.title}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '등록자: ${jsonParser.mailAddress}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '카테고리: ${jsonParser.category}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '등록일: ${DateFormat('yyyy-MM-dd HH:mm').format(jsonParser.regDate)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '수정일: ${DateFormat('yyyy-MM-dd HH:mm').format(jsonParser.modDate)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '내용: ${jsonParser.content}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              );
            } else {
              return Center(child: Text('데이터가 없습니다.'));
            }
          },
        ),
      ),
    );
  }
}
