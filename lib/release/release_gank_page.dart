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
import 'package:gank/i10n/localization_intl.dart';

class ReleaseGankPage extends StatefulWidget {
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
    return _ReleaseGankPageState();
  }
}

class _ReleaseGankPageState extends State<ReleaseGankPage> {
  GlobalKey _formKey = new GlobalKey<FormState>();
  TextEditingController _urlController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _nicknameController = TextEditingController();
  String _type;

  bool isReleasing = false;

  @override
  void initState() {
    super.initState();
    _type = widget.typeList[0];
  }

  @override
  Widget build(BuildContext context) {
    GankLocalizations localizations = GankLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.releaseGankTitle),
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
                labelText: localizations.gankUrl,
                icon: Icon(Icons.link),
              ),
              validator: (value) {
                return value.length > 0 && value.startsWith(RegExp('https?://'))
                    ? null
                    : localizations.gankUrlError;
              },
            ),
            TextFormField(
              controller: _descController,
              decoration: InputDecoration(
                labelText: localizations.gankDesc,
                icon: Icon(Icons.description),
              ),
              validator: (value) {
                return value.length > 0 ? null : localizations.gankDescError;
              },
            ),
            TextFormField(
              controller: _nicknameController,
              decoration: InputDecoration(
                labelText: localizations.gankWho,
                icon: Icon(Icons.person),
              ),
              validator: (value) {
                return value.length > 0 ? null : localizations.gankWhoError;
              },
            ),
            InputDecorator(
              decoration: InputDecoration(
                labelText: localizations.categoryTitle,
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
              ignoring: isReleasing,
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Offstage(
                      offstage: !isReleasing,
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
                      isReleasing ? localizations.releasing : localizations.release,
                      style: TextStyle(color: Theme.of(context).primaryTextTheme.title.color),
                    ),
                  ],
                ),
                onPressed: () {
                  if ((_formKey.currentState as FormState).validate()) {
                    release(_urlController.text, _descController.text, _nicknameController.text);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  release(String url, String desc, String who) {
    setState(() {
      isReleasing = true;
    });
    API().releaseGank(url, desc, who, _type).then((result) {
      showReleaseResult(GankLocalizations.of(context).releaseSuccess);
    }).catchError((error) {
      showReleaseResult(error?.message ?? GankLocalizations.of(context).releaseFailed);
    });
  }

  showReleaseResult(String msg) {
    setState(() {
      isReleasing = false;
    });
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.only(top: 12),
          children: <Widget>[
            Center(child: Text(msg, style: TextStyle(fontSize: 16))),
            FlatButton(
              child: Text(
                GankLocalizations.of(context).confirm,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
