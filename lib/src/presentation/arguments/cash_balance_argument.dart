

import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_accounts/cash_balance_account_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_as_on_date/cash_balance_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_currency/cash_balance_currency_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_denomination/cash_balance_denomination_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_entity/cash_balance_entity_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_grouping/cash_balance_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_number_of_period/cash_balance_number_of_period_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_period/cash_balance_period_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_report/cash_balance_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_sort_cubit/cash_balance_sort_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_sub_grouping/cash_balance_sub_grouping_cubit.dart';

import '../../domain/entities/favorites/favorites_entity.dart';
import '../blocs/cash_balance/cash_balance_loading/cash_balance_loading_cubit.dart';
import '../blocs/universal_filter/as_on_date_universal_filter/universal_filter_as_on_date_cubit.dart';
import '../blocs/universal_filter/enitity_universal_filter/universal_entity_filter_cubit.dart';
import '../blocs/universal_filter/favourite_as_on_date_universal_filter/favourite_universal_filter_as_on_date_cubit.dart';


class CashBalanceArgument {
  final bool isFavorite;
  final Favorite? favorite;
  final CashBalanceLoadingCubit cashBalanceLoadingCubit;
  final UniversalEntityFilterCubit universalEntityFilterCubit;
  final UniversalFilterAsOnDateCubit universalFilterAsOnDateCubit;
  final FavouriteUniversalFilterAsOnDateCubit favouriteUniversalFilterAsOnDateCubit;
  final CashBalanceSortCubit cashBalanceSortCubit;
  final CashBalanceEntityCubit cashBalanceEntityCubit;
  final CashBalancePrimaryGroupingCubit cashBalancePrimaryGroupingCubit;
  final CashBalancePrimarySubGroupingCubit cashBalancePrimarySubGroupingCubit;
  final CashBalancePeriodCubit cashBalancePeriodCubit;
  final CashBalanceNumberOfPeriodCubit cashBalanceNumberOfPeriodCubit;
  final CashBalanceCurrencyCubit cashBalanceCurrencyCubit;
  final CashBalanceDenominationCubit cashBalanceDenominationCubit;
  final CashBalanceAsOnDateCubit cashBalanceAsOnDateCubit;
  final CashBalanceReportCubit cashBalanceReportCubit;
  final CashBalanceAccountCubit cashBalanceAccountCubit;
  CashBalanceArgument({
    this.isFavorite = false,
    this.favorite,
    required this.cashBalanceLoadingCubit,
    required this.universalEntityFilterCubit,
    required this.universalFilterAsOnDateCubit,
    required this.favouriteUniversalFilterAsOnDateCubit,
    required this.cashBalanceSortCubit,
    required this.cashBalanceEntityCubit,
    required this.cashBalancePrimaryGroupingCubit,
    required this.cashBalancePrimarySubGroupingCubit,
    required this.cashBalanceAsOnDateCubit,
    required this.cashBalanceDenominationCubit,
    required this.cashBalanceCurrencyCubit,
    required this.cashBalanceNumberOfPeriodCubit,
    required this.cashBalancePeriodCubit,
    required this.cashBalanceReportCubit,
    required this.cashBalanceAccountCubit,
  });
}