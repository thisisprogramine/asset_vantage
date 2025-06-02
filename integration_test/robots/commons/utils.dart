import 'package:flutter_test/flutter_test.dart';

Future<void> tapAndWait(WidgetTester _tester, Finder finder, int time) async {
  await _tester.tap(finder);
  await _tester.pumpAndSettle(Duration(seconds: time));
}
