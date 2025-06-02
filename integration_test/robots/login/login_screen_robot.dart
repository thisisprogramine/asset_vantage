
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

class LoginScreenRobot {
  final WidgetTester _tester;
  final String _username = "chirag.nanavati";
  final String _password = "SSOtest@123";
  final String _clientSystemName = "avmobileapp";

  LoginScreenRobot(this._tester);

  Future<void> startLogin() async {
    final usernameField = find.byKey(const ValueKey('username'));
    final passwordField = find.byKey(const ValueKey('password'));
    final clientSystemNameField =
        find.byKey(const ValueKey('clientSystemName'));
    final loginButton = find.byKey(const ValueKey('loginButton'));
    await _tester.ensureVisible(usernameField);
    await _tester.enterText(usernameField, _username);
    await _tester.pumpAndSettle(const Duration(seconds: 2));

    await _tester.ensureVisible(passwordField);
    await _tester.enterText(passwordField, _password);
    await _tester.pumpAndSettle(const Duration(seconds: 2));

    await _tester.ensureVisible(clientSystemNameField);
    await _tester.enterText(clientSystemNameField, _clientSystemName);
    await _tester.pumpAndSettle(const Duration(seconds: 2));

    await _tester.ensureVisible(loginButton);
    await _tester.tap(loginButton);
    await _tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.byKey(const ValueKey("ips")), findsWidgets);
    // sleep(const Duration(seconds: 5));
  }
}
