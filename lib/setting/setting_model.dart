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
import 'package:gank/i10n/localization_intl.dart';
import 'package:provide/provide.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 主题
class GankTheme {
  final String tag;
  final ThemeData themeData;

  /// 通过 [tag] 和 [themeData] 创建主题实例
  GankTheme(this.tag, this.themeData);
}

/// 语言
class Language {
  static final Language followSystem = Language("LanguageFollowSystem", null);

  final String tag;
  final Locale locale;

  /// 通过 [tag] 和 [locale] 创建语言实例
  Language(this.tag, this.locale);
}

/// 设置
class Settings {
  /// 通过 [primaryColor] 创建主题
  static ThemeData _createThemeData(Color primaryColor) {
    return ThemeData(primarySwatch: primaryColor);
  }

  /// 预定义主题
  static final List<GankTheme> themeList = [
    GankTheme("blue", _createThemeData(Colors.blue)),
    GankTheme("indigo", _createThemeData(Colors.indigo)),
    GankTheme("cyan", _createThemeData(Colors.cyan)),
    GankTheme("yellow", _createThemeData(Colors.yellow)),
    GankTheme("lime", _createThemeData(Colors.lime)),
    GankTheme("amber", _createThemeData(Colors.amber)),
    GankTheme("orange", _createThemeData(Colors.orange)),
    GankTheme("red", _createThemeData(Colors.red)),
    GankTheme("pink", _createThemeData(Colors.pink)),
    GankTheme("purple", _createThemeData(Colors.purple)),
    GankTheme("green", _createThemeData(Colors.green)),
    GankTheme("teal", _createThemeData(Colors.teal)),
  ];

  /// 预定义语言
  static final List<Language> languageList = [
    Language.followSystem,
    Language("中文简体", Locale("zh", "CN")),
    Language("English (US)", Locale("en", "US")),
  ];

  /// 获取支持的语言
  static List<Locale> getSupportLocales() {
    return languageList.map((language) => language.locale).toList()..remove(null);
  }

  /// 当前使用的主题
  GankTheme theme = themeList.first;

  /// 当前使用的语言
  Language language = languageList.first;
}

class SettingModel extends Settings with ChangeNotifier {
  final String _keyTheme = "Theme";
  final String _keyLanguage = "Language";

  SettingModel() {
    _init();
  }

  void _init() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    theme = Settings.themeList.firstWhere(
      (item) => item.tag == preferences.get(_keyTheme),
      orElse: () => Settings.themeList.first,
    );
    language = Settings.languageList.firstWhere(
      (item) => item.tag == preferences.get(_keyLanguage),
      orElse: () => Settings.languageList.first,
    );
    notifyListeners();
  }

  /// 切换当前主题为 [theme]
  Future setTheme(BuildContext context, GankTheme theme) async {
    if (!Settings.themeList.contains(theme)) {
      throw Exception(GankLocalizations.of(context).themeError);
    }
    this.theme = theme;
    (await SharedPreferences.getInstance()).setString(_keyTheme, theme.tag);
    notifyListeners();
  }

  /// 切换语言为跟随系统设置
  Future setLocaleFollowSystem(BuildContext context) async {
    setLocale(context, Language.followSystem);
  }

  /// 切换当前语言为 [language]
  Future setLocale(BuildContext context, Language language) async {
    if (!Settings.languageList.contains(language)) {
      throw Exception(GankLocalizations.of(context).localeError);
    }
    this.language = language;
    (await SharedPreferences.getInstance()).setString(_keyLanguage, language.tag);
    notifyListeners();
  }
}

class Store {
  /// 初始化节点，默认提供 [SettingModel]
  static ProviderNode init({Widget child, dispose = true}) {
    final providers = Providers()..provide(Provider.value(SettingModel()));
    return ProviderNode(child: child, providers: providers, dispose: dispose);
  }

  /// 创建 [Provide]
  static Provide<T> connect<T>({ValueBuilder<T> builder, Widget child, ProviderScope scope}) {
    return Provide<T>(builder: builder, child: child, scope: scope);
  }

  /// 获取提供的数据
  static T value<T>(BuildContext context, {ProviderScope scope}) {
    return Provide.value<T>(context, scope: scope);
  }
}
