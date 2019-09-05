import 'package:flutter/material.dart';
import 'package:gank/api/api.dart';
import 'package:gank/entity/entity.dart';
import 'package:gank/home/gank_list_widget.dart';

class DailyBody extends StatefulWidget {
  final String date;

  DailyBody.byDate(this.date) : assert(date != null && date != "");

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
    _future = widget.date == "" ? API().getLatest() : API().getDaily(widget.date);
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
        // 构建最终显示的 Widget 树
        return bodyWidget;
      },
    );
  }

  Widget _createLoadingBody() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _createErrorBody(context) {
    return Center(
      child: FlatButton(
        child: Text(
          "加载失败，点我重试",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        onPressed: () => setState(() {}),
      ),
    );
  }

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
            children: categories.map((category) => GankListWidget(data[category])).toList(),
          ),
        ),
      ],
    );
  }

  _filterAndSortCategories(List<String> categories) {
    categories.remove("福利");
    categories.remove("休息视频");
    categories.sort();
  }
}
