import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gank/entity/entity.dart';
import 'package:gank/webview/WebViewPage.dart';

class GankListWidget extends StatefulWidget {
  final List<Gank> gankList;

  GankListWidget(this.gankList);

  @override
  State<StatefulWidget> createState() {
    return _GankListWidgetState();
  }
}

class _GankListWidgetState extends State<GankListWidget> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: widget.gankList.length,
        itemBuilder: (context, index) {
          Gank gank = widget.gankList[index];
          // 发布人和发布时间
          Widget publisherAndTimeWidget = Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                gank.who,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                _formatDate(gank.publishedAt),
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          );
          // 图片
          Widget imagesWidget = SizedBox(
            height: gank.images == null ? 0 : 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(top: 10),
              physics: BouncingScrollPhysics(),
              itemCount: gank.images == null ? 0 : gank.images.length,
              itemBuilder: (context, index) => CachedNetworkImage(
                imageUrl: gank.images[index],
                placeholder: (context, url) => Icon(Icons.image),
                errorWidget: (context, url, error) => Icon(Icons.broken_image),
              ),
              separatorBuilder: (context, index) => Padding(padding: const EdgeInsets.all(5)),
            ),
          );
          return GestureDetector(
            onTap: showGank(widget.gankList[index]),
            child: Card(
              elevation: 5,
              margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(gank.desc),
                    Padding(padding: const EdgeInsets.all(3)),
                    publisherAndTimeWidget,
                    imagesWidget,
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;

  /// 显示 [url] 对应的干货
  GestureTapCallback showGank(Gank gank) {
    return () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewPage(url: gank.url)));
    };
  }

  /// 格式化 [date] 为 yyyy-mm-dd 的格式。
  String _formatDate(String date) {
    DateTime time = DateTime.parse(date);
    return "${time.year}-${time.month.toString().padLeft(2, "0")}-${time.day.toString().padLeft(2, "0")}";
  }
}
