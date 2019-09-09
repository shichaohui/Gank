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
import 'package:provide/provide.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData _createThemeData(Color primaryColor) {
  return ThemeData(primarySwatch: primaryColor);
}

class SettingInfo {
  final Map<String, ThemeData> themeMap = {
    "blue": _createThemeData(Colors.blue),
    "indigo": _createThemeData(Colors.indigo),
    "cyan": _createThemeData(Colors.cyan),
    "yellow": _createThemeData(Colors.yellow),
    "lime": _createThemeData(Colors.lime),
    "amber": _createThemeData(Colors.amber),
    "orange": _createThemeData(Colors.orange),
    "red": _createThemeData(Colors.red),
    "pink": _createThemeData(Colors.pink),
    "purple": _createThemeData(Colors.purple),
    "green": _createThemeData(Colors.green),
    "teal": _createThemeData(Colors.teal),
  };

  ThemeData theme = _createThemeData(Colors.red);
}

class SettingModel extends SettingInfo with ChangeNotifier {
  final String keyTheme = "Theme";

  SettingModel() {
    _initPrimaryColor();
  }

  Future $setTheme(ThemeData themeData) async {
    if (!themeMap.containsValue(themeData)) {
      throw Exception("传入的 ThemeData 不在预置列表中");
    }
    this.theme = themeData;

    for (String themeName in themeMap.keys) {
      if (themeMap[themeName] == themeData) {
        (await SharedPreferences.getInstance()).setString(keyTheme, themeName);
        break;
      }
    }

    notifyListeners();
  }

  void _initPrimaryColor() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    theme = themeMap[preferences.get(keyTheme) ?? themeMap.keys.first];
    notifyListeners();
  }
}

class Store {
  static ProviderNode init({Widget child, dispose = true}) {
    final providers = Providers()..provide(Provider.value(SettingModel()));
    return ProviderNode(child: child, providers: providers, dispose: dispose);
  }

  static Provide<T> connect<T>({ValueBuilder<T> builder, Widget child, ProviderScope scope}) {
    return Provide<T>(builder: builder, child: child, scope: scope);
  }

  static T value<T>(BuildContext context, {ProviderScope scope}) {
    return Provide.value<T>(context, scope: scope);
  }
}
