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
          .then((welfare) => print(welfare.toJson()))
          .catchError((error) => print(error)));

  test(
      "get history",
          () => API()
          .getHistory(1, 5)
          .then((history) => print(history.toJson()))
          .catchError((error) => print(error)));

  test(
      "submit gank",
          () => API()
          .submitGank("http://www.baidu.com", "descccc", "meeeee", "iOS")
          .then((result) => print(result.toJson()))
          .catchError((error) => print(error)));

  test(
      "get Android gank",
          () => API()
          .getCategoryGank("Android", 1, 2)
          .then((result) => print(result))
          .catchError((error) => print(error)));
}
