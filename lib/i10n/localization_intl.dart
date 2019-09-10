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
import 'package:intl/intl.dart';
import 'messages_all.dart';

class GankLocalizations {
  static Future<GankLocalizations> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((b) {
      Intl.defaultLocale = localeName;
      return new GankLocalizations();
    });
  }

  static GankLocalizations of(BuildContext context) {
    return Localizations.of<GankLocalizations>(context, GankLocalizations);
  }

  String get appTitle {
    return Intl.message(
      'Gank',
      name: 'appTitle',
      desc: 'Title for current application',
    );
  }

  String get latestTitle {
    return Intl.message(
      'Latest',
      name: 'latestTitle',
      desc: 'Title for latest ganks page',
    );
  }

  String get categoryTitle {
    return Intl.message(
      'Category',
      name: 'categoryTitle',
      desc: 'Title for category ganks page',
    );
  }

  String get historyTitle {
    return Intl.message(
      'History',
      name: 'historyTitle',
      desc: 'Title for history ganks page',
    );
  }

  String get welfareTitle {
    return Intl.message(
      'Welfare',
      name: 'welfareTitle',
      desc: 'Title for welfare ganks page',
    );
  }

  String get submitGankTitle {
    return Intl.message(
      'Submit Gank',
      name: 'submitGankTitle',
      desc: 'Title for submit ganks page',
    );
  }

  String get settingsTitle {
    return Intl.message(
      'Settings',
      name: 'settingsTitle',
      desc: 'Title for settings page',
    );
  }

  String get loadError {
    return Intl.message(
      'Error，click me to try again',
      name: 'loadError',
      desc: 'load data error for list',
    );
  }

  String get loadingMore {
    return Intl.message(
      'Loading more ...',
      name: 'loadingMore',
      desc: 'loading more data for list',
    );
  }

  String get noMore {
    return Intl.message(
      'No more',
      name: 'noMore',
      desc: 'No more data for list',
    );
  }

  String get empty {
    return Intl.message(
      'Empty',
      name: 'empty',
      desc: 'No data',
    );
  }

  String get themeError {
    return Intl.message(
      'The passing ThemeData is not in the preset list',
      name: 'themeError',
      desc: 'The passing ThemeData for setTheme() is not in the preset list',
    );
  }

  String get localeError {
    return Intl.message(
      'The passing Locale is not in the preset list',
      name: 'localeError',
      desc: 'The passing Locals for setLocale() is not in the preset list',
    );
  }

  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: 'Language selector title in list tile',
    );
  }

  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: 'Theme selector title in list tile',
    );
  }

  String get gankUrl {
    return Intl.message(
      'Gank url',
      name: 'gankUrl',
      desc: 'The gank url',
    );
  }

  String get gankUrlError {
    return Intl.message(
      'Please input correct url',
      name: 'gankUrlError',
      desc: 'The inputting gank url is error',
    );
  }

  String get gankDesc {
    return Intl.message(
      'Gank desc',
      name: 'gankDesc',
      desc: 'The gank description',
    );
  }

  String get gankDescError {
    return Intl.message(
      'Please input description',
      name: 'gankDescError',
      desc: 'The inputting gank description is error',
    );
  }

  String get gankWho {
    return Intl.message(
      'Nickname',
      name: 'gankWho',
      desc: 'The nickname of the submitter',
    );
  }

  String get gankWhoError {
    return Intl.message(
      'Please input your nickname',
      name: 'gankWhoError',
      desc: 'The inputting nickname is error',
    );
  }

  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: 'Submit',
    );
  }

  String get submitting {
    return Intl.message(
      'Submitting',
      name: 'submitting',
      desc: 'Submitting gank',
    );
  }

  String get submitFailed {
    return Intl.message(
      'Submit failed',
      name: 'submitFailed',
      desc: 'Submit gank failed',
    );
  }

  String get submitSuccess{
    return Intl.message(
      'Submit success',
      name: 'submitSuccess',
      desc: 'Submit gank success',
    );
  }

  String get confirm{
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: 'Confirm',
    );
  }

}

class GankLocalizationsDelegate extends LocalizationsDelegate<GankLocalizations> {
  static GankLocalizationsDelegate delegate = GankLocalizationsDelegate._();

  GankLocalizationsDelegate._();

  @override
  bool isSupported(Locale locale) => Settings.localeMap.containsValue(locale);

  @override
  Future<GankLocalizations> load(Locale locale) {
    return GankLocalizations.load(locale);
  }

  @override
  bool shouldReload(GankLocalizationsDelegate old) => false;
}
