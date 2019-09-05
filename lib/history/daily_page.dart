import 'package:flutter/material.dart';
import 'package:gank/history/daily_body.dart';

class DailyPage extends StatefulWidget {
  final String title;
  final String date;

  DailyPage(this.date) : title = date;

  @override
  State<StatefulWidget> createState() {
    return _DailyPageState();
  }
}

class _DailyPageState extends State<DailyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        elevation: 0,
      ),
      body: DailyBody.byDate(widget.date),
    );
  }
}
