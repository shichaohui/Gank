import 'package:flutter_test/flutter_test.dart';
import 'package:gank/api/api.dart';

void main() {
  test(
      "get data of today",
      () => API()
          .getLatest()
          .then((today) => print(today.toJson()))
          .catchError((error) => print(error)));

  test(
      "get welfare",
          () => API()
          .getWelfare(1, 10)
          .then((gankList) => print(gankList))
          .catchError((error) => print(error)));

  test(
      "get history",
          () => API()
          .getHistory(1, 5)
          .then((historyList) => print(historyList))
          .catchError((error) => print(error)));

  test(
      "get daily",
          () => API()
          .getDaily("2019-04-10")
          .then((daily) => print(daily))
          .catchError((error) => print(error)));

  test(
      "submit gank",
          () => API()
          .submitGank("http://www.baidu.com", "descccc", "meeeee", "iOS")
          .then((v) => print("success"))
          .catchError((error) => print(error)));

  test(
      "get Android gank",
          () => API()
          .getCategoryGank("Android", 1, 2)
          .then((gankList) => print(gankList))
          .catchError((error) => print(error)));
}
