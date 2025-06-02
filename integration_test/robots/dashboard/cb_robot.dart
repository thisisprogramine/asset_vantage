import 'package:asset_vantage/src/presentation/screens/cash_balance_report/cash_balance_grouping_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import './../commons/utils.dart';

class CashBalanceRobot {
  final WidgetTester _tester;
  final _done = find.byKey(const ValueKey('done_button'));

  CashBalanceRobot(this._tester);

  Future<void> changeFilter() async {
    final subGroup = find.byKey(const ValueKey("subGroup"));
    final item = find.byKey(const ValueKey("subGroup4"));
    await tapAndWait(_tester, subGroup, 2);
    await tapAndWait(_tester, item, 2);
    await tapAndWait(_tester, _done, 2);
  }

  Future<void> changeGroup() async {
    final groups = find.byType(CashBalanceGroupingItem);
    await tapAndWait(_tester, groups.at(1), 3);
  }
}
