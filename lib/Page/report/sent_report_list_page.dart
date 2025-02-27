import 'package:flutter/material.dart';
import 'package:thirdproject/Dio/reportDio/reportDio.dart';
import 'package:thirdproject/Page/report/received_report_list_page.dart';
import 'package:thirdproject/Page/report/report_read_page.dart';

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
        title: Text('🍔🍟보낸 보고서'),
      ),
      body: Column(
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
                      title: parsingList.dtolist[index]['isDayOff']
                          ? Text('연차')
                          : Text('일반'),
                      subtitle: parsingList.dtolist[index]['isDayOff']
                          ? Text(
                              '사용 날짜 : ${parsingList.dtolist[index]['title']} | 시간 : ${parsingList.dtolist[index]['contents']}')
                          : Text('${parsingList.dtolist[index]['title']}'),
                      trailing:
                          Text('${parsingList.dtolist[index]['reportStatus']}'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReportReadpage(
                                    reportNo: int.parse(
                                        '${parsingList.dtolist[index]['reportNo']}'))));
                      },
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
