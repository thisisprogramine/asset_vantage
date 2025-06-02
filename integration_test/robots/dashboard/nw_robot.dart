import 'package:asset_vantage/src/presentation/screens/net_worth_report/net_worth_grouping_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../commons/utils.dart';

class NetWorthRobot {
  final WidgetTester _tester;
  final _done = find.byKey(const ValueKey('done_button'));

  NetWorthRobot(this._tester);

  Future<void> subGroup() async {
    final subGroup = find.byKey(const ValueKey("subGroup"));
    final item = find.byKey(const ValueKey("subGroup4"));
    await tapAndWait(_tester, subGroup, 2);
    await tapAndWait(_tester, item, 2);
    await tapAndWait(_tester, _done, 2);
  }

  Future<void> changePeriod() async {
    final period = find.byKey(const ValueKey("periods"));
    final item = find.byKey(const ValueKey("periods4"));
    await tapAndWait(_tester, period, 2);
    await tapAndWait(_tester, item, 2);
    await tapAndWait(_tester, _done, 2);
  }

  Future<void> changeMetricTimes() async {
    final monthly = find.byKey(const ValueKey('monthly'));
    final quaterly = find.byKey(const ValueKey('quaterly'));
    final yearly = find.byKey(const ValueKey('yearly'));
    final fiscal = find.byKey(const ValueKey('fiscal'));
    await tapAndWait(_tester, monthly, 2);
    await tapAndWait(_tester, quaterly, 2);
    await tapAndWait(_tester, yearly, 2);
    await tapAndWait(_tester, fiscal, 2);
  }

  Future<void> changeGroup() async {
    final groups = find.byType(NetWorthGroupingItem);
    await tapAndWait(_tester, groups.at(1), 2);
    await tapAndWait(_tester, groups.at(2), 2);
    await tapAndWait(_tester, groups.at(3), 2);
    await _tester.drag(
        find.byKey(const ValueKey("groupingList")), const Offset(-500, 0));
    await _tester.pumpAndSettle(const Duration(seconds: 2));
    await tapAndWait(_tester, groups.at(3), 2);
  }
}
