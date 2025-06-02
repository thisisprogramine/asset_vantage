
import 'package:asset_vantage/src/presentation/arguments/cash_balance_argument.dart';
import 'package:asset_vantage/src/presentation/arguments/document_argument.dart';
import 'package:asset_vantage/src/presentation/arguments/login_argument.dart';
import 'package:asset_vantage/src/presentation/arguments/net_worth_argument.dart';
import 'package:asset_vantage/src/presentation/arguments/performance_argument.dart';
import 'package:asset_vantage/src/presentation/arguments/user_profile_argument.dart';
import 'package:asset_vantage/src/presentation/screens/documents/documents_screen.dart';
import 'package:asset_vantage/src/presentation/screens/forgot_password/forgor_password_screen.dart';
import 'package:asset_vantage/src/presentation/screens/notifications/notifications_screen.dart';
import 'package:asset_vantage/src/presentation/screens/performance_report/performance_report_screen.dart';
import 'package:asset_vantage/src/presentation/screens/user_profile/user_profile_screen.dart';
import 'package:flutter/material.dart';

import '../../config/constants/route_constants.dart';
import '../arguments/expense_report_argument.dart';
import '../arguments/crop_image_argument.dart';
import '../arguments/income_expense_argument.dart';
import '../arguments/income_report_argument.dart';
import '../arguments/investment_policy_statement_argument.dart';
import '../arguments/mfa_login_argument.dart';
import '../arguments/reset_passoword_argument.dart';
import '../av_app_init.dart';
import '../screens/authentication/login_screen.dart';
import '../screens/cash_balance_report/cash_balance_report_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/expense_report/expense_report_screen.dart';
import '../screens/income_report/income_report_screen.dart';
import '../screens/insights/insights_screen.dart';
import '../screens/investment_policy_statement_report/ips_report_screen.dart';
import '../screens/mfa_login/mobile_number_screen.dart';
import '../screens/reset_password/reset_password_screen.dart';
import '../screens/theme/theme_screen.dart';
import '../screens/user_profile/privacy_policy/privacy_policy_screen.dart';
import '../screens/user_profile/profile_pic_edit_screen.dart';
import '../screens/user_profile/terms_and_condition/terms_and_condition_screen.dart';


class Routes {
  static Map<String, WidgetBuilder> getRoutes(RouteSettings setting) => {
        RouteList.initial: (context) => const AVAppInit(),
        RouteList.login: (context) => LoginScreen(argument: setting.arguments as LoginArgument,),
        RouteList.forgotPassword: (context) => const ForgotPasswordScreen(),
        RouteList.dashboard: (context) => const DashboardScreen(),
        RouteList.investmentPolicyReport: (context) => IPSReportScreen(argument: setting.arguments as InvestmentPolicyStatementArgument,),
        RouteList.cashBalanceReport: (context) => CashBalanceReportScreen(argument: setting.arguments as CashBalanceArgument,),
        RouteList.performanceReport: (context) => PerformanceReportScreen(argument: setting.arguments as PerformanceArgument,),
        RouteList.incomeReportScreen: (context) => IncomeReportScreen(argument: setting.arguments as IncomeReportArgument,),
        RouteList.expenseReportScreen: (context) => ExpenseReportScreen(argument: setting.arguments as ExpenseReportArgument,),
        RouteList.notifications: (context) => const NotificationsScreen(),
        RouteList.theme: (context) => const ThemeScreen(),
        RouteList.insights: (context) => const Chatbot(),
        RouteList.documents: (context) => DocumentsScreen(argument: setting.arguments as DocumentArgument,),
        RouteList.userProfile: (context) => UserProfileScreen(argument: setting.arguments as UserProfileArgument),
        RouteList.cropProfilePic: (context) => ProfilePicEditScreen(argument: setting.arguments as CropImageArgument),
        RouteList.tncScreen: (context) => const TermsAndConditionScreen(),
        RouteList.privacyPolicy: (context) => const PrivacyPolicyScreen(),
        RouteList.mfaLogin: (context) => MfaLoginScreen(argument: setting.arguments as MfaLoginArgument),
        RouteList.resetPassword: (context) => ResetPassword(argument: setting.arguments as ResetPasswordArgument),
      };
}
