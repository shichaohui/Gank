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
import 'package:gank/api/api.dart';
import 'package:gank/entity/entity.dart';
import 'package:gank/i10n/localization_intl.dart';

import 'gank_card.dart';

/// 显示指定日期干货数据的页面主体小部件
class DailyBody extends StatefulWidget {
  final String date;

  /// 生成指定日期 [date] 的小部件
  DailyBody.byDate(this.date) : assert(date != null && date != "");

  /// 生成最近发布数据的小部件
  DailyBody.byLatest() : date = "";

  @override
  State<StatefulWidget> createState() {
    return _DailyBodyState();
  }
}

class _DailyBodyState extends State<DailyBody> with TickerProviderStateMixin {
  Future<Daily> _future;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Daily>(
      // 加载最新数据
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<Daily> snapshot) {
        Widget bodyWidget;
        if (snapshot.connectionState != ConnectionState.done) {
          // 正在加载
          bodyWidget = _createLoadingBody();
        } else if (snapshot.hasError || snapshot.data.error) {
          // 加载失败
          bodyWidget = _createErrorBody(context);
        } else {
          // 加载成功
          bodyWidget = _createBody(snapshot.data.categories, snapshot.data.result);
        }
        return bodyWidget;
      },
    );
  }

  /// 加载数据
  _loadData() {
    _future = widget.date == "" ? API().getLatest() : API().getDaily(widget.date);
  }

  ///  创建正在加载数据的小部件
  Widget _createLoadingBody() {
    return Center(child: CircularProgressIndicator());
  }

  /// 创建加载数据错误的小部件
  Widget _createErrorBody(context) {
    return Center(
      child: FlatButton(
        child: Text(
          GankLocalizations.of(context).loadError,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        // 点击重新加载数据
        onPressed: () => setState(() => _loadData()),
      ),
    );
  }

  /// 创建页面主体，显示数据 [categories] 和 [data]。
  Widget _createBody(List<String> categories, Map<String, List<Gank>> data) {
    _filterAndSortCategories(categories);

    if (_tabController == null) {
      _tabController = TabController(length: categories.length, vsync: this);
    }

    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            boxShadow: [BoxShadow(color: Theme.of(context).primaryColor, blurRadius: 3)],
          ),
          child: TabBar(
            isScrollable: true,
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Theme.of(context).primaryTextTheme.title.color,
            tabs: categories.map((category) => Tab(text: category)).toList(),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: PageScrollPhysics(parent: BouncingScrollPhysics()),
            children: categories.map((category) => _GankList(data[category])).toList(),
          ),
        ),
      ],
    );
  }

  /// 对 [categories] 进行过滤和排序
  _filterAndSortCategories(List<String> categories) {
    categories.remove("福利");
    categories.remove("休息视频");
    categories.sort();
  }
}

/// 一个数据列表
class _GankList extends StatefulWidget {
  final List<Gank> gankList;

  /// 生成显示 [gankList] 数据的列表小部件
  _GankList(this.gankList);

  @override
  State<StatefulWidget> createState() {
    return _GankListState();
  }
}

class _GankListState extends State<_GankList> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: widget.gankList.length,
        itemBuilder: (context, index) {
          return GankCard(widget.gankList[index]);
        });
  }

  @override
  bool get wantKeepAlive => true;
}
