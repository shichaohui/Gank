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

import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'entity.g.dart';

/// 格式化 [date] 为 yyyy-mm-dd 的格式。
String _formatDate(String date) {
  DateTime time = DateTime.parse(date);
  return "${time.year}-${time.month.toString().padLeft(2, "0")}-${time.day.toString().padLeft(2, "0")}";
}

/// 指定日期的干货
@JsonSerializable()
class Daily {
  @JsonKey(name: "error")
  final bool error;
  @JsonKey(name: "category")
  final List<String> categories;
  @JsonKey(name: "results")
  final Map<String, List<Gank>> result;

  Daily({this.error, this.categories, this.result});

  factory Daily.fromJson(Map<String, dynamic> json) => _$DailyFromJson(json);

  Map<String, dynamic> toJson() => _$DailyToJson(this);
}

/// 单条干货
@JsonSerializable()
class Gank {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey(name: "createdAt")
  final String createdAt;
  @JsonKey(name: "desc")
  final String desc;
  @JsonKey(name: "images")
  final List<String> images;
  @JsonKey(name: "publishedAt")
  final String publishedAt;
  @JsonKey(name: "source")
  final String source;
  @JsonKey(name: "type")
  final String type;
  @JsonKey(name: "url")
  final String url;
  @JsonKey(name: "used")
  final bool used;
  @JsonKey(name: "who")
  final String who;

  final String formatPublishedAt;

  Gank({
    this.id,
    this.createdAt,
    this.desc,
    this.images,
    this.publishedAt,
    this.source,
    this.type,
    this.url,
    this.used,
    this.who,
  }) : formatPublishedAt = _formatDate(publishedAt);

  factory Gank.fromJson(Map<String, dynamic> json) => _$GankFromJson(json);

  Map<String, dynamic> toJson() => _$GankToJson(this);
}

/// 指定日期的干货内容
@JsonSerializable()
class History {
  @JsonKey(name: "title")
  final String title;
  @JsonKey(name: "content")
  final String content;
  @JsonKey(name: "publishedAt")
  final String publishedAt;

  final String formatPublishedAt;
  final String imageUrl;

  History(this.title, this.content, this.publishedAt)
      : formatPublishedAt = _formatDate(publishedAt),
        imageUrl = RegExp(r'src=\"(.+?)\"').firstMatch(content).group(1);

  factory History.fromJson(Map<String, dynamic> json) => _$HistoryFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryToJson(this);
}