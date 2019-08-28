import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gank/api/api.dart';
import 'package:gank/entity/entity.dart';

/// 福利页面
class WelfarePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WelfarePageState();
  }
}

class _WelfarePageState extends State<WelfarePage> with SingleTickerProviderStateMixin {
  final int _pageCount = 20;
  int _page = 1;

  final List<Gank> gankList = [];

  ScrollController _scrollController;

  bool _isLoadEnable = true;
  bool _isNoMore = false;

  @override
  void initState() {
    super.initState();

    _refresh();

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(context),
      body: RefreshIndicator(
        child: _createBody(),
        onRefresh: _refresh,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

  Axis axis = Axis.vertical;

  Widget _createBody() {
    int crossAxisCount = 2;
    return StaggeredGridView.countBuilder(
      physics: BouncingScrollPhysics(),
      controller: _scrollController,
      crossAxisCount: crossAxisCount,
      itemCount: gankList.length + 1,
      itemBuilder: (context, index) {
        if (index == gankList.length) {
          if (_isNoMore) {
            return createNoMoreWidget();
          }
          return createLoadingWidget();
        }
        return GestureDetector(
          onTap: () {
            setState(() => axis = axis == Axis.vertical ? Axis.horizontal : Axis.vertical);
          },
          child: Card(
            elevation: 5,
            margin: const EdgeInsets.all(5),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: CachedNetworkImage(
                imageUrl: gankList[index].url,
                placeholder: (context, url) => Icon(Icons.image),
                errorWidget: (context, url, error) => Icon(Icons.broken_image),
              ),
            ),
          ),
        );
      },
      staggeredTileBuilder: (index) {
        return StaggeredTile.fit(index == gankList.length ? crossAxisCount : 1);
      },
    );
  }

  Widget createLoadingWidget() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2)),
          Padding(padding: const EdgeInsets.only(left: 5, right: 5)),
          Text("正在加载..."),
        ],
      ),
    );
  }

  Widget createNoMoreWidget() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(child: Text("没有更多数据了")),
    );
  }

  Future<void> _refresh() async {
    if (!_isLoadEnable) {
      return;
    }
    _isLoadEnable = false;
    _page = 1;
    Welfare welfare = await API().getWelfare(_page, _pageCount);
    setState(() {
      gankList.clear();
      gankList.addAll(welfare.result);
      _isNoMore = welfare.result.isEmpty;
    });
    _isLoadEnable = true;
  }

  _loadMore() async {
    if (!_isLoadEnable) {
      return;
    }
    _isLoadEnable = false;
    _page++;
    Welfare welfare = await API().getWelfare(_page, _pageCount);
    setState(() {
      gankList.addAll(welfare.result);
      _isNoMore = welfare.result.isEmpty;
    });
    _isLoadEnable = true;
  }
}
