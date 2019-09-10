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
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gank/home/home_page.dart';
import 'package:gank/i10n/localization_intl.dart';
import 'package:gank/setting/setting_model.dart';

/// 启动应用程序
void main() => runApp(Store.init(child: MyApp()));

/// 应用程序入口
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Store.connect<SettingModel>(
      builder: (context, child, settingModel) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => GankLocalizations.of(context).appTitle,
          // 指定主题
          theme: settingModel.theme.themeData,
          // 指定语言
          locale: settingModel.language.locale,
          // 指定语言处理程序
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GankLocalizationsDelegate.delegate
          ],
          // 指定支持的语言
          supportedLocales: Settings.getSupportLocales(),
          // 首页
          home: HomePage(),
        );
      },
    );
  }
}
