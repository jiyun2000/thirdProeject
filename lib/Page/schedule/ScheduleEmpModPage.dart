import 'package:flutter/material.dart';
import 'package:thirdproject/Dio/CalendarDio/emp_sche_dio.dart';
class ScheduleEmpModPage extends StatefulWidget{
  final int empSchNo;

  const ScheduleEmpModPage({super.key, required this.empSchNo});

  @override
  State<StatefulWidget> createState()=>_ScheduleEmpModState();
}

class _ScheduleEmpModState extends State<ScheduleEmpModPage>{

    final TextEditingController _startDateController = TextEditingController();
    final TextEditingController _endDateController = TextEditingController();
    final TextEditingController _scheduleTextController = TextEditingController();
    final TextEditingController _empNoContorller = TextEditingController();
    final TextEditingController _empSchNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('개인 스케줄 수정'),
      ),
      body: Padding(padding: EdgeInsets.all(16.0),
      child: FutureBuilder(future: EmpScheDio().readEmpSche(1, widget.empSchNo), 
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
         } else if (snapshot.hasError) {
              return Center(child: Text('에러 발생: ${snapshot.error}')); //여기서 에러가 발생한건데...
        } else if (snapshot.hasData) {
          JsonParser jsonParser = snapshot.data!;
          print("!!!!");
          print(jsonParser);

          _startDateController.text = jsonParser.startDate.toIso8601String();
          _endDateController.text = jsonParser.endDate.toIso8601String();
          _scheduleTextController.text = jsonParser.scheduleText;
          _empNoContorller.text = jsonParser.empNo.toString();
          _empSchNoController.text = widget.empSchNo.toString();

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
                controller: _empNoContorller,
                decoration: InputDecoration(labelText: '사원번호'),
              ),
              SizedBox(height: 16),
               TextField(
                controller: _empSchNoController,
                decoration: InputDecoration(labelText: '스케줄번호'),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: 200, 
                child: ElevatedButton(onPressed: (){
                  EmpScheDio().modEmpSchedule(
                    DateTime.parse(_startDateController.text), 
                    DateTime.parse(_endDateController.text), 
                    _scheduleTextController.text, 
                    int.parse(_empNoContorller.text), 
                    int.parse(_empSchNoController.text));
                },child: Text('수정'))),
                 SizedBox(
                height: 30,
              ),
               SizedBox(
                width: 200, 
                child: ElevatedButton(onPressed: (){
                 print('삭제');
                 EmpScheDio().delEmpSch(int.parse(_empNoContorller.text), int.parse(_empSchNoController.text));
                 print('삭제되었습니다.');
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