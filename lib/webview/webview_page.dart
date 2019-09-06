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
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final url;
  final title;

  WebViewPage({Key key, @required this.url, this.title = ""}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WebViewPageState();
  }
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewController _controller;
  bool _isFinished = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      WebView(
        initialUrl: widget.url,
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
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: WillPopScope(child: Stack(children: children), onWillPop: goBack),
    );
  }

  Future<bool> goBack() async {
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
