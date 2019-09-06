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
import 'package:gank/widget/super_flow_view.dart';

class HistoryPage extends StatefulWidget {
  final String title = "干货历史";

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
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SuperFlowView<History>(
        physics: BouncingScrollPhysics(),
        pageRequest: (page, pageSize) async {
          return await API().getHistory(page, pageSize);
        },
        itemBuilder: (context, index, history) {
          return GestureDetector(
            onTap: () => showDaily(history),
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(5),
                child: Stack(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 3 / 2,
                      child: CachedNetworkImage(
                        imageUrl: history.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
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

  showDaily(History history) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DailyPage(history.formatPublishedAt)),
    );
  }
}
