/*
 * Copyright (c) 2015-2019 StoneHui
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gank/i10n/localization_intl.dart';

/// 加载指定页面指定数量的数据
typedef Future<List<T>> PageRequest<T>(int page, int pageSize);

/// 构建 Item 小部件
typedef Widget ItemBuilder<T>(BuildContext context, int index, T item);

/// 处理流式布局中指定位置的小部件所占的格子数
typedef StaggeredTile StaggeredTileBuilder<T>(BuildContext context, int index, T item);

/// 流式布局的类型
enum FlowType { LIST, GRID, STAGGERED_GRID }

/// 流式布局的小部件
class SuperFlowView<T> extends StatefulWidget {
  final FlowType type;
  final ScrollPhysics physics;
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

  /// 创建流式布局小部件
  SuperFlowView({
    Key key,
    this.type = FlowType.LIST,
    this.physics,
    this.pageSize = 20,
    @required this.pageRequest,
    this.crossAxisCount = 2,
    @required this.itemBuilder,
    this.staggeredTileBuilder,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.loadingMoreWidget,
    this.noMoreWidget,
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

    _loadData();

    // 创建 Item 构建器
    _itemBuilder = (context, index) {
      if (_dataList.isEmpty) {
        return _emptyWidget();
      } else if (index < _dataList.length) {
        return widget.itemBuilder(context, index, _dataList[index]);
      } else if (_isNoMore) {
        return _noMoreWidget();
      } else {
        return _loadingMoreWidget();
      }
    };

    if (widget.type == FlowType.GRID || widget.type == FlowType.STAGGERED_GRID) {
      // 创建 Item 占位数处理器
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
      // 滚动到底部加载更多数据
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
            return _loadingWidget();
          } else if (snapshot.hasError || !snapshot.hasData) {
            return _errorWidget();
          } else {
            switch (widget.type) {
              case FlowType.GRID:
              case FlowType.STAGGERED_GRID:
                return _createStaggeredGridView();
                break;
              case FlowType.LIST:
              default:
                return _createListView();
                break;
            }
          }
        },
        future: _future,
      ),
      onRefresh: _refresh,
    );
  }

  /// 获取正在加载数据的布局
  Widget _loadingWidget() {
    return widget.loadingWidget ?? const Center(child: CircularProgressIndicator());
  }

  /// 获取加载数据失败的布局
  Widget _errorWidget() {
    return Center(
      child: FlatButton(
        onPressed: () => setState(() => _loadData()),
        child: widget.errorWidget ??
            Text(
              GankLocalizations.of(context).loadError,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
      ),
    );
  }

  /// 获取数据为空的布局
  Widget _emptyWidget() {
    return widget.emptyWidget ?? Center(child: Text(GankLocalizations.of(context).empty));
  }

  /// 获取正在加载更多数据的布局
  Widget _loadingMoreWidget() {
    return widget.loadingMoreWidget ??
        Padding(
          padding: EdgeInsets.all(10),
          child: Center(
              child: FractionallySizedBox(widthFactor: .5, child: LinearProgressIndicator())),
        );
  }

  /// 获取没有更多数据可加载的布局
  Widget _noMoreWidget() {
    return widget.noMoreWidget ??
        Padding(
          padding: EdgeInsets.all(10),
          child: Center(child: Text(GankLocalizations.of(context).noMore)),
        );
  }

  /// 创建 List 列表布局
  ListView _createListView() {
    return ListView.builder(
      physics: widget.physics,
      controller: _scrollController,
      itemCount: _dataList.length + 1,
      itemBuilder: _itemBuilder,
    );
  }

  /// 创建流式布局/宫格布局
  StaggeredGridView _createStaggeredGridView() {
    return StaggeredGridView.countBuilder(
      physics: widget.physics,
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

  /// 加载数据
  _loadData() {
    Future<List<T>> _load() async {
      _isLoading = true;
      _page = 1;
      List<T> list = await widget.pageRequest(_page, widget.pageSize);
      _dataList.clear();
      _dataList.addAll(list);
      _isLoading = false;
      _isNoMore = list.length < widget.pageSize;
      return list;
    }

    _future = _load();
  }

  /// 刷新数据
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

  /// 加载更多数据
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
