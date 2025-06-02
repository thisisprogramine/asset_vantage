import 'package:asset_vantage/src/presentation/screens/investment_policy_statement_report/item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import './../commons/utils.dart';

class InvestmentPolicyRobot {
  final WidgetTester _tester;
  final _done = find.byKey(const ValueKey('done_button'));

  InvestmentPolicyRobot(this._tester);

  Future<void> changePolicy() async {
    final policy = find.byKey(const ValueKey("policyFilter"));
    final item = find.byKey(const ValueKey("policyFilter2"));
    await tapAndWait(_tester, policy, 2);
    await tapAndWait(_tester, item, 2);
    await tapAndWait(_tester, _done, 3);
  }

  Future<void> changeGroupSub() async {
    final subGroup = find.byKey(const ValueKey('groupingFilter'));
    final item = find.byKey(const ValueKey('groupingFilter2'));
    await tapAndWait(_tester, subGroup, 2);
    await tapAndWait(_tester, item, 2);
    await tapAndWait(_tester, _done, 3);
  }

  Future<void> changeYear() async {
    final year = find.byKey(const ValueKey('yearFilter'));
    final item = find.byKey(const ValueKey('yearFilter2'));
    await tapAndWait(_tester, year, 2);
    await tapAndWait(_tester, item, 2);
    await tapAndWait(_tester, _done, 3);
  }

  Future<void> changeGroup() async {
    final groups = find.byType(ItemWidget);
    await tapAndWait(_tester, groups.at(1), 2);
    await tapAndWait(_tester, groups.at(2), 2);
    await tapAndWait(_tester, groups.at(3), 2);
    await _tester.drag(
        find.byKey(const ValueKey("groupingList")), const Offset(-500, 0));
    await _tester.pumpAndSettle(const Duration(seconds: 2));
    await tapAndWait(_tester, groups.at(3), 2);
  }
}
