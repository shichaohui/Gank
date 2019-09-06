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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gank/entity/entity.dart';
import 'package:gank/gank_widget/gank_card.dart';
import 'package:gank/webview/webview_page.dart';

class GankList extends StatefulWidget {
  final List<Gank> gankList;

  GankList(this.gankList);

  @override
  State<StatefulWidget> createState() {
    return _GankListState();
  }
}

class _GankListState extends State<GankList> with AutomaticKeepAliveClientMixin {
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
