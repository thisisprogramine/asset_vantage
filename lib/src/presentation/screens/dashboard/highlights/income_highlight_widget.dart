import 'package:asset_vantage/src/config/constants/route_constants.dart';
import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/num_extensions.dart';
import 'package:asset_vantage/src/config/extensions/string_extensions.dart';
import 'package:asset_vantage/src/domain/entities/income/income_chart_data.dart';
import 'package:asset_vantage/src/injector.dart';
import 'package:asset_vantage/src/presentation/arguments/income_report_argument.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_account/income_account_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_as_on_date/income_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_chart/income_chart_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_currency/income_currency_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_denomination/income_denomination_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_entity/income_entity_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_report/income_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_sort_cubit/income_sort_cubit.dart';
import 'package:asset_vantage/src/presentation/widgets/custom_popup_menu.dart';
import 'package:asset_vantage/src/presentation/widgets/delete_favorite_dialog.dart';
import 'package:asset_vantage/src/presentation/widgets/entity_asondate_label.dart';
import 'package:asset_vantage/src/presentation/widgets/filter_icon.dart';
import 'package:asset_vantage/src/presentation/widgets/navigation_arrow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dotted_line/dotted_line.dart';

import '../../../../config/constants/favorite_constants.dart';
import '../../../../config/constants/size_constants.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/authentication/user_entity.dart';
import '../../../../domain/entities/favorites/favorites_entity.dart';
import '../../../../utilities/helper/app_helper.dart';
import '../../../../utilities/helper/flash_helper.dart';
import '../../../../utilities/helper/ui_helper.dart';
import '../../../blocs/authentication/user/user_cubit.dart';
import '../../../blocs/currency_filter/currency_filter_cubit.dart';
import '../../../blocs/dashboard_datepicker/dashboard_datepicker_cubit.dart';
import '../../../blocs/dashboard_filter/dashboard_filter_cubit.dart';
import '../../../blocs/favorites/favorites_cubit.dart';
import '../../../blocs/income/income_loading/income_loading_cubit.dart';
import '../../../blocs/income/income_number_of_period/income_number_of_period_cubit.dart';
import '../../../blocs/income/income_period/income_period_cubit.dart';
import '../../../blocs/stealth/stealth_cubit.dart';
import '../../../blocs/universal_filter/as_on_date_universal_filter/universal_filter_as_on_date_cubit.dart';
import '../../../blocs/universal_filter/enitity_universal_filter/universal_entity_filter_cubit.dart';
import '../../../blocs/universal_filter/favourite_as_on_date_universal_filter/favourite_universal_filter_as_on_date_cubit.dart';
import '../../../theme/theme_color.dart';
import '../../../widgets/EditableTitle.dart';
import '../../../widgets/blue_dot_icon.dart';
import '../../../widgets/cie_balance_for.dart';
import '../../../widgets/editable_title_row.dart';
import '../../../widgets/favorite_icon.dart';
import '../../../widgets/filter_personalization_hint.dart';
import '../../../widgets/loading_widgets/loading_bg.dart';
import '../../income_report/income_universal_filter.dart';

class IncomeHighlightWidget extends StatefulWidget {
  final bool isDetailScreen;
  final bool isFavorite;
  final Favorite? favorite;
  final IncomeReportCubit incomeReportCubit;
  final IncomeSortCubit incomeSortCubit;
  final IncomeEntityCubit incomeEntityCubit;
  final IncomeAccountCubit incomeAccountCubit;
  final IncomePeriodCubit incomePeriodCubit;
  final IncomeNumberOfPeriodCubit incomeNumberOfPeriodCubit;
  final IncomeChartCubit incomeChartCubit;
  final IncomeCurrencyCubit incomeCurrencyCubit;
  final IncomeDenominationCubit incomeDenominationCubit;
  final IncomeAsOnDateCubit incomeAsOnDateCubit;
  final IncomeLoadingCubit incomeLoadingCubit;
  final UniversalEntityFilterCubit universalEntityFilterCubit;
  final UniversalFilterAsOnDateCubit universalFilterAsOnDateCubit;
  final FavouriteUniversalFilterAsOnDateCubit favouriteUniversalFilterAsOnDateCubit;
  final int currentLevel;
  final String? selectedPosition;
  final void Function(int)? selectChartBarFunc;
  final List<int>? selectedChartBarMonth;

  const IncomeHighlightWidget(
      {super.key,
      this.isFavorite = false,
      this.favorite,
      required this.isDetailScreen,
      required this.incomeReportCubit,
      required this.universalEntityFilterCubit,
      required this.universalFilterAsOnDateCubit,
      required this.favouriteUniversalFilterAsOnDateCubit,
      required this.incomeSortCubit,
      required this.incomeAccountCubit,
      required this.incomePeriodCubit,
      required this.incomeNumberOfPeriodCubit,
      required this.incomeChartCubit,
      required this.incomeCurrencyCubit,
      required this.incomeDenominationCubit,
      required this.incomeEntityCubit,
      required this.incomeAsOnDateCubit,
      required this.incomeLoadingCubit,
      this.currentLevel = 0,
      this.selectedPosition,
      this.selectChartBarFunc,
      this.selectedChartBarMonth});

  @override
  State<IncomeHighlightWidget> createState() => _IncomeHighlightWidgetState();
}

class _IncomeHighlightWidgetState extends State<IncomeHighlightWidget> {
  bool canEdit = false;
  int? activeIndex;
  int? greatestMarketValue;
  List? chartData;
  List<int> periodItemVal = [0, 0];
  double height = Sizes.dimen_13.h / 1.84;

  void setChildHeight(double newHeight) => setState(() {
        height = newHeight;
      });

  @override
  void didUpdateWidget(covariant IncomeHighlightWidget oldWidget) {
    if (widget.currentLevel < oldWidget.currentLevel) {
      activeIndex = widget.selectedChartBarMonth?[widget.currentLevel];
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StealthCubit, bool>(builder: (context, stealthValue) {
      return BlocBuilder<UserCubit, UserEntity?>(builder: (context, user) {
        return BlocBuilder<IncomeEntityCubit, IncomeEntityState>(
            bloc: widget.incomeEntityCubit,
            builder: (context, entityState) {
              return BlocBuilder<IncomeAsOnDateCubit, IncomeAsOnDateState>(
                  bloc: widget.incomeAsOnDateCubit,
                  builder: (context, asOnDate) {
                    return BlocBuilder<IncomeReportCubit, IncomeReportState>(
                        bloc: widget.incomeReportCubit,
                        builder: (context, incomeState) {
                          if (incomeState is IncomeReportLoaded) {
                            return BlocBuilder<IncomeNumberOfPeriodCubit,
                                    IncomeNumberOfPeriodState>(
                                bloc: widget.incomeNumberOfPeriodCubit,
                                builder: (context, numberOfPeriodState) {
                                  if(incomeState.chartData.isNotEmpty) {
                                    if (widget.currentLevel == 0) {
                                      chartData = incomeState.chartData.sublist(
                                          incomeState.chartData.length -
                                              (numberOfPeriodState
                                                  .selectedIncomeNumberOfPeriod
                                                  ?.value ??
                                                  0),
                                          incomeState.chartData.length);
                                      greatestMarketValue =
                                          AppHelpers.getIncomeGreaterValue(
                                              incomeList: chartData
                                              as List<IncomeChartData>);
                                    } else {
                                      chartData = incomeState.chartData
                                          .map(
                                            (e) {
                                          final item = e.children.where(
                                                (element) {
                                              return element.accountName ==
                                                  widget.selectedPosition;
                                            },
                                          ).toList();
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
                                      )
                                          .toList()
                                          .sublist(
                                          incomeState.chartData.length -
                                              (numberOfPeriodState
                                                  .selectedIncomeNumberOfPeriod
                                                  ?.value ??
                                                  0),
                                          incomeState.chartData.length);
                                      greatestMarketValue = AppHelpers
                                          .getIncomeChildrenGreaterValue(
                                          incomeList:
                                          chartData as List<Child>);
                                    }
                                    if (periodItemVal[widget.currentLevel] !=
                                        numberOfPeriodState
                                            .selectedIncomeNumberOfPeriod
                                            ?.value) {
                                      if (widget.currentLevel != 0) {
                                        activeIndex =
                                        widget.selectedChartBarMonth?[
                                        widget.currentLevel];
                                        Future.delayed(const Duration(seconds: 0),
                                                () {
                                              if (widget.selectChartBarFunc != null) {
                                                widget.selectChartBarFunc!(
                                                    activeIndex ?? 0);
                                              }
                                            });
                                      } else {
                                        activeIndex = chartData!.length - 1;
                                        Future.delayed(const Duration(seconds: 0),
                                                () {
                                              if (widget.selectChartBarFunc != null) {
                                                widget.selectChartBarFunc!(
                                                    activeIndex ?? 0);
                                              }
                                            });
                                      }
                                    }
                                    periodItemVal[widget.currentLevel] =
                                        numberOfPeriodState
                                            .selectedIncomeNumberOfPeriod
                                            ?.value ??
                                            0;
                                    return Container(
                                      width: double.infinity,
                                      decoration: !widget.isDetailScreen && !widget.isFavorite ? BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                              color: AppColor.textGrey.withValues(alpha: 0.2),
                                              width: 0.6,
                                            )),
                                      ) : null,
                                      padding: EdgeInsets.symmetric(
                                          vertical: Sizes.dimen_4.h),
                                      margin: EdgeInsets.symmetric(
                                        horizontal: Sizes.dimen_12.w,),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if(!widget.isDetailScreen && !widget.isFavorite)
                                            Container(
                                              child: Column(
                                                children: [
                                                  BlocBuilder<UserCubit, UserEntity?>(
                                                      builder: (context, user) {
                                                        return BlocBuilder<IncomeEntityCubit, IncomeEntityState>(
                                                            bloc: widget.incomeEntityCubit,
                                                            builder: (context, entityState) {
                                                              return BlocBuilder<IncomeAsOnDateCubit, IncomeAsOnDateState>(
                                                                  bloc: widget.incomeAsOnDateCubit,
                                                                  builder: (context, asOnDate) {
                                                                    return Row(
                                                                      children: [
                                                                        if(entityState.selectedIncomeEntity?.id != widget.universalEntityFilterCubit.state.selectedUniversalEntity?.id ||
                                                                            !((entityState.selectedIncomeEntity?.type?.contains(widget.universalEntityFilterCubit.state.selectedUniversalEntity?.type ?? 'None') ?? false))
                                                                        )
                                                                          ...[

                                                                            EntityAsonDateLabels(text: "${entityState.selectedIncomeEntity?.name}"),
                                                                            UIHelper.horizontalSpaceSmall
                                                                          ],
                                                                        if(!(asOnDate.asOnDate?.contains(widget.universalFilterAsOnDateCubit.state.asOnDate ?? "None") ?? false))

                                                                          EntityAsonDateLabels(text: DateFormat(user?.dateFormat ?? 'dd MMM yyyy').format(DateTime.parse(asOnDate.asOnDate ?? DateTime.now().toString()))),

                                                                        if((asOnDate.asOnDate?.contains(widget.universalFilterAsOnDateCubit.state.asOnDate ?? "None") ?? true) && !(entityState.selectedIncomeEntity?.id != widget.universalEntityFilterCubit.state.selectedUniversalEntity?.id ||
                                                                            !((entityState.selectedIncomeEntity?.type?.contains(widget.universalEntityFilterCubit.state.selectedUniversalEntity?.type ?? 'None') ?? true))))

                                                                          const FilterPersonalizationHint(),

                                                                        UIHelper.horizontalSpaceSmall,
                                                                        Expanded(child: Container()),
                                                                        GestureDetector(
                                                                          onTap: () async {
                                                                            await showModalBottomSheet(
                                                                              context: context,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.only(
                                                                                  topLeft: Radius.circular(Sizes.dimen_10.r),
                                                                                  topRight: Radius.circular(Sizes.dimen_10.r),
                                                                                ),
                                                                              ),
                                                                              isScrollControlled: true,
                                                                              builder: (context) {
                                                                                return IncomeUniversalFilter(
                                                                                  favorite: widget.favorite,
                                                                                  isFavorite: widget.isFavorite,
                                                                                  incomeLoadingCubit:
                                                                                  widget.incomeLoadingCubit,
                                                                                  incomeEntityCubit: widget.incomeEntityCubit,
                                                                                  incomeAccountCubit:
                                                                                  widget.incomeAccountCubit,
                                                                                  incomeNumberOfPeriodCubit:
                                                                                  widget.incomeNumberOfPeriodCubit,
                                                                                  incomeCurrencyCubit:
                                                                                  widget.incomeCurrencyCubit,
                                                                                  incomeDenominationCubit:
                                                                                  widget.incomeDenominationCubit,
                                                                                  incomeAsOnDateCubit:
                                                                                  widget.incomeAsOnDateCubit,
                                                                                  incomePeriodCubit: widget.incomePeriodCubit,
                                                                                  incomeReportCubit: widget.incomeReportCubit,
                                                                                );
                                                                              },
                                                                            );

                                                                          },
                                                                          child: Stack(
                                                                            children: [
                                                                              if(!((asOnDate.asOnDate?.contains(widget.universalFilterAsOnDateCubit.state.asOnDate ?? "None") ?? true) && !(entityState.selectedIncomeEntity?.id != widget.universalEntityFilterCubit.state.selectedUniversalEntity?.id ||
                                                                                  !((entityState.selectedIncomeEntity?.type?.contains(widget.universalEntityFilterCubit.state.selectedUniversalEntity?.type ?? 'None') ?? true)))))

                                                                                 const BlueDotIcon(),

                                                                              const FilterIcon()
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        UIHelper.horizontalSpace(Sizes.dimen_4.w),
                                                                      ],
                                                                    );
                                                                  }
                                                              );
                                                            }
                                                        );
                                                      }
                                                  ),
                                                ],
                                              ),

                                            ),

                                          if(widget.isDetailScreen)
                                            BlocBuilder<UserCubit, UserEntity?>(
                                                builder: (context, user) {
                                                  return BlocBuilder<IncomeEntityCubit, IncomeEntityState>(
                                                      bloc: widget.incomeEntityCubit,
                                                      builder: (context, entityState) {
                                                        return BlocBuilder<IncomeAsOnDateCubit, IncomeAsOnDateState>(
                                                            bloc: widget.incomeAsOnDateCubit,
                                                            builder: (context, asOnDate) {
                                                              return Container(
                                                                padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
                                                                decoration:
                                                                const BoxDecoration(
                                                                  border: Border(
                                                                    bottom: BorderSide(
                                                                        color: AppColor
                                                                            .textGrey,
                                                                        width: 0.1),
                                                                  ),
                                                                ),
                                                                child: Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Expanded(
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Flexible(
                                                                                child: Text("${entityState.selectedIncomeEntity?.name}",
                                                                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          UIHelper.horizontalSpaceSmall,
                                                                          Text("as on ${DateFormat(user?.dateFormat ?? 'dd MMM yyyy').format(DateTime.parse(asOnDate.asOnDate ?? DateTime.now().toString()))}",
                                                                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.normal, fontSize: Sizes.dimen_12)),
                                                                          UIHelper.horizontalSpaceSmall,
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    if (widget.currentLevel == 0)
                                                                      ...[
                                                                        if(widget.isDetailScreen)
                                                                          GestureDetector(
                                                                            onTap: () async {
                                                                              await showModalBottomSheet(
                                                                                context: context,
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.only(
                                                                                    topLeft: Radius.circular(Sizes.dimen_10.r),
                                                                                    topRight: Radius.circular(Sizes.dimen_10.r),
                                                                                  ),
                                                                                ),
                                                                                isScrollControlled: true,
                                                                                builder: (context) {
                                                                                  return IncomeUniversalFilter(
                                                                                    favorite: widget.favorite,
                                                                                    isFavorite: widget.isFavorite,
                                                                                    incomeLoadingCubit:
                                                                                    widget.incomeLoadingCubit,
                                                                                    incomeEntityCubit: widget.incomeEntityCubit,
                                                                                    incomeAccountCubit:
                                                                                    widget.incomeAccountCubit,
                                                                                    incomeNumberOfPeriodCubit:
                                                                                    widget.incomeNumberOfPeriodCubit,
                                                                                    incomeCurrencyCubit:
                                                                                    widget.incomeCurrencyCubit,
                                                                                    incomeDenominationCubit:
                                                                                    widget.incomeDenominationCubit,
                                                                                    incomeAsOnDateCubit:
                                                                                    widget.incomeAsOnDateCubit,
                                                                                    incomePeriodCubit: widget.incomePeriodCubit,
                                                                                    incomeReportCubit: widget.incomeReportCubit,
                                                                                  );
                                                                                },
                                                                              );
                                                                            },
                                                                            child: const FilterIcon(isSummary: true,)

                                                                          ),
                                                                        if(!widget.isDetailScreen)
                                                                          ...[
                                                                            UIHelper.horizontalSpaceMedium,
                                                                            GestureDetector(
                                                                                onTap: () {
                                                                                  Navigator.of(context)
                                                                                      .pushNamed(
                                                                                      RouteList
                                                                                          .incomeReportScreen,
                                                                                      arguments: IncomeReportArgument(
                                                                                        isFavorite:
                                                                                        widget
                                                                                            .isFavorite,
                                                                                        universalEntityFilterCubit: widget.universalEntityFilterCubit,
                                                                                        universalFilterAsOnDateCubit: widget.universalFilterAsOnDateCubit,
                                                                                        favouriteUniversalFilterAsOnDateCubit: widget.favouriteUniversalFilterAsOnDateCubit,
                                                                                        favorite: widget
                                                                                            .favorite,
                                                                                        incomeReportCubit:
                                                                                        widget
                                                                                            .incomeReportCubit,
                                                                                        incomeLoadingCubit:
                                                                                        widget
                                                                                            .incomeLoadingCubit,
                                                                                        incomeSortCubit:
                                                                                        widget
                                                                                            .incomeSortCubit,
                                                                                        incomeEntityCubit:
                                                                                        widget
                                                                                            .incomeEntityCubit,
                                                                                        incomeAccountCubit:
                                                                                        widget
                                                                                            .incomeAccountCubit,
                                                                                        incomePeriodCubit:
                                                                                        widget
                                                                                            .incomePeriodCubit,
                                                                                        incomeNumberOfPeriodCubit:
                                                                                        widget
                                                                                            .incomeNumberOfPeriodCubit,
                                                                                        incomeChartCubit:
                                                                                        widget
                                                                                            .incomeChartCubit,
                                                                                        incomeCurrencyCubit:
                                                                                        widget
                                                                                            .incomeCurrencyCubit,
                                                                                        incomeDenominationCubit:
                                                                                        widget
                                                                                            .incomeDenominationCubit,
                                                                                        incomeAsOnDateCubit:
                                                                                        widget
                                                                                            .incomeAsOnDateCubit,
                                                                                      ));
                                                                                },
                                                                                child: const NavigationArrow()

                                                                            )
                                                                          ]
                                                                      ]
                                                                  ],
                                                                ),
                                                              );
                                                            }
                                                        );
                                                      }
                                                  );
                                                }
                                            ),

                                          if (!widget.isDetailScreen && !widget.isFavorite)
                                            ...[
                                              UIHelper.verticalSpace(Sizes.dimen_6.h),
                                              Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        if (!widget.isDetailScreen)
                                                          BlocBuilder<
                                                              FavoritesCubit,
                                                              FavoritesState>(
                                                              builder: (context,
                                                                  favoriteState) {
                                                                return EditableTitleRow.editableRowWithoutTransform(
                                                                    canEditTransform: canEdit,
                                                                    favoriteT: widget.favorite,
                                                                    titleT: widget.favorite?.reportname,
                                                                    defaultTitle: StringConstants.incomeReport,
                                                                    onEditComplete: (){
                                                                      setState(() {
                                                                        canEdit = false;
                                                                      });
                                                                    },
                                                                    onEditToggle: (){
                                                                      setState(() {
                                                                        canEdit =
                                                                        !canEdit;
                                                                      });
                                                                    },
                                                                    isFavT: widget.isFavorite,
                                                                    context: context);
                                                              }),
                                                      ],
                                                    ),
                                                  ),
                                                  if (!widget.isDetailScreen)
                                                    Row(
                                                      children: [

                                                        GestureDetector(
                                                            onTap: () {
                                                              Navigator.of(context)
                                                                  .pushNamed(
                                                                  RouteList
                                                                      .incomeReportScreen,
                                                                  arguments:
                                                                  IncomeReportArgument(
                                                                    isFavorite:
                                                                    widget
                                                                        .isFavorite,
                                                                    universalEntityFilterCubit: widget.universalEntityFilterCubit,
                                                                    universalFilterAsOnDateCubit: widget.universalFilterAsOnDateCubit,
                                                                    favouriteUniversalFilterAsOnDateCubit: widget.favouriteUniversalFilterAsOnDateCubit,
                                                                    favorite: widget
                                                                        .favorite,
                                                                    incomeReportCubit:
                                                                    widget
                                                                        .incomeReportCubit,
                                                                    incomeLoadingCubit:
                                                                    widget
                                                                        .incomeLoadingCubit,
                                                                    incomeSortCubit:
                                                                    widget
                                                                        .incomeSortCubit,
                                                                    incomeEntityCubit:
                                                                    widget
                                                                        .incomeEntityCubit,
                                                                    incomeAccountCubit:
                                                                    widget
                                                                        .incomeAccountCubit,
                                                                    incomePeriodCubit:
                                                                    widget
                                                                        .incomePeriodCubit,
                                                                    incomeNumberOfPeriodCubit:
                                                                    widget
                                                                        .incomeNumberOfPeriodCubit,
                                                                    incomeChartCubit:
                                                                    widget
                                                                        .incomeChartCubit,
                                                                    incomeCurrencyCubit:
                                                                    widget
                                                                        .incomeCurrencyCubit,
                                                                    incomeDenominationCubit:
                                                                    widget
                                                                        .incomeDenominationCubit,
                                                                    incomeAsOnDateCubit:
                                                                    widget
                                                                        .incomeAsOnDateCubit,
                                                                  )
                                                              );
                                                            },
                                                            child: const NavigationArrow()

                                                        ),
                                                      ],
                                                    )
                                                ],
                                              ),
                                            ],

                                          if(!widget.isDetailScreen && widget.isFavorite)
                                            ...[
                                              BlocBuilder<UserCubit, UserEntity?>(
                                                  builder: (context, user) {
                                                    return BlocBuilder<IncomeEntityCubit, IncomeEntityState>(
                                                        bloc: widget.incomeEntityCubit,
                                                        builder: (context, entityState) {
                                                          return BlocBuilder<IncomeAsOnDateCubit, IncomeAsOnDateState>(
                                                              bloc: widget.incomeAsOnDateCubit,
                                                              builder: (context, asOnDate) {
                                                                return Container(
                                                                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
                                                                  decoration:
                                                                  const BoxDecoration(
                                                                    border: Border(
                                                                      bottom: BorderSide(
                                                                          color: AppColor
                                                                              .textGrey,
                                                                          width: 0.1),
                                                                    ),
                                                                  ),
                                                                  child: Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Expanded(
                                                                          child: BlocBuilder<FavoritesCubit, FavoritesState>(
                                                                              builder: (context, favoriteState) {
                                                                                return Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    EditableTitleRow(
                                                                                      canEdit: canEdit,
                                                                                      favorite: widget.favorite,
                                                                                      title: widget.favorite?.reportname,
                                                                                      onEditComplete: () {
                                                                                        setState((){
                                                                                          canEdit = false;
                                                                                        });
                                                                                      },
                                                                                      isFav: widget.isFavorite,
                                                                                      defaultTitle: StringConstants.incomeReport,
                                                                                      onEditToggle: () {
                                                                                        setState((){
                                                                                          canEdit = !canEdit;
                                                                                        });
                                                                                      },

                                                                                    ),
                                                                                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                                                                                    Row(
                                                                                      children: [
                                                                                        EntityAsonDateLabels(text: "${entityState.selectedIncomeEntity?.name}"),
                                                                                        UIHelper.horizontalSpaceSmall,
                                                                                        if(!(asOnDate.asOnDate?.contains(widget.favouriteUniversalFilterAsOnDateCubit.state.asOnDate ?? "None") ?? false))
                                                                                          EntityAsonDateLabels(text: DateFormat(user?.dateFormat ?? 'dd MMM yyyy').format(DateTime.parse(asOnDate.asOnDate ?? DateTime.now().toString())))
                                                                                      ],
                                                                                    )
                                                                                  ],
                                                                                );

                                                                              }
                                                                          )
                                                                      ),
                                                                      if (widget.currentLevel == 0)
                                                                        ...[
                                                                          if(widget.isDetailScreen)
                                                                            GestureDetector(
                                                                              onTap: () async {
                                                                                await showModalBottomSheet(
                                                                                  context: context,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.only(
                                                                                      topLeft: Radius.circular(Sizes.dimen_10.r),
                                                                                      topRight: Radius.circular(Sizes.dimen_10.r),
                                                                                    ),
                                                                                  ),
                                                                                  isScrollControlled: true,
                                                                                  builder: (context) {
                                                                                    return IncomeUniversalFilter(
                                                                                      favorite: widget.favorite,
                                                                                      isFavorite: widget.isFavorite,
                                                                                      incomeLoadingCubit:
                                                                                      widget.incomeLoadingCubit,
                                                                                      incomeEntityCubit: widget.incomeEntityCubit,
                                                                                      incomeAccountCubit:
                                                                                      widget.incomeAccountCubit,
                                                                                      incomeNumberOfPeriodCubit:
                                                                                      widget.incomeNumberOfPeriodCubit,
                                                                                      incomeCurrencyCubit:
                                                                                      widget.incomeCurrencyCubit,
                                                                                      incomeDenominationCubit:
                                                                                      widget.incomeDenominationCubit,
                                                                                      incomeAsOnDateCubit:
                                                                                      widget.incomeAsOnDateCubit,
                                                                                      incomePeriodCubit: widget.incomePeriodCubit,
                                                                                      incomeReportCubit: widget.incomeReportCubit,
                                                                                    );
                                                                                  },
                                                                                );
                                                                              },
                                                                              child: FilterIcon.getFilterIcon()
                                                                            ),
                                                                          UIHelper.horizontalSpaceMedium,
                                                                          if(widget.isFavorite && !widget.isDetailScreen)
                                                                            Row(
                                                                              children: [
                                                                                CustomPopupMenu(onSelect: (int index) async {
                                                                                  if (index == 1) {
                                                                                    context
                                                                                        .read<FavoritesCubit>()
                                                                                        .saveFilters(
                                                                                      context: context,
                                                                                      shouldUpdate: false,
                                                                                      isPinned: false,
                                                                                      reportId: FavoriteConstants.incomeId,
                                                                                      reportName: "${widget.favorite?.reportname} Copy",
                                                                                      entity: widget.incomeReportCubit.incomeEntityCubit.state.selectedIncomeEntity,
                                                                                      currency:
                                                                                      widget.incomeReportCubit.incomeCurrencyCubit.state.selectedIncomeCurrency,
                                                                                      denomination: widget.incomeReportCubit.incomeDenominationCubit
                                                                                          .state.selectedIncomeDenomination,
                                                                                      asOnDate: widget.incomeReportCubit.incomeAsOnDateCubit.state.asOnDate,
                                                                                      incomeAccounts:
                                                                                      widget.incomeReportCubit.incomeAccountCubit.state.selectedAccountList,
                                                                                      period: widget.incomeReportCubit.incomePeriodCubit.state.selectedIncomePeriod,
                                                                                      numberOfPeriod: widget.incomeReportCubit.incomeNumberOfPeriodCubit
                                                                                          .state.selectedIncomeNumberOfPeriod,
                                                                                    );

                                                                                  } else if (index == 2) {

                                                                                    DeleteFavoriteDialog.show(context: context,
                                                                                    onCancel: (){
                                                                                      Navigator.of(context).popUntil(
                                                                                            (route) =>
                                                                                        route.settings.name ==
                                                                                            RouteList.dashboard,
                                                                                      );
                                                                                    },
                                                                                    onDelete: (){
                                                                                      context
                                                                                          .read<FavoritesCubit>()
                                                                                          .removeFavorites(
                                                                                          context: context,
                                                                                          favorite: widget.favorite);
                                                                                      Navigator.of(context).pop();
                                                                                    });
                                                                                  }
                                                                                }),
                                                                                UIHelper.horizontalSpaceMedium,
                                                                                GestureDetector(
                                                                                    onTap: () {
                                                                                      Navigator.of(context)
                                                                                          .pushNamed(
                                                                                          RouteList
                                                                                              .incomeReportScreen,
                                                                                          arguments: IncomeReportArgument(
                                                                                            isFavorite:
                                                                                            widget
                                                                                                .isFavorite,
                                                                                            universalEntityFilterCubit: widget.universalEntityFilterCubit,
                                                                                            universalFilterAsOnDateCubit: widget.universalFilterAsOnDateCubit,
                                                                                            favouriteUniversalFilterAsOnDateCubit: widget.favouriteUniversalFilterAsOnDateCubit,
                                                                                            favorite: widget
                                                                                                .favorite,
                                                                                            incomeReportCubit:
                                                                                            widget
                                                                                                .incomeReportCubit,
                                                                                            incomeLoadingCubit:
                                                                                            widget
                                                                                                .incomeLoadingCubit,
                                                                                            incomeSortCubit:
                                                                                            widget
                                                                                                .incomeSortCubit,
                                                                                            incomeEntityCubit:
                                                                                            widget
                                                                                                .incomeEntityCubit,
                                                                                            incomeAccountCubit:
                                                                                            widget
                                                                                                .incomeAccountCubit,
                                                                                            incomePeriodCubit:
                                                                                            widget
                                                                                                .incomePeriodCubit,
                                                                                            incomeNumberOfPeriodCubit:
                                                                                            widget
                                                                                                .incomeNumberOfPeriodCubit,
                                                                                            incomeChartCubit:
                                                                                            widget
                                                                                                .incomeChartCubit,
                                                                                            incomeCurrencyCubit:
                                                                                            widget
                                                                                                .incomeCurrencyCubit,
                                                                                            incomeDenominationCubit:
                                                                                            widget
                                                                                                .incomeDenominationCubit,
                                                                                            incomeAsOnDateCubit:
                                                                                            widget
                                                                                                .incomeAsOnDateCubit,
                                                                                          ));
                                                                                    },
                                                                                    child: const NavigationArrow(isFav: true,)

                                                                                )
                                                                              ],
                                                                            )
                                                                        ]
                                                                    ],
                                                                  ),
                                                                );
                                                              }
                                                          );
                                                        }
                                                    );
                                                  }
                                              ),
                                            ],



                                          SizedBox(
                                            height: ScreenUtil().screenHeight *
                                                (!widget.isDetailScreen ? 0.20 : 0.15) +
                                                height,
                                            child: Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.only(
                                                    top: Sizes.dimen_5.h,
                                                    bottom: height,
                                                  ),
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                      top: Sizes.dimen_8.w,
                                                    ),
                                                    decoration:
                                                    const BoxDecoration(
                                                      border: Border(
                                                        left: BorderSide(
                                                            color: AppColor
                                                                .textGrey,
                                                            width: 0.1),
                                                        bottom: BorderSide(
                                                            color: AppColor
                                                                .textGrey,
                                                            width: 0.1),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      children: List.generate(
                                                        5,
                                                            (index) {
                                                          return Expanded(
                                                            child: Container(
                                                              decoration:
                                                              BoxDecoration(
                                                                  border:
                                                                  Border(
                                                                    top: BorderSide(
                                                                        color: AppColor
                                                                            .grey
                                                                            .withOpacity(
                                                                            0.2)),
                                                                  )),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                    bottom: 0,
                                                    left: Sizes.dimen_0.w,
                                                    height: (ScreenUtil()
                                                        .screenHeight *
                                                        (!widget.isDetailScreen ? 0.20 : 0.15)) +
                                                        height -
                                                        Sizes.dimen_5.h,
                                                    width: (ScreenUtil()
                                                        .screenWidth) -
                                                        (Sizes.dimen_32.r +
                                                            Sizes.dimen_32.w),
                                                    child: BlocBuilder<
                                                        IncomeChartCubit,
                                                        int>(
                                                        bloc: widget
                                                            .incomeChartCubit,
                                                        builder: (context,
                                                            incomeChartState) {
                                                          return Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            children:
                                                            List.generate(
                                                              chartData
                                                                  ?.length ??
                                                                  0,
                                                                  (index) {
                                                                final currentData =
                                                                chartData?[
                                                                index];
                                                                return Expanded(
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                        Padding(
                                                                          padding:
                                                                          EdgeInsets.symmetric(horizontal: Sizes.dimen_4.w),
                                                                          child:
                                                                          Column(
                                                                            mainAxisSize:
                                                                            MainAxisSize.max,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Stack(
                                                                                  fit: StackFit.loose,
                                                                                  alignment: Alignment.bottomCenter,
                                                                                  children: [
                                                                                    GestureDetector(
                                                                                      onTap: () {
                                                                                        activeIndex = index;
                                                                                        if (widget.selectChartBarFunc != null) {
                                                                                          widget.selectChartBarFunc!(index);
                                                                                        }
                                                                                        setState(() {});
                                                                                      },
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.only(top: Sizes.dimen_5.h),
                                                                                        child: AnimatedOpacity(
                                                                                          opacity: index == activeIndex ? 1 : 0.4,
                                                                                          duration: const Duration(milliseconds: 300),
                                                                                          curve: Curves.easeIn,
                                                                                          child: Column(
                                                                                            children: [
                                                                                              Expanded(
                                                                                                child: Container(
                                                                                                  color: AppColor.transparent,
                                                                                                  child: AnimatedFractionallySizedBox(
                                                                                                    heightFactor: AppHelpers.getIncomeChartFraction(
                                                                                                        actualValue: currentData.total,
                                                                                                        greaterValue: greatestMarketValue?.toDouble() ?? 0.0
                                                                                                    ),
                                                                                                    duration: const Duration(milliseconds: 500),
                                                                                                    alignment: Alignment.bottomCenter,
                                                                                                    child: Container(
                                                                                                      color: AppColor.incomeChartColor,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    if (index == activeIndex)
                                                                                      Container(
                                                                                        alignment: Alignment.center,
                                                                                        height: ScreenUtil().screenHeight * 0.20,
                                                                                        child: const DottedLine(
                                                                                          direction: Axis.vertical,
                                                                                          lineThickness: 1.0,
                                                                                          dashLength: 4.0,
                                                                                          dashColor: Colors.black,
                                                                                          dashGapLength: 4.0,
                                                                                          dashGapColor: Colors.transparent,
                                                                                        ),
                                                                                      ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              TextAbbr(setHeight: setChildHeight, text: AppHelpers.getNetWorthMonthAbbreviation(date: currentData.date, length: (numberOfPeriodState.selectedIncomeNumberOfPeriod?.value ?? 0) <= 6 ? 3 : 1)),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        })),
                                              ],
                                            ),
                                          ),
                                          BlocBuilder<IncomeDenominationCubit,
                                              IncomeDenominationState>(
                                              bloc: widget
                                                  .incomeDenominationCubit,
                                              builder:
                                                  (context, denominationState) {
                                                return BlocBuilder<
                                                    IncomeChartCubit, int>(
                                                    bloc:
                                                    widget.incomeChartCubit,
                                                    builder: (context,
                                                        incomeChartState) {
                                                      return BalanceFor(
                                                        isSummary: !widget.isDetailScreen,
                                                        balanceFor: "Total Income For ${DateFormat.yMMM().format(DateTime.parse(chartData?[activeIndex!].date))}",
                                                        balance: "${NumberFormat.simpleCurrency(name: widget.incomeCurrencyCubit.state.selectedIncomeCurrency?.code).currencySymbol} ${(chartData?[activeIndex!].total ?? 0.00) < 0.0 ? '(${NumberFormat(widget.incomeCurrencyCubit.state.selectedIncomeCurrency?.format ?? '###,###,##0.00').format((chartData?[activeIndex!].total as num).abs().denominate(denominator: denominationState.selectedIncomeDenomination?.denomination))})' : NumberFormat(widget.incomeCurrencyCubit.state.selectedIncomeCurrency?.format ?? '###,###,##0.00').format((chartData?[activeIndex!].total as num).denominate(denominator: denominationState.selectedIncomeDenomination?.denomination))}${denominationState.selectedIncomeDenomination?.suffix}".stealth(stealthValue),
                                                      );
                                                    });
                                              })
                                        ],
                                      ),
                                    );
                                  }else {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_14.w,),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            decoration: !widget.isFavorite && !widget.isDetailScreen ?BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(
                                                    color: AppColor.textGrey.withValues(alpha: 0.2),
                                                    width: 0.6,
                                                  )),
                                            ):null,
                                            padding: EdgeInsets.only(
                                              top: Sizes.dimen_4.h,
                                              bottom: Sizes.dimen_1.h,
                                            ),
                                          ),
                                          if(!widget.isDetailScreen && !widget.isFavorite)
                                            Expanded(
                                                child: LoadingBg(
                                                  message: Message.noPositionFound,
                                                  onRetry: () async{
                                                    await showModalBottomSheet(
                                                      context: context,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(Sizes.dimen_10.r),
                                                          topRight: Radius.circular(Sizes.dimen_10.r),
                                                        ),
                                                      ),
                                                      isScrollControlled: true,
                                                      builder: (context) {
                                                        return IncomeUniversalFilter(
                                                          favorite: widget.favorite,
                                                          isFavorite: widget.isFavorite,
                                                          incomeLoadingCubit:
                                                          widget.incomeLoadingCubit,
                                                          incomeEntityCubit: widget.incomeEntityCubit,
                                                          incomeAccountCubit:
                                                          widget.incomeAccountCubit,
                                                          incomeNumberOfPeriodCubit:
                                                          widget.incomeNumberOfPeriodCubit,
                                                          incomeCurrencyCubit:
                                                          widget.incomeCurrencyCubit,
                                                          incomeDenominationCubit:
                                                          widget.incomeDenominationCubit,
                                                          incomeAsOnDateCubit:
                                                          widget.incomeAsOnDateCubit,
                                                          incomePeriodCubit: widget.incomePeriodCubit,
                                                          incomeReportCubit: widget.incomeReportCubit,
                                                        );
                                                      },
                                                    );
                                                  },
                                                )
                                            )
                                          else
                                            LoadingBg(
                                              height: widget.isFavorite ? ScreenUtil().screenHeight * 0.25 : ScreenUtil().screenHeight * 0.20,
                                              message: Message.noPositionFound,
                                              menu: widget.isFavorite || !widget.isDetailScreen ? CustomPopupMenu(
                                                  onSelect: (int index) async {
                                                if (index == 1) {
                                                  context
                                                      .read<FavoritesCubit>()
                                                      .saveFilters(
                                                    context: context,
                                                    shouldUpdate: false,
                                                    isPinned: false,
                                                    reportId: FavoriteConstants.incomeId,
                                                    reportName: "${widget.favorite?.reportname} Copy",
                                                    entity: widget.incomeReportCubit.incomeEntityCubit.state.selectedIncomeEntity,
                                                    currency:
                                                    widget.incomeReportCubit.incomeCurrencyCubit.state.selectedIncomeCurrency,
                                                    denomination: widget.incomeReportCubit.incomeDenominationCubit
                                                        .state.selectedIncomeDenomination,
                                                    asOnDate: widget.incomeReportCubit.incomeAsOnDateCubit.state.asOnDate,
                                                    incomeAccounts:
                                                    widget.incomeReportCubit.incomeAccountCubit.state.selectedAccountList,
                                                    period: widget.incomeReportCubit.incomePeriodCubit.state.selectedIncomePeriod,
                                                    numberOfPeriod: widget.incomeReportCubit.incomeNumberOfPeriodCubit
                                                        .state.selectedIncomeNumberOfPeriod,
                                                  );

                                                } else if (index == 2) {

                                                  DeleteFavoriteDialog.show(context: context,
                                                  onCancel: (){
                                                    Navigator.of(context).popUntil(
                                                          (route) =>
                                                      route.settings.name ==
                                                          RouteList.dashboard,
                                                    );
                                                  },
                                                  onDelete: (){
                                                    context
                                                        .read<FavoritesCubit>()
                                                        .removeFavorites(
                                                        context: context,
                                                        favorite: widget.favorite);
                                                    Navigator.of(context).pop();
                                                  });

                                                }
                                              },
                                                isLoading: true,
                                              ): null,
                                              onRetry: () async{
                                                await showModalBottomSheet(
                                                  context: context,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(Sizes.dimen_10.r),
                                                      topRight: Radius.circular(Sizes.dimen_10.r),
                                                    ),
                                                  ),
                                                  isScrollControlled: true,
                                                  builder: (context) {
                                                    return IncomeUniversalFilter(
                                                      favorite: widget.favorite,
                                                      isFavorite: widget.isFavorite,
                                                      incomeLoadingCubit:
                                                      widget.incomeLoadingCubit,
                                                      incomeEntityCubit: widget.incomeEntityCubit,
                                                      incomeAccountCubit:
                                                      widget.incomeAccountCubit,
                                                      incomeNumberOfPeriodCubit:
                                                      widget.incomeNumberOfPeriodCubit,
                                                      incomeCurrencyCubit:
                                                      widget.incomeCurrencyCubit,
                                                      incomeDenominationCubit:
                                                      widget.incomeDenominationCubit,
                                                      incomeAsOnDateCubit:
                                                      widget.incomeAsOnDateCubit,
                                                      incomePeriodCubit: widget.incomePeriodCubit,
                                                      incomeReportCubit: widget.incomeReportCubit,
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          UIHelper.verticalSpaceSmall,
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: Sizes.dimen_22.h,
                                                child: Row(
                                                  children: [
                                                    Expanded(child: LoadingBg()),
                                                    Expanded(child: LoadingBg()),
                                                    UIHelper.horizontalSpaceMedium,
                                                    Expanded(child: Container()),
                                                  ],
                                                ),
                                              ),
                                              if(!widget.isDetailScreen && !widget.isFavorite)
                                                ...[
                                                  UIHelper.verticalSpaceSmall,
                                                  SizedBox(
                                                    height: Sizes.dimen_10.h,
                                                    child: Row(
                                                      children: [
                                                        Expanded(child: Container()),
                                                        UIHelper.horizontalSpaceMedium,
                                                        Expanded(child: Container()),
                                                        UIHelper.horizontalSpaceMedium,
                                                        Expanded(child: Container()),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              UIHelper.verticalSpaceSmall,
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                });
                          } else if (incomeState is IncomeReportLoading) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_14.w,),
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: !widget.isFavorite && !widget.isDetailScreen ? BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                            color: AppColor.textGrey.withValues(alpha: 0.2),
                                            width: 0.6,
                                          )),
                                    ): null,
                                    padding: EdgeInsets.only(
                                      top: Sizes.dimen_4.h,
                                      bottom: Sizes.dimen_1.h,
                                    ),
                                  ),
                                  if(!widget.isDetailScreen && !widget.isFavorite)
                                    Expanded(
                                        child: LoadingBg(message: Message.loading,)
                                    )
                                  else
                                    LoadingBg(
                                      height: widget.isFavorite ? ScreenUtil().screenHeight * 0.25 : ScreenUtil().screenHeight * 0.20,
                                      message: Message.loading,
                                      menu: widget.isFavorite && !widget.isDetailScreen ? CustomPopupMenu(
                                          onSelect: (int index) async {
                                        if (index == 1) {
                                          context
                                              .read<FavoritesCubit>()
                                              .saveFilters(
                                            context: context,
                                            shouldUpdate: false,
                                            isPinned: false,
                                            reportId: FavoriteConstants.incomeId,
                                            reportName: "${widget.favorite?.reportname} Copy",
                                            entity: widget.incomeReportCubit.incomeEntityCubit.state.selectedIncomeEntity,
                                            currency:
                                            widget.incomeReportCubit.incomeCurrencyCubit.state.selectedIncomeCurrency,
                                            denomination: widget.incomeReportCubit.incomeDenominationCubit
                                                .state.selectedIncomeDenomination,
                                            asOnDate: widget.incomeReportCubit.incomeAsOnDateCubit.state.asOnDate,
                                            incomeAccounts:
                                            widget.incomeReportCubit.incomeAccountCubit.state.selectedAccountList,
                                            period: widget.incomeReportCubit.incomePeriodCubit.state.selectedIncomePeriod,
                                            numberOfPeriod: widget.incomeReportCubit.incomeNumberOfPeriodCubit
                                                .state.selectedIncomeNumberOfPeriod,
                                          );

                                        } else if (index == 2) {

                                          DeleteFavoriteDialog.show(context: context,
                                          onCancel: (){
                                            Navigator.of(context).popUntil(
                                                  (route) =>
                                              route.settings.name ==
                                                  RouteList.dashboard,
                                            );
                                          },
                                          onDelete: (){
                                            context
                                                .read<FavoritesCubit>()
                                                .removeFavorites(
                                                context: context,
                                                favorite: widget.favorite);
                                            Navigator.of(context).pop();
                                          });
                                        }
                                      },
                                        isLoading: true,
                                      ): null,
                                    ),
                                  UIHelper.verticalSpaceSmall,
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: Sizes.dimen_22.h,
                                        child: Row(
                                          children: [
                                            Expanded(child: LoadingBg()),
                                            Expanded(child: LoadingBg()),
                                            UIHelper.horizontalSpaceMedium,
                                            Expanded(child: Container()),
                                          ],
                                        ),
                                      ),
                                      if(!widget.isDetailScreen && !widget.isFavorite)
                                        ...[
                                          UIHelper.verticalSpaceSmall,
                                          SizedBox(
                                            height: Sizes.dimen_10.h,
                                            child: Row(
                                              children: [
                                                Expanded(child: Container()),
                                                UIHelper.horizontalSpaceMedium,
                                                Expanded(child: Container()),
                                                UIHelper.horizontalSpaceMedium,
                                                Expanded(child: Container()),
                                              ],
                                            ),
                                          ),
                                        ],
                                      UIHelper.verticalSpaceSmall,
                                    ],
                                  ),
                                ],
                              ),
                            );
                          } else if (incomeState is IncomeReportError) {
                            if (incomeState.errorType ==
                                AppErrorType.unauthorised) {
                              AppHelpers.logout(context: context);
                            }
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_14.w,),
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                            color: AppColor.textGrey.withValues(alpha: 0.2),
                                            width: 0.6,
                                          )),
                                    ),
                                    padding: EdgeInsets.only(
                                      top: Sizes.dimen_4.h,
                                      bottom: Sizes.dimen_1.h,
                                    ),
                                  ),

                                  if(!widget.isDetailScreen && !widget.isFavorite)
                                    Expanded(
                                        child: LoadingBg(
                                          message: Message.error,
                                          onRetry: () async{
                                            await showModalBottomSheet(
                                            context: context,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(Sizes.dimen_10.r),
                                                topRight: Radius.circular(Sizes.dimen_10.r),
                                              ),
                                            ),
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return IncomeUniversalFilter(
                                                favorite: widget.favorite,
                                                isFavorite: widget.isFavorite,
                                                incomeLoadingCubit:
                                                widget.incomeLoadingCubit,
                                                incomeEntityCubit: widget.incomeEntityCubit,
                                                incomeAccountCubit:
                                                widget.incomeAccountCubit,
                                                incomeNumberOfPeriodCubit:
                                                widget.incomeNumberOfPeriodCubit,
                                                incomeCurrencyCubit:
                                                widget.incomeCurrencyCubit,
                                                incomeDenominationCubit:
                                                widget.incomeDenominationCubit,
                                                incomeAsOnDateCubit:
                                                widget.incomeAsOnDateCubit,
                                                incomePeriodCubit: widget.incomePeriodCubit,
                                                incomeReportCubit: widget.incomeReportCubit,
                                              );
                                            },
                                            );
                                          },
                                        )
                                    )
                                  else
                                    LoadingBg(
                                      height: widget.isFavorite ? ScreenUtil().screenHeight * 0.25 : ScreenUtil().screenHeight * 0.20,
                                      message: Message.error,
                                      menu: CustomPopupMenu(
                                          onSelect: (int index) async {
                                        if (index == 1) {
                                          context
                                              .read<FavoritesCubit>()
                                              .saveFilters(
                                            context: context,
                                            shouldUpdate: false,
                                            isPinned: false,
                                            reportId: FavoriteConstants.incomeId,
                                            reportName: "${widget.favorite?.reportname} Copy",
                                            entity: widget.incomeReportCubit.incomeEntityCubit.state.selectedIncomeEntity,
                                            currency:
                                            widget.incomeReportCubit.incomeCurrencyCubit.state.selectedIncomeCurrency,
                                            denomination: widget.incomeReportCubit.incomeDenominationCubit
                                                .state.selectedIncomeDenomination,
                                            asOnDate: widget.incomeReportCubit.incomeAsOnDateCubit.state.asOnDate,
                                            incomeAccounts:
                                            widget.incomeReportCubit.incomeAccountCubit.state.selectedAccountList,
                                            period: widget.incomeReportCubit.incomePeriodCubit.state.selectedIncomePeriod,
                                            numberOfPeriod: widget.incomeReportCubit.incomeNumberOfPeriodCubit
                                                .state.selectedIncomeNumberOfPeriod,
                                          );

                                        } else if (index == 2) {

                                          DeleteFavoriteDialog.show(context: context,
                                          onCancel: (){
                                            Navigator.of(context).popUntil(
                                                  (route) =>
                                              route.settings.name ==
                                                  RouteList.dashboard,
                                            );
                                          },
                                          onDelete: (){
                                            context
                                                .read<FavoritesCubit>()
                                                .removeFavorites(
                                                context: context,
                                                favorite: widget.favorite);
                                            Navigator.of(context).pop();
                                          });
                                        }
                                      },
                                        isLoading: true,
                                      ),
                                      onRetry: () async{
                                        await showModalBottomSheet(
                                          context: context,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(Sizes.dimen_10.r),
                                              topRight: Radius.circular(Sizes.dimen_10.r),
                                            ),
                                          ),
                                          isScrollControlled: true,
                                          builder: (context) {
                                            return IncomeUniversalFilter(
                                              favorite: widget.favorite,
                                              isFavorite: widget.isFavorite,
                                              incomeLoadingCubit:
                                              widget.incomeLoadingCubit,
                                              incomeEntityCubit: widget.incomeEntityCubit,
                                              incomeAccountCubit:
                                              widget.incomeAccountCubit,
                                              incomeNumberOfPeriodCubit:
                                              widget.incomeNumberOfPeriodCubit,
                                              incomeCurrencyCubit:
                                              widget.incomeCurrencyCubit,
                                              incomeDenominationCubit:
                                              widget.incomeDenominationCubit,
                                              incomeAsOnDateCubit:
                                              widget.incomeAsOnDateCubit,
                                              incomePeriodCubit: widget.incomePeriodCubit,
                                              incomeReportCubit: widget.incomeReportCubit,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  UIHelper.verticalSpaceSmall,
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: Sizes.dimen_22.h,
                                        child: Row(
                                          children: [
                                            Expanded(child: LoadingBg()),
                                            Expanded(child: LoadingBg()),
                                            UIHelper.horizontalSpaceMedium,
                                            Expanded(child: Container()),
                                          ],
                                        ),
                                      ),
                                      if(!widget.isDetailScreen && !widget.isFavorite)
                                        ...[
                                          UIHelper.verticalSpaceSmall,
                                          SizedBox(
                                            height: Sizes.dimen_10.h,
                                            child: Row(
                                              children: [
                                                Expanded(child: Container()),
                                                UIHelper.horizontalSpaceMedium,
                                                Expanded(child: Container()),
                                                UIHelper.horizontalSpaceMedium,
                                                Expanded(child: Container()),
                                              ],
                                            ),
                                          ),
                                        ],
                                      UIHelper.verticalSpaceSmall,
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_14.w,),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                          color: AppColor.textGrey.withValues(alpha: 0.2),
                                          width: 0.6,
                                        )),
                                  ),
                                  padding: EdgeInsets.only(
                                    top: Sizes.dimen_4.h,
                                    bottom: Sizes.dimen_1.h,
                                  ),
                                ),

                                if(!widget.isDetailScreen && !widget.isFavorite)
                                  Expanded(
                                      child: LoadingBg(message: Message.loading,)
                                  )
                                else
                                  LoadingBg(
                                    height: widget.isFavorite ? ScreenUtil().screenHeight * 0.25 : ScreenUtil().screenHeight * 0.20,
                                    message: Message.loading,
                                    menu: CustomPopupMenu(onSelect: (int index) async {
                                      if (index == 1) {
                                        context
                                            .read<FavoritesCubit>()
                                            .saveFilters(
                                          context: context,
                                          shouldUpdate: false,
                                          isPinned: false,
                                          reportId: FavoriteConstants.incomeId,
                                          reportName: "${widget.favorite?.reportname} Copy",
                                          entity: widget.incomeReportCubit.incomeEntityCubit.state.selectedIncomeEntity,
                                          currency:
                                          widget.incomeReportCubit.incomeCurrencyCubit.state.selectedIncomeCurrency,
                                          denomination: widget.incomeReportCubit.incomeDenominationCubit
                                              .state.selectedIncomeDenomination,
                                          asOnDate: widget.incomeReportCubit.incomeAsOnDateCubit.state.asOnDate,
                                          incomeAccounts:
                                          widget.incomeReportCubit.incomeAccountCubit.state.selectedAccountList,
                                          period: widget.incomeReportCubit.incomePeriodCubit.state.selectedIncomePeriod,
                                          numberOfPeriod: widget.incomeReportCubit.incomeNumberOfPeriodCubit
                                              .state.selectedIncomeNumberOfPeriod,
                                        );

                                      } else if (index == 2) {

                                        DeleteFavoriteDialog.show(context: context,
                                        onCancel: (){
                                          Navigator.of(context).popUntil(
                                                (route) =>
                                            route.settings.name ==
                                                RouteList.dashboard,
                                          );
                                        },
                                        onDelete: (){
                                          context
                                              .read<FavoritesCubit>()
                                              .removeFavorites(
                                              context: context,
                                              favorite: widget.favorite);
                                          Navigator.of(context).pop();
                                        });
                                      }
                                    }),
                                  ),
                                UIHelper.verticalSpaceSmall,
                                Column(
                                  children: [
                                    SizedBox(
                                      height: Sizes.dimen_22.h,
                                      child: Row(
                                        children: [
                                          Expanded(child: LoadingBg()),
                                          Expanded(child: LoadingBg()),
                                          UIHelper.horizontalSpaceMedium,
                                          Expanded(child: Container()),
                                        ],
                                      ),
                                    ),
                                    if(!widget.isDetailScreen && !widget.isFavorite)
                                      ...[
                                        UIHelper.verticalSpaceSmall,
                                        SizedBox(
                                          height: Sizes.dimen_10.h,
                                          child: Row(
                                            children: [
                                              Expanded(child: Container()),
                                              UIHelper.horizontalSpaceMedium,
                                              Expanded(child: Container()),
                                              UIHelper.horizontalSpaceMedium,
                                              Expanded(child: Container()),
                                            ],
                                          ),
                                        ),
                                      ],
                                    UIHelper.verticalSpaceSmall,
                                  ],
                                ),
                              ],
                            ),
                          );
                        });
                  });
            });
      });
    });
  }
}

class TextAbbr extends StatefulWidget {
  final void Function(double) setHeight;
  final String text;
  const TextAbbr({
    super.key,
    required this.setHeight,
    required this.text,
  });

  @override
  State<TextAbbr> createState() => _TextAbbrState();
}

class _TextAbbrState extends State<TextAbbr> {
  double? _oldSize;

  void _notifySize() {
    if (!mounted) {
      return;
    }
    final size = context.size?.height;
    if (_oldSize != size && size != null) {
      _oldSize = size;
      widget.setHeight(size);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
    return Text(
      widget.text,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleSmall
          ?.copyWith(
        color: AppColor.grey,
        fontWeight:
        FontWeight.normal,
      ),
    );
  }
}
