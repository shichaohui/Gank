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

class SubmitGankPage extends StatefulWidget {
  final String title = "提交干货";
  final List<String> typeList = [
    "Android",
    "iOS",
    "休息视频",
    "福利",
    "拓展资源",
    "前端",
    "瞎推荐",
    "App",
  ];

  @override
  State<StatefulWidget> createState() {
    return _SubmitGankPageState();
  }
}

class _SubmitGankPageState extends State<SubmitGankPage> {
  GlobalKey _formKey = new GlobalKey<FormState>();
  TextEditingController _urlController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _nicknameController = TextEditingController();
  String _type;

  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _type = widget.typeList[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        autovalidate: true,
        child: ListView(
          padding: EdgeInsets.only(left: 16, right: 16),
          children: <Widget>[
            TextFormField(
              autofocus: true,
              controller: _urlController,
              decoration: InputDecoration(
                labelText: "干货地址",
                icon: Icon(Icons.link),
              ),
              validator: (value) {
                return value.length > 0 && value.startsWith(RegExp('https?://'))
                    ? null
                    : "请输入正确的网址";
              },
            ),
            TextFormField(
              controller: _descController,
              decoration: InputDecoration(
                labelText: "干货描述",
                icon: Icon(Icons.description),
              ),
              validator: (value) {
                return value.length > 0 ? null : "请对干货进行简单描述";
              },
            ),
            TextFormField(
              controller: _nicknameController,
              decoration: InputDecoration(
                labelText: "你的昵称",
                icon: Icon(Icons.person),
              ),
              validator: (value) {
                return value.length > 0 ? null : "请输入你的昵称";
              },
            ),
            InputDecorator(
              decoration: InputDecoration(
                labelText: "分类",
                icon: Icon(Icons.category),
                border: InputBorder.none,
              ),
              child: DropdownButtonFormField(
                value: _type,
                items: widget.typeList.map((type) {
                  return DropdownMenuItem<String>(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) => setState(() => _type = value),
              ),
            ),
            IgnorePointer(
              ignoring: isSubmitting,
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Offstage(
                      offstage: !isSubmitting,
                      child: SizedBox.fromSize(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          backgroundColor: Theme.of(context).primaryTextTheme.title.color,
                        ),
                        size: Size.square(15),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      isSubmitting ? "正在提交..." : "提交",
                      style: TextStyle(color: Theme.of(context).primaryTextTheme.title.color),
                    ),
                  ],
                ),
                onPressed: () {
                  if ((_formKey.currentState as FormState).validate()) {
                    submit(_urlController.text, _descController.text, _nicknameController.text);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  submit(String url, String desc, String who) {
    setState(() {
      isSubmitting = true;
    });
    API().submitGank(url, desc, who, _type).then((result) {
      showSubmitResult("提交成功");
    }).catchError((error) {
      showSubmitResult(error?.message ?? "提交失败");
    });
  }

  showSubmitResult(String msg) {
    setState(() {
      isSubmitting = false;
    });
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.only(top: 12),
          children: <Widget>[
            Center(child: Text(msg, style: TextStyle(fontSize: 16))),
            FlatButton(
              child: Text("确定", style: TextStyle(color: Theme.of(context).primaryColor)),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
