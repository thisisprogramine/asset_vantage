
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/screens/dashboard/highlights/cash_balance_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../config/constants/favorite_constants.dart';
import '../../../config/constants/route_constants.dart';
import '../../../config/constants/size_constants.dart';
import '../../../domain/entities/favorites/favorites_entity.dart';
import '../../../injector.dart';
import '../../blocs/cash_balance/cash_balance_accounts/cash_balance_account_cubit.dart';
import '../../blocs/cash_balance/cash_balance_as_on_date/cash_balance_as_on_date_cubit.dart';
import '../../blocs/cash_balance/cash_balance_currency/cash_balance_currency_cubit.dart';
import '../../blocs/cash_balance/cash_balance_denomination/cash_balance_denomination_cubit.dart';
import '../../blocs/cash_balance/cash_balance_entity/cash_balance_entity_cubit.dart';
import '../../blocs/cash_balance/cash_balance_grouping/cash_balance_grouping_cubit.dart';
import '../../blocs/cash_balance/cash_balance_loading/cash_balance_loading_cubit.dart';
import '../../blocs/cash_balance/cash_balance_number_of_period/cash_balance_number_of_period_cubit.dart';
import '../../blocs/cash_balance/cash_balance_period/cash_balance_period_cubit.dart';
import '../../blocs/cash_balance/cash_balance_report/cash_balance_report_cubit.dart';
import '../../blocs/cash_balance/cash_balance_sort_cubit/cash_balance_sort_cubit.dart';
import '../../blocs/cash_balance/cash_balance_sub_grouping/cash_balance_sub_grouping_cubit.dart';
import '../../blocs/favorites/favorites_cubit.dart';
import '../../blocs/universal_filter/as_on_date_universal_filter/universal_filter_as_on_date_cubit.dart';
import '../../blocs/universal_filter/enitity_universal_filter/universal_entity_filter_cubit.dart';
import '../../blocs/universal_filter/favourite_as_on_date_universal_filter/favourite_universal_filter_as_on_date_cubit.dart';
import '../../theme/theme_color.dart';

class FavoriteCashBalanceWidget extends StatefulWidget {
  final Favorite? favorite;
  final CashBalanceReportCubit cashBalanceReportCubit;
  final UniversalEntityFilterCubit universalEntityFilterCubit;
  final UniversalFilterAsOnDateCubit universalFilterAsOnDateCubit;
  final FavouriteUniversalFilterAsOnDateCubit favouriteUniversalFilterAsOnDateCubit;
  final ScrollController? scrollController;
  const FavoriteCashBalanceWidget({
    super.key,
    required this.favorite,
    required this.universalEntityFilterCubit,
    required this.universalFilterAsOnDateCubit,
    required this.favouriteUniversalFilterAsOnDateCubit,
    required this.cashBalanceReportCubit,
    required this.scrollController,
  });

  @override
  State<FavoriteCashBalanceWidget> createState() => _FavoriteCashBalanceWidgetState();
}

class _FavoriteCashBalanceWidgetState extends State<FavoriteCashBalanceWidget> with TickerProviderStateMixin {

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

  @override
  void initState() {
    super.initState();

    cashBalanceSortCubit = getItInstance<CashBalanceSortCubit>();
    cashBalanceReportCubit = widget.cashBalanceReportCubit;
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
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
        child: CashBalanceHighlightChart(
          isFavorite: true,
          favorite: widget.favorite,
          cashBalanceSortCubit: cashBalanceSortCubit,
          cashBalanceEntityCubit: cashBalanceEntityCubit,
          cashBalancePrimaryGroupingCubit: cashBalancePrimaryGroupingCubit,
          universalEntityFilterCubit: widget.universalEntityFilterCubit,
          universalFilterAsOnDateCubit: widget.universalFilterAsOnDateCubit,
          favouriteUniversalFilterAsOnDateCubit: widget.favouriteUniversalFilterAsOnDateCubit,
          cashBalanceLoadingCubit: cashBalanceLoadingCubit,
          cashBalancePrimarySubGroupingCubit: cashBalancePrimarySubGroupingCubit,
          cashBalanceAsOnDateCubit: cashBalanceAsOnDateCubit,
          cashBalanceDenominationCubit: cashBalanceDenominationCubit,
          cashBalanceCurrencyCubit: cashBalanceCurrencyCubit,
          cashBalanceNumberOfPeriodCubit: cashBalanceNumberOfPeriodCubit,
          cashBalancePeriodCubit: cashBalancePeriodCubit,
          cashBalanceReportCubit: cashBalanceReportCubit,
          cashBalanceAccountCubit: cashBalanceAccountCubit,
        ));
  }
}
