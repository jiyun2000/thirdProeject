import 'package:flutter/material.dart';
import 'package:thirdproject/Dio/BoardDio/boardDio.dart';

class BoardAddPage extends StatefulWidget {
  const BoardAddPage({super.key});

  @override
  State<StatefulWidget> createState() => _BoardAddState();
}

class _BoardAddState extends State<BoardAddPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _empNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _selectedCategory = '일반';

  final List<String> _categories = ['일반', '공지', '긴급'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🎙️공지사항 추가'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                      hintText: '제목을 입력하세요',
                      labelText: '제목',
                      border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _contentController,
                  decoration: InputDecoration(
                      hintText: "내용을 입력하세요",
                      labelText: '내용',
                      border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: '카테고리',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _empNoController,
                  maxLines: 1,
                  decoration: InputDecoration(
                      labelText: '사원번호', border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _emailController,
                  maxLines: 1,
                  decoration: InputDecoration(
                      labelText: '이메일', border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                    onPressed: () {
                      BoardDio().addBoard(
                          _titleController.text,
                          _contentController.text,
                          _selectedCategory,
                          int.parse(_empNoController.text),
                          _emailController.text);
                    },
                    child: Text('등록')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
