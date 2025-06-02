
import 'dart:developer';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/domain/entities/authentication/user_entity.dart';
import 'package:asset_vantage/src/injector.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_accounts/cash_balance_account_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_grouping/cash_balance_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_report/cash_balance_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/dashboard/dashboard_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/dashboard_filter/dashboard_filter_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/favorites/favorites_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_account/income_account_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_as_on_date/income_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_denomination/income_denomination_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_period/income_period_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_sort_cubit/income_sort_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/networth_holding_method/networth_holding_method_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/networth_partnership_method/networth_partnership_method_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_holding_method/performance_holding_method_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_loading/performance_loading_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_partnership_method/performance_partnership_method_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_report/performance_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/universal_filter/enitity_universal_filter/universal_entity_filter_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/universal_filter/favourite_as_on_date_universal_filter/favourite_universal_filter_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/user_guide_assets/user_guide_assets_cubit.dart';
import 'package:asset_vantage/src/presentation/screens/browse_menu/browse_screen.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_primary_grouping/performance_primary_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/screens/dashboard/universal_filter/universal_as_on_date_filter.dart';
import 'package:asset_vantage/src/presentation/screens/dashboard/universal_filter/universal_entity_filter.dart';
import 'package:asset_vantage/src/presentation/screens/dashboard/universal_filter/universal_header.dart';
import 'package:asset_vantage/src/presentation/screens/dashboard/widget_selection_sheet.dart';
import 'package:asset_vantage/src/presentation/theme/theme_color.dart';
import 'package:asset_vantage/src/presentation/widgets/sliver_hidden_header.dart';
import 'package:asset_vantage/src/utilities/helper/file_helper.dart';
import 'package:asset_vantage/src/utilities/helper/flash_helper.dart';
import 'package:asset_vantage/src/utilities/helper/ui_helper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../config/constants/size_constants.dart';
import '../../../config/constants/strings_constants.dart';
import '../../../data/models/return_percentage/return_percentage_model.dart';
import '../../../utilities/helper/app_helper.dart';
import '../../arguments/cash_balance_argument.dart';
import '../../arguments/expense_report_argument.dart';
import '../../arguments/income_report_argument.dart';
import '../../arguments/net_worth_argument.dart';
import '../../arguments/performance_argument.dart';
import '../../blocs/authentication/user/user_cubit.dart';
import '../../blocs/cash_balance/cash_balance_as_on_date/cash_balance_as_on_date_cubit.dart';
import '../../blocs/cash_balance/cash_balance_currency/cash_balance_currency_cubit.dart';
import '../../blocs/cash_balance/cash_balance_denomination/cash_balance_denomination_cubit.dart';
import '../../blocs/cash_balance/cash_balance_entity/cash_balance_entity_cubit.dart';
import '../../blocs/cash_balance/cash_balance_loading/cash_balance_loading_cubit.dart';
import '../../blocs/cash_balance/cash_balance_number_of_period/cash_balance_number_of_period_cubit.dart';
import '../../blocs/cash_balance/cash_balance_period/cash_balance_period_cubit.dart';
import '../../blocs/cash_balance/cash_balance_sort_cubit/cash_balance_sort_cubit.dart';
import '../../blocs/cash_balance/cash_balance_sub_grouping/cash_balance_sub_grouping_cubit.dart';
import '../../blocs/currency_filter/currency_filter_cubit.dart';
import '../../blocs/dashboard/dashboard_cubit.dart';
import '../../blocs/dashboard_datepicker/dashboard_datepicker_cubit.dart';
import '../../blocs/denomination_filter/denomination_filter_cubit.dart';
import '../../blocs/expense/expense_account/expense_account_cubit.dart';
import '../../blocs/expense/expense_as_on_date/expense_as_on_date_cubit.dart';
import '../../blocs/expense/expense_chart/expense_chart_cubit.dart';
import '../../blocs/expense/expense_currency/expense_currency_cubit.dart';
import '../../blocs/expense/expense_denomination/expense_denomination_cubit.dart';
import '../../blocs/expense/expense_entity/expense_entity_cubit.dart';
import '../../blocs/expense/expense_loading/expense_loading_cubit.dart';
import '../../blocs/expense/expense_number_of_period/expense_number_of_period_cubit.dart';
import '../../blocs/expense/expense_period/expense_period_cubit.dart';
import '../../blocs/expense/expense_report/expense_report_cubit.dart';
import '../../blocs/expense/expense_sort_cubit/expense_sort_cubit.dart';
import '../../blocs/income/income_chart/income_chart_cubit.dart';
import '../../blocs/income/income_currency/income_currency_cubit.dart';
import '../../blocs/income/income_entity/income_entity_cubit.dart';
import '../../blocs/income/income_loading/income_loading_cubit.dart';
import '../../blocs/income/income_number_of_period/income_number_of_period_cubit.dart';
import '../../blocs/income/income_report/income_report_cubit.dart';
import '../../blocs/investment_policy_statement/investment_policy_statement_no_position/investment_policy_statement_no_position_cubit.dart';
import '../../blocs/net_worth/net_worth_as_on_date/net_worth_as_on_date_cubit.dart';
import '../../blocs/net_worth/net_worth_currency/net_worth_currency_cubit.dart';
import '../../blocs/net_worth/net_worth_denomination/net_worth_denomination_cubit.dart';
import '../../blocs/net_worth/net_worth_entity/net_worth_entity_cubit.dart';
import '../../blocs/net_worth/net_worth_grouping/net_worth_grouping_cubit.dart';
import '../../blocs/net_worth/net_worth_loading/net_worth_loading_cubit.dart';
import '../../blocs/net_worth/net_worth_number_of_period/net_worth_number_of_period_cubit.dart';
import '../../blocs/net_worth/net_worth_period/net_worth_period_cubit.dart';
import '../../blocs/net_worth/net_worth_report/net_worth_report_cubit.dart';
import '../../blocs/net_worth/net_worth_return_percent/net_worth_return_percent_cubit.dart';
import '../../blocs/net_worth/net_worth_sub_grouping/net_worth_sub_grouping_cubit.dart';
import '../../blocs/performance/performance_as_on_date/performance_as_on_date_cubit.dart';
import '../../blocs/performance/performance_currency/performance_currency_cubit.dart';
import '../../blocs/performance/performance_denomination/performance_denomination_cubit.dart';
import '../../blocs/performance/performance_entity/performance_entity_cubit.dart';
import '../../blocs/performance/performance_number_of_period/performance_number_of_period_cubit.dart';
import '../../blocs/performance/performance_period/performance_period_cubit.dart';
import '../../blocs/performance/performance_primary_sub_grouping/performance_primary_sub_grouping_cubit.dart';
import '../../blocs/performance/performance_return_percent/performance_return_percent_cubit.dart';
import '../../blocs/performance/performance_secondary_grouping/performance_secondary_grouping_cubit.dart';
import '../../blocs/performance/performance_secondary_sub_grouping/performance_secondary_sub_grouping_cubit.dart';
import '../../blocs/performance/performance_sort_cubit/performance_sort_cubit.dart';
import '../../blocs/universal_filter/as_on_date_universal_filter/universal_filter_as_on_date_cubit.dart';
import '../../blocs/universal_filter/favourite_universal_filter_cubit.dart';
import '../../blocs/universal_filter/universal_filter_cubit.dart';
import '../../widgets/av_app_bar.dart';
import '../../widgets/my_bottom_navigation_bar.dart';
import '../../widgets/size_tween_hero.dart';
import '../../widgets/user_guide_widget.dart';
import '../cash_balance_report/cash_balance_filter_modal.dart';
import '../favorite/favorite_screen.dart';
import '../favorite/favourite_universal_as_on_date_filter.dart';
import '../fevorite_screen/favorites_screen.dart';
import '../navigation_drawer/NavigationDrawer.dart';
import '../navigation_drawer/new_navigation_drawer.dart';
import 'dashboard_personalisation.dart';
import 'highlights/cash_balance_chart.dart';
import 'highlights/expense_highlight_widget.dart';
import 'highlights/income_highlight_widget.dart';
import 'net_worth_summary/net_worth_summary_chart.dart';
import 'highlights/performance_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarouselTracker {
  static bool wasCollapsed = false;
  static Function? expandCallback;
  static bool isPerformance=false;
  static bool isCashBalance=false;
  static bool isIncome=false;
  static bool isExpense=false;


  static void registerExpandCallback(Function callback) {
    expandCallback = callback;
  }

  static void expandIfNeeded() {
    if (wasCollapsed && expandCallback != null) {
      expandCallback!();
      wasCollapsed = false;
      isPerformance=false;
      isCashBalance=false;
      isIncome=false;
      isExpense=false;
    }
  }
}
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  late InvestmentPolicyNoPositionCubit performanceNoPositionCubit;
  int selectedIndex = 0;
  bool isFavorate = false;
  late DashboardCubit dashboardCubit;
  late UniversalFilterCubit universalFilterCubit;
  late UniversalEntityFilterCubit universalEntityFilterCubit;
  late UniversalFilterAsOnDateCubit universalFilterAsOnDateCubit;
  late FavouriteUniversalFilterCubit favouriteUniversalFilterCubit;
  late FavouriteUniversalFilterAsOnDateCubit favouriteUniversalFilterAsOnDateCubit;
  late NetWorthGroupingCubit netWorthPrimaryGroupingCubit;
  late NetWorthEntityCubit netWorthEntityCubit;
  late NetWorthPartnershipMethodCubit netWorthPartnershipMethodCubit;
  late NetWorthHoldingMethodCubit netWorthHoldingMethodCubit;
  late NetWorthPrimarySubGroupingCubit netWorthPrimarySubGroupingCubit;
  late NetWorthReportCubit netWorthReportCubit;
  late NetWorthPeriodCubit netWorthPeriodCubit;
  late NetWorthNumberOfPeriodCubit netWorthNumberOfPeriodCubit;
  late NetWorthReturnPercentCubit netWorthReturnPercentCubit;
  late NetWorthDenominationCubit netWorthDenominationCubit;
  late NetWorthCurrencyCubit netWorthCurrencyCubit;
  late NetWorthAsOnDateCubit netWorthAsOnDateCubit;
  late NetWorthLoadingCubit netWorthLoadingCubit;
  late PerformancePrimaryGroupingCubit performancePrimaryGroupingCubit;
  late PerformanceEntityCubit performanceEntityCubit;
  late PerformancePartnershipMethodCubit performancePartnershipMethodCubit;
  late PerformanceHoldingMethodCubit performanceHoldingMethodCubit;
  late PerformancePrimarySubGroupingCubit performancePrimarySubGroupingCubit;
  late PerformanceSecondaryGroupingCubit performanceSecondaryGroupingCubit;
  late PerformanceSecondarySubGroupingCubit
  performanceSecondarySubGroupingCubit;
  late PerformanceReportCubit performanceReportCubit;
  late PerformancePeriodCubit performancePeriodCubit;
  late PerformanceNumberOfPeriodCubit performanceNumberOfPeriodCubit;
  late PerformanceReturnPercentCubit performanceReturnPercentCubit;
  late PerformanceDenominationCubit performanceDenominationCubit;
  late PerformanceCurrencyCubit performanceCurrencyCubit;
  late PerformanceAsOnDateCubit performanceAsOnDateCubit;
  late PerformanceSortCubit performanceSortCubit;
  late PerformanceLoadingCubit performanceLoadingCubit;
  late CashBalanceSortCubit cashBalanceSortCubit;
  late CashBalanceEntityCubit cashBalanceEntityCubit;
  late CashBalancePrimaryGroupingCubit cashBalancePrimaryGroupingCubit;
  late CashBalancePrimarySubGroupingCubit cashBalancePrimarySubGroupingCubit;
  late CashBalancePeriodCubit cashBalancePeriodCubit;
  late CashBalanceNumberOfPeriodCubit cashBalanceNumberOfPeriodCubit;
  late CashBalanceCurrencyCubit cashBalanceCurrencyCubit;
  late CashBalanceDenominationCubit cashBalanceDenominationCubit;
  late CashBalanceAsOnDateCubit cashBalanceAsOnDateCubit;
  late CashBalanceReportCubit cashBalanceReportCubit;
  late CashBalanceAccountCubit cashBalanceAccountCubit;
  late CashBalanceLoadingCubit cashBalanceLoadingCubit;
  late IncomeReportCubit incomeReportCubit;
  late IncomeEntityCubit incomeEntityCubit;
  late IncomeAccountCubit incomeAccountCubit;
  late IncomePeriodCubit incomePeriodCubit;
  late IncomeNumberOfPeriodCubit incomeNumberOfPeriodCubit;
  late IncomeChartCubit incomeChartCubit;
  late IncomeDenominationCubit incomeDenominationCubit;
  late IncomeCurrencyCubit incomeCurrencyCubit;
  late IncomeAsOnDateCubit incomeAsOnDateCubit;
  late IncomeSortCubit incomeSortCubit;
  late IncomeLoadingCubit incomeLoadingCubit;
  late ExpenseReportCubit expenseReportCubit;
  late ExpenseEntityCubit expenseEntityCubit;
  late ExpenseAccountCubit expenseAccountCubit;
  late ExpensePeriodCubit expensePeriodCubit;
  late ExpenseNumberOfPeriodCubit expenseNumberOfPeriodCubit;
  late ExpenseChartCubit expenseChartCubit;
  late ExpenseDenominationCubit expenseDenominationCubit;
  late ExpenseCurrencyCubit expenseCurrencyCubit;
  late ExpenseAsOnDateCubit expenseAsOnDateCubit;
  late ExpenseSortCubit expenseSortCubit;
  late ExpenseLoadingCubit expenseLoadingCubit;
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    dashboardCubit = getItInstance<DashboardCubit>();
    universalFilterCubit = getItInstance<UniversalFilterCubit>();
    dashboardCubit.loadDashboard(
      context: context,
    );
    performanceNoPositionCubit =
        getItInstance<InvestmentPolicyNoPositionCubit>();
    context.read<UserCubit>().updateUser(
      context: context,
      onCollapsed: collapseWidgetFalse
    );

    universalEntityFilterCubit =
        universalFilterCubit.universalEntityFilterCubit;
    universalEntityFilterCubit.loadUniversalEntity(context: context);
    universalFilterAsOnDateCubit =
        universalFilterCubit.universalFilterAsOnDateCubit;
    universalFilterAsOnDateCubit.changeAsOnDate();

    favouriteUniversalFilterCubit = getItInstance<FavouriteUniversalFilterCubit>();
    favouriteUniversalFilterAsOnDateCubit = favouriteUniversalFilterCubit.favouriteUniversalFilterAsOnDateCubit;
    favouriteUniversalFilterAsOnDateCubit.changeAsOnDate();

    performanceReportCubit = getItInstance<PerformanceReportCubit>();
    performanceEntityCubit = performanceReportCubit.performanceEntityCubit;
    performancePartnershipMethodCubit = performanceReportCubit.performancePartnershipMethodCubit;
    performanceHoldingMethodCubit = performanceReportCubit.performanceHoldingMethodCubit;
    performancePrimaryGroupingCubit =
        performanceReportCubit.performancePrimaryGroupingCubit;
    performancePrimarySubGroupingCubit =
        performanceReportCubit.performancePrimarySubGroupingCubit;
    performanceSecondaryGroupingCubit =
        performanceReportCubit.performanceSecondaryGroupingCubit;
    performanceSecondarySubGroupingCubit =
        performanceReportCubit.performanceSecondarySubGroupingCubit;
    performancePeriodCubit = performanceReportCubit.performancePeriodCubit;
    performanceNumberOfPeriodCubit =
        performanceReportCubit.performanceNumberOfPeriodCubit;
    performanceReturnPercentCubit =
        performanceReportCubit.performanceReturnPercentCubit;
    performanceDenominationCubit =
        performanceReportCubit.performanceDenominationCubit;
    performanceCurrencyCubit = performanceReportCubit.performanceCurrencyCubit;
    performanceAsOnDateCubit = performanceReportCubit.performanceAsOnDateCubit;
    performanceSortCubit = performanceReportCubit.performanceSortCubit;
    performanceLoadingCubit = performanceReportCubit.performanceLoadingCubit;
    performanceReportCubit.loadPerformanceReport(context: context, tileName: "Performance");

    incomeReportCubit = getItInstance<IncomeReportCubit>();
    incomeEntityCubit = incomeReportCubit.incomeEntityCubit;
    incomeAccountCubit = incomeReportCubit.incomeAccountCubit;
    incomePeriodCubit = incomeReportCubit.incomePeriodCubit;
    incomeNumberOfPeriodCubit = incomeReportCubit.incomeNumberOfPeriodCubit;
    incomeChartCubit = incomeNumberOfPeriodCubit.incomeChartCubit;
    incomeDenominationCubit = incomeReportCubit.incomeDenominationCubit;
    incomeCurrencyCubit = incomeReportCubit.incomeCurrencyCubit;
    incomeAsOnDateCubit = incomeReportCubit.incomeAsOnDateCubit;
    incomeSortCubit = incomeReportCubit.incomeSortCubit;
    incomeLoadingCubit = incomeReportCubit.incomeLoadingCubit;
    incomeReportCubit.loadIncomeReport(
      context: context,
    );

    expenseReportCubit = getItInstance<ExpenseReportCubit>();
    expenseEntityCubit = expenseReportCubit.expenseEntityCubit;
    expenseAccountCubit = expenseReportCubit.expenseAccountCubit;
    expensePeriodCubit = expenseReportCubit.expensePeriodCubit;
    expenseNumberOfPeriodCubit = expenseReportCubit.expenseNumberOfPeriodCubit;
    expenseChartCubit = expenseNumberOfPeriodCubit.expenseChartCubit;
    expenseDenominationCubit = expenseReportCubit.expenseDenominationCubit;
    expenseCurrencyCubit = expenseReportCubit.expenseCurrencyCubit;
    expenseAsOnDateCubit = expenseReportCubit.expenseAsOnDateCubit;
    expenseSortCubit = expenseReportCubit.expenseSortCubit;
    expenseLoadingCubit = expenseReportCubit.expenseLoadingCubit;
    expenseReportCubit.loadExpenseReport(
      context: context,
    );

    cashBalanceSortCubit = getItInstance<CashBalanceSortCubit>();
    cashBalanceReportCubit = getItInstance<CashBalanceReportCubit>();
    cashBalanceEntityCubit = cashBalanceReportCubit.cashBalanceEntityCubit;
    cashBalancePrimaryGroupingCubit =
        cashBalanceReportCubit.cashBalancePrimaryGroupingCubit;
    cashBalancePrimarySubGroupingCubit =
        cashBalanceReportCubit.cashBalancePrimarySubGroupingCubit;
    cashBalancePeriodCubit = cashBalanceReportCubit.cashBalancePeriodCubit;
    cashBalanceNumberOfPeriodCubit =
        cashBalanceReportCubit.cashBalanceNumberOfPeriodCubit;
    cashBalanceCurrencyCubit = cashBalanceReportCubit.cashBalanceCurrencyCubit;
    cashBalanceDenominationCubit =
        cashBalanceReportCubit.cashBalanceDenominationCubit;
    cashBalanceAsOnDateCubit = cashBalanceReportCubit.cashBalanceAsOnDateCubit;
    cashBalanceAccountCubit = cashBalanceReportCubit.cashBalanceAccountCubit;
    cashBalanceLoadingCubit = cashBalanceReportCubit.cashBalanceLoadingCubit;
    cashBalanceReportCubit.loadCashBalanceReport(
        context: context, tileName: "cash_balance");

    netWorthReportCubit = getItInstance<NetWorthReportCubit>();
    netWorthEntityCubit = netWorthReportCubit.netWorthEntityCubit;
    netWorthPartnershipMethodCubit = netWorthReportCubit.netWorthPartnershipMethodCubit;
    netWorthHoldingMethodCubit = netWorthReportCubit.netWorthHoldingMethodCubit;
    netWorthPrimaryGroupingCubit =
        netWorthReportCubit.netWorthPrimaryGroupingCubit;
    netWorthPrimarySubGroupingCubit =
        netWorthReportCubit.netWorthPrimarySubGroupingCubit;
    netWorthPeriodCubit = netWorthReportCubit.netWorthPeriodCubit;
    netWorthNumberOfPeriodCubit =
        netWorthReportCubit.netWorthNumberOfPeriodCubit;
    netWorthReturnPercentCubit = netWorthReportCubit.netWorthReturnPercentCubit;
    netWorthDenominationCubit = netWorthReportCubit.netWorthDenominationCubit;
    netWorthCurrencyCubit = netWorthReportCubit.netWorthCurrencyCubit;
    netWorthAsOnDateCubit = netWorthReportCubit.netWorthAsOnDateCubit;
    netWorthLoadingCubit = netWorthReportCubit.netWorthLoadingCubit;
    netWorthReportCubit.loadNetWorthReport(
        tileName: "NetWorth", context: context);

    CarouselTracker.registerExpandCallback(() {
      setState(() {
        isCollapsed = false;
      });
      if(CarouselTracker.isPerformance==true){
        _controller.jumpToPage(1);
      }
      else if(CarouselTracker.isCashBalance==true){
        _controller.jumpToPage(2);
      }
      else if(CarouselTracker.isIncome==true){
        _controller.jumpToPage(3);
      }
      else if(CarouselTracker.isExpense==true){
        _controller.jumpToPage(4);
      }

    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    universalFilterCubit.close();
    universalEntityFilterCubit.close();
    universalFilterAsOnDateCubit.close();
    favouriteUniversalFilterAsOnDateCubit.close();
    favouriteUniversalFilterCubit.close();
    dashboardCubit.close();
    cashBalanceSortCubit.close();
    cashBalanceEntityCubit.close();
    cashBalancePrimaryGroupingCubit.close();
    cashBalancePrimarySubGroupingCubit.close();
    cashBalanceDenominationCubit.close();
    cashBalanceCurrencyCubit.close();
    cashBalanceNumberOfPeriodCubit.close();
    cashBalancePeriodCubit.close();
    cashBalanceAsOnDateCubit.close();
    expenseReportCubit.close();
    expenseEntityCubit.close();
    expenseAccountCubit.close();
    expensePeriodCubit.close();
    expenseNumberOfPeriodCubit.close();
    expenseChartCubit.close();
    expenseDenominationCubit.close();
    expenseCurrencyCubit.close();
    expenseAsOnDateCubit.close();
    expenseSortCubit.close();
    netWorthAsOnDateCubit.close();
    netWorthLoadingCubit.close();
    netWorthEntityCubit.close();
    netWorthPrimaryGroupingCubit.close();
    netWorthPrimarySubGroupingCubit.close();
    netWorthPeriodCubit.close();
    netWorthNumberOfPeriodCubit.close();
    netWorthReturnPercentCubit.close();
    netWorthDenominationCubit.close();
    netWorthCurrencyCubit.close();
    netWorthReportCubit.close();
  }

  final PageController _controller = PageController();
  bool isCollapsed = true;
  List<int> widgetSelected=[];

  void collapseWidget() {
    setState(() {
      isCollapsed = !isCollapsed;
    });
  }

  void collapseWidgetFalse() {
    setState(() {
      isCollapsed = false;
    });
  }

  List<Widget> highlightWidgets() => [
    Container(
      key: const ValueKey(0),
      child: NetWorthSummaryChartWidget(
        universalEntityFilterCubit: universalEntityFilterCubit,
        universalFilterAsOnDateCubit: universalFilterAsOnDateCubit,
        favouriteUniversalFilterAsOnDateCubit: favouriteUniversalFilterAsOnDateCubit,
        netWorthGroupingCubit: netWorthPrimaryGroupingCubit,
        netWorthReturnPercentCubit: netWorthReturnPercentCubit,
        netWorthPrimarySubGroupingCubit:
        netWorthPrimarySubGroupingCubit,
        netWorthNumberOfPeriodCubit:
        netWorthNumberOfPeriodCubit,
        netWorthLoadingCubit: netWorthLoadingCubit,
        netWorthEntityCubit: netWorthEntityCubit,
        netWorthDenominationCubit: netWorthDenominationCubit,
        netWorthReportCubit: netWorthReportCubit,
        netWorthAsOnDateCubit: netWorthAsOnDateCubit,
        netWorthCurrencyCubit: netWorthCurrencyCubit,
        netWorthPeriodCubit: netWorthPeriodCubit,
        netWorthPartnershipMethodCubit: netWorthPartnershipMethodCubit,
        netWorthHoldingMethodCubit: netWorthHoldingMethodCubit,
      ),
    ),
    Container(
      key: const ValueKey(1),
      child: PerformanceWidget(
        isFavorite: isFavorate,
        performanceSortCubit: performanceReportCubit.performanceSortCubit,
        universalFilterAsOnDateCubit: universalFilterAsOnDateCubit,
        universalEntityFilterCubit: universalEntityFilterCubit,
        favouriteUniversalFilterAsOnDateCubit: favouriteUniversalFilterAsOnDateCubit,
        performanceEntityCubit:
        performanceReportCubit.performanceEntityCubit,
        performanceReportCubit: performanceReportCubit,
        performancePrimaryGroupingCubit:
        performanceReportCubit.performancePrimaryGroupingCubit,
        performanceSecondaryGroupingCubit:
        performanceReportCubit.performanceSecondaryGroupingCubit,
        performancePrimarySubGroupingCubit:
        performanceReportCubit.performancePrimarySubGroupingCubit,
        performanceSecondarySubGroupingCubit:
        performanceReportCubit.performanceSecondarySubGroupingCubit,
        performanceNumberOfPeriodCubit:
        performanceReportCubit.performanceNumberOfPeriodCubit,
        performanceReturnPercentCubit:
        performanceReportCubit.performanceReturnPercentCubit,
        performanceCurrencyCubit:
        performanceReportCubit.performanceCurrencyCubit,
        performanceDenominationCubit:
        performanceReportCubit.performanceDenominationCubit,
        performanceAsOnDateCubit:
        performanceReportCubit.performanceAsOnDateCubit,
        performancePeriodCubit:
        performanceReportCubit.performancePeriodCubit,
        performanceLoadingCubit: performanceLoadingCubit,
        performancePartnershipMethodCubit: performancePartnershipMethodCubit,
        performanceHoldingMethodCubit: performanceHoldingMethodCubit,
      ),
    ),
    Container(
      key: const ValueKey(2),
      child: CashBalanceHighlightChart(
        cashBalanceEntityCubit: cashBalanceEntityCubit,
        universalFilterAsOnDateCubit: universalFilterAsOnDateCubit,
        universalEntityFilterCubit: universalEntityFilterCubit,
        favouriteUniversalFilterAsOnDateCubit: favouriteUniversalFilterAsOnDateCubit,
        cashBalanceSortCubit: cashBalanceSortCubit,
        cashBalancePrimaryGroupingCubit: cashBalancePrimaryGroupingCubit,
        cashBalancePrimarySubGroupingCubit:
        cashBalancePrimarySubGroupingCubit,
        cashBalanceAsOnDateCubit: cashBalanceAsOnDateCubit,
        cashBalanceCurrencyCubit: cashBalanceCurrencyCubit,
        cashBalanceDenominationCubit: cashBalanceDenominationCubit,
        cashBalanceNumberOfPeriodCubit: cashBalanceNumberOfPeriodCubit,
        cashBalancePeriodCubit: cashBalancePeriodCubit,
        cashBalanceReportCubit: cashBalanceReportCubit,
        cashBalanceAccountCubit: cashBalanceAccountCubit,
        cashBalanceLoadingCubit: cashBalanceLoadingCubit,
      ),
    ),
    Container(
      key: const ValueKey(3),
      child: IncomeHighlightWidget(
        isDetailScreen: false,
        incomeReportCubit: incomeReportCubit,
        universalFilterAsOnDateCubit: universalFilterAsOnDateCubit,
        universalEntityFilterCubit: universalEntityFilterCubit,
        favouriteUniversalFilterAsOnDateCubit: favouriteUniversalFilterAsOnDateCubit,
        incomeSortCubit: incomeSortCubit,
        incomeEntityCubit: incomeEntityCubit,
        incomeAsOnDateCubit: incomeAsOnDateCubit,
        incomePeriodCubit: incomePeriodCubit,
        incomeNumberOfPeriodCubit: incomeNumberOfPeriodCubit,
        incomeChartCubit: incomeChartCubit,
        incomeAccountCubit: incomeAccountCubit,
        incomeDenominationCubit: incomeDenominationCubit,
        incomeCurrencyCubit: incomeCurrencyCubit,
        incomeLoadingCubit: incomeLoadingCubit,
      ),
    ),
    Container(
      key: const ValueKey(4),
      child: ExpenseHighlightWidget(
        isDetailScreen: false,
        expenseReportCubit: expenseReportCubit,
        universalFilterAsOnDateCubit: universalFilterAsOnDateCubit,
        universalEntityFilterCubit: universalEntityFilterCubit,
        favouriteUniversalFilterAsOnDateCubit: favouriteUniversalFilterAsOnDateCubit,
        expenseSortCubit: expenseSortCubit,
        expenseEntityCubit: expenseEntityCubit,
        expenseAsOnDateCubit: expenseAsOnDateCubit,
        expensePeriodCubit: expensePeriodCubit,
        expenseNumberOfPeriodCubit: expenseNumberOfPeriodCubit,
        expenseChartCubit: expenseChartCubit,
        expenseAccountCubit: expenseAccountCubit,
        expenseDenominationCubit: expenseDenominationCubit,
        expenseCurrencyCubit: expenseCurrencyCubit,
        expenseLoadingCubit: expenseLoadingCubit,
      ),
    )
  ];

  void navigateToWidget(int index){

    _controller.jumpToPage(index);
    _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    if(isCollapsed){
      setState(() {
        isCollapsed=false;
      });
    }

  }
  void addWidget(int index) {
    setState(() {
      widgetSelected.add(index);
    });
  }

  void showWidgetSelectionSheet(BuildContext context){
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(Sizes.dimen_12.r)
            )
        ),
        builder: (context) => WidgetSelectionSheet(scrollController: _scrollController,));
  }

  void didChangeDependencies(){
    super.didChangeDependencies();
    final route =  ModalRoute.of(context);
    if (route != null && route.isCurrent) {
      CarouselTracker.expandIfNeeded();
    }
  }
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: universalEntityFilterCubit,
        ),
        BlocProvider.value(
          value: universalFilterAsOnDateCubit,
        ),
        BlocProvider.value(
          value: favouriteUniversalFilterCubit,
        ),
        BlocProvider.value(
          value: favouriteUniversalFilterAsOnDateCubit,
        ),
        BlocProvider.value(
          value: universalFilterCubit,
        ),
        BlocProvider.value(
          value: netWorthPrimaryGroupingCubit,
        ),
        BlocProvider.value(
          value: netWorthEntityCubit,
        ),
        BlocProvider.value(
          value: netWorthPrimarySubGroupingCubit,
        ),
        BlocProvider.value(
          value: netWorthLoadingCubit,
        ),
        BlocProvider.value(
          value: netWorthReportCubit,
        ),
        BlocProvider.value(
          value: netWorthPeriodCubit,
        ),
        BlocProvider.value(
          value: netWorthNumberOfPeriodCubit,
        ),
        BlocProvider.value(
          value: netWorthReturnPercentCubit,
        ),
        BlocProvider.value(
          value: netWorthCurrencyCubit,
        ),
        BlocProvider.value(
          value: netWorthDenominationCubit,
        ),
        BlocProvider.value(
          value: netWorthAsOnDateCubit,
        ),
        BlocProvider.value(
          value: netWorthLoadingCubit,
        ),
        BlocProvider(
          create: (context) => dashboardCubit,
        ),
        BlocProvider(
          create: (context) => performanceNoPositionCubit,
        ),
        BlocProvider(
          create: (context) => performanceSortCubit,
        ),
        BlocProvider(
          create: (context) => performanceEntityCubit,
        ),
        BlocProvider(
          create: (context) => performanceReportCubit,
        ),
        BlocProvider(
          create: (context) => performancePrimaryGroupingCubit,
        ),
        BlocProvider(
          create: (context) => performancePrimarySubGroupingCubit,
        ),
        BlocProvider(
          create: (context) => performanceSecondaryGroupingCubit,
        ),
        BlocProvider(
          create: (context) => performanceSecondarySubGroupingCubit,
        ),
        BlocProvider(
          create: (context) => performancePeriodCubit,
        ),
        BlocProvider(
          create: (context) => performanceNumberOfPeriodCubit,
        ),
        BlocProvider(
          create: (context) => performanceCurrencyCubit,
        ),
        BlocProvider(
          create: (context) => performanceDenominationCubit,
        ),
        BlocProvider(
          create: (context) => performanceReturnPercentCubit,
        ),
        BlocProvider(
          create: (context) => performanceAsOnDateCubit,
        ),
        BlocProvider(
          create: (context) => incomeReportCubit,
        ),
        BlocProvider(
          create: (context) => incomeEntityCubit,
        ),
        BlocProvider(
          create: (context) => incomeAccountCubit,
        ),
        BlocProvider(
          create: (context) => incomePeriodCubit,
        ),
        BlocProvider(
          create: (context) => incomeNumberOfPeriodCubit,
        ),
        BlocProvider(
          create: (context) => incomeChartCubit,
        ),
        BlocProvider(
          create: (context) => incomeCurrencyCubit,
        ),
        BlocProvider(
          create: (context) => incomeDenominationCubit,
        ),
        BlocProvider(
          create: (context) => incomeAsOnDateCubit,
        ),
        BlocProvider(
          create: (context) => incomeSortCubit,
        ),
        BlocProvider(
          create: (context) => expenseReportCubit,
        ),
        BlocProvider(
          create: (context) => expenseEntityCubit,
        ),
        BlocProvider(
          create: (context) => expenseAccountCubit,
        ),
        BlocProvider(
          create: (context) => expensePeriodCubit,
        ),
        BlocProvider(
          create: (context) => expenseNumberOfPeriodCubit,
        ),
        BlocProvider(
          create: (context) => expenseChartCubit,
        ),
        BlocProvider(
          create: (context) => expenseCurrencyCubit,
        ),
        BlocProvider(
          create: (context) => expenseDenominationCubit,
        ),
        BlocProvider(
          create: (context) => expenseAsOnDateCubit,
        ),
        BlocProvider(
          create: (context) => expenseSortCubit,
        ),
      ],
      child: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          backgroundColor: AppColor.scaffoldBackground,
          drawer: NewNavigationDrawer(
            universalEntityFilterCubit: universalEntityFilterCubit,
            universalFilterAsOnDateCubit: universalFilterAsOnDateCubit,
            favouriteUniversalFilterAsOnDateCubit: favouriteUniversalFilterAsOnDateCubit,
            performanceReportCubit: performanceReportCubit,
            incomeReportCubit: incomeReportCubit,
            expenseReportCubit: expenseReportCubit,
            incomeChartCubit: incomeChartCubit,
            expenseChartCubit: expenseChartCubit,
            cashBalanceReportCubit: cashBalanceReportCubit,
            cashBalanceSortCubit: cashBalanceSortCubit,
            onNetWorthTap: () {
              navigateToWidget(0);
            },
            onHomeTap: () {
              navigateToWidget(0);
            }, ),
          drawerEnableOpenDragGesture: false,
          appBar: AVAppBar(),
          body: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.only(
                  top: Sizes.dimen_0.h,
                ),
                child: BlocBuilder<DashboardCubit, DashboardState>(
                    builder: (context, state) {
                      if (state is DashboardLoaded) {
                        return CustomScrollView(
                            controller: _scrollController,
                            physics: const BouncingScrollPhysics(),
                            slivers: [
                              SliverToBoxAdapter(
                                child: UIHelper.verticalSpace(Sizes.dimen_6.h),
                              ),
                              SliverToBoxAdapter(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    UniversalHeader(
                                      resetUniversalFilters: () {
                                        universalFilterCubit.resetAllTheFilters(
                                          context: context,
                                          netWorthReportCubit: netWorthReportCubit,
                                          cashBalanceReportCubit:
                                          cashBalanceReportCubit,
                                          performanceReportCubit:
                                          performanceReportCubit,
                                          incomeReportCubit: incomeReportCubit,
                                          expenseReportCubit: expenseReportCubit,
                                        );
                                      },
                                      controller: _controller,
                                      length: highlightWidgets().length,
                                      onCollapsed: collapseWidget,

                                      universalEntityFilterCubit: universalEntityFilterCubit,
                                      universalFilterAsOnDateCubit: universalFilterAsOnDateCubit,
                                      is_Collapsed: isCollapsed,
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            height: ScreenUtil().screenHeight * 0.45,
                                            child: PageView.builder(
                                                controller: _controller,
                                                onPageChanged: (int index) {

                                                },
                                                scrollDirection: Axis.horizontal,
                                                itemCount: highlightWidgets().length,
                                                itemBuilder: (context, index) {
                                                  return highlightWidgets()[index];
                                                }
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SliverPersistentHeader(
                                  pinned: true,
                                  delegate: FavoritesHeaderDelegate(
                                    height:  context.watch<FavoritesCubit>().state is FavoritesLoaded && (context.watch<FavoritesCubit>().state as FavoritesLoaded).favoritesList?.isNotEmpty == true ? Sizes.dimen_24.h : Sizes.dimen_0.h,
                                    child: Container(
                                      color: Theme.of(context).scaffoldBackgroundColor,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_18.w),
                                        child: BlocBuilder<FavoritesCubit, FavoritesState>(
                                            bloc: context.read<FavoritesCubit>(),
                                            builder: (context, state) {
                                              if(state is FavoritesLoaded && (state.favoritesList?.isNotEmpty ?? false)) {
                                                return Container(
                                                  padding: EdgeInsets.only(top: Sizes.dimen_8.h, bottom: Sizes.dimen_2.h),
                                                  child: Row(
                                                    children: [
                                                      Text(StringConstants.favoriteHeader,
                                                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      UIHelper.horizontalSpaceSmall,
                                                      GestureDetector(
                                                        onTap: () {
                                                          showWidgetSelectionSheet(context);
                                                        },
                                                        child: Card(
                                                            color: AppColor.lightGrey,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.all(
                                                                Radius.circular(Sizes.dimen_6.r),
                                                              ),
                                                            ),
                                                            child: Semantics(
                                                              identifier: "FavAdd",
                                                              child: Container(
                                                                padding: EdgeInsets.symmetric(vertical: Sizes.dimen_6, horizontal: Sizes.dimen_6),
                                                                child: SvgPicture.asset("assets/svgs/add.svg"),
                                                              ),
                                                            )
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: BlocBuilder<UserCubit, UserEntity?>(
                                                            builder: (context, user) {
                                                              return BlocBuilder<FavouriteUniversalFilterAsOnDateCubit, FavouriteUniversalFilterAsOnDateState>(
                                                                  bloc: favouriteUniversalFilterAsOnDateCubit,
                                                                  builder: (context, asOnDate) {
                                                                    return FavouriteUniversalAsOnDateFilter(  favouriteUniversalFilterAsOnDateCubit: favouriteUniversalFilterAsOnDateCubit,  favouriteUniversalFilterCubit: favouriteUniversalFilterCubit,  favoritesCubit: context.read<FavoritesCubit>(),);
                                                                  }
                                                              );
                                                            }
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }
                                              return const SizedBox.shrink();
                                            }
                                        ),
                                      ),
                                    ),

                                  )
                              ),
                              FavoritesScreen(
                                scrollController: _scrollController,
                                favouriteUniversalFilterCubit: favouriteUniversalFilterCubit,
                                changeBool: () {},
                                universalFilterAsOnDateCubit: universalFilterAsOnDateCubit,
                                universalEntityFilterCubit: universalEntityFilterCubit,
                                favouriteUniversalFilterAsOnDateCubit: favouriteUniversalFilterAsOnDateCubit,
                                cashBalanceArgument: CashBalanceArgument(
                                  cashBalanceEntityCubit: cashBalanceEntityCubit,
                                  cashBalanceLoadingCubit: cashBalanceLoadingCubit,
                                  cashBalanceSortCubit: cashBalanceSortCubit,
                                  universalFilterAsOnDateCubit: universalFilterAsOnDateCubit,
                                  universalEntityFilterCubit: universalEntityFilterCubit,
                                  favouriteUniversalFilterAsOnDateCubit: favouriteUniversalFilterAsOnDateCubit,
                                  cashBalancePrimaryGroupingCubit:
                                  cashBalancePrimaryGroupingCubit,
                                  cashBalancePrimarySubGroupingCubit:
                                  cashBalancePrimarySubGroupingCubit,
                                  cashBalanceAsOnDateCubit: cashBalanceAsOnDateCubit,
                                  cashBalanceCurrencyCubit: cashBalanceCurrencyCubit,
                                  cashBalanceDenominationCubit:
                                  cashBalanceDenominationCubit,
                                  cashBalanceNumberOfPeriodCubit:
                                  cashBalanceNumberOfPeriodCubit,
                                  cashBalancePeriodCubit: cashBalancePeriodCubit,
                                  cashBalanceReportCubit: cashBalanceReportCubit,
                                  cashBalanceAccountCubit: cashBalanceAccountCubit,
                                ),
                                performanceArgument: PerformanceArgument(
                                    performanceEntityCubit: performanceEntityCubit,
                                    universalFilterAsOnDateCubit: universalFilterAsOnDateCubit,
                                    universalEntityFilterCubit: universalEntityFilterCubit,
                                    favouriteUniversalFilterAsOnDateCubit: favouriteUniversalFilterAsOnDateCubit,
                                    performanceSortCubit: performanceSortCubit,
                                    performanceReportCubit: performanceReportCubit,
                                    performancePrimaryGroupingCubit: performancePrimaryGroupingCubit,
                                    performanceSecondaryGroupingCubit: performanceSecondaryGroupingCubit,
                                    performancePrimarySubGroupingCubit: performancePrimarySubGroupingCubit,
                                    performanceSecondarySubGroupingCubit: performanceSecondarySubGroupingCubit,
                                    performanceNumberOfPeriodCubit: performanceNumberOfPeriodCubit,
                                    performanceReturnPercentCubit: performanceReturnPercentCubit,
                                    performanceCurrencyCubit: performanceCurrencyCubit,
                                    performanceDenominationCubit: performanceDenominationCubit,
                                    performancePeriodCubit: performancePeriodCubit,
                                    performanceAsOnDateCubit:
                                    performanceAsOnDateCubit,
                                    performanceLoadingCubit:
                                    performanceLoadingCubit,
                                    returnType:
                                    ReturnType.MTD,
                                    entityData: context
                                        .read<DashboardFilterCubit>()
                                        .state
                                        .selectedFilter,
                                    asOnDate: "30 July 2024",
                                    performancePartnershipMethodCubit: performancePartnershipMethodCubit,
                                    performanceHoldingMethodCubit: performanceHoldingMethodCubit),
                                netWorthArgument: NetWorthArgument(
                                    netWorthPrimaryGroupingCubit: netWorthPrimaryGroupingCubit,
                                    netWorthEntityCubit: netWorthEntityCubit,
                                    netWorthPrimarySubGroupingCubit: netWorthPrimarySubGroupingCubit,
                                    netWorthReportCubit: netWorthReportCubit,
                                    netWorthNumberOfPeriodCubit: netWorthNumberOfPeriodCubit,
                                    netWorthPeriodCubit: netWorthPeriodCubit,
                                    netWorthReturnPercentCubit: netWorthReturnPercentCubit,
                                    netWorthDenominationCubit: netWorthDenominationCubit,
                                    netWorthCurrencyCubit: netWorthCurrencyCubit,
                                    netWorthAsOnDateCubit: netWorthAsOnDateCubit,
                                    netWorthLoadingCubit: netWorthLoadingCubit),
                                incomeReportArgument: IncomeReportArgument(
                                  isFavorite: true,
                                  universalFilterAsOnDateCubit: universalFilterAsOnDateCubit,
                                  universalEntityFilterCubit: universalEntityFilterCubit,
                                  favouriteUniversalFilterAsOnDateCubit: favouriteUniversalFilterAsOnDateCubit,
                                  incomeReportCubit:
                                  incomeReportCubit,
                                  incomeLoadingCubit:
                                  incomeLoadingCubit,
                                  incomeSortCubit:
                                  incomeSortCubit,
                                  incomeEntityCubit:
                                  incomeEntityCubit,
                                  incomeAccountCubit:
                                  incomeAccountCubit,
                                  incomePeriodCubit:
                                  incomePeriodCubit,
                                  incomeNumberOfPeriodCubit:
                                  incomeNumberOfPeriodCubit,
                                  incomeChartCubit:
                                  incomeChartCubit,
                                  incomeCurrencyCubit:
                                  incomeCurrencyCubit,
                                  incomeDenominationCubit:
                                  incomeDenominationCubit,
                                  incomeAsOnDateCubit:
                                  incomeAsOnDateCubit,
                                ),
                                expenseReportArgument: ExpenseReportArgument(
                                  isFavorite:
                                  true,
                                  expenseReportCubit: expenseReportCubit,
                                  expenseLoadingCubit:
                                  expenseLoadingCubit,
                                  expenseSortCubit: expenseSortCubit,
                                  expenseEntityCubit: expenseEntityCubit,
                                  expenseAccountCubit:
                                  expenseAccountCubit,
                                  universalFilterAsOnDateCubit: universalFilterAsOnDateCubit,
                                  universalEntityFilterCubit: universalEntityFilterCubit,
                                  favouriteUniversalFilterAsOnDateCubit: favouriteUniversalFilterAsOnDateCubit,
                                  expensePeriodCubit: expensePeriodCubit,
                                  expenseNumberOfPeriodCubit:
                                  expenseNumberOfPeriodCubit,
                                  expenseChartCubit: expenseChartCubit,
                                  expenseCurrencyCubit:
                                  expenseCurrencyCubit,
                                  expenseDenominationCubit:
                                  expenseDenominationCubit,
                                  expenseAsOnDateCubit:
                                  expenseAsOnDateCubit,
                                ),
                              ),


                            ]
                        );
                      }
                      return const SizedBox.shrink();
                    }),
              )),
        ),
      ),
    );
  }
}


class FavoritesHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  FavoritesHeaderDelegate( {
    required this.child,
    required this.height,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {

    return SizedBox.expand(child: child);

  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
