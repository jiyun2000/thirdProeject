import 'package:flutter/material.dart';
import 'package:thirdproject/Dio/BoardDio/boardDio.dart';
import 'package:thirdproject/Page/BoardReadPage.dart';

class BoardPage extends StatefulWidget {
  
  const BoardPage({super.key});
  
  @override
  State<StatefulWidget> createState() => _BoardState();
}

class _BoardState extends State<BoardPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🎙️공지사항'),
      ),
      body: Column(
        children: [
          FutureBuilder<resDto>(
            future: BoardDio().getAllList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                //print(snapshot.error);
                return Center(child: Text('에러 발생: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                print("데이터 존재함");
                resDto parsingList = snapshot.data!;

                return Expanded(
                  child: ListView.separated(
                    itemCount: parsingList.dtolist.length,
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        height: 10,
                        thickness: 1,
                      );
                    },
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.ac_unit_outlined),
                        title: Text('${parsingList.dtolist[index]['boardNo']}'),
                        subtitle:
                            Text('${parsingList.dtolist[index]['title']}'),
                        trailing: Text(
                            '${parsingList.dtolist[index]['mailAddress']}'),
                        onTap: () {

                          Navigator.push(context, MaterialPageRoute(builder: 
                          (context) => BoardReadpage(BoardNo: '${parsingList.dtolist[index]['boardNo']}')));

                        },
                      );
                    },
                  ),
                );
              } else {
                return Center(child: Text('데이터 없어요'));
              }
            },
          ),
        ],
      ),
    );
  }
}
