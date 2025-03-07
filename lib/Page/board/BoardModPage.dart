import 'package:flutter/material.dart';
import 'package:thirdproject/Dio/BoardDio/boardDio.dart';
import 'package:thirdproject/Page/board/BoardPage.dart';

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

  String _selectedCategory = '일반';

  final List<String> _categories = ['일반', '공지', '긴급', '완료'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("🎙️공지사항 수정", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        centerTitle: true,
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

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildInputField(
                        controller: _titleController,
                        labelText: '제목',
                        hintText: '제목을 입력하세요',
                      ),
                      const SizedBox(height: 16),
                      
                      _buildInputField(
                        controller: _contentController,
                        labelText: '내용',
                        hintText: '내용을 입력하세요',
                      ),
                      const SizedBox(height: 16),
                      
                      _buildDropdownField(),
                      const SizedBox(height: 16),
                      
                      _buildInputField(
                        controller: _emailController,
                        labelText: '작성자',
                        hintText: '작성자의 이메일',
                        enabled: false,
                      ),
                      const SizedBox(height: 20),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            BoardDio().modBoard(
                              _titleController.text,
                              _contentController.text,
                              _selectedCategory,
                              _emailController.text,
                              int.parse(_boardNoController.text),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BoardPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: Size(double.infinity, 50),
                          ),
                          child: Text('수정완료'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: Text('데이터가 없습니다.'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      enabled: enabled,
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: InputDecoration(
        labelText: '카테고리',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
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
    );
  }
}
