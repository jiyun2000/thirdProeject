import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thirdproject/Dio/EmpDio/employeesDio.dart';

class MyPage extends StatefulWidget{
  const MyPage({super.key});

  @override
  State<StatefulWidget> createState() => _MyPageState();
}

int empNo = 1;

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("🙋‍♀️My Page"),
      ),
      body: Padding(padding: EdgeInsets.all(16.0),
      child: FutureBuilder(future: Employeesdio().findByEmpNo(1), 
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }else if(snapshot.hasError){
          return Center(child: Text('에러 : ${snapshot.error}'));
        }else if(snapshot.hasData){
          JsonParser jsonParser = snapshot.data!;
          return ListView(
            children: [
              Text(
                '사원번호 : ${jsonParser.empNo}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                '이름 : ${jsonParser.firstName} ${jsonParser.lastName}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                '메일주소 : ${jsonParser.mailAddress} ',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 16),
              Text(
                '주소 : ${jsonParser.address} ',
                style: TextStyle(fontSize: 20),
              ),
             SizedBox(height: 16),
              Text(
                '전화번호 : ${jsonParser.phoneNum.substring(0,3)}-${jsonParser.phoneNum.substring(3,7)}-${jsonParser.phoneNum.substring(7,11)} ',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 16),
              Text(
                '성별 : ${jsonParser.gender == 'm' ? '남성' : '여성'} ',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 16),
              Text(
                '주민등록번호 : ${jsonParser.citizenId.substring(0,6)}-${jsonParser.citizenId.substring(6)} ',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 16),
              Text(
                '입사일 : ${DateFormat("yyyy-MM-dd").format(jsonParser.hireDate)}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 16),
              Text(
                '연봉 : ${jsonParser.salary} ',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 16),
              Text(
                '직책번호 : ${jsonParser.jobNo}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 16),
              Text(
                '생일 :  ${DateFormat("yyyy-MM-dd").format(jsonParser.birthday)} ',
                style: TextStyle(fontSize: 20),
              ),
               SizedBox(height: 16),
              Text(
                '부서번호 : ${jsonParser.deptNo} ',
                style: TextStyle(fontSize: 20),
              ),
            ],
          );
        }else{
          return Center(child: Text('데이터x'));
        }
      },),
      )
    );
  }
}