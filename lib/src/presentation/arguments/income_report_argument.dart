
import 'package:asset_vantage/src/presentation/blocs/income/income_account/income_account_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_currency/income_currency_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_denomination/income_denomination_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_period/income_period_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_sort_cubit/income_sort_cubit.dart';

import '../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../domain/entities/favorites/favorites_entity.dart';
import '../blocs/income/income_as_on_date/income_as_on_date_cubit.dart';
import '../blocs/income/income_chart/income_chart_cubit.dart';
import '../blocs/income/income_entity/income_entity_cubit.dart';
import '../blocs/income/income_loading/income_loading_cubit.dart';
import '../blocs/income/income_number_of_period/income_number_of_period_cubit.dart';
import '../blocs/income/income_report/income_report_cubit.dart';
import '../blocs/universal_filter/as_on_date_universal_filter/universal_filter_as_on_date_cubit.dart';
import '../blocs/universal_filter/enitity_universal_filter/universal_entity_filter_cubit.dart';
import '../blocs/universal_filter/favourite_as_on_date_universal_filter/favourite_universal_filter_as_on_date_cubit.dart';

class IncomeReportArgument {
  final bool isFavorite;
  final Favorite? favorite;
  final IncomeLoadingCubit incomeLoadingCubit;
  final IncomeReportCubit incomeReportCubit;
  final UniversalEntityFilterCubit universalEntityFilterCubit;
  final UniversalFilterAsOnDateCubit universalFilterAsOnDateCubit;
  final FavouriteUniversalFilterAsOnDateCubit favouriteUniversalFilterAsOnDateCubit;
  final IncomeSortCubit incomeSortCubit;
  final IncomeEntityCubit incomeEntityCubit;
  final IncomeAccountCubit incomeAccountCubit;
  final IncomePeriodCubit incomePeriodCubit;
  final IncomeNumberOfPeriodCubit incomeNumberOfPeriodCubit;
  final IncomeChartCubit incomeChartCubit;
  final IncomeCurrencyCubit incomeCurrencyCubit;
  final IncomeDenominationCubit incomeDenominationCubit;
  final IncomeAsOnDateCubit incomeAsOnDateCubit;
  IncomeReportArgument({
    this.isFavorite = false,
    this.favorite,
    required this.incomeLoadingCubit,
    required this.universalEntityFilterCubit,
    required this.universalFilterAsOnDateCubit,
    required this.favouriteUniversalFilterAsOnDateCubit,
    required this.incomeReportCubit,
    required this.incomeSortCubit,
    required this.incomeEntityCubit,
    required this.incomeAccountCubit,
    required this.incomePeriodCubit,
    required this.incomeNumberOfPeriodCubit,
    required this.incomeChartCubit,
    required this.incomeCurrencyCubit,
    required this.incomeDenominationCubit,
    required this.incomeAsOnDateCubit,
  });
}