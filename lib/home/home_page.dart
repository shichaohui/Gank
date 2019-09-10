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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gank/gank_widget/daily_body.dart';
import 'package:gank/home/drawer.dart';
import 'package:gank/i10n/localization_intl.dart';
import 'package:gank/setting/setting_model.dart';

void main() => runApp(Store.init(child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Store.connect<SettingModel>(
      builder: (context, child, settingModel) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => GankLocalizations.of(context).appTitle,
          theme: settingModel.theme,
          locale: settingModel.locale,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GankLocalizationsDelegate.delegate
          ],
          supportedLocales: Settings.localeMap.values.toList(),
          home: _HomePage(),
        );
      },
    );
  }
}

class _HomePage extends StatefulWidget {
  _HomePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(GankLocalizations.of(context).latestTitle),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: HomeDrawer(),
      body: DailyBody.byLatest(),
    );
  }
}
