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
