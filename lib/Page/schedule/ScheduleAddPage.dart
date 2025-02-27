import 'package:flutter/material.dart';

class ScheduleAddPage extends StatefulWidget{
  const ScheduleAddPage({super.key});

  @override
  State<StatefulWidget> createState()=>_ScheduleAddState();
}

class _ScheduleAddState extends State<ScheduleAddPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('일정 등록'),
      ),
    );
  }
}