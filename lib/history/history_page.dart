import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gank/api/api.dart';
import 'package:gank/entity/entity.dart';
import 'package:gank/history/daily_page.dart';
import 'package:gank/widget/super_flow_view.dart';

class HistoryPage extends StatefulWidget {
  final String title = "干货历史";

  @override
  State<StatefulWidget> createState() {
    return _HistoryPageState();
  }
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SuperFlowView<History>(
        physics: BouncingScrollPhysics(),
        pageRequest: (page, pageSize) async {
          return (await API().getHistory(page, pageSize)).result;
        },
        itemBuilder: (context, index, history) {
          return GestureDetector(
            onTap: () => showDaily(history),
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(5),
                child: Stack(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 3 / 2,
                      child: CachedNetworkImage(
                        imageUrl: history.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      child: Container(
                        decoration: BoxDecoration(color: Color.fromARGB(50, 0, 0, 0)),
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          history.formatPublishedAt,
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: Color.fromARGB(122, 0, 0, 0)),
                        padding: const EdgeInsets.all(5),
                        child: Text(history.title, style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  showDaily(History history) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DailyPage(history.formatPublishedAt)),
    );
  }
}
