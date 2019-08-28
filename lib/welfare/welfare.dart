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

  Axis _axis = Axis.vertical;

  int _targetPage = 0;
  double _targetOffset = 0.0;

  ScrollController _scrollController;
  PageController _pageController;

  bool _isLoadEnable = true;
  bool _isNoMore = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(context),
      body: RefreshIndicator(
        child: _axis == Axis.vertical ? _createScrollBody() : _createPageBody(),
        onRefresh: _refresh,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _pageController?.dispose();
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

  Widget _createScrollBody() {
    const int crossAxisCount = 2;
    return StaggeredGridView.countBuilder(
      physics: BouncingScrollPhysics(),
      controller: _createScrollController(),
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
          onTap: () => setState(() {
            _axis = Axis.horizontal;
            _targetPage = index;
            _targetOffset = _scrollController.offset;
          }),
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

  ScrollController _createScrollController() {
    _scrollController?.dispose();
    _scrollController = ScrollController(initialScrollOffset: _targetOffset);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadMore();
      }
    });
    return _scrollController;
  }

  Widget _createPageBody() {
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      controller: _createPageController(),
      itemCount: gankList.length + 1,
      itemBuilder: (context, index) {
        if (index == gankList.length) {
          if (_isNoMore) {
            return createNoMoreWidget();
          }
          return createLoadingWidget();
        }
        return GestureDetector(
          onTap: () => setState(() => _axis = Axis.vertical),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: CachedNetworkImage(
              imageUrl: gankList[index].url,
              placeholder: (context, url) => Icon(Icons.image),
              errorWidget: (context, url, error) => Icon(Icons.broken_image),
            ),
          ),
        );
      },
    );
  }

  PageController _createPageController() {
    _pageController?.dispose();
    _pageController = PageController(initialPage: _targetPage);
    _pageController.addListener(() {
      if (_pageController.position.pixels == _pageController.position.maxScrollExtent) {
        _loadMore();
      }
    });
    return _pageController;
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
