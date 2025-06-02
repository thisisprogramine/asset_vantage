import "package:flutter/material.dart";
import 'package:flutter_test/flutter_test.dart';

import '../commons/utils.dart';
import 'document_robot.dart';
import 'hey_av_robot.dart';
import 'profile_screen_robot.dart';

class SideDrawerRobot {
  final WidgetTester _tester;
  final ProfileScreenRobot profRobot;
  final DocumentScreenRobot docRobot;
  final ChatBotScreenRobot chatBotScreenRobot;
  final _backButton = find.byKey(const ValueKey("back_button"));

  SideDrawerRobot(this._tester)
      : profRobot = ProfileScreenRobot(_tester),
        chatBotScreenRobot = ChatBotScreenRobot(_tester),
        docRobot = DocumentScreenRobot(_tester);

  Future<void> openDrawer() async {
    final drawer = find.byKey(const ValueKey("hamburger_icon"));
    await tapAndWait(_tester, drawer, 2);
  }

  Future<void> openProfile() async {
    await openDrawer();
    final profFinder = find.byKey(const ValueKey("profile_widget"));
    await tapAndWait(_tester, profFinder, 2);
    await profRobot.clickLicense();
    await profRobot.clickPassword();
    await profRobot.clickPrivpol();
    await profRobot.clicktnc();
    await profRobot.clickbiolog();
  }

  Future<void> openHeyAV() async {
    await openDrawer();
    final avFinder = find.byKey(const ValueKey("heyav"));
    await tapAndWait(_tester, avFinder, 8);
    await chatBotScreenRobot.sendMessage();
    await chatBotScreenRobot.testHistory();
  }

  Future<void> openDocTab() async {
    final docFinder = find.byKey(const ValueKey("docs"));
    await tapAndWait(_tester, docFinder, 7);
    await docRobot.searchDocuments();
    await docRobot.changeView();
    await docRobot.changeEntity();
  }

  Future<void> openNotifications() async {
    await openDrawer();
    final avFinder = find.byKey(const ValueKey("notify"));
    await tapAndWait(_tester, avFinder, 7);
    await tapAndWait(_tester, _backButton, 2);
  }

  Future<void> switchThemes() async {
    await openDrawer();
    final button = find.byKey(const ValueKey("themeSwitch"));
    final close = find.byKey(const ValueKey("close"));
    await tapAndWait(_tester, button, 2);
    await tapAndWait(_tester, close, 2);
  }

  Future<void> logout() async {
    await openDrawer();
    final logout = find.byKey(const ValueKey("logout"));
    await tapAndWait(_tester, logout, 3);
  }
}
