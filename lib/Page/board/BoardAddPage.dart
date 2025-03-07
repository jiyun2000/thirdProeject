import 'package:flutter/material.dart';
import 'package:thirdproject/Dio/BoardDio/boardDio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  int? _empNo;
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadEmpNo();
    _loadEmail();
  }

  Future<void> _loadEmpNo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _empNo = prefs.getInt("empNo");
      if (_empNo != null) {
        _empNoController.text = _empNo.toString();
      }
    });
  }

  Future<void> _loadEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString("email");
      if (_email != null) {
        _emailController.text = _email.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          '🎙️공지사항 추가',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
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
                controller: _empNoController,
                labelText: '사원번호',
                hintText: '사원번호',
                enabled: false,
              ),
              const SizedBox(height: 16),

              _buildInputField(
                controller: _emailController,
                labelText: '이메일',
                hintText: '이메일',
                enabled: false,
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _empNo != null
                      ? () {
                          BoardDio().addBoard(
                            _titleController.text,
                            _contentController.text,
                            _selectedCategory,
                            _empNo!,
                            _email.toString(),
                          );
                          Navigator.pop(context);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text('등록'),
                ),
              ),
            ],
          ),
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
