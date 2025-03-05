import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thirdproject/Dio/EmpDio/employeesDio.dart';

class MyPage extends StatefulWidget{
  const MyPage({super.key});

  @override
  State<StatefulWidget> createState() => _MyPageState();
}



class _MyPageState extends State<MyPage> {

Future<int> getEmpNo() async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.getInt('empNo') ?? 0;
}

Future<int> getDeptNo() async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.getInt('deptNo') ?? 0;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("🙋‍♀️My Page"),
      ),
      body: Column(
      children:[ 

          FutureBuilder<int>(
            future: getEmpNo(), 
            builder: (context, empNoSnapshot) {
                if (empNoSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }else if(empNoSnapshot.hasError){
                  return Center(child: Text('Error:${empNoSnapshot.error}'));
                }else if(empNoSnapshot.hasData){
                  int empNo = empNoSnapshot.data!;
                    return FutureBuilder(future: Employeesdio().findByEmpNo(empNo), 
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Center(child: CircularProgressIndicator());
                        }else if(snapshot.hasError){
                          return Center(child: Text('에러 : ${snapshot.error}'));
                        }else if(snapshot.hasData){
                          JsonParser jsonParser = snapshot.data!;
                          return Expanded(
                            child: ListView(
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
                            ),
                          );
                        }else{
                          return Center(child: Text('데이터x'));
                        }
                      },
            );
            }else{
              return Center(child: Text('데이터를 불러오는데 실패하였습니다.'));
            }
            },)
      ]
      )
    );
  }
}