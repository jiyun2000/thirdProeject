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
            future: ReportDio().readReport(widget.reportNo),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("에러발생 : ${snapshot.error}"));
              } else if (snapshot.hasData) {
                JsonParser jsonParser = snapshot.data!;
                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      jsonParser.isDayOff
                          ? Text(
                              '날짜: ${jsonParser.title}',
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            )
                          : Text(
                              '제목목: ${jsonParser.title}',
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                      const SizedBox(height: 8),
                      jsonParser.isDayOff
                          ? Text('시간: ${jsonParser.contents}',
                              style: const TextStyle(fontSize: 16))
                          : Text('내용: ${jsonParser.contents}',
                              style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 16),
                      Text('마감일: ${jsonParser.deadLine}',
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('등록일: ${jsonParser.reportingDate}',
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('수신인: ${jsonParser.receivers.join(', ')}',
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 16),
                      Text('발신인: ${jsonParser.sender}',
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: jsonParser.uploadFileNames.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 10, thickness: 1),
                          itemBuilder: (context, index) {
                            String fileName = jsonParser.uploadFileNames[index];
                            String fileUrl =
                                'http://192.168.0.13:8080/api/report/view/$fileName';
                            return ListTile(
                              title: Text('첨부서류${index + 1}'),
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
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
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
