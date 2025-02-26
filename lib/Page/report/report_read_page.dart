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
        title: Text("공지사항"),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: ReportDio().readReport(widget.reportNo),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("에러발생 : ${snapshot.error}"));
              } else if (snapshot.hasData) {
                return Text("has data");
              }
              throw context;
            },
          )
        ],
      ),
    );
  }
}
