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
import 'package:gank/widget/gesture_zoom_box.dart';
import 'package:gank/widget/super_flow_view.dart';

/// 福利页面
class WelfarePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WelfarePageState();
  }
}

class _WelfarePageState extends State<WelfarePage> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(context),
      body: SuperFlowView<Welfare>(
        type: FlowType.STAGGERED_GRID,
        physics: BouncingScrollPhysics(),
        pageRequest: (page, pageSize) async {
          return (await API().getWelfare(page, pageSize)).result;
        },
        crossAxisCount: 2,
        itemBuilder: (context, index, welfare) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => _createBigImagePage(welfare.url)),
              );
            },
            child: Card(
              elevation: 5,
              margin: const EdgeInsets.all(5),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Hero(
                  tag: welfare.url,
                  child: CachedNetworkImage(
                    imageUrl: welfare.url,
                    placeholder: (context, url) => Icon(Icons.image),
                    errorWidget: (context, url, error) => Icon(Icons.broken_image),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
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

  Widget _createBigImagePage(String url) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
          tag: url,
          child: GestureZoomBox(
            child: CachedNetworkImage(
              imageUrl: url,
              placeholder: (context, url) => Icon(Icons.image),
              errorWidget: (context, url, error) => Icon(Icons.broken_image),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }
}
