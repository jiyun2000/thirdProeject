import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BoardModPage extends StatefulWidget {
  final String BoardNo;
  const BoardModPage({super.key, required this.BoardNo});

  @override
  State<StatefulWidget> createState() => _BoardModState();
}

class _BoardModState extends State<BoardModPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('공지사항 수정'),
      ),
    );
  }
}
