import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../commons/utils.dart';

class ChatBotScreenRobot {
  final WidgetTester _tester;
  final _backButton = find.byKey(const ValueKey("backButton"));
  ChatBotScreenRobot(this._tester);

  Future<void> sendMessage() async {
    final textfield = find.byKey(const ValueKey("textfield"));
    final sendButton = find.byKey(const ValueKey("sendButton"));
    await tapAndWait(_tester, textfield, 2);
    _tester.testTextInput.enterText('Cash allocation as of today');
    await _tester.testTextInput.receiveAction(TextInputAction.done);
    await _tester.pumpAndSettle(const Duration(seconds: 2));
    await tapAndWait(_tester, sendButton, 10);
  }

  Future<void> testHistory() async {
    final openHistory = find.byKey(const ValueKey("history"));
    final childWidget = find.byKey(const ValueKey("child0"));
    await tapAndWait(_tester, openHistory, 2);
    await _tester.pumpAndSettle(const Duration(seconds: 1));
    await tapAndWait(_tester, childWidget, 3);
    await tapAndWait(_tester, _backButton, 3);
  }
}
