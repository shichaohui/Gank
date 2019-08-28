import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'entity.g.dart';

/// 今天的干货
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

  Gank(
      {this.id,
      this.createdAt,
      this.desc,
      this.images,
      this.publishedAt,
      this.source,
      this.type,
      this.url,
      this.used,
      this.who});

  factory Gank.fromJson(Map<String, dynamic> json) => _$GankFromJson(json);

  Map<String, dynamic> toJson() => _$GankToJson(this);
}

/// 福利
@JsonSerializable()
class Welfare {
  @JsonKey(name: "error")
  final bool error;
  @JsonKey(name: "results")
  final List<Gank> result;

  Welfare(this.error, this.result);

  factory Welfare.fromJson(Map<String, dynamic> json) => _$WelfareFromJson(json);

  Map<String, dynamic> toJson() => _$WelfareToJson(this);
}
