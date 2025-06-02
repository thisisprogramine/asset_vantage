import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/domain/entities/favorites/favorites_entity.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_loading/performance_loading_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../config/constants/favorite_constants.dart';
import '../../../config/constants/route_constants.dart';
import '../../../config/constants/size_constants.dart';
import '../../../injector.dart';
import '../../blocs/favorites/favorites_cubit.dart';
import '../../blocs/performance/performance_as_on_date/performance_as_on_date_cubit.dart';
import '../../blocs/performance/performance_currency/performance_currency_cubit.dart';
import '../../blocs/performance/performance_denomination/performance_denomination_cubit.dart';
import '../../blocs/performance/performance_entity/performance_entity_cubit.dart';
import '../../blocs/performance/performance_number_of_period/performance_number_of_period_cubit.dart';
import '../../blocs/performance/performance_period/performance_period_cubit.dart';
import '../../blocs/performance/performance_primary_grouping/performance_primary_grouping_cubit.dart';
import '../../blocs/performance/performance_primary_sub_grouping/performance_primary_sub_grouping_cubit.dart';
import '../../blocs/performance/performance_report/performance_report_cubit.dart';
import '../../blocs/performance/performance_return_percent/performance_return_percent_cubit.dart';
import '../../blocs/performance/performance_secondary_grouping/performance_secondary_grouping_cubit.dart';
import '../../blocs/performance/performance_secondary_sub_grouping/performance_secondary_sub_grouping_cubit.dart';
import '../../blocs/performance/performance_sort_cubit/performance_sort_cubit.dart';
import '../../blocs/universal_filter/as_on_date_universal_filter/universal_filter_as_on_date_cubit.dart';
import '../../blocs/universal_filter/enitity_universal_filter/universal_entity_filter_cubit.dart';
import '../../blocs/universal_filter/favourite_as_on_date_universal_filter/favourite_universal_filter_as_on_date_cubit.dart';
import '../../theme/theme_color.dart';
import '../dashboard/dashboard_screen.dart';
import '../dashboard/highlights/performance_widget.dart';

class FavoritePerformanceWidget extends StatefulWidget {
  final Favorite? favorite;
  final PerformanceReportCubit performanceReportCubit;
  final UniversalEntityFilterCubit universalEntityFilterCubit;
  final UniversalFilterAsOnDateCubit universalFilterAsOnDateCubit;
  final FavouriteUniversalFilterAsOnDateCubit favouriteUniversalFilterAsOnDateCubit;
  final ScrollController? scrollController;
  const FavoritePerformanceWidget({
    super.key,
    required this.favorite,
    required this.universalEntityFilterCubit,
    required this.universalFilterAsOnDateCubit,
    required this.favouriteUniversalFilterAsOnDateCubit,
    required this.performanceReportCubit,
    required this.scrollController,
  });

  @override
  State<FavoritePerformanceWidget> createState() =>
      _FavoritePerformanceWidgetState();
}

class _FavoritePerformanceWidgetState extends State<FavoritePerformanceWidget>
    with TickerProviderStateMixin {

  late PerformancePrimaryGroupingCubit performancePrimaryGroupingCubit;
  late PerformanceEntityCubit performanceEntityCubit;
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

  @override
  void initState() {
    super.initState();
    performanceReportCubit = widget.performanceReportCubit;
    performanceEntityCubit =
        widget.performanceReportCubit.performanceEntityCubit;
    performancePrimaryGroupingCubit =
        widget.performanceReportCubit.performancePrimaryGroupingCubit;
    performancePrimarySubGroupingCubit =
        widget.performanceReportCubit.performancePrimarySubGroupingCubit;
    performanceSecondaryGroupingCubit =
        widget.performanceReportCubit.performanceSecondaryGroupingCubit;
    performanceSecondarySubGroupingCubit =
        widget.performanceReportCubit.performanceSecondarySubGroupingCubit;
    performancePeriodCubit =
        widget.performanceReportCubit.performancePeriodCubit;
    performanceNumberOfPeriodCubit =
        widget.performanceReportCubit.performanceNumberOfPeriodCubit;
    performanceReturnPercentCubit =
        widget.performanceReportCubit.performanceReturnPercentCubit;
    performanceDenominationCubit =
        widget.performanceReportCubit.performanceDenominationCubit;
    performanceCurrencyCubit =
        widget.performanceReportCubit.performanceCurrencyCubit;
    performanceAsOnDateCubit =
        widget.performanceReportCubit.performanceAsOnDateCubit;
    performanceSortCubit = widget.performanceReportCubit.performanceSortCubit;
    performanceLoadingCubit = widget.performanceReportCubit.performanceLoadingCubit;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
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
      ],
      child: Slidable(
          child: PerformanceWidget(
            isFavorite: true,
            favorite: widget.favorite,
            performanceSortCubit: performanceReportCubit.performanceSortCubit,
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
            universalEntityFilterCubit: widget.universalEntityFilterCubit,
            universalFilterAsOnDateCubit: widget.universalFilterAsOnDateCubit,
            favouriteUniversalFilterAsOnDateCubit: widget.favouriteUniversalFilterAsOnDateCubit,
            performanceDenominationCubit:
                performanceReportCubit.performanceDenominationCubit,
            performanceAsOnDateCubit:
                performanceReportCubit.performanceAsOnDateCubit,
            performancePeriodCubit:
                performanceReportCubit.performancePeriodCubit,
            performanceLoadingCubit: performanceLoadingCubit,
            performancePartnershipMethodCubit: performanceReportCubit.performancePartnershipMethodCubit,
            performanceHoldingMethodCubit: performanceReportCubit.performanceHoldingMethodCubit,
          )),
    );
  }
}
