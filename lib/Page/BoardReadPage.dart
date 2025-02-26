import 'package:flutter/material.dart';
import 'package:thirdproject/Dio/BoardDio/boardDio.dart';

class BoardReadpage extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>_BoardState();
}

class _BoardState extends State<BoardReadpage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("공지사항"),
      ),
      // body: Column(
      //   children: [
      //     FutureBuilder
      //     (future: BoardDio().readBoard(boardNo), 
      //     builder: (context, snapshot) {
      //       if(snapshot.connectionState == ConnectionState.waiting){
      //         return Center(child: CircularProgressIndicator());
      //       }else if(snapshot.hasError){
      //         return Center(child: Text("에러발생 : ${snapshot.error}"));
      //       }else if(snapshot.hasData){
      //         print('데이터 존재함');
      //         return Expanded(child: ListView.separated(
      //           itemBuilder: itemBuilder, 
      //           separatorBuilder: separatorBuilder, 
      //           itemCount: parsingLIst.length)
      //       }
      //     },)
      //   ],
      // ),
    );
  }
}