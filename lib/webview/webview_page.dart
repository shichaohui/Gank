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
import 'package:gank/db/dao.dart';
import 'package:gank/db/table/favorite.dart';
import 'package:gank/entity/entity.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// WebView 页面
class WebViewPage extends StatefulWidget {
  final Gank gank;

  /// 创建 WebView 页面，显示指定 [gank] 内容
  WebViewPage(this.gank, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WebViewPageState();
  }
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewController _controller;
  bool _isFinished = false;

  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    DaoManager.instance.favoriteDao.hasId(widget.gank.id).then((has) {
      setState(() => isFavorite = has);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      WebView(
        initialUrl: widget.gank.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) => _controller = controller,
        onPageFinished: (url) => setState(() => _isFinished = true),
      ),
    ];
    if (!_isFinished) {
      children.add(SizedBox(height: 3, child: LinearProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () => Share.share(widget.gank.url),
          ),
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              Future<int> future;
              if (isFavorite) {
                future = DaoManager.instance.favoriteDao.deleteById(widget.gank.id);
              } else {
                future = DaoManager.instance.favoriteDao.insert(Favorite(widget.gank));
              }
              future.then((i) => setState(() => isFavorite = !isFavorite));
            },
          ),
        ],
      ),
      body: WillPopScope(child: Stack(children: children), onWillPop: _goBack),
    );
  }

  /// 处理返回事件
  Future<bool> _goBack() async {
    if (_controller == null) {
      return true;
    }
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return false;
    }
    return true;
  }
}
