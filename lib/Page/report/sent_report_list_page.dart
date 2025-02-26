import 'package:flutter/material.dart';
import 'package:thirdproject/Dio/reportDio/reportDio.dart';
import 'package:thirdproject/Page/report/received_report_list_page.dart';

class SentReportListPage extends StatefulWidget {
  const SentReportListPage({super.key});

  @override
  State<StatefulWidget> createState() => _SentReportListState();
}

class _SentReportListState extends State<SentReportListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🍔🍟보고서'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReceivedReportListPage()),
                  );
                },
                child: const Text('🍔🍟받은 보고서'),
              ),
              SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReceivedReportListPage()),
                  );
                },
                child: const Text('💩보고서 등록'),
              ),
            ],
          ),
          FutureBuilder<ResDto>(
            future: ReportDio().getSentList(1),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                //print(snapshot.error);
                return Center(child: Text('에러 발생: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                print("데이터 존재함");
                ResDto parsingList = snapshot.data!;

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
                      title: Text('${parsingList.dtolist[index]['reportNo']}'),
                      subtitle: Text('${parsingList.dtolist[index]['title']}'),
                      trailing:
                          Text('${parsingList.dtolist[index]['reportStatus']}'),
                      // onTap: () {
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) =>
                      //               recieved_report_read_page()));
                      // },
                    );
                  },
                ));
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
