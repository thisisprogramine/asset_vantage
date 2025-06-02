import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../commons/utils.dart';

class ProfileScreenRobot {
  final WidgetTester _tester;
  final _backButton = find.byKey(const ValueKey("back_button"));

  ProfileScreenRobot(this._tester);

  Future<void> clickPassword() async {
    final passfinder = find.byKey(const ValueKey("password"));
    await tapAndWait(_tester, passfinder, 3);
  }

  Future<void> clickLicense() async {
    final licfinder = find.byKey(const ValueKey("license"));
    await tapAndWait(_tester, licfinder, 3);
  }

  Future<void> clickPrivpol() async {
    final privfinder = find.byKey(const ValueKey("priv-pol"));
    await tapAndWait(_tester, privfinder, 7);
    await tapAndWait(_tester, _backButton, 2);
  }

  Future<void> clicktnc() async {
    final privfinder = find.byKey(const ValueKey("tnc"));
    await tapAndWait(_tester, privfinder, 7);
    await tapAndWait(_tester, _backButton, 2);
  }

  Future<void> clickbiolog() async {
    final privfinder = find.byKey(const ValueKey("biolog"));
    await tapAndWait(_tester, privfinder, 2);
    await tapAndWait(_tester, privfinder, 2);
    await tapAndWait(_tester, _backButton, 2);
  }
}
