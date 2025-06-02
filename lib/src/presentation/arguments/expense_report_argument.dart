import 'package:asset_vantage/src/presentation/blocs/expense/expense_account/expense_account_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/expense/expense_chart/expense_chart_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/expense/expense_entity/expense_entity_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/expense/expense_number_of_period/expense_number_of_period_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/expense/expense_period/expense_period_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/expense/expense_report/expense_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/expense/expense_as_on_date/expense_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/expense/expense_currency/expense_currency_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/expense/expense_denomination/expense_denomination_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/expense/expense_sort_cubit/expense_sort_cubit.dart';

import '../../domain/entities/favorites/favorites_entity.dart';
import '../blocs/expense/expense_loading/expense_loading_cubit.dart';
import '../blocs/universal_filter/as_on_date_universal_filter/universal_filter_as_on_date_cubit.dart';
import '../blocs/universal_filter/enitity_universal_filter/universal_entity_filter_cubit.dart';
import '../blocs/universal_filter/favourite_as_on_date_universal_filter/favourite_universal_filter_as_on_date_cubit.dart';


class ExpenseReportArgument {
  final bool isFavorite;
  final Favorite? favorite;
  final ExpenseLoadingCubit expenseLoadingCubit;
  final UniversalEntityFilterCubit universalEntityFilterCubit;
  final UniversalFilterAsOnDateCubit universalFilterAsOnDateCubit;
  final FavouriteUniversalFilterAsOnDateCubit favouriteUniversalFilterAsOnDateCubit;
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
  ExpenseReportArgument({
    this.isFavorite = false,
    this.favorite,
    required this.universalEntityFilterCubit,
    required this.universalFilterAsOnDateCubit,
    required this.favouriteUniversalFilterAsOnDateCubit,
    required this.expenseLoadingCubit,
    required this.expenseReportCubit,
    required this.expenseSortCubit,
    required this.expenseEntityCubit,
    required this.expenseAccountCubit,
    required this.expensePeriodCubit,
    required this.expenseNumberOfPeriodCubit,
    required this.expenseChartCubit,
    required this.expenseCurrencyCubit,
    required this.expenseDenominationCubit,
    required this.expenseAsOnDateCubit,
  });
}