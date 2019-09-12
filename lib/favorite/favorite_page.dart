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
import 'package:gank/db/dao.dart';
import 'package:gank/db/table/favorite.dart';
import 'package:gank/gank_widget/gank_card.dart';
import 'package:gank/i10n/localization_intl.dart';

/// 收藏页面
class FavoritePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FavoritePageState();
  }
}

class _FavoritePageState extends State<FavoritePage> {
  Future<List<Favorite>> _future;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    GankLocalizations localizations = GankLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.favoriteTitle),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Favorite>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return _createLoadingBody();
          } else if (snapshot.hasError) {
            return _createErrorBody(context);
          } else if (snapshot.data.isEmpty) {
            return _createEmptyBody();
          } else {
            return _createBody(snapshot.data);
          }
        },
      ),
    );
  }

  /// 加载数据
  _loadData() {
    _future = DaoManager.instance.favoriteDao.getAll();
  }

  ///  创建正在加载数据的小部件
  Widget _createLoadingBody() {
    return Center(child: CircularProgressIndicator());
  }

  /// 创建加载数据错误的小部件
  Widget _createErrorBody(context) {
    return Center(
      child: FlatButton(
        child: Text(
          GankLocalizations.of(context).loadError,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        // 点击重新加载数据
        onPressed: () => setState(() => _loadData()),
      ),
    );
  }

  /// 创建无数据的小部件
  Widget _createEmptyBody() {
    return Center(child: Text(GankLocalizations.of(context).empty));
  }

  /// 创建页面主体，显示 [favoriteList]
  Widget _createBody(List<Favorite> favoriteList) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: favoriteList.map((favorite) {
        return Dismissible(
          key: Key(favorite.gank.id),
          background: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon((Icons.delete_sweep), color: Theme.of(context).primaryColor),
              Icon((Icons.delete_sweep), color: Theme.of(context).primaryColor),
              Icon((Icons.delete_sweep), color: Theme.of(context).primaryColor),
            ],
          ),
          child: GankCard(favorite.gank),
          onDismissed: (direction) {
            // 删除数据
            DaoManager.instance.favoriteDao.deleteById(favorite.gank.id).then((i) {
              setState(() => favoriteList.remove(favorite));
            });
          },
        );
      }).toList(),
    );
  }
}
