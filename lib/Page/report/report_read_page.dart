import 'package:thirdproject/Dio/EmpDio/employeesDio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:thirdproject/Dio/reportDio/reportDio.dart';

class ReportReadpage extends StatefulWidget {
  final int reportNo;
  const ReportReadpage({super.key, required this.reportNo});

  @override
  State<StatefulWidget> createState() => _ReportState();
}

class _ReportState extends State<ReportReadpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("보고서"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text('승인👌'),
              ),
              const SizedBox(
                width: 8,
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('반려🙏'),
              ),
            ],
          ),
          FutureBuilder(
            future: Future.wait([
              ReportDio().readReport(widget.reportNo),
            ]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("에러발생 : ${snapshot.error}"));
              } else if (snapshot.hasData) {
                ReportJsonParser reportJsonParser = snapshot.data![0];
                return FutureBuilder(
                    future: Future.wait([
                      Employeesdio().findByEmpNo(reportJsonParser.sender),
                      Employeesdio().findByEmpNo(reportJsonParser.receivers[0])
                    ]),
                    builder: (context, snapshot1) {
                      if (snapshot1.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot1.hasError) {
                        //print(snapshot.error);
                        return Center(child: Text('에러 발생: ${snapshot.error}'));
                      } else if (snapshot1.hasData) {
                        JsonParser jsonParserSender = snapshot1.data![0]!;
                        JsonParser jsonParserReceiver = snapshot1.data![1]!;
                        return Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              reportJsonParser.isDayOff
                                  ? Text(
                                      '날짜: ${reportJsonParser.title}',
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      '제목: ${reportJsonParser.title}',
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                              const SizedBox(height: 8),
                              reportJsonParser.isDayOff
                                  ? Text('시간: ${reportJsonParser.contents}',
                                      style: const TextStyle(fontSize: 16))
                                  : Text('내용: ${reportJsonParser.contents}',
                                      style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 16),
                              Text('마감일: ${reportJsonParser.deadLine}',
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 8),
                              Text('등록일: ${reportJsonParser.reportingDate}',
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 8),
                              Text(
                                  '수신인: ${jsonParserReceiver.firstName}${jsonParserReceiver.lastName}',
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 16),
                              Text(
                                  '발신인: ${jsonParserSender.firstName}${jsonParserSender.lastName}',
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 16),
                              Expanded(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount:
                                      reportJsonParser.uploadFileNames.length,
                                  separatorBuilder: (context, index) =>
                                      const Divider(height: 10, thickness: 1),
                                  itemBuilder: (context, index) {
                                    String fileName =
                                        reportJsonParser.uploadFileNames[index];
                                    String fileUrl =
                                        'http://192.168.0.51:8080/api/report/view/$fileName';
                                    return ListTile(
                                      title: Text('첨부서류${index + 1}'),
                                      onTap: () async {
                                        final Uri url = Uri.parse(fileUrl);
                                        if (!await launchUrl(url,
                                            mode: LaunchMode
                                                .externalApplication)) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    '링크를 열 수 없습니다: $fileUrl')),
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Center(child: Text('데이터 없어요'));
                      }
                    });
              } else {
                return const Center(child: Text('데이터가 없습니다.'));
              }
            },
          )
        ],
      ),
    );
  }
}
