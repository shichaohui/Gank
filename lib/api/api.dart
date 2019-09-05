import 'dart:core';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gank/entity/entity.dart';

class API {
  static API _instance;

  API._();

  factory API() {
    if (_instance == null) {
      _instance = API._();
    }
    return _instance;
  }

  /// 获取最新一天的干货
  Future<Daily> getLatest() async {
    var url = "http://gank.io/api/today";
    var response = await Dio().get<String>(url);
    return Daily.fromJson(json.decode(response.data));
  }

  /// 获取第 [page] 页的 [pageCount] 条福利
  Future<WelfareResponse> getWelfare(int page, int pageCount) async {
    var url = "http://gank.io/api/data/%E7%A6%8F%E5%88%A9/$pageCount/$page";
    var response = await Dio().get<String>(url);
    return WelfareResponse.fromJson(json.decode(response.data));
  }
}
