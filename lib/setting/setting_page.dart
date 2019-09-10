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
import 'package:gank/i10n/localization_intl.dart';
import 'package:gank/setting/setting_model.dart';

class SettingPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _SettingPageState();
  }
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
  GankLocalizations localizations = GankLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settingsTitle),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.language, color: Theme.of(context).primaryColor),
            title: Text(localizations.language),
            trailing: Icon(Icons.arrow_drop_down),
            onTap: () => showLanguageDialog(),
          ),
          ListTile(
            leading: Icon(Icons.palette, color: Theme.of(context).primaryColor),
            title: Text(localizations.theme),
            trailing: Icon(Icons.arrow_drop_down),
            onTap: () => showThemeDialog(),
          ),
        ],
      ),
    );
  }

  showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.all(10),
          children: <Widget>[
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: Settings.themeMap.values.map((themeData) {
                return GestureDetector(
                  child: Container(color: themeData.primaryColor),
                  onTap: () {
                    Store.value<SettingModel>(context).setTheme(context, themeData);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            )
          ],
        );
      },
    );
  }

  showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: Settings.localeMap.keys.map((key) {
            return ListTile(
              title: Text(key),
              onTap: () {
                Store.value<SettingModel>(context).setLocale(context, Settings.localeMap[key]);
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }
}
