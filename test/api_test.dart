import 'package:flutter_test/flutter_test.dart';

import 'package:gank/api/api.dart';

void main() {
  test(
      "get data of today",
      () => API()
          .getLatest()
          .then((today) => print(today))
          .catchError((error) => print(error)));

  test(
      "get welfare",
          () => API()
          .getWelfare(1, 10)
          .then((welfare) => print(welfare))
          .catchError((error) => print(error)));

  test(
      "get history",
          () => API()
          .getHistory(1, 5)
          .then((welfare) => print(welfare))
          .catchError((error) => print(error)));
}
