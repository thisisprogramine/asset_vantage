import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:asset_vantage/main.dart' as app;
import 'robots/login/login_screen_robot.dart';
import 'robots/dashboard/dashboard_screen_robot.dart';
import 'robots/sidedrawer/side_drawer_robot.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  if (binding != null) {
    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  }

  // flutter test integration_test/app_test.dart

  LoginScreenRobot loginScreenRobot;
  DashboardScreenRobot dashboardScreenRobot;
  SideDrawerRobot sideDrawerRobot;

  group('end to end test', () {
    testWidgets(
        'Test Flow:-login>dashboard>Side Drawer Items>Dashboard Items>IPS>CB>NW>PER>logout',
        (widgetTester) async {
      loginScreenRobot = LoginScreenRobot(widgetTester);
      dashboardScreenRobot = DashboardScreenRobot(widgetTester);
      sideDrawerRobot = SideDrawerRobot(widgetTester);
      // await binding.traceAction(() async {
      await app.main();
      await widgetTester.pumpAndSettle(const Duration(seconds: 10));
      await loginScreenRobot.startLogin();
      await dashboardScreenRobot.openIPS();
      await dashboardScreenRobot.openCB();
      await dashboardScreenRobot.openNW();
      await dashboardScreenRobot.openPer();
      await dashboardScreenRobot.openIncome();
      await dashboardScreenRobot.openExpense();
      await sideDrawerRobot.openProfile();
      await sideDrawerRobot.openDocTab();
      await sideDrawerRobot.openHeyAV();
      await sideDrawerRobot.openNotifications();
      await sideDrawerRobot.switchThemes();
      await sideDrawerRobot.logout();
      // });
    });
  });
}
