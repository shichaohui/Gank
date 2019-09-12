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
import 'dart:core';

import 'package:dio/dio.dart';
import 'package:gank/entity/entity.dart';

typedef T _ResultHandler<T>(Map<String, dynamic> json);

/// 服务器接口
class API {
  static API _instance;

  Dio _dio;

  API._() {
    _dio = Dio(BaseOptions(baseUrl: "http://gank.io/api/"));
  }

  factory API() {
    if (_instance == null) {
      _instance = API._();
    }
    return _instance;
  }

  /// 使用 [handler] 处理服务器响应 [response] 中的 result 自动，并统一处理 error。
  Future<List<T>> _handleResponse<T>(Response response, _ResultHandler<T> handler) {
    Map<String, dynamic> map = json.decode(response.data);
    if (map["error"]) {
      return Future.error(DioError(message: map["msg"]));
    } else if (map["results"] is List<dynamic>) {
      return Future.value((map["results"] as List<dynamic>).map((json) => handler(json)).toList());
    } else {
      return Future.value(map["results"]);
    }
  }

  /// 获取最新一天的干货
  Future<Daily> getLatest() async {
    var response = await _dio.get<String>("today");
    return Daily.fromJson(json.decode(response.data));
  }

  /// 获取指定日期的干货
  Future<Daily> getDaily(String date) async {
    DateTime dateTime = DateTime.parse(date);
    var url = "day/${dateTime.year}/${dateTime.month}/${dateTime.day}";
    var response = await _dio.get<String>(url);
    return Daily.fromJson(json.decode(response.data));
  }

  /// 获取第 [page] 页的 [pageSize] 条 [type] 类型的干货
  Future<List<Gank>> getCategoryGank(String type, int page, int pageSize) async {
    var url = "data/$type/$pageSize/$page";
    var response = await _dio.get<String>(url);
    return _handleResponse(response, (json) => Gank.fromJson(json));
  }

  /// 获取第 [page] 页的 [pageSize] 条福利
  Future<List<Gank>> getWelfare(int page, int pageSize) async {
    return await getCategoryGank("%E7%A6%8F%E5%88%A9", page, pageSize);
  }

  /// 获取第 [page] 页的 [pageCount] 条历史数据
  Future<List<History>> getHistory(int page, int pageSize) async {
    var url = "history/content/$pageSize/$page";
    var response = await _dio.get<String>(url);
    return _handleResponse(response, (json) => History.fromJson(json));
  }

  /// 提审一条干货到干货集中营后台
  Future<void> releaseGank(String url, String desc, String who, String type) async {
    FormData data = FormData();
    data.add("url", url);
    data.add("desc", desc);
    data.add("who", who);
    data.add("type", type);
    data.add("debug", const bool.fromEnvironment("dart.vm.product"));
    var response = await _dio.post<String>("add2gank", data: data);
    return _handleResponse(response, (json) {});
  }
}
