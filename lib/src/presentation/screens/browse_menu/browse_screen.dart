import 'package:asset_vantage/src/config/constants/route_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/blocs/expense/expense_loading/expense_loading_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_report/income_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_holding_method/performance_holding_method_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_loading/performance_loading_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/universal_filter/as_on_date_universal_filter/universal_filter_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/universal_filter/enitity_universal_filter/universal_entity_filter_cubit.dart';
import 'package:asset_vantage/src/presentation/screens/browse_menu/browse_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/constants/size_constants.dart';
import '../../../data/models/return_percentage/return_percentage_model.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../arguments/cash_balance_argument.dart';
import '../../arguments/document_argument.dart';
import '../../arguments/expense_report_argument.dart';
import '../../arguments/income_report_argument.dart';
import '../../arguments/performance_argument.dart';
import '../../blocs/cash_balance/cash_balance_loading/cash_balance_loading_cubit.dart';
import '../../blocs/expense/expense_sort_cubit/expense_sort_cubit.dart';
import '../../blocs/cash_balance/cash_balance_accounts/cash_balance_account_cubit.dart';
import '../../blocs/cash_balance/cash_balance_as_on_date/cash_balance_as_on_date_cubit.dart';
import '../../blocs/cash_balance/cash_balance_currency/cash_balance_currency_cubit.dart';
import '../../blocs/cash_balance/cash_balance_denomination/cash_balance_denomination_cubit.dart';
import '../../blocs/cash_balance/cash_balance_entity/cash_balance_entity_cubit.dart';
import '../../blocs/cash_balance/cash_balance_grouping/cash_balance_grouping_cubit.dart';
import '../../blocs/cash_balance/cash_balance_number_of_period/cash_balance_number_of_period_cubit.dart';
import '../../blocs/cash_balance/cash_balance_period/cash_balance_period_cubit.dart';
import '../../blocs/cash_balance/cash_balance_report/cash_balance_report_cubit.dart';
import '../../blocs/cash_balance/cash_balance_sort_cubit/cash_balance_sort_cubit.dart';
import '../../blocs/cash_balance/cash_balance_sub_grouping/cash_balance_sub_grouping_cubit.dart';
import '../../blocs/dashboard_filter/dashboard_filter_cubit.dart';
import '../../blocs/expense/expense_account/expense_account_cubit.dart';
import '../../blocs/expense/expense_as_on_date/expense_as_on_date_cubit.dart';
import '../../blocs/expense/expense_chart/expense_chart_cubit.dart';
import '../../blocs/expense/expense_currency/expense_currency_cubit.dart';
import '../../blocs/expense/expense_denomination/expense_denomination_cubit.dart';
import '../../blocs/expense/expense_entity/expense_entity_cubit.dart';
import '../../blocs/expense/expense_number_of_period/expense_number_of_period_cubit.dart';
import '../../blocs/expense/expense_period/expense_period_cubit.dart';
import '../../blocs/expense/expense_report/expense_report_cubit.dart';
import '../../blocs/income/income_account/income_account_cubit.dart';
import '../../blocs/income/income_as_on_date/income_as_on_date_cubit.dart';
import '../../blocs/income/income_chart/income_chart_cubit.dart';
import '../../blocs/income/income_currency/income_currency_cubit.dart';
import '../../blocs/income/income_denomination/income_denomination_cubit.dart';
import '../../blocs/income/income_entity/income_entity_cubit.dart';
import '../../blocs/income/income_loading/income_loading_cubit.dart';
import '../../blocs/income/income_number_of_period/income_number_of_period_cubit.dart';
import '../../blocs/income/income_period/income_period_cubit.dart';
import '../../blocs/income/income_sort_cubit/income_sort_cubit.dart';
import '../../blocs/performance/performance_as_on_date/performance_as_on_date_cubit.dart';
import '../../blocs/performance/performance_currency/performance_currency_cubit.dart';
import '../../blocs/performance/performance_denomination/performance_denomination_cubit.dart';
import '../../blocs/performance/performance_entity/performance_entity_cubit.dart';
import '../../blocs/performance/performance_number_of_period/performance_number_of_period_cubit.dart';
import '../../blocs/performance/performance_partnership_method/performance_partnership_method_cubit.dart';
import '../../blocs/performance/performance_period/performance_period_cubit.dart';
import '../../blocs/performance/performance_primary_grouping/performance_primary_grouping_cubit.dart';
import '../../blocs/performance/performance_primary_sub_grouping/performance_primary_sub_grouping_cubit.dart';
import '../../blocs/performance/performance_report/performance_report_cubit.dart';
import '../../blocs/performance/performance_return_percent/performance_return_percent_cubit.dart';
import '../../blocs/performance/performance_secondary_grouping/performance_secondary_grouping_cubit.dart';
import '../../blocs/performance/performance_secondary_sub_grouping/performance_secondary_sub_grouping_cubit.dart';
import '../../blocs/performance/performance_sort_cubit/performance_sort_cubit.dart';
import '../../blocs/universal_filter/favourite_as_on_date_universal_filter/favourite_universal_filter_as_on_date_cubit.dart';
import '../../theme/theme_color.dart';

class BrowseScreen extends StatelessWidget {
  PerformanceSortCubit performanceSortCubit;
  PerformanceEntityCubit performanceEntityCubit;
  PerformanceReportCubit performanceReportCubit;
  PerformancePrimaryGroupingCubit performancePrimaryGroupingCubit;
  PerformanceSecondaryGroupingCubit performanceSecondaryGroupingCubit;
  PerformancePrimarySubGroupingCubit performancePrimarySubGroupingCubit;
  PerformanceSecondarySubGroupingCubit performanceSecondarySubGroupingCubit;
  final UniversalEntityFilterCubit universalEntityFilterCubit;
  final UniversalFilterAsOnDateCubit universalFilterAsOnDateCubit;
  final FavouriteUniversalFilterAsOnDateCubit favouriteUniversalFilterAsOnDateCubit;
  final PerformanceNumberOfPeriodCubit performanceNumberOfPeriodCubit;
  final PerformanceReturnPercentCubit performanceReturnPercentCubit;
  final PerformanceCurrencyCubit performanceCurrencyCubit;
  final PerformanceDenominationCubit performanceDenominationCubit;
  final PerformancePartnershipMethodCubit performancePartnershipMethodCubit;
  final PerformanceHoldingMethodCubit performanceHoldingMethodCubit;
  final PerformanceAsOnDateCubit performanceAsOnDateCubit;
  final PerformanceLoadingCubit performanceLoadingCubit;
  PerformancePeriodCubit performancePeriodCubit;

  final CashBalanceLoadingCubit cashBalanceLoadingCubit;
  final CashBalanceEntityCubit cashBalanceEntityCubit;
  final CashBalanceSortCubit cashBalanceSortCubit;
  final CashBalancePrimaryGroupingCubit cashBalancePrimaryGroupingCubit;
  final CashBalancePrimarySubGroupingCubit cashBalancePrimarySubGroupingCubit;
  final CashBalanceAsOnDateCubit cashBalanceAsOnDateCubit;
  final CashBalanceCurrencyCubit cashBalanceCurrencyCubit;
  final CashBalanceDenominationCubit cashBalanceDenominationCubit;
  final CashBalanceNumberOfPeriodCubit cashBalanceNumberOfPeriodCubit;
  final CashBalancePeriodCubit cashBalancePeriodCubit;
  final CashBalanceReportCubit cashBalanceReportCubit;
  final CashBalanceAccountCubit cashBalanceAccountCubit;

  final IncomeLoadingCubit incomeLoadingCubit;
  final IncomeReportCubit incomeReportCubit;
  final IncomeSortCubit incomeSortCubit;
  final IncomeEntityCubit incomeEntityCubit;
  final IncomeAccountCubit incomeAccountCubit;
  final IncomePeriodCubit incomePeriodCubit;
  final IncomeNumberOfPeriodCubit incomeNumberOfPeriodCubit;
  final IncomeChartCubit incomeChartCubit;
  final IncomeCurrencyCubit incomeCurrencyCubit;
  final IncomeDenominationCubit incomeDenominationCubit;
  final IncomeAsOnDateCubit incomeAsOnDateCubit;

  final ExpenseLoadingCubit expenseLoadingCubit;
  final ExpenseReportCubit expenseReportCubit;
  final ExpenseSortCubit expenseSortCubit;
  final ExpenseEntityCubit expenseEntityCubit;
  final ExpenseAccountCubit expenseAccountCubit;
  final ExpensePeriodCubit expensePeriodCubit;
  final ExpenseNumberOfPeriodCubit expenseNumberOfPeriodCubit;
  final ExpenseChartCubit expenseChartCubit;
  final ExpenseCurrencyCubit expenseCurrencyCubit;
  final ExpenseDenominationCubit expenseDenominationCubit;
  final ExpenseAsOnDateCubit expenseAsOnDateCubit;

  BrowseScreen({
    super.key,
    required this.performanceSortCubit,
    required this.performanceLoadingCubit,
    required this.performanceEntityCubit,
    required this.performanceReportCubit,
    required this.universalEntityFilterCubit,
    required this.universalFilterAsOnDateCubit,
    required this.favouriteUniversalFilterAsOnDateCubit,
    required this.performancePrimaryGroupingCubit,
    required this.performanceSecondaryGroupingCubit,
    required this.performancePrimarySubGroupingCubit,
    required this.performanceSecondarySubGroupingCubit,
    required this.performanceNumberOfPeriodCubit,
    required this.performanceReturnPercentCubit,
    required this.performanceCurrencyCubit,
    required this.performanceDenominationCubit,
    required this.performanceAsOnDateCubit,
    required this.performancePeriodCubit,
    required this.cashBalanceSortCubit,
    required this.cashBalanceReportCubit,
    required this.cashBalanceCurrencyCubit,
    required this.cashBalanceDenominationCubit,
    required this.cashBalanceNumberOfPeriodCubit,
    required this.cashBalanceAsOnDateCubit,
    required this.cashBalanceAccountCubit,
    required this.cashBalancePeriodCubit,
    required this.cashBalancePrimarySubGroupingCubit,
    required this.cashBalancePrimaryGroupingCubit,
    required this.cashBalanceEntityCubit,
    required this.cashBalanceLoadingCubit,
    required this.incomeReportCubit,
    required this.incomeEntityCubit,
    required this.incomeAccountCubit,
    required this.incomeChartCubit,
    required this.incomePeriodCubit,
    required this.incomeNumberOfPeriodCubit,
    required this.incomeCurrencyCubit,
    required this.incomeSortCubit,
    required this.incomeDenominationCubit,
    required this.incomeAsOnDateCubit,
    required this.incomeLoadingCubit,
    required this.expenseAccountCubit,
  required this.expenseAsOnDateCubit,
  required this.expenseChartCubit,
  required this.expenseCurrencyCubit,
  required this.expenseDenominationCubit,
  required this.expenseEntityCubit,
  required this.expenseNumberOfPeriodCubit,
  required this.expensePeriodCubit,
  required this.expenseReportCubit,
  required this.expenseSortCubit,
  required this.expenseLoadingCubit,
    required this.performancePartnershipMethodCubit,
    required this.performanceHoldingMethodCubit
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> browseItems = [
      {
        "title": "Performance",
        "onPressed": () => {
          Navigator.of(context).pushNamed(RouteList.performanceReport, arguments: PerformanceArgument(
              performanceSortCubit: performanceSortCubit,
                performanceEntityCubit: performanceEntityCubit,
              universalFilterAsOnDateCubit: universalFilterAsOnDateCubit,
              universalEntityFilterCubit: universalEntityFilterCubit,
              favouriteUniversalFilterAsOnDateCubit: favouriteUniversalFilterAsOnDateCubit,
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
                performanceAsOnDateCubit: performanceAsOnDateCubit,
                performanceLoadingCubit: performanceLoadingCubit,
                returnType: performanceReturnPercentCubit.state.selectedPerformanceReturnPercentList?.last?.value ?? ReturnType.FYTD,
                entityData: context.read<DashboardFilterCubit>().state.selectedFilter,
                asOnDate: "30 July 2024",
              performancePartnershipMethodCubit: performancePartnershipMethodCubit,
              performanceHoldingMethodCubit: performanceHoldingMethodCubit)
          )
        },
      },
      {
        "title": "Cash Balances",
        "onPressed": () {
          Navigator.of(context).pushNamed(
            RouteList.cashBalanceReport,
            arguments: CashBalanceArgument(
              cashBalanceLoadingCubit: cashBalanceLoadingCubit,
              cashBalanceEntityCubit: cashBalanceEntityCubit,
              universalFilterAsOnDateCubit: universalFilterAsOnDateCubit,
              universalEntityFilterCubit: universalEntityFilterCubit,
              favouriteUniversalFilterAsOnDateCubit: favouriteUniversalFilterAsOnDateCubit,
              cashBalanceSortCubit: cashBalanceSortCubit,
              cashBalancePrimaryGroupingCubit:
                  cashBalancePrimaryGroupingCubit,
              cashBalancePrimarySubGroupingCubit:
                  cashBalancePrimarySubGroupingCubit,
              cashBalanceAsOnDateCubit: cashBalanceAsOnDateCubit,
              cashBalanceCurrencyCubit: cashBalanceCurrencyCubit,
              cashBalanceDenominationCubit: cashBalanceDenominationCubit,
              cashBalanceNumberOfPeriodCubit:
                  cashBalanceNumberOfPeriodCubit,
              cashBalancePeriodCubit: cashBalancePeriodCubit,
              cashBalanceReportCubit: cashBalanceReportCubit,
              cashBalanceAccountCubit: cashBalanceAccountCubit,
            ),
          );
        },
      },
      {
        "title": "Income",
        "onPressed": () {
          Navigator.of(context).pushNamed(RouteList.incomeReportScreen,
              arguments: IncomeReportArgument(
                incomeLoadingCubit: incomeLoadingCubit,
                incomeReportCubit: incomeReportCubit,
                incomeSortCubit: incomeSortCubit,
                universalFilterAsOnDateCubit: universalFilterAsOnDateCubit,
                universalEntityFilterCubit: universalEntityFilterCubit,
                favouriteUniversalFilterAsOnDateCubit: favouriteUniversalFilterAsOnDateCubit,
                incomeEntityCubit: incomeEntityCubit,
                incomeAccountCubit: incomeAccountCubit,
                incomePeriodCubit: incomePeriodCubit,
                incomeNumberOfPeriodCubit: incomeNumberOfPeriodCubit,
                incomeChartCubit: incomeChartCubit,
                incomeCurrencyCubit: incomeCurrencyCubit,
                incomeDenominationCubit: incomeDenominationCubit,
                incomeAsOnDateCubit: incomeAsOnDateCubit,
              ));
        },
      },
      {
        "title": "Expense",
        "onPressed": () {
          Navigator.of(context).pushNamed(RouteList.expenseReportScreen,
              arguments: ExpenseReportArgument(
                expenseLoadingCubit: expenseLoadingCubit,
                expenseReportCubit: expenseReportCubit,
                expenseSortCubit: expenseSortCubit,
                expenseEntityCubit: expenseEntityCubit,
                expenseAccountCubit: expenseAccountCubit,
                expensePeriodCubit: expensePeriodCubit,
                universalFilterAsOnDateCubit: universalFilterAsOnDateCubit,
                universalEntityFilterCubit: universalEntityFilterCubit,
                favouriteUniversalFilterAsOnDateCubit: favouriteUniversalFilterAsOnDateCubit,
                expenseNumberOfPeriodCubit: expenseNumberOfPeriodCubit,
                expenseChartCubit: expenseChartCubit,
                expenseCurrencyCubit: expenseCurrencyCubit,
                expenseDenominationCubit: expenseDenominationCubit,
                expenseAsOnDateCubit: expenseAsOnDateCubit,
              ));
        },
      },
    ];

    final List<Map<String, dynamic>> resourceItems = [
      {
        "title": "Documents",
        "onPressed": () => Navigator.of(context).pushNamed(RouteList.documents,
            arguments: DocumentArgument(
                dashboardFilterCubit: context.read<DashboardFilterCubit>())),
      },
    ];

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          top: Sizes.dimen_6.h,
          left: Sizes.dimen_16.w,
          right: Sizes.dimen_16.w,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Browse",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: Sizes.dimen_4.h,
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(
                    Sizes.dimen_10.r,
                  ),
                ),
                child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => Column(
                      children: [
                        BrowseItem(
                              title: browseItems[index]["title"],
                              onPressed: browseItems[index]["onPressed"],
                            ),
                      ],
                    ),
                    separatorBuilder: (context, index) => Divider(
                          color: AppColor.grey,
                          thickness: 0.4,
                          height: 0.4,
                          indent: Sizes.dimen_16.w,
                          endIndent: Sizes.dimen_16.w,
                        ),
                    itemCount: browseItems.length),
              ),
              UIHelper.verticalSpaceSmall,
              Text(
                "Resources",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: Sizes.dimen_4.h,
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(
                    Sizes.dimen_10.r,
                  ),
                ),
                child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => BrowseItem(
                          title: resourceItems[index]["title"],
                          onPressed: resourceItems[index]["onPressed"],
                        ),
                    separatorBuilder: (context, index) => Divider(
                          color: AppColor.grey,
                          thickness: 0.4,
                          height: 0.4,
                          indent: Sizes.dimen_16.w,
                          endIndent: Sizes.dimen_16.w,
                        ),
                    itemCount: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
