import 'package:flutter/material.dart';
import 'package:thirdproject/Dio/reportDio/reportDio.dart';
import 'package:thirdproject/Page/report/report_add_page.dart';
import 'package:thirdproject/Page/report/report_read_page.dart';
import 'package:thirdproject/Page/report/sent_report_list_page.dart';

class ReceivedReportListPage extends StatefulWidget {
  final int empNo;
  const ReceivedReportListPage({super.key, required this.empNo});

  @override
  State<ReceivedReportListPage> createState() => _ReceivedReportListState();
}

class _ReceivedReportListState extends State<ReceivedReportListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('받은 보고서', style: TextStyle(fontWeight: FontWeight.bold)),
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
                label: const Text('보낸 보고서'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SentReportListPage(empNo: widget.empNo),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<ResDto>(
                future: ReportDio().getReceivedList(widget.empNo),
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
                            report['isDayOff'] ? '연차' : '일반 보고서',
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
