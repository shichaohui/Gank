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
import 'package:gank/category/category_page.dart';
import 'package:gank/history/history_page.dart';
import 'package:gank/i10n/localization_intl.dart';
import 'package:gank/setting/setting_page.dart';
import 'package:gank/release/release_gank_page.dart';
import 'package:gank/welfare/welfare.dart';

/// 首页的抽屉
class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GankLocalizations localizations = GankLocalizations.of(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Center(
              child: Text(
                GankLocalizations.of(context).appTitle,
                style: TextStyle(color: Theme.of(context).primaryTextTheme.title.color, fontSize: 22),
              ),
            ),
          ),
          _createListTile(context, localizations.historyTitle, Icons.history, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryPage()));
          }),
          _createListTile(context, localizations.categoryTitle, Icons.category, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
          }),
          _createListTile(context, localizations.welfareTitle, Icons.image, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => WelfarePage()));
          }),
          _createListTile(context, localizations.releaseGankTitle, Icons.cloud_upload, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ReleaseGankPage()));
          }),
          Divider(),
          _createListTile(context, localizations.settingsTitle, Icons.settings, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage()));
          }),
        ],
      ),
    );
  }

  /// 通过标题[title]、图标[icon]、点击事件 [onTap] 创建列表的 Item 小部件
  ListTile _createListTile(
    BuildContext context,
    String title,
    IconData icon,
    GestureTapCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      onTap: onTap,
    );
  }
}
