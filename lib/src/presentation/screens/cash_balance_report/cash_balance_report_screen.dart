import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:asset_vantage/src/config/extensions/num_extensions.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/config/extensions/string_extensions.dart';
import 'package:asset_vantage/src/presentation/arguments/cash_balance_argument.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_currency/cash_balance_currency_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_denomination/cash_balance_denomination_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_entity/cash_balance_entity_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_report/cash_balance_report_cubit.dart';
import 'package:asset_vantage/src/presentation/screens/cash_balance_report/cash_balance_filter_modal.dart';
import 'package:asset_vantage/src/presentation/screens/dashboard/highlights/cash_balance_chart.dart';
import 'package:asset_vantage/src/presentation/screens/navigation_drawer/NavigationDrawer.dart';
import 'package:asset_vantage/src/presentation/widgets/drill_down_back_arrow.dart';
import 'package:asset_vantage/src/presentation/widgets/sort_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../config/constants/size_constants.dart';
import '../../../config/constants/strings_constants.dart';
import '../../../domain/entities/app_error.dart';
import '../../../domain/entities/authentication/user_entity.dart';
import '../../../domain/entities/cash_balance/cash_balance_entity.dart';
import '../../../utilities/helper/app_helper.dart';
import '../../../utilities/helper/flash_helper.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../blocs/authentication/user/user_cubit.dart';
import '../../blocs/cash_balance/cash_balance_as_on_date/cash_balance_as_on_date_cubit.dart';
import '../../blocs/cash_balance/cash_balance_number_of_period/cash_balance_number_of_period_cubit.dart';
import '../../blocs/cash_balance/cash_balance_sort_cubit/cash_balance_sort_cubit.dart';
import '../../blocs/currency_filter/currency_filter_cubit.dart';
import '../../blocs/favorites/favorites_cubit.dart';
import '../../blocs/stealth/stealth_cubit.dart';
import '../../theme/theme_color.dart';
import '../../widgets/av_app_bar.dart';
import '../../widgets/favorite_icon.dart';
import '../../widgets/loading_widgets/loading_bg.dart';
import '../../widgets/size_tween_hero.dart';

class CashBalanceReportScreen extends StatefulWidget {
  final CashBalanceArgument argument;
  const CashBalanceReportScreen({
    super.key,
    required this.argument,
  });

  @override
  State<CashBalanceReportScreen> createState() =>
      _CashBalanceReportScreenState();
}

class _CashBalanceReportScreenState extends State<CashBalanceReportScreen> {
  int currentLevel = 0;
  List<String> title = [];
  PrimarySubgroupEntity? selectedPrimaryGrping;
  List<int> selectedChartBarMonth = [0];
  List<String> selectedPosition = [];
  late final SuperTooltipController _tooltipController =
      SuperTooltipController();
  late final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    widget.argument.cashBalanceSortCubit.getSelectedOne().then((value) =>
        widget.argument.cashBalanceSortCubit.tableSortChange(value ?? 3));
    super.initState();
  }

  void selectChartBar(int index) {

    if (selectedChartBarMonth[currentLevel] != index) {
      selectedChartBarMonth[currentLevel] = index;

      if (currentLevel > 0) {
        currentLevel--;
        title.removeLast();
        selectedChartBarMonth.removeLast();
        selectedPosition.removeLast();
        setState(() {});
      }

      if (currentLevel >= 0) {
        selectedChartBarMonth[currentLevel] = index;
        setState(() {});
      }
    }
  }

  Widget uiElementsToShowAfterDataLoad(
      Timer? timer, bool stealthValue, CashBalanceReportLoaded state) {
    return Column(
      children: [

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(Sizes.dimen_8.r),
              ),
            ),
            child: CashBalanceHighlightChart(
              isFavorite: widget.argument.isFavorite,
              favorite: widget.argument.favorite,
              cashBalanceSortCubit: widget.argument.cashBalanceSortCubit,
              cashBalanceEntityCubit: widget.argument.cashBalanceEntityCubit,
              universalFilterAsOnDateCubit: widget.argument.universalFilterAsOnDateCubit,
              universalEntityFilterCubit: widget.argument.universalEntityFilterCubit,
              favouriteUniversalFilterAsOnDateCubit: widget.argument.favouriteUniversalFilterAsOnDateCubit,
              cashBalanceLoadingCubit: widget.argument.cashBalanceLoadingCubit,
              cashBalancePrimaryGroupingCubit:
                  widget.argument.cashBalancePrimaryGroupingCubit,
              cashBalancePrimarySubGroupingCubit:
                  widget.argument.cashBalancePrimarySubGroupingCubit,
              cashBalanceAsOnDateCubit: widget.argument.cashBalanceAsOnDateCubit,
              cashBalanceCurrencyCubit: widget.argument.cashBalanceCurrencyCubit,
              cashBalanceDenominationCubit:
                  widget.argument.cashBalanceDenominationCubit,
              cashBalanceNumberOfPeriodCubit:
                  widget.argument.cashBalanceNumberOfPeriodCubit,
              cashBalancePeriodCubit: widget.argument.cashBalancePeriodCubit,
              cashBalanceReportCubit: widget.argument.cashBalanceReportCubit,
              cashBalanceAccountCubit: widget.argument.cashBalanceAccountCubit,
              isSummary: false,
              currentLevel: currentLevel,
              selectChartBarFunc: selectChartBar,
              selectedPosition:
                  currentLevel == 0 ? null : selectedPosition[currentLevel - 1],
              selectedChartBarMonth: selectedChartBarMonth,
            ),
          ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BlocBuilder<CashBalanceSortCubit, Sort>(
                  builder: (context, sortState) {
                    return SortFilter(
                        onSelect: (int index) async {
                          if (index == 1) {
                            context
                                .read<CashBalanceSortCubit>()
                                .tableSortChange(Sort.az.index);
                          } else if (index == 2) {
                            context
                                .read<CashBalanceSortCubit>()
                                .tableSortChange(Sort.za.index);
                          } else if (index == 3) {
                            context
                                .read<CashBalanceSortCubit>()
                                .tableSortChange(Sort.ascending.index);
                          } else if (index == 4) {
                            context
                                .read<CashBalanceSortCubit>()
                                .tableSortChange(Sort.descending.index);
                          }
                        },
                        menu: [
                          PopupMenuItem(
                            key: const Key("descending"),
                            value: 4,
                            child: SizedBox(
                              width: ScreenUtil().screenWidth / 3,
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
                            value: 3,
                            child: SizedBox(
                              width: ScreenUtil().screenWidth / 3,
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
                            value: 1,
                            child: SizedBox(
                              width: ScreenUtil().screenWidth / 3,
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
                            value: 2,
                            child: SizedBox(
                              width: ScreenUtil().screenWidth / 3,
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
              })
            ],
          ),
        ),
        BlocBuilder<CashBalanceNumberOfPeriodCubit,
                CashBalanceNumberOfPeriodState>(
            bloc: widget.argument.cashBalanceNumberOfPeriodCubit,
            builder: (context, numberOfPeriodState) {
              if (selectedChartBarMonth[currentLevel] <
                  (numberOfPeriodState
                          .selectedCashBalanceNumberOfPeriod?.value ??
                      0)) {
                return Flexible(
                  child: SafeArea(
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 0.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: (state.chartData.periodsList?.isNotEmpty ?? false) ? _getDrilldownList(
                        controller: _scrollController,
                        stealthValue: stealthValue,
                        chartData: state.chartData.periodsList?[selectedChartBarMonth[0]]
                      ) : const SizedBox.shrink(),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool stealthValue = context.read<StealthCubit>().state;
    Timer? timer;
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: widget.argument.cashBalanceSortCubit),
        BlocProvider.value(value: widget.argument.cashBalanceEntityCubit),
        BlocProvider.value(
            value: widget.argument.cashBalancePrimaryGroupingCubit),
        BlocProvider.value(
            value: widget.argument.cashBalancePrimarySubGroupingCubit)
      ],
      child: Scaffold(
        drawer: const AVNavigationDrawer(),
        drawerEnableOpenDragGesture: false,
        appBar: AVAppBar(
          title: title.isNotEmpty
              ? title.last
              : widget.argument.isFavorite
              ? (widget.argument.favorite?.reportname ??
              'Cash Balance')
              : 'Cash Balance',
          leading: DrillDownBackArrow(
              onTap: (){
                if (currentLevel != 0) {
                  currentLevel--;
                  title.removeLast();
                  selectedChartBarMonth.removeLast();
                  selectedPosition.removeLast();
                  setState(() {});
                } else {
                  Navigator.of(context).pop();
                }
          })

        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Sizes.dimen_10.w,
          ),
          child: BlocBuilder<CashBalanceReportCubit, CashBalanceReportState>(
              bloc: widget.argument.cashBalanceReportCubit,
              builder: (context, state) {
                if (state is CashBalanceReportLoaded) {
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
                } else if (state is CashBalanceReportError) {
                  if (state.errorType ==
                      AppErrorType.unauthorised) {
                    AppHelpers.logout(context: context);
                  }
                  return Column(
                    children: [
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(Sizes.dimen_8.r),
                          ),
                        ),
                        child: CashBalanceHighlightChart(
                          cashBalanceSortCubit: widget.argument.cashBalanceSortCubit,
                          universalFilterAsOnDateCubit: widget.argument.universalFilterAsOnDateCubit,
                          universalEntityFilterCubit: widget.argument.universalEntityFilterCubit,
                          favouriteUniversalFilterAsOnDateCubit: widget.argument.favouriteUniversalFilterAsOnDateCubit,
                          cashBalanceEntityCubit: widget.argument.cashBalanceEntityCubit,
                          cashBalanceLoadingCubit: widget.argument.cashBalanceLoadingCubit,
                          cashBalancePrimaryGroupingCubit:
                          widget.argument.cashBalancePrimaryGroupingCubit,
                          cashBalancePrimarySubGroupingCubit:
                          widget.argument.cashBalancePrimarySubGroupingCubit,
                          cashBalanceAsOnDateCubit: widget.argument.cashBalanceAsOnDateCubit,
                          cashBalanceCurrencyCubit: widget.argument.cashBalanceCurrencyCubit,
                          cashBalanceDenominationCubit:
                          widget.argument.cashBalanceDenominationCubit,
                          cashBalanceNumberOfPeriodCubit:
                          widget.argument.cashBalanceNumberOfPeriodCubit,
                          cashBalancePeriodCubit: widget.argument.cashBalancePeriodCubit,
                          cashBalanceReportCubit: widget.argument.cashBalanceReportCubit,
                          cashBalanceAccountCubit: widget.argument.cashBalanceAccountCubit,
                          isSummary: false,
                          currentLevel: currentLevel,
                          selectChartBarFunc: selectChartBar,
                          selectedPosition:
                          currentLevel == 0 ? null : selectedPosition[currentLevel - 1],
                          selectedChartBarMonth: selectedChartBarMonth,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_4.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            BlocBuilder<CashBalanceSortCubit, Sort>(
                                builder: (context, sortState) {
                                  return SortFilter(
                                      onSelect: (int index) async {

                                      },
                                      menu: [],
                                      sortName: _getSortName(sortState),
                                      isDissable: true
                                  );
                                })
                          ],
                        ),
                      ),
                      Expanded(
                        child: SafeArea(
                          child: Card(
                              child: _getDrilldownLoadingList()
                          ),
                        ),
                      )
                    ],
                  );
                } else if (state is CashBalanceReportLoading) {
                  return Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(Sizes.dimen_8.r),
                          ),
                        ),
                        child: CashBalanceHighlightChart(
                          cashBalanceSortCubit: widget.argument.cashBalanceSortCubit,
                          cashBalanceEntityCubit: widget.argument.cashBalanceEntityCubit,
                          cashBalanceLoadingCubit: widget.argument.cashBalanceLoadingCubit,
                          universalFilterAsOnDateCubit: widget.argument.universalFilterAsOnDateCubit,
                          universalEntityFilterCubit: widget.argument.universalEntityFilterCubit,
                          favouriteUniversalFilterAsOnDateCubit: widget.argument.favouriteUniversalFilterAsOnDateCubit,
                          cashBalancePrimaryGroupingCubit:
                          widget.argument.cashBalancePrimaryGroupingCubit,
                          cashBalancePrimarySubGroupingCubit:
                          widget.argument.cashBalancePrimarySubGroupingCubit,
                          cashBalanceAsOnDateCubit: widget.argument.cashBalanceAsOnDateCubit,
                          cashBalanceCurrencyCubit: widget.argument.cashBalanceCurrencyCubit,
                          cashBalanceDenominationCubit:
                          widget.argument.cashBalanceDenominationCubit,
                          cashBalanceNumberOfPeriodCubit:
                          widget.argument.cashBalanceNumberOfPeriodCubit,
                          cashBalancePeriodCubit: widget.argument.cashBalancePeriodCubit,
                          cashBalanceReportCubit: widget.argument.cashBalanceReportCubit,
                          cashBalanceAccountCubit: widget.argument.cashBalanceAccountCubit,
                          isSummary: false,
                          currentLevel: currentLevel,
                          selectChartBarFunc: selectChartBar,
                          selectedPosition:
                          currentLevel == 0 ? null : selectedPosition[currentLevel - 1],
                          selectedChartBarMonth: selectedChartBarMonth,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_4.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            BlocBuilder<CashBalanceSortCubit, Sort>(
                                builder: (context, sortState) {
                                  return SortFilter(
                                      onSelect: (int index) async {

                                      },
                                      menu: [],
                                      sortName: _getSortName(sortState),
                                      isDissable: true
                                  );
                                })
                          ],
                        ),
                      ),
                      Expanded(
                        child: SafeArea(
                          child: Card(
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
                      child: CashBalanceHighlightChart(
                        cashBalanceSortCubit: widget.argument.cashBalanceSortCubit,
                        cashBalanceEntityCubit: widget.argument.cashBalanceEntityCubit,
                        cashBalanceLoadingCubit: widget.argument.cashBalanceLoadingCubit,
                        universalFilterAsOnDateCubit: widget.argument.universalFilterAsOnDateCubit,
                        universalEntityFilterCubit: widget.argument.universalEntityFilterCubit,
                        favouriteUniversalFilterAsOnDateCubit: widget.argument.favouriteUniversalFilterAsOnDateCubit,
                        cashBalancePrimaryGroupingCubit:
                        widget.argument.cashBalancePrimaryGroupingCubit,
                        cashBalancePrimarySubGroupingCubit:
                        widget.argument.cashBalancePrimarySubGroupingCubit,
                        cashBalanceAsOnDateCubit: widget.argument.cashBalanceAsOnDateCubit,
                        cashBalanceCurrencyCubit: widget.argument.cashBalanceCurrencyCubit,
                        cashBalanceDenominationCubit:
                        widget.argument.cashBalanceDenominationCubit,
                        cashBalanceNumberOfPeriodCubit:
                        widget.argument.cashBalanceNumberOfPeriodCubit,
                        cashBalancePeriodCubit: widget.argument.cashBalancePeriodCubit,
                        cashBalanceReportCubit: widget.argument.cashBalanceReportCubit,
                        cashBalanceAccountCubit: widget.argument.cashBalanceAccountCubit,
                        isSummary: false,
                        currentLevel: currentLevel,
                        selectChartBarFunc: selectChartBar,
                        selectedPosition:
                        currentLevel == 0 ? null : selectedPosition[currentLevel - 1],
                        selectedChartBarMonth: selectedChartBarMonth,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_4.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          BlocBuilder<CashBalanceSortCubit, Sort>(
                              builder: (context, sortState) {
                                return SortFilter(
                                    onSelect: (int index) async {

                                    },
                                    menu: [],
                                    sortName: _getSortName(sortState),
                                    isDissable: true
                                );
                              })
                        ],
                      ),
                    ),
                    Expanded(
                      child: SafeArea(
                        child: Card(
                            child: _getDrilldownLoadingList()
                        ),
                      ),
                    )
                  ],
                );
              }),
        ),
      ),
    );
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

  Widget _getDrilldownList({
    required ScrollController controller,
    required bool stealthValue,
    required CBPeriodEntity? chartData,
  }) {
    return BlocBuilder<CashBalanceDenominationCubit,
            CashBalanceDenominationState>(
        bloc: widget.argument.cashBalanceDenominationCubit,
        builder: (context, denominationState) {
          return BlocBuilder<CashBalanceCurrencyCubit,
                  CashBalanceCurrencyState>(
              bloc: widget.argument.cashBalanceCurrencyCubit,
              builder: (context, currencyState) {

                if (currentLevel == 0) {
                  print("Returning primary grouping list view");
                  return _getPrimaryGroupingListView(
                      controller: _scrollController,
                      primarySubgroup: chartData?.primarySubgroup,
                      stealthValue: stealthValue
                  );
                } else {
                  print("Returning account list view");
                  return _getAccountListView(
                      controller: _scrollController,
                      accountList: selectedPrimaryGrping?.accounts,
                      stealthValue: stealthValue
                  );
                }
              });
        });
  }

  Widget _getPrimaryGroupingListView({required ScrollController controller, List<PrimarySubgroupEntity>? primarySubgroup, required bool stealthValue}) {
    return BlocBuilder<CashBalanceDenominationCubit,
        CashBalanceDenominationState>(
        bloc: widget.argument.cashBalanceDenominationCubit,
        builder: (context, denominationState) {
        return BlocBuilder<CashBalanceSortCubit, Sort>(
            builder: (context, sortState) {
              if (sortState == Sort.az) {
                primarySubgroup?.sort((a, b) {
                  return (a.title ?? '')
                      .toLowerCase()
                      .compareTo((b.title ?? '').toLowerCase() ?? '');
                });
              } else if (sortState == Sort.za) {
                primarySubgroup?.sort((a, b) {
                  return (b.title ?? '').toLowerCase()
                      .compareTo((a.title ?? '').toLowerCase() ?? '');
                });
              } else if (sortState == Sort.ascending) {
                primarySubgroup?.sort((a, b) {
                  return (a.total ?? 0).compareTo((b.total ?? 0));
                });
              } else {
                primarySubgroup?.sort((a, b) {
                  return (b.total ?? 0).compareTo((a.total ?? 0));
                });
              }
              return ListView.builder(
                controller: controller,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: primarySubgroup?.length,
                itemBuilder: (context, index) {
                  final item = primarySubgroup?[index];
                  return ChildOfPrimaryGroupingItemWithTooltip(
                    shouldShowLine: index != (primarySubgroup?.length ?? 0) - 1,
                      cashBalanceEntityCubit:
                      widget.argument.cashBalanceEntityCubit,
                      cashBalanceCurrencyCubit:
                      widget.argument.cashBalanceCurrencyCubit,
                      item: item,
                      currentLevel: currentLevel,
                      denominationState: denominationState,
                      stealthValue: stealthValue,
                      onDone: () {
                        setState(() {
                          title.add(item?.title ?? '');
                          selectedPosition.add(item?.title ?? "");
                          selectedPrimaryGrping = item;
                          selectedChartBarMonth
                              .add(selectedChartBarMonth[currentLevel]);
                          currentLevel++;
                        });
                      });
                },
              );
            });
      }
    );
  }

  Widget _getAccountListView({required ScrollController controller, List<AccountEntity>? accountList, required bool stealthValue}) {
    return BlocBuilder<CashBalanceDenominationCubit,
        CashBalanceDenominationState>(
        bloc: widget.argument.cashBalanceDenominationCubit,
        builder: (context, denominationState) {
          return BlocBuilder<CashBalanceSortCubit, Sort>(
              builder: (context, sortState) {
                if (sortState == Sort.az) {
                  accountList?.sort((a, b) {
                    return (a.accountName ?? '')
                        .toLowerCase()
                        .compareTo((b.accountName ?? '').toLowerCase() ?? '');
                  });
                } else if (sortState == Sort.za) {
                  accountList?.sort((a, b) {
                    return (b.accountName ?? '').toLowerCase()
                        .compareTo((a.accountName ?? '').toLowerCase() ?? '');
                  });
                } else if (sortState == Sort.ascending) {
                  accountList?.sort((a, b) {
                    return (a.amount ?? 0).compareTo((b.amount ?? 0));
                  });
                } else {
                  accountList?.sort((a, b) {
                    return (b.amount ?? 0).compareTo((a.amount ?? 0));
                  });
                }
                return ListView.builder(
                  controller: controller,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: accountList?.length,
                  itemBuilder: (context, index) {
                    final item = accountList?[index];
                    return ChildOfAccountItemWithTooltip(
                      shouldShowLine: index != (accountList?.length ?? 0) - 1,
                        cashBalanceEntityCubit:
                        widget.argument.cashBalanceEntityCubit,
                        cashBalanceCurrencyCubit:
                        widget.argument.cashBalanceCurrencyCubit,
                        item: item,
                        currentLevel: currentLevel,
                        denominationState: denominationState,
                        stealthValue: stealthValue,
                        onDone: () {
                        });
                  },
                );
              });
        }
    );
  }
}

class ChildOfPrimaryGroupingItemWithTooltip extends StatefulWidget {
  final bool stealthValue;
  final PrimarySubgroupEntity? item;
  final CashBalanceCurrencyCubit cashBalanceCurrencyCubit;
  final CashBalanceEntityCubit cashBalanceEntityCubit;
  final CashBalanceDenominationState denominationState;
  final bool shouldShowLine;
  final int currentLevel;
  final void Function() onDone;
  const ChildOfPrimaryGroupingItemWithTooltip({
    super.key,
    required this.shouldShowLine,
    required this.cashBalanceCurrencyCubit,
    required this.item,
    required this.denominationState,
    required this.stealthValue,
    required this.onDone,
    required this.cashBalanceEntityCubit,
    required this.currentLevel,
  });

  @override
  State<ChildOfPrimaryGroupingItemWithTooltip> createState() => _ChildItemWithTooltipState();
}

class _ChildItemWithTooltipState extends State<ChildOfPrimaryGroupingItemWithTooltip> {
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
      content: Container(
        margin: EdgeInsets.symmetric(
          horizontal: Sizes.dimen_12.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.item?.title ?? '',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.lightGrey.withOpacity(0.6)),
                  ),
                ),
                UIHelper.horizontalSpace(Sizes.dimen_2.h),
                Flexible(
                  child: Text(
                    (widget.item?.total ?? 0) < 0
                        ? "${NumberFormat.simpleCurrency(name: widget.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency?.code).currencySymbol} (${NumberFormat(widget.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency?.format ?? '###,###,##0.00').format(widget.item?.total.denominate(denominator: widget.denominationState.selectedCashBalanceDenomination?.denomination))}${widget.denominationState.selectedCashBalanceDenomination?.suffix})"
                            .stealth(widget.stealthValue)
                        : "${NumberFormat.simpleCurrency(name: widget.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency?.code).currencySymbol} ${NumberFormat(widget.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency?.format ?? '###,###,##0.00').format(widget.item?.total.denominate(denominator: widget.denominationState.selectedCashBalanceDenomination?.denomination))}${widget.denominationState.selectedCashBalanceDenomination?.suffix}"
                            .stealth(widget.stealthValue),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: widget.stealthValue
                            ? null
                            : (widget.item?.total ?? 0) >= 0.0
                                ? null
                                : AppColor.red),
                  ),
                )
              ],
            ),
            BlocBuilder<CashBalanceEntityCubit, CashBalanceEntityState>(
                bloc: widget.cashBalanceEntityCubit,
                builder: (context, entityState) {
                  return Text("${(((widget.item?.entityName?.isEmpty ?? true) ? null : widget.item?.entityName) ?? entityState.selectedCashBalanceEntity?.name)?.stealth(widget.stealthValue)}",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: Sizes.dimen_14,
                        fontWeight: FontWeight.bold,
                        color: AppColor.lightGrey.withOpacity(0.7)),
                  );
                })
          ],
        ),
      ),
      showBarrier: true,
      popupDirection: TooltipDirection.up,
      child: GestureDetector(
        onTap: () {
            widget.onDone();
        },
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: Sizes.dimen_18.w,
          ),
          decoration: BoxDecoration(
              border: widget.shouldShowLine ? Border(
                  bottom: BorderSide(color: AppColor.grey.withOpacity(0.7))) : null),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: Sizes.dimen_5.h, bottom: Sizes.dimen_3.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item?.title ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColor.lightGrey.withOpacity(0.6)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      UIHelper.verticalSpace(Sizes.dimen_2.h),
                      BlocBuilder<CashBalanceEntityCubit,
                              CashBalanceEntityState>(
                          bloc: widget.cashBalanceEntityCubit,
                          builder: (context, entityState) {
                            return Text("${(((widget.item?.entityName?.isEmpty ?? true) ? null : widget.item?.entityName) ?? entityState.selectedCashBalanceEntity?.name)?.stealth(widget.stealthValue)}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: Sizes.dimen_14,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          AppColor.lightGrey.withOpacity(0.7)),
                            );
                          })
                    ],
                  ),
                ),
              ),
              UIHelper.horizontalSpaceSmall,
              Flexible(
                child: Text(
                  (widget.item?.total ?? 0) < 0
                      ? "${NumberFormat.simpleCurrency(name: widget.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency?.code).currencySymbol} (${NumberFormat(widget.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency?.format ?? '###,###,##0.00').format(widget.item?.total.denominate(denominator: widget.denominationState.selectedCashBalanceDenomination?.denomination))}${widget.denominationState.selectedCashBalanceDenomination?.suffix})"
                          .stealth(widget.stealthValue)
                      : "${NumberFormat.simpleCurrency(name: widget.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency?.code).currencySymbol} ${NumberFormat(widget.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency?.format ?? '###,###,##0.00').format(widget.item?.total.denominate(denominator: widget.denominationState.selectedCashBalanceDenomination?.denomination))}${widget.denominationState.selectedCashBalanceDenomination?.suffix}"
                          .stealth(widget.stealthValue),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                      color: widget.stealthValue
                          ? null
                          : (widget.item?.total ?? 0) >= 0.0
                              ? null
                              : AppColor.red),
                ),
              ),
              UIHelper.horizontalSpaceSmall,
              if (widget.item?.accounts != null &&
                  (widget.item?.accounts!.isNotEmpty ?? false) &&
                  widget.currentLevel == 0)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: Sizes.dimen_14.w,
                    color: AppColor.grey,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChildOfAccountItemWithTooltip extends StatefulWidget {
  final bool stealthValue;
  final AccountEntity? item;
  final CashBalanceCurrencyCubit cashBalanceCurrencyCubit;
  final CashBalanceEntityCubit cashBalanceEntityCubit;
  final CashBalanceDenominationState denominationState;
  final bool shouldShowLine;
  final int currentLevel;
  final void Function() onDone;
  const ChildOfAccountItemWithTooltip({
    super.key,
    required this.cashBalanceCurrencyCubit,
    required this.item,
    required this.denominationState,
    required this.stealthValue,
    required this.onDone,
    required this.cashBalanceEntityCubit,
    required this.currentLevel,
    required this.shouldShowLine,
  });

  @override
  State<ChildOfAccountItemWithTooltip> createState() => _ChildAccountItemWithTooltipState();
}

class _ChildAccountItemWithTooltipState extends State<ChildOfAccountItemWithTooltip> {
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
      content: Container(
        margin: EdgeInsets.symmetric(
          horizontal: Sizes.dimen_12.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.item?.accountName ?? '',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.lightGrey.withOpacity(0.6)),
                  ),
                ),
                UIHelper.horizontalSpace(Sizes.dimen_2.h),
                Flexible(
                  child: Text(
                    (widget.item?.amount ?? 0) < 0
                        ? "${NumberFormat.simpleCurrency(name: widget.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency?.code).currencySymbol} (${NumberFormat(widget.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency?.format ?? '###,###,##0.00').format(widget.item?.amount.denominate(denominator: widget.denominationState.selectedCashBalanceDenomination?.denomination))}${widget.denominationState.selectedCashBalanceDenomination?.suffix})"
                        .stealth(widget.stealthValue)
                        : "${NumberFormat.simpleCurrency(name: widget.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency?.code).currencySymbol} ${NumberFormat(widget.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency?.format ?? '###,###,##0.00').format(widget.item?.amount.denominate(denominator: widget.denominationState.selectedCashBalanceDenomination?.denomination))}${widget.denominationState.selectedCashBalanceDenomination?.suffix}"
                        .stealth(widget.stealthValue),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: widget.stealthValue
                            ? null
                            : (widget.item?.amount ?? 0) >= 0.0
                            ? null
                            : AppColor.red),
                  ),
                )
              ],
            ),
            BlocBuilder<CashBalanceEntityCubit, CashBalanceEntityState>(
                bloc: widget.cashBalanceEntityCubit,
                builder: (context, entityState) {
                  return Text("${(((widget.item?.entityName?.isEmpty ?? true) ? null : widget.item?.entityName) ?? entityState.selectedCashBalanceEntity?.name)?.stealth(widget.stealthValue)}",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: Sizes.dimen_14,
                        fontWeight: FontWeight.bold,
                        color: AppColor.lightGrey.withOpacity(0.7)),
                  );
                })
          ],
        ),
      ),
      showBarrier: true,
      popupDirection: TooltipDirection.up,
      child: GestureDetector(
        onTap: () {

        },
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: Sizes.dimen_18.w,
          ),
          decoration: BoxDecoration(
              border: widget.shouldShowLine ? Border(
                  bottom: BorderSide(color: AppColor.grey.withOpacity(0.7))) : null),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: Sizes.dimen_5.h, bottom: Sizes.dimen_3.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item?.accountName ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColor.lightGrey.withOpacity(0.6)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      UIHelper.verticalSpace(Sizes.dimen_2.h),
                      BlocBuilder<CashBalanceEntityCubit,
                          CashBalanceEntityState>(
                          bloc: widget.cashBalanceEntityCubit,
                          builder: (context, entityState) {
                            return Text("${(((widget.item?.entityName?.isEmpty ?? true) ? null : widget.item?.entityName) ?? entityState.selectedCashBalanceEntity?.name)?.stealth(widget.stealthValue)}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: Sizes.dimen_14,
                                  fontWeight: FontWeight.bold,
                                  color:
                                  AppColor.lightGrey.withOpacity(0.7)),
                            );
                          })
                    ],
                  ),
                ),
              ),
              UIHelper.horizontalSpaceSmall,
              Flexible(
                child: Text(
                  (widget.item?.amount ?? 0) < 0
                      ? "${NumberFormat.simpleCurrency(name: widget.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency?.code).currencySymbol} (${NumberFormat(widget.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency?.format ?? '###,###,##0.00').format(widget.item?.amount.denominate(denominator: widget.denominationState.selectedCashBalanceDenomination?.denomination))}${widget.denominationState.selectedCashBalanceDenomination?.suffix})"
                      .stealth(widget.stealthValue)
                      : "${NumberFormat.simpleCurrency(name: widget.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency?.code).currencySymbol} ${NumberFormat(widget.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency?.format ?? '###,###,##0.00').format(widget.item?.amount.denominate(denominator: widget.denominationState.selectedCashBalanceDenomination?.denomination))}${widget.denominationState.selectedCashBalanceDenomination?.suffix}"
                      .stealth(widget.stealthValue),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                      color: widget.stealthValue
                          ? null
                          : (widget.item?.amount ?? 0) >= 0.0
                          ? null
                          : AppColor.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
