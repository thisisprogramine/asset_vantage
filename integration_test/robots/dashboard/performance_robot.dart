import 'package:asset_vantage/src/presentation/screens/performance_report/performance_grouping_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../commons/utils.dart';

class PerformanceRobot {
  final WidgetTester _tester;
  final _done = find.byKey(const ValueKey('done_button'));

  PerformanceRobot(this._tester);

  Future<void> changeMarketValue() async {
    final sortBy = find.byKey(const ValueKey("sortBy"));
    final item = find.byKey(const ValueKey("sortBy4"));
    await tapAndWait(_tester, sortBy, 2);
    await tapAndWait(_tester, item, 1);
    await tapAndWait(_tester, _done, 2);
  }

  Future<void> changeTopLimit() async {
    final topItem = find.byKey(const ValueKey("topItem"));
    final item = find.byKey(const ValueKey("topItem1"));
    await tapAndWait(_tester, topItem, 2);
    await tapAndWait(_tester, item, 1);
    await tapAndWait(_tester, _done, 2);
  }

  Future<void> changeGroup() async {
    final groups = find.byType(PerformanceGroupingItem);
    await tapAndWait(_tester, groups.at(1), 2);
    await tapAndWait(_tester, groups.at(2), 2);
    await tapAndWait(_tester, groups.at(3), 2);
    await _tester.drag(
        find.byKey(const ValueKey("groupingList")), const Offset(-500, 0));
    await _tester.pumpAndSettle(const Duration(seconds: 2));
    await tapAndWait(_tester, groups.at(3), 2);
  }
}
