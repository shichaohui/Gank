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
import 'package:gank/gank_widget/gank_card.dart';
import 'package:gank/i10n/localization_intl.dart';
import 'package:gank/widget/super_flow_view.dart';

class CategoryPage extends StatefulWidget {
  final List<String> typeList = [
    "Android",
    "App",
    "iOS",
    "前端",
    "拓展资源",
    "瞎推荐",
  ];

  @override
  State<StatefulWidget> createState() {
    return _CategoryPageState();
  }
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.typeList.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(GankLocalizations.of(context).categoryTitle),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: widget.typeList.map((type) => Tab(child: Text(type))).toList(),
          ),
        ),
        body: TabBarView(
          physics: PageScrollPhysics(parent: BouncingScrollPhysics()),
          children: widget.typeList.map((type) {
            return _GankList(type);
          }).toList(),
        ),
      ),
    );
  }
}

class _GankList extends StatefulWidget {
  final String type;

  _GankList(this.type);

  @override
  State<StatefulWidget> createState() {
    return _GankListState();
  }
}

class _GankListState extends State<_GankList> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SuperFlowView<Gank>(
      pageRequest: (page, pageSize) async {
        return (await API().getCategoryGank(widget.type, page, pageSize));
      },
      itemBuilder: (context, index, gank) {
        return GankCard(gank);
      },
    );
  }
}
