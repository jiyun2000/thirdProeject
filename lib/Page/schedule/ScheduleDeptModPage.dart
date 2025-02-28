import 'package:flutter/material.dart';
import 'package:thirdproject/Dio/CalendarDio/dept_sche_dio.dart';

class ScheduleDeptModPage extends StatefulWidget {
  final int deptSchNo; 

  const ScheduleDeptModPage({super.key, required this.deptSchNo});

  @override
  State<ScheduleDeptModPage> createState() => _ScheduleDeptModPageState();
}

class _ScheduleDeptModPageState extends State<ScheduleDeptModPage> {

    final TextEditingController _startDateController = TextEditingController();
    final TextEditingController _endDateController = TextEditingController();
    final TextEditingController _scheduleTextController = TextEditingController();
    final TextEditingController _empNoController = TextEditingController();
    final TextEditingController _deptSchNoController = TextEditingController();
    final TextEditingController _deptNoController = TextEditingController();

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('부서서 스케줄 수정'),
      ),
      body: Padding(padding: EdgeInsets.all(16.0),
      child: FutureBuilder(future: DeptScheDio().readDeptSche(1, 1, widget.deptSchNo), 
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
         } else if (snapshot.hasError) {
              return Center(child: Text('에러 발생: ${snapshot.error}')); 
        } else if (snapshot.hasData) {
          JsonParser jsonParser = snapshot.data!;
          print("!!!!");
          print(jsonParser);

          _startDateController.text = jsonParser.startDate.toIso8601String();
          _endDateController.text = jsonParser.endDate.toIso8601String();
          _scheduleTextController.text = jsonParser.scheduleText;
          _empNoController.text = jsonParser.empNo.toString();
          _deptSchNoController.text = widget.deptSchNo.toString();
          _deptNoController.text = jsonParser.deptNo.toString();

          return ListView(
            children: [
              TextField(
                controller: _startDateController,
                decoration: InputDecoration(labelText: '시작날짜'),
              ),
              SizedBox(height: 16),
               TextField(
                controller: _endDateController,
                decoration: InputDecoration(labelText: '마감날짜'),
              ),
              SizedBox(height: 16),
               TextField(
                controller: _scheduleTextController,
                decoration: InputDecoration(labelText: '내용'),
              ),
              SizedBox(height: 16),
               TextField(
                controller: _empNoController,
                decoration: InputDecoration(labelText: '사원번호'),
              ),
              SizedBox(height: 16),
               TextField(
                controller: _deptSchNoController,
                decoration: InputDecoration(labelText: '스케줄번호'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _deptNoController,
                decoration: InputDecoration(labelText: '부서번호'),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: 200, 
                child: ElevatedButton(onPressed: (){
                  DeptScheDio().modDeptSchedule(
                    DateTime.parse(_startDateController.text), 
                    DateTime.parse(_endDateController.text), 
                    _scheduleTextController.text, 
                    int.parse(_empNoController.text), 
                    int.parse(_deptNoController.text),
                    int.parse(_deptSchNoController.text));
                },child: Text('수정'))),
              SizedBox(
                height: 30,
              ),
               SizedBox(
                width: 200, 
                child: ElevatedButton(onPressed: (){
                 print('삭제');
                 DeptScheDio().delDeptSche(int.parse(_deptNoController.text), int.parse(_deptSchNoController.text));
                 print("삭제되었습니다.");
                 
                },child: Text('삭제'))),
            ],
          );
        }else{
          return Center(child: Text('데이터x'));
        }
      },
      ),
    ),
    );
  }
}
