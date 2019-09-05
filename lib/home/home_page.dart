import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gank/history/daily_body.dart';
import 'package:gank/home/drawer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.blue),
      home: _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  final String title = "最新";

  _HomePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: HomeDrawer(),
      body: DailyBody.byLatest(),
    );
  }
}
