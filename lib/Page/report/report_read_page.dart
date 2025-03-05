import 'package:flutter/material.dart';
import 'package:thirdproject/Dio/EmpDio/employeesDio.dart';
import 'package:thirdproject/Page/report/received_report_list_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:thirdproject/Dio/reportDio/reportDio.dart';

class ReportReadPage extends StatefulWidget {
  final int reportNo;
  final int empNo;

  const ReportReadPage(
      {super.key, required this.reportNo, required this.empNo});

  @override
  State<ReportReadPage> createState() => _ReportReadPageState();
}

class _ReportReadPageState extends State<ReportReadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("보고서"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: Future.wait([
            ReportDio().readReport(widget.reportNo),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("에러 발생: ${snapshot.error}"));
            } else if (!snapshot.hasData) {
              return const Center(child: Text("데이터가 없습니다."));
            }

            ReportJsonParser report = snapshot.data![0];
            return FutureBuilder(
              future: Future.wait([
                Employeesdio().findByEmpNo(report.sender),
                Employeesdio().findByEmpNo(report.receivers[0])
              ]),
              builder: (context, empSnapshot) {
                if (empSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (empSnapshot.hasError) {
                  return Center(child: Text("에러 발생: ${empSnapshot.error}"));
                } else if (!empSnapshot.hasData) {
                  return const Center(child: Text("데이터 없음"));
                }

                JsonParser sender = empSnapshot.data![0];
                JsonParser receiver = empSnapshot.data![1];

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(48.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(report.isDayOff ? '연차 사용' : '보고서',
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  Text(
                                      report.isDayOff
                                          ? '날짜: ${report.title}'
                                          : '제목: ${report.title}',
                                      style: const TextStyle(fontSize: 18)),
                                  const SizedBox(height: 8),
                                  Text(
                                      report.isDayOff
                                          ? '시간: ${report.contents}'
                                          : '내용: ${report.contents}',
                                      style: const TextStyle(fontSize: 16)),
                                  const SizedBox(height: 8),
                                  Text('마감일: ${report.deadLine}',
                                      style: const TextStyle(fontSize: 16)),
                                  const SizedBox(height: 8),
                                  Text('등록일: ${report.reportingDate}',
                                      style: const TextStyle(fontSize: 16)),
                                  const SizedBox(height: 8),
                                  Text(
                                      '수신인: ${receiver.firstName} ${receiver.lastName}',
                                      style: const TextStyle(fontSize: 16)),
                                  const SizedBox(height: 8),
                                  Text(
                                      '발신인: ${sender.firstName} ${sender.lastName}',
                                      style: const TextStyle(fontSize: 16)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (report.uploadFileNames.isNotEmpty) ...[
                        const Text('첨부 파일',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: report.uploadFileNames.length,
                          itemBuilder: (context, index) {
                            String fileName = report.uploadFileNames[index];
                            String fileUrl =
                                'http://localhost:8080/api/report/view/$fileName';
                            return Card(
                              child: ListTile(
                                title: Text('첨부 파일 ${index + 1}'),
                                trailing: const Icon(Icons.attach_file),
                                onTap: () async {
                                  final Uri url = Uri.parse(fileUrl);
                                  if (!await launchUrl(url,
                                      mode: LaunchMode.externalApplication)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('링크를 열 수 없습니다: $fileUrl')),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ],
                      const SizedBox(height: 16),
                      report.sender == 1
                          ? SizedBox.shrink()
                          : OverflowBar(
                              alignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.check),
                                  label: const Text('승인'),
                                  onPressed: () async {
                                    try {
                                      await ReportDio()
                                          .modReport(widget.reportNo, '진행중');
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ReceivedReportListPage(
                                                  empNo: widget.empNo),
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text('에러 발생: $e')),
                                      );
                                    }
                                  },
                                ),
                                SizedBox(
                                  width: 80,
                                ),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.cancel),
                                  label: const Text('반려'),
                                  onPressed: () async {
                                    try {
                                      await ReportDio()
                                          .modReport(widget.reportNo, '반려');
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ReceivedReportListPage(
                                                  empNo: widget.empNo),
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text('에러 발생: $e')),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
