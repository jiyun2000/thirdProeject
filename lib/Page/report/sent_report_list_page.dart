// import 'package:flutter/material.dart';
// import 'package:thirdproject/Dio/reportDio/reportDio.dart';
// import 'package:thirdproject/Page/report/received_report_list_page.dart';
// import 'package:thirdproject/Page/report/report_add_page.dart';
// import 'package:thirdproject/Page/report/report_read_page.dart';

// class SentReportListPage extends StatefulWidget {
//   final int empNo;
//   const SentReportListPage({super.key, required this.empNo});

//   @override
//   State<StatefulWidget> createState() => _SentReportListState();
// }

// class _SentReportListState extends State<SentReportListPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('🍔🍟보낸 보고서'),
//       ),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) =>
//                         ReceivedReportListPage(empNo: widget.empNo)),
//               );
//             },
//             child: const Text('🍔🍟받은 보고서'),
//           ),
//           SizedBox(
//             height: 8,
//           ),
//           FutureBuilder<ResDto>(
//             future: ReportDio().getSentList(widget.empNo),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 //print(snapshot.error);
//                 return Center(child: Text('에러 발생: ${snapshot.error}'));
//               } else if (snapshot.hasData) {
//                 print("데이터 존재함");
//                 ResDto parsingList = snapshot.data!;

//                 return Expanded(
//                     child: ListView.separated(
//                   itemCount: parsingList.dtolist.length,
//                   separatorBuilder: (context, index) {
//                     return Divider(
//                       color: const Color.fromARGB(255, 255, 255, 255),
//                       height: 10,
//                       thickness: 1,
//                     );
//                   },
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       leading: Icon(Icons.ac_unit_outlined),
//                       title: parsingList.dtolist[index]['isDayOff']
//                           ? Text('연차')
//                           : Text('일반'),
//                       subtitle: parsingList.dtolist[index]['isDayOff']
//                           ? Text(
//                               '사용 날짜 : ${parsingList.dtolist[index]['title']} | 시간 : ${parsingList.dtolist[index]['contents']}')
//                           : Text('${parsingList.dtolist[index]['title']}'),
//                       trailing:
//                           Text('${parsingList.dtolist[index]['reportStatus']}'),
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => ReportReadPage(
//                                     empNo: widget.empNo,
//                                     reportNo: int.parse(
//                                         '${parsingList.dtolist[index]['reportNo']}'))));
//                       },
//                     );
//                   },
//                 ));
//               } else {
//                 return Center(child: Text('데이터 없어요'));
//               }
//             },
//           ),
//         ],
//       ),
//       floatingActionButton: SizedBox(
//         height: 50,
//         width: 120,
//         child: FloatingActionButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => ReportAddPage(
//                         empNo: widget.empNo,
//                       )),
//             );
//           },
//           child: Text('연차 등록💩'),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:thirdproject/Dio/reportDio/reportDio.dart';
import 'package:thirdproject/Page/report/received_report_list_page.dart';
import 'package:thirdproject/Page/report/report_add_page.dart';
import 'package:thirdproject/Page/report/report_read_page.dart';

class SentReportListPage extends StatefulWidget {
  final int empNo;
  const SentReportListPage({super.key, required this.empNo});

  @override
  State<StatefulWidget> createState() => _SentReportListState();
}

class _SentReportListState extends State<SentReportListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('보낸 보고서', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('받은 보고서'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ReceivedReportListPage(empNo: widget.empNo),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<ResDto>(
                future: ReportDio().getSentList(widget.empNo),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('에러 발생: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('데이터가 없습니다.'));
                  }

                  ResDto parsingList = snapshot.data!;

                  return ListView.separated(
                    itemCount: parsingList.dtolist.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      var report = parsingList.dtolist[index];
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          leading: Icon(
                            report['isDayOff']
                                ? Icons.beach_access
                                : Icons.description,
                            color: Colors.blueAccent,
                          ),
                          title: Text(
                            report['isDayOff'] ? '연차' : '일반',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            report['isDayOff']
                                ? '사용 날짜: ${report['title']} | 시간: ${report['contents']}'
                                : '${report['title']}',
                          ),
                          trailing: Text(
                            '${report['reportStatus']}',
                            style: TextStyle(
                              color: report['reportStatus'] == '진행중'
                                  ? Colors.orange
                                  : report['reportStatus'] == '반려'
                                      ? Colors.red
                                      : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReportReadPage(
                                  empNo: widget.empNo,
                                  reportNo: int.parse('${report['reportNo']}'),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReportAddPage(empNo: widget.empNo),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('연차 등록'),
      ),
    );
  }
}
