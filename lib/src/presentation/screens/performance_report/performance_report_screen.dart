import 'dart:async';
import 'dart:io';

import 'package:asset_vantage/src/config/app_config.dart';
import 'package:asset_vantage/src/config/constants/favorite_constants.dart';
import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/num_extensions.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/config/extensions/string_extensions.dart';
import 'package:asset_vantage/src/data/models/return_percentage/return_percentage_model.dart';
import 'package:asset_vantage/src/presentation/blocs/favorites/favorites_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_denomination/performance_denomination_cubit.dart';
import 'package:asset_vantage/src/presentation/widgets/drill_down_back_arrow.dart';
import 'package:asset_vantage/src/presentation/widgets/sort_filter.dart';
import 'package:asset_vantage/src/utilities/helper/ui_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../config/constants/hive_constants.dart';
import '../../../config/constants/size_constants.dart';
import '../../../domain/entities/app_error.dart';
import '../../../domain/entities/authentication/user_entity.dart';
import '../../../domain/entities/performance/performance_report_entity.dart';
import '../../../domain/entities/return_percentage/return_percentage_entity.dart';
import '../../../utilities/helper/app_helper.dart';
import '../../../utilities/helper/flash_helper.dart';
import '../../arguments/performance_argument.dart';
import '../../blocs/authentication/user/user_cubit.dart';
import '../../blocs/performance/performance_as_on_date/performance_as_on_date_cubit.dart';
import '../../blocs/performance/performance_entity/performance_entity_cubit.dart';
import '../../blocs/performance/performance_report/performance_report_cubit.dart';
import '../../blocs/performance/performance_sort_cubit/performance_sort_cubit.dart';
import '../../blocs/stealth/stealth_cubit.dart';
import '../../theme/theme_color.dart';
import '../../widgets/av_app_bar.dart';
import '../../widgets/loading_widgets/loading_bg.dart';
import '../../widgets/size_tween_hero.dart';
import '../dashboard/highlights/performance_widget.dart';
import '../navigation_drawer/NavigationDrawer.dart';
import '../../widgets/favorite_icon.dart';
import 'performance_universal_filter.dart';

class PerformanceReportScreen extends StatefulWidget {
  final PerformanceArgument argument;
  final bool isSummary = false;

  const PerformanceReportScreen({Key? key, required this.argument})
      : super(key: key);

  @override
  State<PerformanceReportScreen> createState() =>
      _PerformanceReportScreenState();
}

class _PerformanceReportScreenState extends State<PerformanceReportScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool stealthMode = false;
  bool isMarketValueSelected = true;
  int currentLevel = 0;
  List<int> selectedItemIndex = [];
  List<String> title = [];
  List<String> marketValue = [];
  ReturnType selectedReturnType = ReturnType.MTD;
  bool sortByAsc = false;
  bool isFavorate = false;
  bool fromApply = false;
  late final SuperTooltipController _tooltipController =
      SuperTooltipController();
  late final ScrollController _scrollController = ScrollController();

  returnTypeChanged(ReturnType returnType) {
    setState(() {
      selectedReturnType = returnType;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedReturnType = widget.argument.returnType;
    currentTile = ReportTile.perAssetClass;
    if (widget.argument.isFavorite) {
      isMarketValueSelected = widget.argument.favorite
              ?.filter?[FavoriteConstants.isMarketValueSelected] ??
          true;
    }
  }

  @override
  void dispose() {
    _tooltipController.dispose();
    super.dispose();
  }

  void changeBoolFromDetails() {
    fromApply = true;
  }

  void setReturn(List<ReturnPercentItemData?>? selectedReturnTypeList) {

    if(fromApply) {
      if(selectedReturnTypeList?.isNotEmpty ?? false) {
        selectedReturnType = _getReturnType(id: selectedReturnTypeList?[(selectedReturnTypeList.length) - 1]?.id);
      }
    }
    fromApply = false;

  }

  ReturnType _getReturnType({required String? id}) {
    switch(id) {
      case 'mtd_twr':
        return ReturnType.MTD;
      case 'qtd_twr':
        return ReturnType.QTD;
      case 'cytd_twr':
        return ReturnType.CYTD;
      case 'fytd_twr':
        return ReturnType.FYTD;
      case 'year_1_twr':
        return ReturnType.Yr1;
      case 'year_2_twr':
        return ReturnType.Yr2;
      case 'year_3_twr':
        return ReturnType.Yr3;
      case 'twr':
        return ReturnType.IncTwr;
      case 'xirr':
        return ReturnType.IncIrr;
      default:
        return ReturnType.MTD;
    }
  }

  Widget uiElementsToShowAfterDataLoad(
      Timer? timer, bool stealthValue, PerformanceReportLoaded state) {
    final List<PerformanceReportEntity> positions = AppHelpers.getPerformanceListAsPerPosition(
      report: state.chartData.positions,
      selectedItemIndex: selectedItemIndex,
      positionLevel: currentLevel,
    );
    return Column(
      children: [
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(Sizes.dimen_8.r),
                ),
              ),
              child: PerformanceWidget(
                currentLevel: currentLevel,
                changeBoolFromDetails: changeBoolFromDetails,
                selectedReturnType: selectedReturnType,
                selectedItemIndex: selectedItemIndex,
                universalFilterAsOnDateCubit: widget.argument.universalFilterAsOnDateCubit,
                favouriteUniversalFilterAsOnDateCubit: widget.argument.favouriteUniversalFilterAsOnDateCubit,
                universalEntityFilterCubit: widget.argument.universalEntityFilterCubit,
                isFavorite: widget.argument.isFavorite,
                favorite: widget.argument.favorite,
                isSummary: false,
                returnTypeChanged: returnTypeChanged,
                marketValue: marketValue.isNotEmpty ? marketValue.last : '0.00',
                performanceReportCubit: widget.argument.performanceReportCubit,
                performanceEntityCubit: widget.argument.performanceEntityCubit,
                performanceSortCubit: widget.argument.performanceSortCubit,
                performancePrimaryGroupingCubit:
                    widget.argument.performancePrimaryGroupingCubit,
                performanceSecondaryGroupingCubit:
                    widget.argument.performanceSecondaryGroupingCubit,
                performancePrimarySubGroupingCubit:
                    widget.argument.performancePrimarySubGroupingCubit,
                performanceSecondarySubGroupingCubit:
                    widget.argument.performanceSecondarySubGroupingCubit,
                performancePeriodCubit: widget.argument.performancePeriodCubit,
                performanceNumberOfPeriodCubit:
                    widget.argument.performanceNumberOfPeriodCubit,
                performanceReturnPercentCubit:
                    widget.argument.performanceReturnPercentCubit,
                performanceCurrencyCubit:
                    widget.argument.performanceCurrencyCubit,
                performanceAsOnDateCubit:
                    widget.argument.performanceAsOnDateCubit,
                performanceDenominationCubit:
                    widget.argument.performanceDenominationCubit,
                performanceLoadingCubit: widget.argument.performanceLoadingCubit,
                performancePartnershipMethodCubit: widget.argument.performancePartnershipMethodCubit,
                performanceHoldingMethodCubit: widget.argument.performanceHoldingMethodCubit,
              ),
            ),
        if(positions.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<PerformanceSortCubit, Sort>(
                    bloc: widget.argument.performanceSortCubit,
                    builder: (context, sortState) {
                      return SortFilter(
                          onSelect: (int index) async {
                            if (index == 1) {
                              widget.argument.performanceSortCubit
                                  .tableSortChange(Sort.az.index);
                            } else if (index == 2) {
                              widget.argument.performanceSortCubit
                                  .tableSortChange(Sort.za.index);
                            } else if (index == 3) {
                              widget.argument.performanceSortCubit
                                  .tableSortChange(Sort.ascending.index);
                            } else if (index == 4) {
                              widget.argument.performanceSortCubit
                                  .tableSortChange(Sort.descending.index);
                            }
                          },
                          menu: [
                            PopupMenuItem(
                              key: const Key("descending"),
                              padding: EdgeInsets.symmetric(
                                  vertical: Sizes.dimen_2.h,
                                  horizontal: Sizes.dimen_12.w),
                              value: 4,
                              child: SizedBox(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            StringConstants.highToLow,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        if (sortState == Sort.descending)
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: Sizes.dimen_4.h,
                                                horizontal: Sizes.dimen_0.w),
                                            child: Icon(
                                              Icons.check_rounded,
                                              color: AppColor.primary,
                                              size: Sizes.dimen_24.w,
                                            ),
                                          )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              key: const Key("ascending"),
                              padding: EdgeInsets.symmetric(
                                  vertical: Sizes.dimen_2.h,
                                  horizontal: Sizes.dimen_12.w),
                              value: 3,
                              child: SizedBox(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            StringConstants.lowToHigh,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        if (sortState == Sort.ascending)
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: Sizes.dimen_4.h,
                                                horizontal: Sizes.dimen_0.w),
                                            child: Icon(
                                              Icons.check_rounded,
                                              color: AppColor.primary,
                                              size: Sizes.dimen_24.w,
                                            ),
                                          )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              padding: EdgeInsets.symmetric(
                                  vertical: Sizes.dimen_2.h,
                                  horizontal: Sizes.dimen_12.w),
                              value: 1,
                              child: SizedBox(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            StringConstants.nameAZ,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        if (sortState == Sort.az)
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: Sizes.dimen_4.h,
                                                horizontal: Sizes.dimen_0.w),
                                            child: Icon(
                                              Icons.check_rounded,
                                              color: AppColor.primary,
                                              size: Sizes.dimen_24.w,
                                            ),
                                          )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              key: const Key("z-a-item"),
                              padding: EdgeInsets.symmetric(
                                  vertical: Sizes.dimen_2.h,
                                  horizontal: Sizes.dimen_12.w),
                              value: 2,
                              child: SizedBox(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            StringConstants.nameZA,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        if (sortState == Sort.za)
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: Sizes.dimen_4.h,
                                                horizontal: Sizes.dimen_0.w),
                                            child: Icon(
                                              Icons.check_rounded,
                                              color: AppColor.primary,
                                              size: Sizes.dimen_24.w,
                                            ),
                                          )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          sortName: _getSortName(sortState),
                          isDissable: false
                      );
                    }),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMarketValueSelected = !isMarketValueSelected;
                    });
                  },
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Sizes.dimen_12.w,
                          vertical: Sizes.dimen_2.h),
                      child: Row(
                        children: [
                          Container(
                            height: Sizes.dimen_8,
                            width: Sizes.dimen_8,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isMarketValueSelected ? AppColor.purple : AppColor.seaBlue),
                          ),
                          UIHelper.horizontalSpaceSmall,
                          Text(
                            isMarketValueSelected ? StringConstants.marketValue : "${AppHelpers.getReturnName(
                                selectedReturnType)}",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                          UIHelper.horizontalSpaceSmall,
                          SvgPicture.asset(
                            'assets/svgs/swipe_icon.svg',
                            width: Sizes.dimen_14,
                            height: Sizes.dimen_14,
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        if (MediaQuery.of(context).textScaler.textScaleFactor > 1.6)
          SizedBox(
            height: ScreenUtil().screenHeight * 0.45,
            child: (positions.isNotEmpty) ?  Card(
              elevation: 0,
              margin: const EdgeInsets.symmetric(vertical: 0.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: _getDrilldownList(
                  scrollController: _scrollController,
                  positions: positions,
                  stealthValue: stealthValue),
            ) : const SizedBox.shrink(),
          )
        else
          Flexible(
            child: (positions.isNotEmpty) ? SafeArea(
              child: Card(
                elevation: 0,
                margin: const EdgeInsets.symmetric(vertical: 0.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: _getDrilldownList(
                    scrollController: _scrollController,
                    positions: positions,
                    stealthValue: stealthValue),
              ),
            ) : const SizedBox.shrink(),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool stealthValue = context.read<StealthCubit>().state;
    Timer? timer;
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      key: _scaffoldKey,
      drawer: const AVNavigationDrawer(),
      appBar: AVAppBar(
        title: title.isNotEmpty
            ? title.last
            : widget.argument.isFavorite
            ? (widget.argument.favorite?.reportname ??
            'Performance')
            : 'Performance',
        leading: DrillDownBackArrow(onTap: () {
          if (currentLevel > 0) {
            setState(() {
              currentLevel--;
              title.removeLast();
              marketValue.removeLast();
              selectedItemIndex.removeLast();
            });
          } else {
            if(widget.argument.returnTypeChangedForSummary != null) {
              widget.argument.returnTypeChangedForSummary!(selectedReturnType);
            }
            Navigator.of(context).pop();
          }
        },)
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_12.w),
        child: BlocBuilder<PerformanceReportCubit, PerformanceReportState>(
            bloc: widget.argument.performanceReportCubit,
            builder: (context, state) {
              if (state is PerformanceReportLoaded) {
                setReturn(widget.argument.performanceReturnPercentCubit.state.selectedPerformanceReturnPercentList);
                if (MediaQuery.of(context).textScaler.textScaleFactor > 1.6) {
                  return SingleChildScrollView(
                    controller: _scrollController,
                    child: uiElementsToShowAfterDataLoad(
                        timer, stealthValue, state),
                  );
                } else {
                  return uiElementsToShowAfterDataLoad(
                      timer, stealthValue, state);
                }
              } else if (state is PerformanceReportLoading) {
                return Column(
                  children: [
                    Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(Sizes.dimen_8.r),
                          ),
                        ),
                        child: PerformanceWidget(
                          currentLevel: currentLevel,
                          selectedReturnType: selectedReturnType,
                          selectedItemIndex: selectedItemIndex,
                          isSummary: false,
                          returnTypeChanged: returnTypeChanged,
                          marketValue: marketValue.isNotEmpty ? marketValue.last : '0.00',
                          performanceReportCubit: widget.argument.performanceReportCubit,
                          performanceEntityCubit: widget.argument.performanceEntityCubit,
                          performanceSortCubit: widget.argument.performanceSortCubit,
                          performancePrimaryGroupingCubit:
                          widget.argument.performancePrimaryGroupingCubit,
                          universalFilterAsOnDateCubit: widget.argument.universalFilterAsOnDateCubit,
                          universalEntityFilterCubit: widget.argument.universalEntityFilterCubit,
                          favouriteUniversalFilterAsOnDateCubit: widget.argument.favouriteUniversalFilterAsOnDateCubit,
                          performanceSecondaryGroupingCubit:
                          widget.argument.performanceSecondaryGroupingCubit,
                          performancePrimarySubGroupingCubit:
                          widget.argument.performancePrimarySubGroupingCubit,
                          performanceSecondarySubGroupingCubit:
                          widget.argument.performanceSecondarySubGroupingCubit,
                          performancePeriodCubit: widget.argument.performancePeriodCubit,
                          performanceNumberOfPeriodCubit:
                          widget.argument.performanceNumberOfPeriodCubit,
                          performanceReturnPercentCubit:
                          widget.argument.performanceReturnPercentCubit,
                          performanceCurrencyCubit:
                          widget.argument.performanceCurrencyCubit,
                          performanceAsOnDateCubit:
                          widget.argument.performanceAsOnDateCubit,
                          performanceDenominationCubit:
                          widget.argument.performanceDenominationCubit,
                          performanceLoadingCubit: widget.argument.performanceLoadingCubit,
                          performancePartnershipMethodCubit: widget.argument.performancePartnershipMethodCubit,
                          performanceHoldingMethodCubit: widget.argument.performanceHoldingMethodCubit,
                        )
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_4.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BlocBuilder<PerformanceSortCubit, Sort>(
                              bloc: widget.argument.performanceSortCubit,
                              builder: (context, sortState) {
                                return SortFilter(
                                    onSelect: (int index) async {

                                    },
                                    menu: [],
                                    sortName: _getSortName(sortState),
                                    isDissable: true
                                );
                              }),
                          GestureDetector(
                            onTap: () {
                            },
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Sizes.dimen_12.w,
                                    vertical: Sizes.dimen_2.h),
                                child: Row(
                                  children: [
                                    Container(
                                      height: Sizes.dimen_8,
                                      width: Sizes.dimen_8,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isMarketValueSelected ? AppColor.purple.withValues(alpha: 0.8) : AppColor.seaBlue.withValues(alpha: 0.8)),
                                    ),
                                    UIHelper.horizontalSpaceSmall,
                                    Text(
                                      isMarketValueSelected ? StringConstants.marketValue : "${AppHelpers.getReturnName(
                                          selectedReturnType)}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                          fontWeight: FontWeight.bold, color: AppColor.grey.withValues(alpha: 0.8)),
                                    ),
                                    UIHelper.horizontalSpaceSmall,
                                    SvgPicture.asset(
                                      'assets/svgs/swipe_icon.svg',
                                      width: Sizes.dimen_14,
                                      height: Sizes.dimen_14,
                                      color: AppColor.grey.withValues(alpha: 0.8),
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SafeArea(
                        child: Card(
                            elevation: 0,
                            child: _getDrilldownLoadingList()
                        ),
                      ),
                    )
                  ],
                );
              } else if (state is PerformanceReportError) {
                if (state.errorType ==
                    AppErrorType.unauthorised) {
                  AppHelpers.logout(context: context);
                }
                return Column(
                  children: [
                    Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(Sizes.dimen_8.r),
                          ),
                        ),
                        child: PerformanceWidget(
                          currentLevel: currentLevel,
                          selectedItemIndex: selectedItemIndex,
                          isSummary: false,
                          returnTypeChanged: returnTypeChanged,
                          selectedReturnType: selectedReturnType,
                          marketValue: marketValue.isNotEmpty ? marketValue.last : '0.00',
                          performanceReportCubit: widget.argument.performanceReportCubit,
                          performanceEntityCubit: widget.argument.performanceEntityCubit,
                          performanceSortCubit: widget.argument.performanceSortCubit,
                          performancePrimaryGroupingCubit:
                          widget.argument.performancePrimaryGroupingCubit,
                          performanceSecondaryGroupingCubit:
                          widget.argument.performanceSecondaryGroupingCubit,
                          universalFilterAsOnDateCubit: widget.argument.universalFilterAsOnDateCubit,
                          universalEntityFilterCubit: widget.argument.universalEntityFilterCubit,
                          favouriteUniversalFilterAsOnDateCubit: widget.argument.favouriteUniversalFilterAsOnDateCubit,
                          performancePrimarySubGroupingCubit:
                          widget.argument.performancePrimarySubGroupingCubit,
                          performanceSecondarySubGroupingCubit:
                          widget.argument.performanceSecondarySubGroupingCubit,
                          performancePeriodCubit: widget.argument.performancePeriodCubit,
                          performanceNumberOfPeriodCubit:
                          widget.argument.performanceNumberOfPeriodCubit,
                          performanceReturnPercentCubit:
                          widget.argument.performanceReturnPercentCubit,
                          performanceCurrencyCubit:
                          widget.argument.performanceCurrencyCubit,
                          performanceAsOnDateCubit:
                          widget.argument.performanceAsOnDateCubit,
                          performanceDenominationCubit:
                          widget.argument.performanceDenominationCubit,
                          performanceLoadingCubit: widget.argument.performanceLoadingCubit,
                          performancePartnershipMethodCubit: widget.argument.performancePartnershipMethodCubit,
                          performanceHoldingMethodCubit: widget.argument.performanceHoldingMethodCubit,
                        )
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_4.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BlocBuilder<PerformanceSortCubit, Sort>(
                              bloc: widget.argument.performanceSortCubit,
                              builder: (context, sortState) {
                                return SortFilter(
                                    onSelect: (int index) async {

                                    },
                                    menu: [],
                                    sortName: _getSortName(sortState),
                                    isDissable: true
                                );
                              }),
                          GestureDetector(
                            onTap: () {
                            },
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Sizes.dimen_12.w,
                                    vertical: Sizes.dimen_2.h),
                                child: Row(
                                  children: [
                                    Container(
                                      height: Sizes.dimen_8,
                                      width: Sizes.dimen_8,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isMarketValueSelected ? AppColor.purple.withValues(alpha: 0.8) : AppColor.seaBlue.withValues(alpha: 0.8)),
                                    ),
                                    UIHelper.horizontalSpaceSmall,
                                    Text(
                                      isMarketValueSelected ? StringConstants.marketValue : "${AppHelpers.getReturnName(
                                          selectedReturnType)}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                          fontWeight: FontWeight.bold, color: AppColor.grey.withValues(alpha: 0.8)),
                                    ),
                                    UIHelper.horizontalSpaceSmall,
                                    SvgPicture.asset(
                                      'assets/svgs/swipe_icon.svg',
                                      width: Sizes.dimen_14,
                                      height: Sizes.dimen_14,
                                      color: AppColor.grey.withValues(alpha: 0.8),
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SafeArea(
                        child: Card(
                            elevation: 0,
                            child: _getDrilldownLoadingList()
                        ),
                      ),
                    )
                  ],
                );
              }
              return Column(
                children: [
                  Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(Sizes.dimen_8.r),
                        ),
                      ),
                      child: PerformanceWidget(
                        currentLevel: currentLevel,
                        selectedItemIndex: selectedItemIndex,
                        isSummary: false,
                        returnTypeChanged: returnTypeChanged,
                        selectedReturnType: selectedReturnType,
                        marketValue: marketValue.isNotEmpty ? marketValue.last : '0.00',
                        performanceReportCubit: widget.argument.performanceReportCubit,
                        performanceEntityCubit: widget.argument.performanceEntityCubit,
                        performanceSortCubit: widget.argument.performanceSortCubit,
                        performancePrimaryGroupingCubit:
                        widget.argument.performancePrimaryGroupingCubit,
                        performanceSecondaryGroupingCubit:
                        widget.argument.performanceSecondaryGroupingCubit,
                        universalFilterAsOnDateCubit: widget.argument.universalFilterAsOnDateCubit,
                        universalEntityFilterCubit: widget.argument.universalEntityFilterCubit,
                        favouriteUniversalFilterAsOnDateCubit: widget.argument.favouriteUniversalFilterAsOnDateCubit,
                        performancePrimarySubGroupingCubit:
                        widget.argument.performancePrimarySubGroupingCubit,
                        performanceSecondarySubGroupingCubit:
                        widget.argument.performanceSecondarySubGroupingCubit,
                        performancePeriodCubit: widget.argument.performancePeriodCubit,
                        performanceNumberOfPeriodCubit:
                        widget.argument.performanceNumberOfPeriodCubit,
                        performanceReturnPercentCubit:
                        widget.argument.performanceReturnPercentCubit,
                        performanceCurrencyCubit:
                        widget.argument.performanceCurrencyCubit,
                        performanceAsOnDateCubit:
                        widget.argument.performanceAsOnDateCubit,
                        performanceDenominationCubit:
                        widget.argument.performanceDenominationCubit,
                        performanceLoadingCubit: widget.argument.performanceLoadingCubit,
                        performancePartnershipMethodCubit: widget.argument.performancePartnershipMethodCubit,
                        performanceHoldingMethodCubit: widget.argument.performanceHoldingMethodCubit,
                      )
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_4.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BlocBuilder<PerformanceSortCubit, Sort>(
                            bloc: widget.argument.performanceSortCubit,
                            builder: (context, sortState) {
                              return SortFilter(
                                  onSelect: (int index) async {

                                  },
                                  menu: [],
                                  sortName: _getSortName(sortState),
                                  isDissable: true
                              );
                            }),
                        GestureDetector(
                          onTap: () {
                          },
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Sizes.dimen_12.w,
                                  vertical: Sizes.dimen_2.h),
                              child: Row(
                                children: [
                                  Container(
                                    height: Sizes.dimen_8,
                                    width: Sizes.dimen_8,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isMarketValueSelected ? AppColor.purple.withValues(alpha: 0.8) : AppColor.seaBlue.withValues(alpha: 0.8)),
                                  ),
                                  UIHelper.horizontalSpaceSmall,
                                  Text(
                                    isMarketValueSelected ? StringConstants.marketValue : "${AppHelpers.getReturnName(
                                        selectedReturnType)}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                        fontWeight: FontWeight.bold, color: AppColor.grey.withValues(alpha: 0.8)),
                                  ),
                                  UIHelper.horizontalSpaceSmall,
                                  SvgPicture.asset(
                                    'assets/svgs/swipe_icon.svg',
                                    width: Sizes.dimen_14,
                                    height: Sizes.dimen_14,
                                    color: AppColor.grey.withValues(alpha: 0.8),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SafeArea(
                      child: Card(
                          elevation: 0,
                          child: _getDrilldownLoadingList()
                      ),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }

  String _getSortName(Sort sort) {
    if (sort == Sort.az) {
      return StringConstants.nameAZ;
    } else if (sort == Sort.za) {
      return StringConstants.nameZA;
    } else if (sort == Sort.ascending) {
      return StringConstants.lowToHigh;
    } else if (sort == Sort.descending) {
      return StringConstants.highToLow;
    }
    return '';
  }

  Widget _getDrilldownList(
      {required ScrollController scrollController,
      required List<PerformanceReportEntity> positions,
      required bool stealthValue}) {
    return BlocBuilder<PerformanceSortCubit, Sort>(
        bloc: widget.argument.performanceSortCubit,
        builder: (context, sortState) {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.symmetric(vertical: Sizes.dimen_0.h),
            shrinkWrap: true,
            itemCount: positions.length,
            itemBuilder: (context, index) {
              if (!isMarketValueSelected) {
                if (sortState == Sort.ascending) {
                  positions.sort((a, b) =>
                      (AppHelpers.getReturnTWR(a, selectedReturnType))
                          .compareTo(
                              AppHelpers.getReturnTWR(b, selectedReturnType)));
                } else if (sortState == Sort.descending) {
                  positions.sort((a, b) =>
                      (AppHelpers.getReturnTWR(b, selectedReturnType))
                          .compareTo(
                              AppHelpers.getReturnTWR(a, selectedReturnType)));
                } else if (sortState == Sort.az) {
                  positions
                      .sort((a, b) => (a.title ?? '').compareTo(b.title ?? ''));
                } else if (sortState == Sort.za) {
                  positions
                      .sort((a, b) => (b.title ?? '').compareTo(a.title ?? ''));
                }
              } else {
                if (sortState == Sort.ascending) {
                  positions.sort((a, b) =>
                      (a.marketValue ?? 0.00).compareTo(b.marketValue ?? 0.00));
                } else if (sortState == Sort.descending) {
                  positions.sort((a, b) =>
                      (b.marketValue ?? 0.00).compareTo(a.marketValue ?? 0.00));
                } else if (sortState == Sort.az) {
                  positions
                      .sort((a, b) => (a.title ?? '').compareTo(b.title ?? ''));
                } else if (sortState == Sort.za) {
                  positions
                      .sort((a, b) => (b.title ?? '').compareTo(a.title ?? ''));
                }
              }

              final item = positions[index];
              final greaterValue = AppHelpers.getPerformanceGreaterValue(
                  performanceList: positions);
              return ChildItemWithTooltip(
                  selectedReturnType: selectedReturnType,
                  shouldShowLine: index != positions.length,
                  greaterValue: greaterValue,
                  stealthValue: stealthValue,
                  isMarketValueSelected: isMarketValueSelected,
                  argument: widget.argument,
                  item: item,
                  getToDrillDown: () {
                    setState(() {
                      title.add(item.title ?? '');
                      marketValue.add(item.marketValue?.toStringAsFixed(2) ??
                          (isMarketValueSelected ? '0.00' : '--'));
                      currentLevel++;
                      selectedItemIndex.add(index);
                    });
                  });
            },
          );
        });
  }

  Widget _getDrilldownLoadingList() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {},
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: Sizes.dimen_12.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: Sizes.dimen_6.h),
                        child: LoadingBg(
                          height: Sizes.dimen_20.h,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ChildItemWithTooltip extends StatefulWidget {
  final bool stealthValue;
  final bool isMarketValueSelected;
  final PerformanceArgument argument;
  final PerformanceReportEntity item;
  final void Function() getToDrillDown;
  final int greaterValue;
  final ReturnType selectedReturnType;
  final bool shouldShowLine;

  const ChildItemWithTooltip({
    super.key,
    required this.stealthValue,
    required this.isMarketValueSelected,
    required this.argument,
    required this.item,
    required this.getToDrillDown,
    required this.greaterValue,
    required this.selectedReturnType,
    required this.shouldShowLine,
  });

  @override
  State<ChildItemWithTooltip> createState() => _ChildItemWithTooltipState();
}

class _ChildItemWithTooltipState extends State<ChildItemWithTooltip> {
  late final SuperTooltipController _tooltipController =
      SuperTooltipController();

  @override
  void dispose() {
    _tooltipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Timer? timer;
    return BlocBuilder<PerformanceDenominationCubit,
            PerformanceDenominationState>(
        bloc: widget.argument.performanceDenominationCubit,
        builder: (context, denominationState) {
          return SuperTooltip(
            borderRadius: 15,
            arrowBaseWidth: 10,
            arrowLength: 15,
            arrowTipDistance: 18,
            hasShadow: false,
            onShow: () {
              timer = Timer(const Duration(seconds: 3), () {
                if (_tooltipController.isVisible) {
                  _tooltipController.hideTooltip();
                }
              });
            },
            onHide: () {
              if (timer?.isActive ?? false) {
                timer?.cancel();
              }
            },
            onLongPress: () {
              if (_tooltipController.isVisible) {
                _tooltipController.hideTooltip();
              } else {
                HapticFeedback.lightImpact();
                SystemSound.play(SystemSoundType.click);
                _tooltipController.showTooltip();
              }
            },
            controller: _tooltipController,
            content: widget.isMarketValueSelected
                ? Container(
                    margin: EdgeInsets.symmetric(horizontal: Sizes.dimen_12.w),
                    padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.item.title}",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.lightGrey.withOpacity(0.6)),
                        ),
                        UIHelper.verticalSpace(Sizes.dimen_2.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: AnimatedFractionallySizedBox(
                                duration: Duration(milliseconds: 500),
                                alignment: Alignment.centerLeft,
                                widthFactor: AppHelpers
                                    .getPerformanceMarketValueChartFraction(
                                        actualValue:
                                            widget.item.marketValue ?? 0.00,
                                        greaterValue:
                                            widget.greaterValue.toDouble()),
                                child: Container(
                                  height: Sizes.dimen_6.h,
                                  decoration: BoxDecoration(
                                      color: AppColor.violet,
                                  ),
                                ),
                              ),
                            ),
                            UIHelper.horizontalSpaceSmall,
                            Text(
                              "${NumberFormat.simpleCurrency(name: widget.argument.performanceCurrencyCubit.state.selectedPerformanceCurrency?.code ?? 'USD').currencySymbol} " +
                                  "${(widget.item.marketValue ?? 0.00) < 0.0 ? '(${NumberFormat(widget.argument.performanceCurrencyCubit.state.selectedPerformanceCurrency?.format ?? '###,###,##0.00').format((widget.item.marketValue ?? 0.00).abs().denominate(denominator: denominationState.selectedPerformanceDenomination?.denomination))})' : NumberFormat(widget.argument.performanceCurrencyCubit.state.selectedPerformanceCurrency?.format ?? '###,###,##0.00').format((widget.item.marketValue ?? 0.00).denominate(denominator: denominationState.selectedPerformanceDenomination?.denomination))}${denominationState.selectedPerformanceDenomination?.suffix}"
                                      .stealth(widget.stealthValue),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                      fontSize: Sizes.dimen_14,
                                      fontWeight: FontWeight.bold,
                                      color: widget.stealthValue
                                          ? null
                                          : (widget.item.marketValue ?? 0.00) >=
                                                  0.0
                                              ? null
                                              : AppColor.red),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: Sizes.dimen_12.w),
                    padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${widget.item.title}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.lightGrey
                                                  .withOpacity(0.6)),
                                    ),
                                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                                    Text(
                                      (AppHelpers.getReturnBenchmark(widget.item, widget.selectedReturnType) * 100000).round() != 0 ?
                                      "${widget.item.benchmark}" : "N/A",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${AppHelpers.getReturnTWR(widget.item, widget.selectedReturnType).toStringAsFixed(2)}" +
                                          "%",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: AppHelpers.getReturnTWR(
                                                          widget.item,
                                                          widget
                                                              .selectedReturnType) >=
                                                      0.00
                                                  ? AppColor.green
                                                  : AppColor.red),
                                    ),
                                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                                    Text(
                                      (AppHelpers.getReturnBenchmark(widget.item, widget.selectedReturnType) * 100000).round() != 0 ?
                                      "${AppHelpers.getReturnBenchmark(widget.item, widget.selectedReturnType).toStringAsFixed(2)}" +
                                          "%" : "N/A",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                              color: AppHelpers.getReturnBenchmark(
                                                          widget.item,
                                                          widget
                                                              .selectedReturnType) >=
                                                      0.00
                                                  ? AppColor.green
                                                  : AppColor.red),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
            showBarrier: true,
            popupDirection: TooltipDirection.up,
            child: widget.isMarketValueSelected
                ? GestureDetector(
                    onTap: () {
                        widget.getToDrillDown();
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: Sizes.dimen_12.w),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: AppColor.grey.withOpacity(0.5)))),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: Sizes.dimen_4.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Semantics(
                                    identifier: "drillDownMarketText",
                                    label: "drillDownMarketText",
                                    child: Text(
                                      "${widget.item.title}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.lightGrey
                                                  .withOpacity(0.6)),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  UIHelper.verticalSpace(Sizes.dimen_2.h),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: AnimatedFractionallySizedBox(
                                          duration: Duration(milliseconds: 500),
                                          alignment: Alignment.centerLeft,
                                          widthFactor:
                                              AppHelpers
                                                  .getPerformanceMarketValueChartFraction(
                                                      actualValue: widget.item
                                                              .marketValue ??
                                                          0.00,
                                                      greaterValue: widget
                                                          .greaterValue
                                                          .toDouble()),
                                          child: Container(
                                            height: Sizes.dimen_6.h,
                                            decoration: BoxDecoration(
                                                color: AppColor.violet,
                                            ),
                                          ),
                                        ),
                                      ),
                                      UIHelper.horizontalSpaceSmall,
                                      Text(
                                        "${NumberFormat.simpleCurrency(name: widget.argument.performanceCurrencyCubit.state.selectedPerformanceCurrency?.code ?? 'USD').currencySymbol} " +
                                            "${(widget.item.marketValue ?? 0.00) < 0.0 ? '(${NumberFormat(widget.argument.performanceCurrencyCubit.state.selectedPerformanceCurrency?.format ?? '###,###,##0.00').format((widget.item.marketValue ?? 0.00).abs().denominate(denominator: denominationState.selectedPerformanceDenomination?.denomination))})' : NumberFormat(widget.argument.performanceCurrencyCubit.state.selectedPerformanceCurrency?.format ?? '###,###,##0.00').format((widget.item.marketValue ?? 0.00).denominate(denominator: denominationState.selectedPerformanceDenomination?.denomination))}${denominationState.selectedPerformanceDenomination?.suffix}"
                                                .stealth(widget.stealthValue),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                                fontSize: Sizes.dimen_14,
                                                fontWeight: FontWeight.bold,
                                                color: widget.stealthValue
                                                    ? null
                                                    : (widget.item.marketValue ??
                                                                0.00) >=
                                                            0.0
                                                        ? null
                                                        : AppColor.red),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          UIHelper.horizontalSpaceMedium,
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: Sizes.dimen_4.h),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: Sizes.dimen_14.w,
                                  color: AppColor.lightGrey,
                                ))
                        ],
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                        widget.getToDrillDown();
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: Sizes.dimen_12.w),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: AppColor.grey.withOpacity(0.5)))),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: Sizes.dimen_4.h),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Semantics(
                                          identifier: "drillDownText",
                                          label: "drillDownText",
                                          child: Text(
                                            "${widget.item.title}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColor.lightGrey
                                                        .withOpacity(0.6)),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        UIHelper.verticalSpace(Sizes.dimen_2.h),
                                        Text(
                                          (AppHelpers.getReturnBenchmark(widget.item, widget.selectedReturnType) * 100000).round() != 0 ?
                                          "${widget.item.benchmark}" : "N/A",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "${AppHelpers.getReturnTWR(widget.item, widget.selectedReturnType).toStringAsFixed(2)}" +
                                              "%",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppHelpers.getReturnTWR(
                                                              widget.item,
                                                              widget
                                                                  .selectedReturnType) >=
                                                          0.00
                                                      ? AppColor.green
                                                      : AppColor.red),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        UIHelper.verticalSpace(Sizes.dimen_2.h),
                                        Text(
                                          (AppHelpers.getReturnBenchmark(widget.item, widget.selectedReturnType) * 100000).round() != 0 ?
                                          "${AppHelpers.getReturnBenchmark(widget.item, widget.selectedReturnType).toStringAsFixed(2)}" +
                                              "%" : "N/A",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                  color: AppHelpers
                                                              .getReturnBenchmark(
                                                                  widget.item,
                                                                  widget
                                                                      .selectedReturnType) >=
                                                          0.00
                                                      ? AppColor.green
                                                      : AppColor.red),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          UIHelper.horizontalSpaceMedium,
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: Sizes.dimen_4.h),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: Sizes.dimen_14.w,
                                  color: AppColor.lightGrey,
                                ))
                        ],
                      ),
                    ),
                  ),
          );
        });
  }
}
