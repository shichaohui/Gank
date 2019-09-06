import 'dart:convert';
import 'dart:core';

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

  /// 获取指定日期的干货
  Future<Daily> getDaily(String date) async {
    DateTime dateTime = DateTime.parse(date);
    var url = "http://gank.io/api/day/${dateTime.year}/${dateTime.month}/${dateTime.day}";
    var response = await Dio().get<String>(url);
    return Daily.fromJson(json.decode(response.data));
  }

  /// 获取第 [page] 页的 [pageCount] 条福利
  Future<WelfareResponse> getWelfare(int page, int pageSize) async {
    var url = "http://gank.io/api/data/%E7%A6%8F%E5%88%A9/$pageSize/$page";
    var response = await Dio().get<String>(url);
    return WelfareResponse.fromJson(json.decode(response.data));
  }

  /// 获取第 [page] 页的 [pageCount] 条历史数据
  Future<HistoryResponse> getHistory(int page, int pageSize) async {
    var url = "http://gank.io/api/history/content/$pageSize/$page";
    var response = await Dio().get<String>(url);
    return HistoryResponse.fromJson(json.decode(response.data));
  }

  /// 提审一条干货到干货集中营后台
  Future<SubmitResult> submitGank(String url, String desc, String who, String type) async {
    FormData data = FormData();
    data.add("url", url);
    data.add("desc", desc);
    data.add("who", who);
    data.add("type", type);
    data.add("debug", const bool.fromEnvironment("dart.vm.product"));
    var apiUrl = "http://gank.io/api/add2gank";
    var response = await Dio().post<String>(apiUrl, data: data);
    return SubmitResult.formJson(json.decode(response.data));
  }
}
