import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_report/net_worth_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/networth_holding_method/networth_holding_method_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/networth_partnership_method/networth_partnership_method_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/universal_filter/as_on_date_universal_filter/universal_filter_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/universal_filter/enitity_universal_filter/universal_entity_filter_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/universal_filter/favourite_as_on_date_universal_filter/favourite_universal_filter_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/screens/dashboard/universal_filter/universal_as_on_date_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../config/constants/favorite_constants.dart';
import '../../../config/constants/size_constants.dart';
import '../../../domain/entities/favorites/favorites_entity.dart';
import '../../../injector.dart';
import '../../blocs/favorites/favorites_cubit.dart';
import '../../blocs/net_worth/net_worth_as_on_date/net_worth_as_on_date_cubit.dart';
import '../../blocs/net_worth/net_worth_currency/net_worth_currency_cubit.dart';
import '../../blocs/net_worth/net_worth_denomination/net_worth_denomination_cubit.dart';
import '../../blocs/net_worth/net_worth_entity/net_worth_entity_cubit.dart';
import '../../blocs/net_worth/net_worth_grouping/net_worth_grouping_cubit.dart';
import '../../blocs/net_worth/net_worth_loading/net_worth_loading_cubit.dart';
import '../../blocs/net_worth/net_worth_number_of_period/net_worth_number_of_period_cubit.dart';
import '../../blocs/net_worth/net_worth_period/net_worth_period_cubit.dart';
import '../../blocs/net_worth/net_worth_return_percent/net_worth_return_percent_cubit.dart';
import '../../blocs/net_worth/net_worth_sub_grouping/net_worth_sub_grouping_cubit.dart';
import '../../theme/theme_color.dart';
import '../dashboard/net_worth_summary/net_worth_summary_chart.dart';

class FavoriteNetWorthWidget extends StatefulWidget {
  final Favorite? favorite;
  final NetWorthReportCubit netWorthReportCubit;
  final ScrollController? scrollController;
  final UniversalEntityFilterCubit universalEntityFilterCubit;
  final UniversalFilterAsOnDateCubit universalFilterAsOnDateCubit;
  final FavouriteUniversalFilterAsOnDateCubit favouriteUniversalFilterAsOnDateCubit;

  const FavoriteNetWorthWidget({
    super.key,
    required this.favorite,
    required this.netWorthReportCubit,
    required this.scrollController,
    required this.universalEntityFilterCubit,
    required this.universalFilterAsOnDateCubit,
    required this.favouriteUniversalFilterAsOnDateCubit,
  });

  @override
  State<FavoriteNetWorthWidget> createState() => _FavoriteNetWorthWidgetState();
}

class _FavoriteNetWorthWidgetState extends State<FavoriteNetWorthWidget> {

  late NetWorthGroupingCubit netWorthPrimaryGroupingCubit;
  late NetWorthEntityCubit netWorthEntityCubit;
  late NetWorthPrimarySubGroupingCubit netWorthPrimarySubGroupingCubit;
  late NetWorthReportCubit netWorthReportCubit;
  late NetWorthPeriodCubit netWorthPeriodCubit;
  late NetWorthNumberOfPeriodCubit netWorthNumberOfPeriodCubit;
  late NetWorthPartnershipMethodCubit netWorthPartnershipMethodCubit;
  late NetWorthHoldingMethodCubit netWorthHoldingMethodCubit;
  late NetWorthReturnPercentCubit netWorthReturnPercentCubit;
  late NetWorthDenominationCubit netWorthDenominationCubit;
  late NetWorthCurrencyCubit netWorthCurrencyCubit;
  late NetWorthAsOnDateCubit netWorthAsOnDateCubit;
  late NetWorthLoadingCubit netWorthLoadingCubit;

  @override
  void initState() {
    super.initState();

    netWorthReportCubit = widget.netWorthReportCubit;
    netWorthEntityCubit = netWorthReportCubit.netWorthEntityCubit;
    netWorthPrimaryGroupingCubit =
        netWorthReportCubit.netWorthPrimaryGroupingCubit;
    netWorthPrimarySubGroupingCubit =
        netWorthReportCubit.netWorthPrimarySubGroupingCubit;
    netWorthPeriodCubit = netWorthReportCubit.netWorthPeriodCubit;
    netWorthNumberOfPeriodCubit =
        netWorthReportCubit.netWorthNumberOfPeriodCubit;
    netWorthPartnershipMethodCubit =netWorthReportCubit.netWorthPartnershipMethodCubit;
    netWorthHoldingMethodCubit = netWorthReportCubit.netWorthHoldingMethodCubit;
    netWorthReturnPercentCubit = netWorthReportCubit.netWorthReturnPercentCubit;
    netWorthDenominationCubit = netWorthReportCubit.netWorthDenominationCubit;
    netWorthCurrencyCubit = netWorthReportCubit.netWorthCurrencyCubit;
    netWorthAsOnDateCubit = netWorthReportCubit.netWorthAsOnDateCubit;
    netWorthLoadingCubit = netWorthReportCubit.netWorthLoadingCubit;
  }
  @override
  Widget build(BuildContext context) {
    return Slidable(
        child: NetWorthSummaryChartWidget(
          isFavorite: true,
          favorite: widget.favorite,
          universalFilterAsOnDateCubit: widget.universalFilterAsOnDateCubit,
          favouriteUniversalFilterAsOnDateCubit: widget.favouriteUniversalFilterAsOnDateCubit,
          universalEntityFilterCubit: widget.universalEntityFilterCubit,
          netWorthGroupingCubit: netWorthPrimaryGroupingCubit,
          netWorthReturnPercentCubit: netWorthReturnPercentCubit,
          netWorthPrimarySubGroupingCubit:
          netWorthPrimarySubGroupingCubit,
          netWorthNumberOfPeriodCubit: netWorthNumberOfPeriodCubit,
          netWorthLoadingCubit: netWorthLoadingCubit,
          netWorthEntityCubit: netWorthEntityCubit,
          netWorthDenominationCubit: netWorthDenominationCubit,
          netWorthReportCubit: netWorthReportCubit,
          netWorthAsOnDateCubit: netWorthAsOnDateCubit,
          netWorthCurrencyCubit: netWorthCurrencyCubit,
          netWorthPeriodCubit: netWorthPeriodCubit,
          netWorthPartnershipMethodCubit: netWorthPartnershipMethodCubit,
          netWorthHoldingMethodCubit: netWorthHoldingMethodCubit,
        ));
  }
}
