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
import 'package:gank/webview/webview_page.dart';

/// 一条干货数据的卡片小部件
class GankCard extends StatelessWidget {
  final Gank gank;

  /// 生成 [gank] 的卡片小部件
  GankCard(this.gank);

  @override
  Widget build(BuildContext context) {
    // 发布人和发布时间
    Widget publisherAndTimeWidget = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          gank.who,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        Text(
          gank.formatPublishedAt,
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
      onTap: showGank(context),
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
  }

  /// 在 [WebViewPage] 显示当前干货的内容
  GestureTapCallback showGank(BuildContext context) {
    return () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewPage(url: gank.url)));
    };
  }
}
