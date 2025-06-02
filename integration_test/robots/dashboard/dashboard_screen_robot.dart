import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'cb_robot.dart';
import 'ips_robot.dart';
import 'nw_robot.dart';
import 'performance_robot.dart';
import './../commons/utils.dart';

class DashboardScreenRobot {
  final WidgetTester _tester;
  final _backButton = find.byKey(const ValueKey("back_button"));
  final InvestmentPolicyRobot _investmentPolicyRobot;
  final CashBalanceRobot _cashBalanceRobot;
  final NetWorthRobot _netWorthRobot;
  final PerformanceRobot _performanceobot;
  DashboardScreenRobot(this._tester)
      : _investmentPolicyRobot = InvestmentPolicyRobot(_tester),
        _cashBalanceRobot = CashBalanceRobot(_tester),
        _netWorthRobot = NetWorthRobot(_tester),
        _performanceobot = PerformanceRobot(_tester);

  Future<void> openIPS() async {
    final ipsFinder = find.byKey(const ValueKey("ips"));
    await tapAndWait(_tester, ipsFinder, 7);
    await _investmentPolicyRobot.changePolicy();
    await _investmentPolicyRobot.changeGroupSub();
    await _investmentPolicyRobot.changeYear();
    await _investmentPolicyRobot.changeGroup();
    await tapAndWait(_tester, _backButton, 2);
  }

  Future<void> openCB() async {
    final cbFinder = find.byKey(const ValueKey('cb'));
    await tapAndWait(_tester, cbFinder, 7);
    await _cashBalanceRobot.changeFilter();
    await _cashBalanceRobot.changeGroup();
    await tapAndWait(_tester, _backButton, 2);
  }

  Future<void> openNW() async {
    final nwFinder = find.byKey(const ValueKey('nw'));
    await tapAndWait(_tester, nwFinder, 7);
    await _netWorthRobot.subGroup();
    await _netWorthRobot.changePeriod();
    await _netWorthRobot.changeMetricTimes();
    await _netWorthRobot.changeGroup();
    await tapAndWait(_tester, _backButton, 2);
  }

  Future<void> openPer() async {
    final perFinder = find.byKey(const ValueKey('per'));
    await tapAndWait(_tester, perFinder, 7);
    await _performanceobot.changeMarketValue();
    await _performanceobot.changeTopLimit();
    await _performanceobot.changeGroup();
    await tapAndWait(_tester, _backButton, 2);
  }

  Future<void> openIncome() async {
    final incomeFinder = find.byKey(const ValueKey('income'));
    await tapAndWait(_tester, incomeFinder, 7);
    await tapAndWait(_tester, _backButton, 2);
  }

  Future<void> openExpense() async {
    final expenseFinder = find.byKey(const ValueKey('expense'));
    await tapAndWait(_tester, expenseFinder, 7);
    await tapAndWait(_tester, _backButton, 2);
  }
}
