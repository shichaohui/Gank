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
import 'package:gank/api/api.dart';
import 'package:gank/entity/entity.dart';
import 'package:gank/history/daily_page.dart';
import 'package:gank/i10n/localization_intl.dart';
import 'package:gank/widget/super_flow_view.dart';

/// 历史数据页面
class HistoryPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _HistoryPageState();
  }
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(GankLocalizations.of(context).historyTitle),
        centerTitle: true,
      ),
      body: SuperFlowView<History>(
        physics: BouncingScrollPhysics(),
        pageRequest: (page, pageSize) async {
          // 网络请求
          return await API().getHistory(page, pageSize);
        },
        itemBuilder: (context, index, history) {
          return GestureDetector(
            // 点击 Item 显示详细数据
            onTap: () => showDaily(history),
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(5),
                child: Stack(
                  children: <Widget>[
                    // 图片
                    AspectRatio(
                      aspectRatio: 3 / 2,
                      child: CachedNetworkImage(
                        imageUrl: history.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // 日期
                    Positioned(
                      child: Container(
                        decoration: BoxDecoration(color: Color.fromARGB(50, 0, 0, 0)),
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          history.formatPublishedAt,
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                    ),
                    // 标题
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: Color.fromARGB(122, 0, 0, 0)),
                        padding: const EdgeInsets.all(5),
                        child: Text(history.title, style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 显示指定的数据 [history]
  showDaily(History history) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DailyPage(history.formatPublishedAt)),
    );
  }
}
