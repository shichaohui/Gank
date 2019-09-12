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

import 'dart:convert';

import 'package:gank/db/dao.dart';
import 'package:gank/db/db_helper.dart';
import 'package:gank/entity/entity.dart';

class Favorite {
  final Gank gank;

  Favorite(this.gank);

  factory Favorite.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic> mutableMap = Map.from(map);
    mutableMap["images"] = json.decode(mutableMap["images"]);
    mutableMap["used"] = mutableMap["images"] == 1;
    return Favorite(Gank.fromJson(mutableMap));
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = gank.toJson();
    map["images"] = json.encode(gank.images);
    return map;
  }
}

class FavoriteDao extends BaseDao<Favorite> {
  @override
  Future<int> delete({String where, List whereArgs}) {
    return DBHelper.instance.db.delete(getTableName(), where: where, whereArgs: whereArgs);
  }

  @override
  Future<int> deleteById(String id) {
    return delete(where: "_id=?", whereArgs: [id]);
  }

  @override
  Future<List<Favorite>> getAll({String where, List whereArgs}) async {
    return (await DBHelper.instance.db.query(getTableName(), where: where, whereArgs: whereArgs))
        .map((map) => Favorite.fromMap(map))
        .toList()
        .reversed
        .toList();
  }

  @override
  String getCreateTableSql() {
    return '''
  create table ${getTableName()} (
  _id text primary key,
  createdAt text not null,
  desc text not null,
  images text,
  publishedAt text not null,
  source text not null,
  type text not null,
  url text not null,
  used integer not null,
  who text not null
  )
  ''';
  }

  @override
  String getTableName() {
    return "favorite";
  }

  @override
  Future<bool> has(String where, List whereArgs) async {
    return (await getAll(where: where, whereArgs: whereArgs)).isNotEmpty;
  }

  @override
  Future<bool> hasId(String id) {
    return has("_id=?", [id]);
  }

  @override
  Future<int> insert(Favorite data) {
    return DBHelper.instance.db.insert(getTableName(), data.toMap());
  }
}
