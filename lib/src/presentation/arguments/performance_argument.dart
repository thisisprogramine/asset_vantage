

import 'package:asset_vantage/src/presentation/blocs/performance/performance_holding_method/performance_holding_method_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_loading/performance_loading_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_partnership_method/performance_partnership_method_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_primary_grouping/performance_primary_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_sort_cubit/performance_sort_cubit.dart';

import '../../data/models/return_percentage/return_percentage_model.dart';
import '../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../domain/entities/favorites/favorites_entity.dart';
import '../../domain/entities/return_percentage/return_percentage_entity.dart';
import '../blocs/performance/performance_as_on_date/performance_as_on_date_cubit.dart';
import '../blocs/performance/performance_currency/performance_currency_cubit.dart';
import '../blocs/performance/performance_denomination/performance_denomination_cubit.dart';
import '../blocs/performance/performance_entity/performance_entity_cubit.dart';
import '../blocs/performance/performance_number_of_period/performance_number_of_period_cubit.dart';
import '../blocs/performance/performance_period/performance_period_cubit.dart';
import '../blocs/performance/performance_primary_sub_grouping/performance_primary_sub_grouping_cubit.dart';
import '../blocs/performance/performance_report/performance_report_cubit.dart';
import '../blocs/performance/performance_return_percent/performance_return_percent_cubit.dart';
import '../blocs/performance/performance_secondary_grouping/performance_secondary_grouping_cubit.dart';
import '../blocs/performance/performance_secondary_sub_grouping/performance_secondary_sub_grouping_cubit.dart';
import '../blocs/universal_filter/as_on_date_universal_filter/universal_filter_as_on_date_cubit.dart';
import '../blocs/universal_filter/enitity_universal_filter/universal_entity_filter_cubit.dart';
import '../blocs/universal_filter/favourite_as_on_date_universal_filter/favourite_universal_filter_as_on_date_cubit.dart';

class PerformanceArgument {
  final bool isFavorite;
  final bool? isMarketValueSelected;
  final Favorite? favorite;
  final ReturnType returnType;
  final EntityData? entityData;
  Function(ReturnType index)? returnTypeChangedForSummary;
  Function()? changeBool;
  Function(List<ReturnPercentItemData?>? selectedReturnTypeList)? setReturnForDetails;
  final UniversalEntityFilterCubit universalEntityFilterCubit;
  final UniversalFilterAsOnDateCubit universalFilterAsOnDateCubit;
  final FavouriteUniversalFilterAsOnDateCubit favouriteUniversalFilterAsOnDateCubit;
  final PerformanceSortCubit performanceSortCubit;
  final PerformanceEntityCubit performanceEntityCubit;
  final PerformanceReportCubit performanceReportCubit;
  final PerformancePrimaryGroupingCubit performancePrimaryGroupingCubit;
  final PerformanceSecondaryGroupingCubit performanceSecondaryGroupingCubit;
  final PerformancePrimarySubGroupingCubit performancePrimarySubGroupingCubit;
  final PerformanceSecondarySubGroupingCubit performanceSecondarySubGroupingCubit;
  final PerformanceNumberOfPeriodCubit performanceNumberOfPeriodCubit;
  final PerformanceReturnPercentCubit performanceReturnPercentCubit;
  final PerformanceCurrencyCubit performanceCurrencyCubit;
  final PerformanceDenominationCubit performanceDenominationCubit;
  final PerformancePartnershipMethodCubit performancePartnershipMethodCubit;
  final PerformanceHoldingMethodCubit performanceHoldingMethodCubit;
  final PerformanceAsOnDateCubit performanceAsOnDateCubit;
  final PerformancePeriodCubit performancePeriodCubit;
  final PerformanceLoadingCubit performanceLoadingCubit;
  final String? asOnDate;

  PerformanceArgument(  {
    this.returnType = ReturnType.MTD,
    this.isFavorite = false,
    this.favorite,
    this.isMarketValueSelected,
    required this.entityData,
    this.returnTypeChangedForSummary,
    this.setReturnForDetails,
    this.changeBool,
    required this.universalEntityFilterCubit,
    required this.universalFilterAsOnDateCubit,
    required this.performanceSortCubit,
    required this.performanceEntityCubit,
    required this.performanceReportCubit,
    required this.performancePrimaryGroupingCubit,
    required this.performanceSecondaryGroupingCubit,
    required this.performancePrimarySubGroupingCubit,
    required this.performanceSecondarySubGroupingCubit,
    required this.performanceNumberOfPeriodCubit,
    required this.performanceReturnPercentCubit,
    required this.performanceCurrencyCubit,
    required this.performancePartnershipMethodCubit,
    required this.performanceHoldingMethodCubit,
    required this.performanceDenominationCubit,
    required this.performanceAsOnDateCubit,
    required this.performancePeriodCubit,
    required this.asOnDate,
    required this.performanceLoadingCubit,
    required this.favouriteUniversalFilterAsOnDateCubit,
  });

}