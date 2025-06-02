import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:asset_vantage/src/config/extensions/num_extensions.dart';
import 'package:asset_vantage/src/config/extensions/string_extensions.dart';
import 'package:asset_vantage/src/domain/entities/income/income_chart_data.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_chart/income_chart_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_currency/income_currency_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_denomination/income_denomination_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_number_of_period/income_number_of_period_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_report/income_report_cubit.dart';
import 'package:asset_vantage/src/presentation/screens/income_report/income_universal_filter.dart';
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
import '../../../domain/entities/income/income_report_entity.dart';
import '../../../utilities/helper/app_helper.dart';
import '../../../utilities/helper/flash_helper.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../arguments/income_report_argument.dart';
import '../../blocs/authentication/user/user_cubit.dart';
import '../../blocs/currency_filter/currency_filter_cubit.dart';
import '../../blocs/favorites/favorites_cubit.dart';
import '../../blocs/income/income_as_on_date/income_as_on_date_cubit.dart';
import '../../blocs/income/income_entity/income_entity_cubit.dart';
import '../../blocs/income/income_sort_cubit/income_sort_cubit.dart';
import '../../blocs/stealth/stealth_cubit.dart';
import '../../theme/theme_color.dart';
import '../../widgets/av_app_bar.dart';
import '../../widgets/loading_widgets/loading_bg.dart';
import '../../widgets/size_tween_hero.dart';
import '../dashboard/highlights/income_highlight_widget.dart';
import '../navigation_drawer/NavigationDrawer.dart';
import '../../widgets/favorite_icon.dart';

class IncomeReportScreen extends StatefulWidget {
  final IncomeReportArgument argument;
  const IncomeReportScreen({super.key, required this.argument});

  @override
  State<IncomeReportScreen> createState() => _IncomeReportScreenState();
}

class _IncomeReportScreenState extends State<IncomeReportScreen> {
  late final SuperTooltipController _tooltipController =
      SuperTooltipController();
  int currentLevel = 0;
  List<String> title = [];
  List<int> selectedChartBarMonth = [0];
  List<String> selectedPosition = [];
  late final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _tooltipController.dispose();
    super.dispose();
  }


  void selectChartBar(int index) {
    selectedChartBarMonth[currentLevel] = index;
    setState(() {});
  }

  List<Child>? getPositionData({required List<IncomeChartData> chartData}) {
    if (currentLevel == 0) {
      return chartData[chartData.length > selectedChartBarMonth[currentLevel] ? selectedChartBarMonth[currentLevel] : chartData.length - 1].children;
    } else if (currentLevel == 1) {

      final data = chartData.map(
        (e) {
          final item = e.children.where(
            (element) {
              return element.accountName == selectedPosition[currentLevel - 1];
            },
          ).toList();
          print("Selected Position: ${selectedPosition[currentLevel - 1]}");
          print("Available Children: ${e.children.map((c) => c.accountName).toList()}");
          if (item.isNotEmpty) {
            return item.first;
          } else {
            return Child(
              date: e.date,
              accounts: [],
              accNumber: "",
              accountId: 0,
              accountName: "",
              currencyData: "",
              percentage: 0,
              total: 0,
            );
          }
        },
      ).toList();

      return data[selectedChartBarMonth[currentLevel]].accounts;
    }
    return [];
  }

  Widget uiElementsToShowAfterDataLoad(
      Timer? timer, bool stealthValue, IncomeReportLoaded state) {
    return BlocBuilder<IncomeNumberOfPeriodCubit, IncomeNumberOfPeriodState>(
        bloc: widget.argument.incomeNumberOfPeriodCubit,
      builder: (context, numberOfPeriodState) {
        if(state.chartData.isNotEmpty) {
          List<IncomeChartData> incomeChartData = state.chartData;

          // if (currentLevel == 0) {
          //   incomeChartData = state.chartData.sublist(
          //       state.chartData.length -
          //           (numberOfPeriodState
          //               .selectedIncomeNumberOfPeriod
          //               ?.value ??
          //               0),
          //       state.chartData.length);
          //
          // } else {
          //   incomeChartData = (state.chartData
          //       .map(
          //         (e) {
          //       final item = e.children.where(
          //             (element) {
          //           return element.accountName ==
          //               selectedPosition;
          //         },
          //       ).toList();
          //
          //       if (item.isNotEmpty) {
          //         return item.first;
          //       } else {
          //         return item.first;
          //       }
          //     },
          //   )
          //       .toList() as List<IncomeChartData>)
          //       .sublist(
          //       state.chartData.length -
          //           (numberOfPeriodState
          //               .selectedIncomeNumberOfPeriod
          //               ?.value ??
          //               0),
          //       state.chartData.length);
          // }

          final List<Child> positions = getPositionData(chartData: incomeChartData) ?? [];
          return Column(
            children: [

              SizedBox(),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(Sizes.dimen_8.r),
                  ),
                ),
                child: IncomeHighlightWidget(
                  isDetailScreen: true,
                  isFavorite: widget.argument.isFavorite,
                  favorite: widget.argument.favorite,
                  incomeLoadingCubit: widget.argument.incomeLoadingCubit,
                  incomeReportCubit: widget.argument.incomeReportCubit,
                  universalFilterAsOnDateCubit: widget.argument.universalFilterAsOnDateCubit,
                  universalEntityFilterCubit: widget.argument.universalEntityFilterCubit,
                  favouriteUniversalFilterAsOnDateCubit: widget.argument.favouriteUniversalFilterAsOnDateCubit,
                  incomeSortCubit: widget.argument.incomeSortCubit,
                  incomeEntityCubit: widget.argument.incomeEntityCubit,
                  incomeAsOnDateCubit: widget.argument.incomeAsOnDateCubit,
                  incomeAccountCubit: widget.argument.incomeAccountCubit,
                  incomePeriodCubit: widget.argument.incomePeriodCubit,
                  incomeNumberOfPeriodCubit:
                  widget.argument.incomeNumberOfPeriodCubit,
                  incomeChartCubit: widget.argument.incomeChartCubit,
                  incomeCurrencyCubit: widget.argument.incomeCurrencyCubit,
                  incomeDenominationCubit: widget.argument.incomeDenominationCubit,
                  currentLevel: currentLevel,
                  selectChartBarFunc: selectChartBar,
                  selectedPosition:
                  currentLevel == 0 ? null : selectedPosition[currentLevel - 1],
                  selectedChartBarMonth: selectedChartBarMonth,
                ),
              ),
              if(positions.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_4.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BlocBuilder<IncomeSortCubit, Sort>(
                          bloc: widget.argument.incomeSortCubit,
                          builder: (context, sortState) {
                            return SortFilter(
                                onSelect: (int index) async {
                                  if (index == 1) {
                                    widget.argument.incomeSortCubit
                                        .tableSortChange(Sort.az.index);
                                  } else if (index == 2) {
                                    widget.argument.incomeSortCubit
                                        .tableSortChange(Sort.za.index);
                                  } else if (index == 3) {
                                    widget.argument.incomeSortCubit
                                        .tableSortChange(Sort.ascending.index);
                                  } else if (index == 4) {
                                    widget.argument.incomeSortCubit
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
                          })
                    ],
                  ),
                ),
              BlocBuilder<IncomeChartCubit, int>(
                  bloc: widget.argument.incomeChartCubit,
                  builder: (context, incomeChartState) {

                    if (selectedChartBarMonth[currentLevel] <
                        (numberOfPeriodState
                            .selectedIncomeNumberOfPeriod?.value ??
                            0)) {
                      if (MediaQuery.of(context).textScaler.textScaleFactor >
                          1.6) {
                        return positions.isNotEmpty ? SizedBox(
                          height: ScreenUtil().screenHeight * 0.45,
                          child: Card(
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: _getDrilldownList(
                                controller: _scrollController,
                                positions: positions,
                                stealthValue: stealthValue),
                          ),
                        ) : Container(
                          height: ScreenUtil().screenHeight * 0.30,
                          child: Center(
                            child: Text("No data to display for this period", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),),
                          ),
                        );
                      } else {
                        return positions.isNotEmpty ? Flexible(
                          child: Card(
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: _getDrilldownList(
                                controller: _scrollController,
                                positions: positions,
                                stealthValue: stealthValue),
                          ),
                        ) : Container(
                          height: ScreenUtil().screenHeight * 0.30,
                          child: Center(
                            child: Text("No data to display for this period", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),),
                          ),
                        );
                      }
                    }
                    return const SizedBox.shrink();
                  })
            ],
          );
        }else {
          return const SizedBox.shrink();
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    bool stealthValue = context.read<StealthCubit>().state;
    Timer? timer;
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      drawer: const AVNavigationDrawer(),
      appBar: AVAppBar(
        title: title.isNotEmpty
            ? title.last
            : widget.argument.isFavorite
            ? (widget.argument.favorite?.reportname ??
            'Income')
            : 'Income',
        leading: DrillDownBackArrow(onTap: () {
          if (currentLevel != 0) {
            currentLevel--;
            title.removeLast();
            selectedChartBarMonth.removeLast();
            selectedPosition.removeLast();
            setState(() {});
          } else {
            Navigator.of(context).pop();
          }
        },)
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_12.w),
        child: BlocBuilder<IncomeReportCubit, IncomeReportState>(
            bloc: widget.argument.incomeReportCubit,
            builder: (context, state) {
              if (state is IncomeReportLoaded) {
                if(state.chartData.isNotEmpty) {
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
                }else {
                  return Column(
                    children: [
                      Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(Sizes.dimen_8.r),
                            ),
                          ),
                          child: IncomeHighlightWidget(
                            isDetailScreen: true,
                            incomeLoadingCubit: widget.argument.incomeLoadingCubit,
                            incomeReportCubit: widget.argument.incomeReportCubit,
                            universalFilterAsOnDateCubit: widget.argument.universalFilterAsOnDateCubit,
                            universalEntityFilterCubit: widget.argument.universalEntityFilterCubit,
                            favouriteUniversalFilterAsOnDateCubit: widget.argument.favouriteUniversalFilterAsOnDateCubit,
                            incomeSortCubit: widget.argument.incomeSortCubit,
                            incomeEntityCubit: widget.argument.incomeEntityCubit,
                            incomeAsOnDateCubit: widget.argument.incomeAsOnDateCubit,
                            incomeAccountCubit: widget.argument.incomeAccountCubit,
                            incomePeriodCubit: widget.argument.incomePeriodCubit,
                            incomeNumberOfPeriodCubit:
                            widget.argument.incomeNumberOfPeriodCubit,
                            incomeChartCubit: widget.argument.incomeChartCubit,
                            incomeCurrencyCubit: widget.argument.incomeCurrencyCubit,
                            incomeDenominationCubit: widget.argument.incomeDenominationCubit,
                            currentLevel: currentLevel,
                            selectChartBarFunc: selectChartBar,
                            selectedPosition:
                            currentLevel == 0 ? null : selectedPosition[currentLevel - 1],
                            selectedChartBarMonth: selectedChartBarMonth,
                          )
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_4.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            BlocBuilder<IncomeSortCubit, Sort>(
                                bloc: widget.argument.incomeSortCubit,
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
              } else if (state is IncomeReportLoading) {
                return Column(
                  children: [
                    Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(Sizes.dimen_8.r),
                          ),
                        ),
                        child: IncomeHighlightWidget(
                          isDetailScreen: true,
                          incomeLoadingCubit: widget.argument.incomeLoadingCubit,
                          incomeReportCubit: widget.argument.incomeReportCubit,
                          universalFilterAsOnDateCubit: widget.argument.universalFilterAsOnDateCubit,
                          universalEntityFilterCubit: widget.argument.universalEntityFilterCubit,
                          favouriteUniversalFilterAsOnDateCubit: widget.argument.favouriteUniversalFilterAsOnDateCubit,
                          incomeSortCubit: widget.argument.incomeSortCubit,
                          incomeEntityCubit: widget.argument.incomeEntityCubit,
                          incomeAsOnDateCubit: widget.argument.incomeAsOnDateCubit,
                          incomeAccountCubit: widget.argument.incomeAccountCubit,
                          incomePeriodCubit: widget.argument.incomePeriodCubit,
                          incomeNumberOfPeriodCubit:
                          widget.argument.incomeNumberOfPeriodCubit,
                          incomeChartCubit: widget.argument.incomeChartCubit,
                          incomeCurrencyCubit: widget.argument.incomeCurrencyCubit,
                          incomeDenominationCubit: widget.argument.incomeDenominationCubit,
                          currentLevel: currentLevel,
                          selectChartBarFunc: selectChartBar,
                          selectedPosition:
                          currentLevel == 0 ? null : selectedPosition[currentLevel - 1],
                          selectedChartBarMonth: selectedChartBarMonth,
                        )
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_4.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          BlocBuilder<IncomeSortCubit, Sort>(
                              bloc: widget.argument.incomeSortCubit,
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
              } else if (state is IncomeReportError) {
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
                        child: IncomeHighlightWidget(
                          isDetailScreen: true,
                          incomeLoadingCubit: widget.argument.incomeLoadingCubit,
                          incomeReportCubit: widget.argument.incomeReportCubit,
                          universalFilterAsOnDateCubit: widget.argument.universalFilterAsOnDateCubit,
                          universalEntityFilterCubit: widget.argument.universalEntityFilterCubit,
                          favouriteUniversalFilterAsOnDateCubit: widget.argument.favouriteUniversalFilterAsOnDateCubit,
                          incomeSortCubit: widget.argument.incomeSortCubit,
                          incomeEntityCubit: widget.argument.incomeEntityCubit,
                          incomeAsOnDateCubit: widget.argument.incomeAsOnDateCubit,
                          incomeAccountCubit: widget.argument.incomeAccountCubit,
                          incomePeriodCubit: widget.argument.incomePeriodCubit,
                          incomeNumberOfPeriodCubit:
                          widget.argument.incomeNumberOfPeriodCubit,
                          incomeChartCubit: widget.argument.incomeChartCubit,
                          incomeCurrencyCubit: widget.argument.incomeCurrencyCubit,
                          incomeDenominationCubit: widget.argument.incomeDenominationCubit,
                          currentLevel: currentLevel,
                          selectChartBarFunc: selectChartBar,
                          selectedPosition:
                          currentLevel == 0 ? null : selectedPosition[currentLevel - 1],
                          selectedChartBarMonth: selectedChartBarMonth,
                        )
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_4.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          BlocBuilder<IncomeSortCubit, Sort>(
                              bloc: widget.argument.incomeSortCubit,
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
                      child: IncomeHighlightWidget(
                        isDetailScreen: true,
                        incomeLoadingCubit: widget.argument.incomeLoadingCubit,
                        incomeReportCubit: widget.argument.incomeReportCubit,
                        incomeSortCubit: widget.argument.incomeSortCubit,
                        incomeEntityCubit: widget.argument.incomeEntityCubit,
                        incomeAsOnDateCubit: widget.argument.incomeAsOnDateCubit,
                        incomeAccountCubit: widget.argument.incomeAccountCubit,
                        incomePeriodCubit: widget.argument.incomePeriodCubit,
                        universalFilterAsOnDateCubit: widget.argument.universalFilterAsOnDateCubit,
                        universalEntityFilterCubit: widget.argument.universalEntityFilterCubit,
                        favouriteUniversalFilterAsOnDateCubit: widget.argument.favouriteUniversalFilterAsOnDateCubit,
                        incomeNumberOfPeriodCubit:
                        widget.argument.incomeNumberOfPeriodCubit,
                        incomeChartCubit: widget.argument.incomeChartCubit,
                        incomeCurrencyCubit: widget.argument.incomeCurrencyCubit,
                        incomeDenominationCubit: widget.argument.incomeDenominationCubit,
                        currentLevel: currentLevel,
                        selectChartBarFunc: selectChartBar,
                        selectedPosition:
                        currentLevel == 0 ? null : selectedPosition[currentLevel - 1],
                        selectedChartBarMonth: selectedChartBarMonth,
                      )
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_4.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        BlocBuilder<IncomeSortCubit, Sort>(
                            bloc: widget.argument.incomeSortCubit,
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
    );
  }

  Widget _getDrilldownList(
      {required ScrollController controller,
      required List<Child>? positions,
      required bool stealthValue}) {
    return BlocBuilder<IncomeSortCubit, Sort>(
        bloc: widget.argument.incomeSortCubit,
        builder: (context, sortState) {
          return ListView.builder(
            controller: controller,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: positions?.length,
            itemBuilder: (context, index) {
              if (sortState == Sort.ascending) {
                positions?.sort((a, b) => a.total.compareTo(b.total));
              } else if (sortState == Sort.descending) {
                positions?.sort((a, b) => b.total.compareTo(a.total));
              } else if (sortState == Sort.az) {
                positions
                    ?.sort((a, b) => (a.accountName).compareTo(b.accountName));
              } else if (sortState == Sort.za) {
                positions
                    ?.sort((a, b) => (b.accountName).compareTo(a.accountName));
              }
              final greaterValue = AppHelpers.getIncomeChildrenGreaterValue(
                  incomeList: positions ?? []);
              final item = positions?[index];
              return ChildItemWithTooltip(
                shouldShowLine: index != (positions?.length ?? 0) - 1,
                  greaterValue: greaterValue,
                  stealthValue: stealthValue,
                  argument: widget.argument,
                  currentLevel: currentLevel,
                  onDone: () {
                    setState(() {
                      title.add(item?.accountName ?? '');
                      selectedPosition.add(item?.accountName ?? "");
                      selectedChartBarMonth
                          .add(selectedChartBarMonth[currentLevel]);
                      currentLevel++;
                    });
                  },
                  item: item);
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

class ChildItemWithTooltip extends StatefulWidget {
  final bool stealthValue;
  final IncomeReportArgument argument;
  final Child? item;
  final int greaterValue;
  final int currentLevel;
  final void Function() onDone;
  final bool shouldShowLine;
  const ChildItemWithTooltip({
    super.key,
    required this.stealthValue,
    required this.argument,
    required this.item,
    required this.greaterValue,
    required this.onDone,
    required this.currentLevel,
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
    return BlocBuilder<IncomeDenominationCubit, IncomeDenominationState>(
        bloc: widget.argument.incomeDenominationCubit,
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
              content: Container(
                margin: EdgeInsets.symmetric(horizontal: Sizes.dimen_12.w),
                padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.item?.accountName}${widget.item?.accNumber != null && widget.item?.accNumber != "--" ? '(${widget.item?.accNumber.stealth(widget.stealthValue)})' : ""}",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColor.lightGrey
                              .withOpacity(0.6)),
                    ),
                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: AnimatedFractionallySizedBox(
                            duration: const Duration(milliseconds: 500),
                            alignment: Alignment.centerLeft,
                            widthFactor: AppHelpers.getIncomeChartFraction(
                                actualValue: widget.item?.total ?? 0.00,
                                greaterValue: widget.greaterValue.toDouble()),
                            child: Container(
                              height: Sizes.dimen_6.h,
                              decoration: const BoxDecoration(
                                  color: AppColor.violet,
                              ),
                            ),
                          ),
                        ),
                        UIHelper.horizontalSpaceSmall,
                        Text(
                          "${NumberFormat.simpleCurrency(name: widget.argument.incomeCurrencyCubit.state.selectedIncomeCurrency?.code ?? 'USD').currencySymbol} ${"${(widget.item?.total ?? 0.00) < 0.0 ? '(${NumberFormat(widget.argument.incomeCurrencyCubit.state.selectedIncomeCurrency?.format ?? '###,###,##0.00').format((widget.item?.total ?? 0.00).abs().denominate(denominator: denominationState.selectedIncomeDenomination?.denomination))})' : NumberFormat(widget.argument.incomeCurrencyCubit.state.selectedIncomeCurrency?.format ?? '###,###,##0.00').format((widget.item?.total ?? 0.00).denominate(denominator: denominationState.selectedIncomeDenomination?.denomination))}${denominationState.selectedIncomeDenomination?.suffix}".stealth(widget.stealthValue)}",
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontSize: Sizes.dimen_14,
                                  fontWeight: FontWeight.bold,
                                  color: widget.stealthValue
                                      ? null
                                      : (widget.item?.total ?? 0.00) >= 0.0
                                          ? null
                                          : AppColor.red),
                        )
                      ],
                    )
                  ],
                ),
              ),
              showBarrier: true,
              popupDirection: TooltipDirection.up,
              child: GestureDetector(
                onTap: () {
                  if ((widget.item?.accounts as List).isNotEmpty &&
                      widget.currentLevel == 0) {
                    widget.onDone();
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: Sizes.dimen_12.w),
                  decoration: BoxDecoration(
                      border: widget.shouldShowLine ? Border(
                          bottom: BorderSide(
                              color: AppColor.grey.withOpacity(0.5))) : null),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.item?.accountName}${widget.item?.accNumber != null && widget.item?.accNumber != "--" ? '(${widget.item?.accNumber.stealth(widget.stealthValue)})' : ""}",
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
                              UIHelper.verticalSpace(Sizes.dimen_2.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: AnimatedFractionallySizedBox(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      alignment: Alignment.centerLeft,
                                      widthFactor:
                                          AppHelpers.getIncomeChartFraction(
                                              actualValue:
                                                  widget.item?.total ?? 0.00,
                                              greaterValue: widget.greaterValue
                                                  .toDouble()),
                                      child: Container(
                                        height: Sizes.dimen_6.h,
                                        decoration: const BoxDecoration(
                                            color: AppColor.violet,
                                        ),
                                      ),
                                    ),
                                  ),
                                  UIHelper.horizontalSpaceSmall,
                                  Text(
                                    "${NumberFormat.simpleCurrency(name: widget.argument.incomeCurrencyCubit.state.selectedIncomeCurrency?.code ?? 'USD').currencySymbol} ${"${(widget.item?.total ?? 0.00) < 0.0 ? '(${NumberFormat(widget.argument.incomeCurrencyCubit.state.selectedIncomeCurrency?.format ?? '###,###,##0.00').format((widget.item?.total ?? 0.00).abs().denominate(denominator: denominationState.selectedIncomeDenomination?.denomination))})' : NumberFormat(widget.argument.incomeCurrencyCubit.state.selectedIncomeCurrency?.format ?? '###,###,##0.00').format((widget.item?.total ?? 0.00).denominate(denominator: denominationState.selectedIncomeDenomination?.denomination))}${denominationState.selectedIncomeDenomination?.suffix}".stealth(widget.stealthValue)}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                            fontSize: Sizes.dimen_14,
                                            fontWeight: FontWeight.bold,
                                            color: widget.stealthValue
                                                ? null
                                                : (widget.item?.total ??
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
                      UIHelper.horizontalSpaceSmall,
                      if (widget.item?.accounts != null &&
                          (widget.item?.accounts!.isNotEmpty ?? false) &&
                          widget.currentLevel == 0)
                        Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: Sizes.dimen_14.w,
                              color: AppColor.lightGrey,
                            ))
                    ],
                  ),
                ),
              ));
        });
  }
}
