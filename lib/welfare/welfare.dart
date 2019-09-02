import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gank/api/api.dart';
import 'package:gank/entity/entity.dart';
import 'package:gank/widget/GestureZoomBox.dart';
import 'package:gank/widget/base_staggered_grid_view.dart';

/// 福利页面
class WelfarePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WelfarePageState();
  }
}

class _WelfarePageState extends State<WelfarePage> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(context),
      body: BaseStaggeredGridView<Gank>(
        pageRequest: (page, pageSize) async {
          Welfare welfare = await API().getWelfare(page, pageSize);
          return welfare.result;
        },
        crossAxisCount: 2,
        itemBuilder: (context, index, gank) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => _createBigImagePage(gank.url)),
              );
            },
            child: Card(
              elevation: 5,
              margin: const EdgeInsets.all(5),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Hero(
                  tag: gank.url,
                  child: CachedNetworkImage(
                    imageUrl: gank.url,
                    placeholder: (context, url) => Icon(Icons.image),
                    errorWidget: (context, url, error) => Icon(Icons.broken_image),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar _createAppBar(BuildContext context) {
    return AppBar(
      leading: FlatButton(
        onPressed: () => Navigator.pop(context),
        child: Icon(
          Icons.arrow_back,
          color: Theme.of(context).primaryTextTheme.title.color,
        ),
      ),
      title: Text("福利"),
      centerTitle: true,
    );
  }

  Widget _createBigImagePage(String url) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
          tag: url,
          child: GestureZoomBox(
            child: CachedNetworkImage(
              imageUrl: url,
              placeholder: (context, url) => Icon(Icons.image),
              errorWidget: (context, url, error) => Icon(Icons.broken_image),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }
}
