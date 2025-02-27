import 'package:flutter/material.dart';

class ScheduleModPage extends StatefulWidget{

  ScheduleModPage({super.key});

  @override
  State<StatefulWidget> createState() => _ScheduleModState();
}

class _ScheduleModState extends State<ScheduleModPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('일정 수정하기'),
      ),
    );
  }
}