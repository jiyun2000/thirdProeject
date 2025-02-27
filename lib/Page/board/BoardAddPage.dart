import 'package:flutter/material.dart';

class BoardAddPage extends StatefulWidget{
  const BoardAddPage({super.key});

  @override
  State<StatefulWidget> createState() => _BoardAddState();
}

class _BoardAddState extends State<BoardAddPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🎙️공지사항 추가'),
      ),
    );
  }
}