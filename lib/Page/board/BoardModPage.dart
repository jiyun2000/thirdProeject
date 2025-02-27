import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thirdproject/Dio/BoardDio/boardDio.dart';

class BoardModPage extends StatefulWidget {
  final String BoardNo;

  const BoardModPage({super.key, required this.BoardNo});

  @override
  State<StatefulWidget> createState() => _BoardModState();
}

class _BoardModState extends State<BoardModPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _boardNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("공지사항 수정"),
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

              _titleController.text = jsonParser.title;
              _contentController.text = jsonParser.content;
              _emailController.text = jsonParser.mailAddress;
              _categoryController.text = jsonParser.category;
              _boardNoController.text = widget.BoardNo;

              return ListView(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: '제목'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _contentController,
                    decoration: InputDecoration(labelText: '내용'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _categoryController,
                    decoration: InputDecoration(labelText: '카테고리'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: '작성자'),
                  ),
                  SizedBox(height: 16),
                  SizedBox(height: 50),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        print(_titleController.text);
                        print(_contentController.text);
                        print(_categoryController.text);
                        print(_emailController.text);
                        print(int.parse(_boardNoController.text));

                        BoardDio().modBoard(
                          _titleController.text,
                          _contentController.text,
                          _categoryController.text,
                          _emailController.text,
                          int.parse(_boardNoController.text),
                        );
                      },
                      child: Text('수정완료'),
                    ),
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
