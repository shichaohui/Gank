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
import 'package:gank/setting/setting_model.dart';

class SettingPage extends StatefulWidget {
  final String title = "设置";

  @override
  State<StatefulWidget> createState() {
    return _SettingPageState();
  }
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.palette, color: Theme.of(context).primaryColor),
            title: Text("修改主题"),
          ),
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 6,
              children: Store.value<SettingModel>(context).themeMap.values.map((themeData) {
                return GestureDetector(
                  onTap: () => Store.value<SettingModel>(context).$setTheme(themeData),
                  child: createColorBlock(themeData.primaryColor),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget createColorBlock(Color color) {
    return Container(
      width: 14,
      height: 14,
      color: color,
      margin: EdgeInsets.all(5),
    );
  }
}
