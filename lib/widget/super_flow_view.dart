import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

typedef Future<List<T>> PageRequest<T>(int page, int pageSize);
typedef Widget ItemBuilder<T>(BuildContext context, int index, T item);
typedef StaggeredTile StaggeredTileBuilder<T>(BuildContext context, int index, T item);

enum FlowType { LIST, GRID, STAGGERED_GRID }

class SuperFlowView<T> extends StatefulWidget {
  final FlowType type;
  final int pageSize;
  final PageRequest<T> pageRequest;
  final int crossAxisCount;
  final ItemBuilder<T> itemBuilder;
  final StaggeredTileBuilder<T> staggeredTileBuilder;

  final Widget loadingWidget;
  final Widget errorWidget;
  final Widget emptyWidget;
  final Widget loadingMoreWidget;
  final Widget noMoreWidget;

  SuperFlowView({
    Key key,
    this.type = FlowType.LIST,
    this.pageSize = 20,
    @required this.pageRequest,
    this.crossAxisCount = 2,
    @required this.itemBuilder,
    this.staggeredTileBuilder,
    this.loadingWidget = const Center(child: CircularProgressIndicator()),
    this.errorWidget = const Center(child: Text("加载失败，下拉重新加载")),
    this.emptyWidget = const Center(child: Text("数据为空")),
    this.loadingMoreWidget = const Padding(
      padding: EdgeInsets.all(10),
      child: Center(child: FractionallySizedBox(widthFactor: .5, child: LinearProgressIndicator())),
    ),
    this.noMoreWidget = const Padding(
      padding: EdgeInsets.all(10),
      child: Center(child: Text("没有更多数据了")),
    ),
  })  : assert(pageSize > 0),
        assert(pageRequest != null),
        assert(crossAxisCount > 0),
        assert(itemBuilder != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SuperFlowViewState<T>();
  }
}

class _SuperFlowViewState<T> extends State<SuperFlowView<T>> {
  ScrollController _scrollController;

  int _page = 0;
  List<T> _dataList = [];

  bool _isLoading = false;
  bool _isNoMore = false;

  Future _future;

  IndexedWidgetBuilder _itemBuilder;

  IndexedStaggeredTileBuilder _staggeredTileBuilder;

  @override
  void initState() {
    super.initState();

    _future = _loadData();

    _itemBuilder = (context, index) {
      if (_dataList.isEmpty) {
        return widget.emptyWidget;
      } else if (index < _dataList.length) {
        return widget.itemBuilder(context, index, _dataList[index]);
      } else if (_isNoMore) {
        return widget.noMoreWidget;
      } else {
        return widget.loadingMoreWidget;
      }
    };

    if (widget.type == FlowType.GRID || widget.type == FlowType.STAGGERED_GRID) {
      _staggeredTileBuilder = (index) {
        if (index == _dataList.length) {
          return StaggeredTile.fit(widget.crossAxisCount);
        } else if (widget.staggeredTileBuilder != null) {
          return widget.staggeredTileBuilder(context, index, _dataList[index]);
        } else {
          return StaggeredTile.fit(1);
        }
      };
    }
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return widget.loadingWidget;
          } else if (snapshot.hasError || !snapshot.hasData) {
            return widget.errorWidget;
          } else {
            switch (widget.type) {
              case FlowType.GRID:
              case FlowType.STAGGERED_GRID:
                return createStaggeredGridView();
                break;
              case FlowType.LIST:
              default:
                return createListView();
                break;
            }
          }
        },
        future: _future,
      ),
      onRefresh: _refresh,
    );
  }

  ListView createListView() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      controller: _scrollController,
      itemCount: _dataList.length + 1,
      itemBuilder: _itemBuilder,
    );
  }

  StaggeredGridView createStaggeredGridView() {
    return StaggeredGridView.countBuilder(
      physics: BouncingScrollPhysics(),
      controller: _scrollController,
      crossAxisCount: widget.crossAxisCount,
      itemCount: _dataList.length + 1,
      itemBuilder: _itemBuilder,
      staggeredTileBuilder: _staggeredTileBuilder,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<T>> _loadData() async {
    _isLoading = true;
    _page = 1;
    List<T> list = await widget.pageRequest(_page, widget.pageSize);
    _dataList.clear();
    _dataList.addAll(list);
    _isLoading = false;
    _isNoMore = list.length < widget.pageSize;
    return list;
  }

  Future<void> _refresh() async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;
    _page = 1;
    List<T> list = await widget.pageRequest(_page, widget.pageSize);
    setState(() {
      _dataList.clear();
      _dataList.addAll(list);
      _isLoading = false;
      _isNoMore = list.length < widget.pageSize;
    });
  }

  void _loadMore() async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;
    _page++;
    List<T> list = await widget.pageRequest(_page, widget.pageSize);
    setState(() {
      _dataList.addAll(list);
      _isLoading = false;
      _isNoMore = list.length < widget.pageSize;
    });
  }
}
