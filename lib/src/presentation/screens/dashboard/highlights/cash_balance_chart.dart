
import 'dart:developer';

import 'package:asset_vantage/src/config/constants/route_constants.dart';
import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/num_extensions.dart';
import 'package:asset_vantage/src/config/extensions/string_extensions.dart';
import 'package:asset_vantage/src/domain/entities/cash_balance/cash_balance_entity.dart';
import 'package:asset_vantage/src/presentation/arguments/cash_balance_argument.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_accounts/cash_balance_account_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_entity/cash_balance_entity_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_grouping/cash_balance_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_sort_cubit/cash_balance_sort_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_sub_grouping/cash_balance_sub_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/widgets/blue_dot_icon.dart';
import 'package:asset_vantage/src/presentation/widgets/custom_popup_menu.dart';
import 'package:asset_vantage/src/presentation/widgets/delete_favorite_dialog.dart';
import 'package:asset_vantage/src/presentation/widgets/editable_title_row.dart';
import 'package:asset_vantage/src/presentation/widgets/entity_asondate_label.dart';
import 'package:asset_vantage/src/presentation/widgets/filter_icon.dart';
import 'package:asset_vantage/src/presentation/widgets/filter_personalization_hint.dart';
import 'package:asset_vantage/src/presentation/widgets/navigation_arrow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../config/constants/favorite_constants.dart';
import '../../../../config/constants/size_constants.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/authentication/user_entity.dart';
import '../../../../domain/entities/favorites/favorites_entity.dart';
import '../../../../utilities/helper/app_helper.dart';
import '../../../../utilities/helper/flash_helper.dart';
import '../../../../utilities/helper/ui_helper.dart';
import '../../../blocs/authentication/user/user_cubit.dart';
import '../../../blocs/cash_balance/cash_balance_as_on_date/cash_balance_as_on_date_cubit.dart';
import '../../../blocs/cash_balance/cash_balance_currency/cash_balance_currency_cubit.dart';
import '../../../blocs/cash_balance/cash_balance_denomination/cash_balance_denomination_cubit.dart';
import '../../../blocs/cash_balance/cash_balance_loading/cash_balance_loading_cubit.dart';
import '../../../blocs/cash_balance/cash_balance_number_of_period/cash_balance_number_of_period_cubit.dart';
import '../../../blocs/cash_balance/cash_balance_period/cash_balance_period_cubit.dart';
import '../../../blocs/cash_balance/cash_balance_report/cash_balance_report_cubit.dart';
import '../../../blocs/currency_filter/currency_filter_cubit.dart';
import '../../../blocs/favorites/favorites_cubit.dart';
import '../../../blocs/stealth/stealth_cubit.dart';
import '../../../blocs/universal_filter/as_on_date_universal_filter/universal_filter_as_on_date_cubit.dart';
import '../../../blocs/universal_filter/enitity_universal_filter/universal_entity_filter_cubit.dart';
import '../../../blocs/universal_filter/favourite_as_on_date_universal_filter/favourite_universal_filter_as_on_date_cubit.dart';
import '../../../theme/theme_color.dart';
import '../../../widgets/EditableTitle.dart';
import '../../../widgets/cie_balance_for.dart';
import '../../../widgets/favorite_icon.dart';
import '../../../widgets/loading_widgets/loading_bg.dart';
import '../../cash_balance_report/cash_balance_filter_modal.dart';

class CashBalanceHighlightChart extends StatefulWidget {
  final bool isFavorite;
  final Favorite? favorite;
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
  final CashBalanceLoadingCubit cashBalanceLoadingCubit;
  final UniversalEntityFilterCubit universalEntityFilterCubit;
  final UniversalFilterAsOnDateCubit universalFilterAsOnDateCubit;
  final FavouriteUniversalFilterAsOnDateCubit favouriteUniversalFilterAsOnDateCubit;
  final bool isSummary;
  final int currentLevel;
  final String? selectedPosition;
  final void Function(int)? selectChartBarFunc;
  final List<int>? selectedChartBarMonth;

  const CashBalanceHighlightChart(
      {super.key,
        this.isFavorite = false,
        this.favorite,
        required this.universalFilterAsOnDateCubit,
        required this.universalEntityFilterCubit,
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
        required this.cashBalanceLoadingCubit,
        this.isSummary = true,
        this.currentLevel = 0,
        this.selectedPosition,
        this.selectChartBarFunc,
        this.selectedChartBarMonth});

  @override
  State<CashBalanceHighlightChart> createState() =>
      _CashBalanceHighlightChartState();
}

class _CashBalanceHighlightChartState extends State<CashBalanceHighlightChart> {
  bool canEdit = false;
  int? activeIndex;
  int? greatestMarketValue;
  List<CBPeriodEntity>? chartData;
  List<int> periodItemVal = [0, 0];
  double height = Sizes.dimen_13.h/1.84;

  void setChildHeight(double newHeight) => setState(() {
    height = newHeight;
  });

  @override
  void didUpdateWidget(covariant CashBalanceHighlightChart oldWidget) {
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
        return BlocBuilder<CashBalanceReportCubit, CashBalanceReportState>(
            bloc: widget.cashBalanceReportCubit,
            builder: (context, reportState) {
              return BlocBuilder<CashBalanceNumberOfPeriodCubit,
                  CashBalanceNumberOfPeriodState>(
                  bloc: widget.cashBalanceNumberOfPeriodCubit,
                  builder: (context, numberOfPeriodState) {
                    if (reportState is CashBalanceReportLoaded) {
                      if(reportState.chartData.periodsList?.isNotEmpty ?? false) {
                        if (widget.currentLevel == 0) {
                          chartData = reportState.chartData.periodsList;
                        }
                        greatestMarketValue =
                            AppHelpers.getCashBalanceGreaterValue(
                                cashBalanceList: chartData ?? []);
                        if (periodItemVal[widget.currentLevel] !=
                            numberOfPeriodState
                                .selectedCashBalanceNumberOfPeriod?.value) {
                          if (widget.currentLevel != 0) {
                            activeIndex = widget
                                .selectedChartBarMonth?[widget.currentLevel];
                            Future.delayed(const Duration(seconds: 0), () {
                              if (widget.selectChartBarFunc != null) {
                                widget.selectChartBarFunc!(activeIndex ?? 0);
                              }
                            });
                          } else {
                            activeIndex = 0;
                            Future.delayed(const Duration(seconds: 0), () {
                              if (widget.selectChartBarFunc != null) {
                                widget.selectChartBarFunc!(activeIndex ?? 0);
                              }
                            });
                          }
                        }
                        periodItemVal[widget.currentLevel] = numberOfPeriodState
                            .selectedCashBalanceNumberOfPeriod?.value ??
                            0;
                        return BlocBuilder<CashBalanceDenominationCubit,
                            CashBalanceDenominationState>(
                            bloc: widget.cashBalanceDenominationCubit,
                            builder: (context, denominationState) {
                              return BlocBuilder<CashBalanceCurrencyCubit,
                                  CashBalanceCurrencyState>(
                                  bloc: widget.cashBalanceCurrencyCubit,
                                  builder: (context, currencyState) {
                                    return Container(
                                      width: double.infinity,
                                      decoration: widget.isSummary && !widget.isFavorite ? BoxDecoration(
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
                                        children: [
                                          if(widget.isSummary && !widget.isFavorite)
                                            Container(
                                              child: Column(
                                                children: [
                                                  BlocBuilder<UserCubit, UserEntity?>(
                                                      builder: (context, user) {
                                                        return BlocBuilder<CashBalanceEntityCubit, CashBalanceEntityState>(
                                                            bloc: widget.cashBalanceEntityCubit,
                                                            builder: (context, entityState) {
                                                              return BlocBuilder<CashBalanceAsOnDateCubit, CashBalanceAsOnDateState>(
                                                                  bloc: widget.cashBalanceAsOnDateCubit,
                                                                  builder: (context, asOnDate) {
                                                                    return Row(
                                                                      children: [
                                                                        if(entityState.selectedCashBalanceEntity?.id != widget.universalEntityFilterCubit.state.selectedUniversalEntity?.id ||
                                                                            !((entityState.selectedCashBalanceEntity?.type?.contains(widget.universalEntityFilterCubit.state.selectedUniversalEntity?.type ?? 'None') ?? false))
                                                                        )
                                                                          ...[

                                                                            EntityAsonDateLabels(text: "${entityState.selectedCashBalanceEntity?.name}"),
                                                                            UIHelper.horizontalSpaceSmall
                                                                          ],
                                                                        if(!(asOnDate.asOnDate?.contains(widget.universalFilterAsOnDateCubit.state.asOnDate ?? "None") ?? false))

                                                                           EntityAsonDateLabels(text: DateFormat(user?.dateFormat ?? 'dd MMM yyyy').format(DateTime.parse(asOnDate.asOnDate ?? DateTime.now().toString()))),

                                                                        if((asOnDate.asOnDate?.contains(widget.universalFilterAsOnDateCubit.state.asOnDate ?? "None") ?? true) && !(entityState.selectedCashBalanceEntity?.id != widget.universalEntityFilterCubit.state.selectedUniversalEntity?.id ||
                                                                            !((entityState.selectedCashBalanceEntity?.type?.contains(widget.universalEntityFilterCubit.state.selectedUniversalEntity?.type ?? 'None') ?? true))))

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
                                                                                return CashBalanceFilterModal(
                                                                                  favorite: widget.favorite,
                                                                                  isFavorite: widget.isFavorite,
                                                                                  cashBalanceEntityCubit:
                                                                                  widget.cashBalanceEntityCubit,
                                                                                  cashBalanceLoadingCubit:
                                                                                  widget.cashBalanceLoadingCubit,
                                                                                  cashBalanceSortCubit:
                                                                                  widget.cashBalanceSortCubit,
                                                                                  cashBalancePrimaryGroupingCubit:
                                                                                  widget.cashBalancePrimaryGroupingCubit,
                                                                                  cashBalancePrimarySubGroupingCubit: widget
                                                                                      .cashBalancePrimarySubGroupingCubit,
                                                                                  cashBalanceAsOnDateCubit:
                                                                                  widget.cashBalanceAsOnDateCubit,
                                                                                  cashBalanceCurrencyCubit:
                                                                                  widget.cashBalanceCurrencyCubit,
                                                                                  cashBalanceDenominationCubit:
                                                                                  widget.cashBalanceDenominationCubit,
                                                                                  cashBalanceNumberOfPeriodCubit:
                                                                                  widget.cashBalanceNumberOfPeriodCubit,
                                                                                  cashBalancePeriodCubit:
                                                                                  widget.cashBalancePeriodCubit,
                                                                                  cashBalanceReportCubit:
                                                                                  widget.cashBalanceReportCubit,
                                                                                  cashBalanceAccountCubit:
                                                                                  widget.cashBalanceAccountCubit,
                                                                                );
                                                                              },
                                                                            );
                                                                          },
                                                                          child: Stack(
                                                                            children: [
                                                                              if(!((asOnDate.asOnDate?.contains(widget.universalFilterAsOnDateCubit.state.asOnDate ?? "None") ?? true) && !(entityState.selectedCashBalanceEntity?.id != widget.universalEntityFilterCubit.state.selectedUniversalEntity?.id ||
                                                                                  !((entityState.selectedCashBalanceEntity?.type?.contains(widget.universalEntityFilterCubit.state.selectedUniversalEntity?.type ?? 'None') ?? true)))))
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

                                          if(!widget.isSummary)
                                            BlocBuilder<UserCubit, UserEntity?>(
                                                builder: (context, user) {
                                                  return BlocBuilder<CashBalanceEntityCubit, CashBalanceEntityState>(
                                                      bloc: widget.cashBalanceEntityCubit,
                                                      builder: (context, entityState) {
                                                        return BlocBuilder<CashBalanceAsOnDateCubit, CashBalanceAsOnDateState>(
                                                            bloc: widget.cashBalanceAsOnDateCubit,
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
                                                                                child: Text("${entityState.selectedCashBalanceEntity?.name}",
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
                                                                        if(!widget.isSummary)
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
                                                                                  return CashBalanceFilterModal(
                                                                                    favorite: widget.favorite,
                                                                                    isFavorite: widget.isFavorite,
                                                                                    cashBalanceEntityCubit:
                                                                                    widget.cashBalanceEntityCubit,
                                                                                    cashBalanceLoadingCubit:
                                                                                    widget.cashBalanceLoadingCubit,
                                                                                    cashBalanceSortCubit:
                                                                                    widget.cashBalanceSortCubit,
                                                                                    cashBalancePrimaryGroupingCubit:
                                                                                    widget.cashBalancePrimaryGroupingCubit,
                                                                                    cashBalancePrimarySubGroupingCubit: widget
                                                                                        .cashBalancePrimarySubGroupingCubit,
                                                                                    cashBalanceAsOnDateCubit:
                                                                                    widget.cashBalanceAsOnDateCubit,
                                                                                    cashBalanceCurrencyCubit:
                                                                                    widget.cashBalanceCurrencyCubit,
                                                                                    cashBalanceDenominationCubit:
                                                                                    widget.cashBalanceDenominationCubit,
                                                                                    cashBalanceNumberOfPeriodCubit:
                                                                                    widget.cashBalanceNumberOfPeriodCubit,
                                                                                    cashBalancePeriodCubit:
                                                                                    widget.cashBalancePeriodCubit,
                                                                                    cashBalanceReportCubit:
                                                                                    widget.cashBalanceReportCubit,
                                                                                    cashBalanceAccountCubit:
                                                                                    widget.cashBalanceAccountCubit,
                                                                                  );
                                                                                },
                                                                              );
                                                                            },
                                                                            child: const FilterIcon(isSummary: true,)
                                                                          ),

                                                                        if(widget.isFavorite && widget.isSummary)
                                                                          ...[
                                                                            UIHelper.horizontalSpaceMedium,
                                                                            GestureDetector(
                                                                                onTap: () {
                                                                                  Navigator.of(context)
                                                                                      .pushNamed(
                                                                                      RouteList
                                                                                          .cashBalanceReport,
                                                                                      arguments: CashBalanceArgument(
                                                                                        isFavorite: widget
                                                                                            .isFavorite,
                                                                                        favorite: widget
                                                                                            .favorite,
                                                                                        universalEntityFilterCubit: widget.universalEntityFilterCubit,
                                                                                        universalFilterAsOnDateCubit: widget.universalFilterAsOnDateCubit,
                                                                                        favouriteUniversalFilterAsOnDateCubit: widget.favouriteUniversalFilterAsOnDateCubit,
                                                                                        cashBalanceEntityCubit:
                                                                                        widget
                                                                                            .cashBalanceEntityCubit,
                                                                                        cashBalanceLoadingCubit:
                                                                                        widget
                                                                                            .cashBalanceLoadingCubit,
                                                                                        cashBalanceSortCubit:
                                                                                        widget
                                                                                            .cashBalanceSortCubit,
                                                                                        cashBalancePrimaryGroupingCubit:
                                                                                        widget
                                                                                            .cashBalancePrimaryGroupingCubit,
                                                                                        cashBalancePrimarySubGroupingCubit:
                                                                                        widget
                                                                                            .cashBalancePrimarySubGroupingCubit,
                                                                                        cashBalanceAsOnDateCubit:
                                                                                        widget
                                                                                            .cashBalanceAsOnDateCubit,
                                                                                        cashBalanceCurrencyCubit:
                                                                                        widget
                                                                                            .cashBalanceCurrencyCubit,
                                                                                        cashBalanceDenominationCubit:
                                                                                        widget
                                                                                            .cashBalanceDenominationCubit,
                                                                                        cashBalanceNumberOfPeriodCubit:
                                                                                        widget
                                                                                            .cashBalanceNumberOfPeriodCubit,
                                                                                        cashBalancePeriodCubit:
                                                                                        widget
                                                                                            .cashBalancePeriodCubit,
                                                                                        cashBalanceReportCubit:
                                                                                        widget
                                                                                            .cashBalanceReportCubit,
                                                                                        cashBalanceAccountCubit:
                                                                                        widget
                                                                                            .cashBalanceAccountCubit,
                                                                                      ));
                                                                                },
                                                                                child: const NavigationArrow()
                                                                            )
                                                                          ]
                                                                      ],

                                                                  ],
                                                                ),
                                                              );
                                                            }
                                                        );
                                                      }
                                                  );
                                                }
                                            ),

                                          if(widget.isSummary && !widget.isFavorite)
                                            ...[
                                              UIHelper.verticalSpace(Sizes.dimen_6.h),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        BlocBuilder<FavoritesCubit, FavoritesState>(
                                                            builder: (context, favoriteState) {
                                                              return EditableTitleRow.editableRowWithoutTransform(
                                                                  canEditTransform: canEdit,
                                                                  favoriteT: widget.favorite,
                                                                  titleT: widget.favorite?.reportname,
                                                                  defaultTitle: StringConstants.cashBalanceReport,
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
                                                            }
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                  UIHelper.horizontalSpaceMedium,
                                                  if(widget.isSummary)
                                                    GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pushNamed(
                                                              RouteList
                                                                  .cashBalanceReport,
                                                              arguments: CashBalanceArgument(
                                                                isFavorite: widget
                                                                    .isFavorite,
                                                                favorite: widget
                                                                    .favorite,
                                                                cashBalanceEntityCubit:
                                                                widget
                                                                    .cashBalanceEntityCubit,
                                                                cashBalanceLoadingCubit:
                                                                widget
                                                                    .cashBalanceLoadingCubit,
                                                                universalEntityFilterCubit: widget.universalEntityFilterCubit,
                                                                universalFilterAsOnDateCubit: widget.universalFilterAsOnDateCubit,
                                                                favouriteUniversalFilterAsOnDateCubit: widget.favouriteUniversalFilterAsOnDateCubit,
                                                                cashBalanceSortCubit:
                                                                widget
                                                                    .cashBalanceSortCubit,
                                                                cashBalancePrimaryGroupingCubit:
                                                                widget
                                                                    .cashBalancePrimaryGroupingCubit,
                                                                cashBalancePrimarySubGroupingCubit:
                                                                widget
                                                                    .cashBalancePrimarySubGroupingCubit,
                                                                cashBalanceAsOnDateCubit:
                                                                widget
                                                                    .cashBalanceAsOnDateCubit,
                                                                cashBalanceCurrencyCubit:
                                                                widget
                                                                    .cashBalanceCurrencyCubit,
                                                                cashBalanceDenominationCubit:
                                                                widget
                                                                    .cashBalanceDenominationCubit,
                                                                cashBalanceNumberOfPeriodCubit:
                                                                widget
                                                                    .cashBalanceNumberOfPeriodCubit,
                                                                cashBalancePeriodCubit:
                                                                widget
                                                                    .cashBalancePeriodCubit,
                                                                cashBalanceReportCubit:
                                                                widget
                                                                    .cashBalanceReportCubit,
                                                                cashBalanceAccountCubit:
                                                                widget
                                                                    .cashBalanceAccountCubit,
                                                              ));
                                                        },
                                                        child: const NavigationArrow()
                                                    )
                                                ],
                                              )
                                            ],

                                          if(widget.isSummary && widget.isFavorite)
                                            ...[
                                              BlocBuilder<UserCubit, UserEntity?>(
                                                  builder: (context, user) {
                                                    return BlocBuilder<CashBalanceEntityCubit, CashBalanceEntityState>(
                                                        bloc: widget.cashBalanceEntityCubit,
                                                        builder: (context, entityState) {
                                                          return BlocBuilder<CashBalanceAsOnDateCubit, CashBalanceAsOnDateState>(
                                                              bloc: widget.cashBalanceAsOnDateCubit,
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
                                                                                        onEditComplete: (){
                                                                                          setState(() {
                                                                                            canEdit=false;
                                                                                          });
                                                                                        },
                                                                                        onEditToggle: (){
                                                                                          setState((){
                                                                                            canEdit = !canEdit;
                                                                                          });
                                                                                        },

                                                                                        isFav: widget.isFavorite,
                                                                                        defaultTitle: StringConstants.cashBalanceReport),
                                                                                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                                                                                    Row(
                                                                                      children: [

                                                                                        EntityAsonDateLabels(text: "${entityState.selectedCashBalanceEntity?.name}"),
                                                                                        UIHelper.horizontalSpaceSmall,
                                                                                        if(!(asOnDate.asOnDate?.contains(widget.favouriteUniversalFilterAsOnDateCubit.state.asOnDate ?? "None") ?? true))
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
                                                                          if(!widget.isSummary)
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
                                                                                    return CashBalanceFilterModal(
                                                                                      favorite: widget.favorite,
                                                                                      isFavorite: widget.isFavorite,
                                                                                      cashBalanceEntityCubit:
                                                                                      widget.cashBalanceEntityCubit,
                                                                                      cashBalanceLoadingCubit:
                                                                                      widget.cashBalanceLoadingCubit,
                                                                                      cashBalanceSortCubit:
                                                                                      widget.cashBalanceSortCubit,
                                                                                      cashBalancePrimaryGroupingCubit:
                                                                                      widget.cashBalancePrimaryGroupingCubit,
                                                                                      cashBalancePrimarySubGroupingCubit: widget
                                                                                          .cashBalancePrimarySubGroupingCubit,
                                                                                      cashBalanceAsOnDateCubit:
                                                                                      widget.cashBalanceAsOnDateCubit,
                                                                                      cashBalanceCurrencyCubit:
                                                                                      widget.cashBalanceCurrencyCubit,
                                                                                      cashBalanceDenominationCubit:
                                                                                      widget.cashBalanceDenominationCubit,
                                                                                      cashBalanceNumberOfPeriodCubit:
                                                                                      widget.cashBalanceNumberOfPeriodCubit,
                                                                                      cashBalancePeriodCubit:
                                                                                      widget.cashBalancePeriodCubit,
                                                                                      cashBalanceReportCubit:
                                                                                      widget.cashBalanceReportCubit,
                                                                                      cashBalanceAccountCubit:
                                                                                      widget.cashBalanceAccountCubit,
                                                                                    );
                                                                                  },
                                                                                );
                                                                              },
                                                                              child: FilterIcon.getFilterIcon()

                                                                            ),
                                                                          UIHelper.horizontalSpaceMedium,
                                                                          if(widget.isFavorite && widget.isSummary)
                                                                            Row(
                                                                              children: [
                                                                                CustomPopupMenu(
                                                                                    onSelect: (int index) async {
                                                                                      if (index == 1) {
                                                                                        context
                                                                                            .read<FavoritesCubit>()
                                                                                            .saveFilters(
                                                                                          context: context,
                                                                                          shouldUpdate: false,
                                                                                          isPinned: false,
                                                                                          reportId: FavoriteConstants.cashBalanceId,
                                                                                          reportName: "${widget.favorite?.reportname} Copy",
                                                                                          entity: widget.cashBalanceReportCubit.cashBalanceEntityCubit.state.selectedCashBalanceEntity,
                                                                                          cashBalancePrimaryGrouping: widget.cashBalanceReportCubit.cashBalancePrimaryGroupingCubit.state.selectedGrouping,
                                                                                          cashBalancePrimarySubGrouping: widget.cashBalanceReportCubit.cashBalancePrimarySubGroupingCubit.state.selectedSubGroupingList,
                                                                                          cashAccounts: widget.cashBalanceReportCubit.cashBalanceAccountCubit.state.selectedAccountsList,
                                                                                          numberOfPeriod: widget.cashBalanceReportCubit.cashBalanceNumberOfPeriodCubit.state.selectedCashBalanceNumberOfPeriod,
                                                                                          period: widget.cashBalanceReportCubit.cashBalancePeriodCubit.state.selectedCashBalancePeriod,
                                                                                          currency: widget.cashBalanceReportCubit.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency,
                                                                                          denomination: widget.cashBalanceReportCubit.cashBalanceDenominationCubit.state.selectedCashBalanceDenomination,
                                                                                          asOnDate: widget.cashBalanceReportCubit.cashBalanceAsOnDateCubit.state.asOnDate,
                                                                                        );

                                                                                      } else if (index == 2) {

                                                                                        DeleteFavoriteDialog.show(context: context,
                                                                                        onCancel: (){
                                                                                          Navigator.of(context).pop();
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
                                                                                ),
                                                                                UIHelper.horizontalSpaceMedium,
                                                                                GestureDetector(
                                                                                    onTap: () {
                                                                                      Navigator.of(context)
                                                                                          .pushNamed(
                                                                                          RouteList
                                                                                              .cashBalanceReport,
                                                                                          arguments: CashBalanceArgument(
                                                                                            isFavorite: widget
                                                                                                .isFavorite,
                                                                                            universalEntityFilterCubit: widget.universalEntityFilterCubit,
                                                                                            universalFilterAsOnDateCubit: widget.universalFilterAsOnDateCubit,
                                                                                            favouriteUniversalFilterAsOnDateCubit: widget.favouriteUniversalFilterAsOnDateCubit,
                                                                                            favorite: widget
                                                                                                .favorite,
                                                                                            cashBalanceEntityCubit:
                                                                                            widget
                                                                                                .cashBalanceEntityCubit,
                                                                                            cashBalanceLoadingCubit:
                                                                                            widget
                                                                                                .cashBalanceLoadingCubit,
                                                                                            cashBalanceSortCubit:
                                                                                            widget
                                                                                                .cashBalanceSortCubit,
                                                                                            cashBalancePrimaryGroupingCubit:
                                                                                            widget
                                                                                                .cashBalancePrimaryGroupingCubit,
                                                                                            cashBalancePrimarySubGroupingCubit:
                                                                                            widget
                                                                                                .cashBalancePrimarySubGroupingCubit,
                                                                                            cashBalanceAsOnDateCubit:
                                                                                            widget
                                                                                                .cashBalanceAsOnDateCubit,
                                                                                            cashBalanceCurrencyCubit:
                                                                                            widget
                                                                                                .cashBalanceCurrencyCubit,
                                                                                            cashBalanceDenominationCubit:
                                                                                            widget
                                                                                                .cashBalanceDenominationCubit,
                                                                                            cashBalanceNumberOfPeriodCubit:
                                                                                            widget
                                                                                                .cashBalanceNumberOfPeriodCubit,
                                                                                            cashBalancePeriodCubit:
                                                                                            widget
                                                                                                .cashBalancePeriodCubit,
                                                                                            cashBalanceReportCubit:
                                                                                            widget
                                                                                                .cashBalanceReportCubit,
                                                                                            cashBalanceAccountCubit:
                                                                                            widget
                                                                                                .cashBalanceAccountCubit,
                                                                                          ));
                                                                                    },
                                                                                    child:const NavigationArrow(isFav: true,)

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
                                                (!widget.isSummary ? 0.15 : 0.20)+height,
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
                                                  left: Sizes.dimen_8.w,
                                                  height: (ScreenUtil()
                                                      .screenHeight *
                                                      (!widget.isSummary ? 0.15 : 0.20))+height -
                                                      (Sizes.dimen_5.h),
                                                  width: (ScreenUtil()
                                                      .screenWidth) -
                                                      (Sizes.dimen_34.r +
                                                          Sizes.dimen_34.w),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: List.generate(
                                                      chartData!.length,
                                                          (index) {
                                                        final currentData =
                                                        chartData![index];
                                                        return Expanded(
                                                          child: Row(
                                                            children: [
                                                              !([
                                                                11,
                                                                12
                                                              ].contains(numberOfPeriodState
                                                                  .selectedCashBalanceNumberOfPeriod
                                                                  ?.value ??
                                                                  -1))
                                                                  ? Expanded(
                                                                child:
                                                                Container(),
                                                              )
                                                                  : const SizedBox
                                                                  .shrink(),
                                                              SizedBox(
                                                                width: (numberOfPeriodState.selectedCashBalanceNumberOfPeriod?.value ??
                                                                    -1) <=
                                                                    6
                                                                    ? Sizes
                                                                    .dimen_48
                                                                    .w
                                                                    : Sizes
                                                                    .dimen_20
                                                                    .w,
                                                                child: Column(
                                                                  mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                      Stack(
                                                                        alignment:
                                                                        Alignment.bottomCenter,
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              activeIndex = index;
                                                                              if (widget.selectChartBarFunc != null) {
                                                                                widget.selectChartBarFunc!(index);
                                                                              }
                                                                              setState(() {});
                                                                            },
                                                                            child:
                                                                            AnimatedOpacity(
                                                                              opacity: index == activeIndex ? 1 : 0.4,
                                                                              duration: const Duration(milliseconds: 300),
                                                                              curve: Curves.easeIn,
                                                                              child: Stack(
                                                                                fit: StackFit.expand,
                                                                                children: [
                                                                                  AnimatedFractionallySizedBox(
                                                                                    alignment: Alignment.bottomCenter,
                                                                                    duration: const Duration(milliseconds: 500),
                                                                                    heightFactor: 1 - AppHelpers.getCashBalanceChartFraction(actualValue: currentData.total ?? 0, greaterValue: greatestMarketValue!.toDouble()),
                                                                                    child: Container(
                                                                                      color: AppColor.transparent,
                                                                                    ),
                                                                                  ),
                                                                                  AnimatedFractionallySizedBox(
                                                                                    alignment: Alignment.bottomCenter,
                                                                                    duration: const Duration(milliseconds: 500),
                                                                                    heightFactor: AppHelpers.getCashBalanceChartFraction(actualValue: currentData.total ?? 0, greaterValue: greatestMarketValue!.toDouble()),
                                                                                    child: Container(
                                                                                      color: AppColor.cbChartColor,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          if (index ==
                                                                              activeIndex)
                                                                            Container(
                                                                              alignment: Alignment.center,
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
                                                                    TextAbbr(setHeight: setChildHeight, text: AppHelpers.getNetWorthMonthAbbreviation(
                                                                        date: currentData
                                                                            .periodEnd ?? DateTime.now().toString(),
                                                                        length: (numberOfPeriodState.selectedCashBalanceNumberOfPeriod?.value ?? 0) <= 6
                                                                            ? 3
                                                                            : 1)),
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                Container(),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ).reversed.toList(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          BalanceFor(
                                            isSummary: widget.isSummary,
                                            balanceFor: "Balance For ${DateFormat.yMMM().format(DateTime.parse(chartData![activeIndex!].periodEnd ?? DateTime.now().toString()))}",
                                            balance: (chartData![activeIndex!]
                                        .total ?? 0) <
                                    0
                                    ? "${NumberFormat.simpleCurrency(name: widget.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency?.code).currencySymbol} (${NumberFormat(widget.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency?.format ?? '###,###,##0.00').format(chartData![activeIndex!].total.denominate(denominator: denominationState.selectedCashBalanceDenomination?.denomination))}${denominationState.selectedCashBalanceDenomination?.suffix})"
                                        .stealth(stealthValue)
                                        : "${NumberFormat.simpleCurrency(name: widget.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency?.code).currencySymbol} ${NumberFormat(widget.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency?.format ?? '###,###,##0.00').format(chartData![activeIndex!].total.denominate(denominator: denominationState.selectedCashBalanceDenomination?.denomination))}${denominationState.selectedCashBalanceDenomination?.suffix}"
                                        .stealth(
                                    stealthValue),
                                          ),

                                        ],
                                      ),
                                    );
                                  });
                            });
                      }else {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_14.w,),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: !widget.isFavorite && widget.isSummary ? BoxDecoration(
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
                              if(widget.isSummary && !widget.isFavorite)
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
                                            return CashBalanceFilterModal(
                                              favorite: widget.favorite,
                                              isFavorite: widget.isFavorite,
                                              cashBalanceEntityCubit:
                                              widget.cashBalanceEntityCubit,
                                              cashBalanceLoadingCubit:
                                              widget.cashBalanceLoadingCubit,
                                              cashBalanceSortCubit:
                                              widget.cashBalanceSortCubit,
                                              cashBalancePrimaryGroupingCubit:
                                              widget.cashBalancePrimaryGroupingCubit,
                                              cashBalancePrimarySubGroupingCubit: widget
                                                  .cashBalancePrimarySubGroupingCubit,
                                              cashBalanceAsOnDateCubit:
                                              widget.cashBalanceAsOnDateCubit,
                                              cashBalanceCurrencyCubit:
                                              widget.cashBalanceCurrencyCubit,
                                              cashBalanceDenominationCubit:
                                              widget.cashBalanceDenominationCubit,
                                              cashBalanceNumberOfPeriodCubit:
                                              widget.cashBalanceNumberOfPeriodCubit,
                                              cashBalancePeriodCubit:
                                              widget.cashBalancePeriodCubit,
                                              cashBalanceReportCubit:
                                              widget.cashBalanceReportCubit,
                                              cashBalanceAccountCubit:
                                              widget.cashBalanceAccountCubit,
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
                                        return CashBalanceFilterModal(
                                          favorite: widget.favorite,
                                          isFavorite: widget.isFavorite,
                                          cashBalanceEntityCubit:
                                          widget.cashBalanceEntityCubit,
                                          cashBalanceLoadingCubit:
                                          widget.cashBalanceLoadingCubit,
                                          cashBalanceSortCubit:
                                          widget.cashBalanceSortCubit,
                                          cashBalancePrimaryGroupingCubit:
                                          widget.cashBalancePrimaryGroupingCubit,
                                          cashBalancePrimarySubGroupingCubit: widget
                                              .cashBalancePrimarySubGroupingCubit,
                                          cashBalanceAsOnDateCubit:
                                          widget.cashBalanceAsOnDateCubit,
                                          cashBalanceCurrencyCubit:
                                          widget.cashBalanceCurrencyCubit,
                                          cashBalanceDenominationCubit:
                                          widget.cashBalanceDenominationCubit,
                                          cashBalanceNumberOfPeriodCubit:
                                          widget.cashBalanceNumberOfPeriodCubit,
                                          cashBalancePeriodCubit:
                                          widget.cashBalancePeriodCubit,
                                          cashBalanceReportCubit:
                                          widget.cashBalanceReportCubit,
                                          cashBalanceAccountCubit:
                                          widget.cashBalanceAccountCubit,
                                        );
                                      },
                                    );
                                  },
                                  menu: widget.isFavorite && widget.isSummary ?
                                      CustomPopupMenu(
                                          onSelect: (int index) async {
                                            if (index == 1) {
                                              context
                                                  .read<FavoritesCubit>()
                                                  .saveFilters(
                                                context: context,
                                                shouldUpdate: false,
                                                isPinned: false,
                                                reportId: FavoriteConstants.cashBalanceId,
                                                reportName: "${widget.favorite?.reportname} Copy",
                                                entity: widget.cashBalanceReportCubit.cashBalanceEntityCubit.state.selectedCashBalanceEntity,
                                                cashBalancePrimaryGrouping: widget.cashBalanceReportCubit.cashBalancePrimaryGroupingCubit.state.selectedGrouping,
                                                cashBalancePrimarySubGrouping: widget.cashBalanceReportCubit.cashBalancePrimarySubGroupingCubit.state.selectedSubGroupingList,
                                                cashAccounts: widget.cashBalanceReportCubit.cashBalanceAccountCubit.state.selectedAccountsList,
                                                numberOfPeriod: widget.cashBalanceReportCubit.cashBalanceNumberOfPeriodCubit.state.selectedCashBalanceNumberOfPeriod,
                                                period: widget.cashBalanceReportCubit.cashBalancePeriodCubit.state.selectedCashBalancePeriod,
                                                currency: widget.cashBalanceReportCubit.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency,
                                                denomination: widget.cashBalanceReportCubit.cashBalanceDenominationCubit.state.selectedCashBalanceDenomination,
                                                asOnDate: widget.cashBalanceReportCubit.cashBalanceAsOnDateCubit.state.asOnDate,
                                              );

                                            } else if (index == 2) {

                                              DeleteFavoriteDialog.show(context: context,
                                              onCancel: (){
                                                Navigator.of(context).pop();
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
                                      )
                                      : null ,
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
                                  if(widget.isSummary && !widget.isFavorite)
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
                    }
                    else if (reportState is CashBalanceReportLoading) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_14.w,),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: !widget.isFavorite && widget.isSummary ?BoxDecoration(
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

                            if(widget.isSummary && !widget.isFavorite)
                              Expanded(
                                  child: LoadingBg(message: Message.loading,)
                              )
                            else
                              LoadingBg(
                                height: widget.isFavorite ? ScreenUtil().screenHeight * 0.25 : ScreenUtil().screenHeight * 0.20,
                                message: Message.loading,
                                menu: widget.isFavorite || widget.isSummary ?
                                CustomPopupMenu(
                                    onSelect: (int index) async {
                                  if (index == 1) {
                                    context
                                        .read<FavoritesCubit>()
                                        .saveFilters(
                                      context: context,
                                      shouldUpdate: false,
                                      isPinned: false,
                                      reportId: FavoriteConstants.cashBalanceId,
                                      reportName: "${widget.favorite?.reportname} Copy",
                                      entity: widget.cashBalanceReportCubit.cashBalanceEntityCubit.state.selectedCashBalanceEntity,
                                      cashBalancePrimaryGrouping: widget.cashBalanceReportCubit.cashBalancePrimaryGroupingCubit.state.selectedGrouping,
                                      cashBalancePrimarySubGrouping: widget.cashBalanceReportCubit.cashBalancePrimarySubGroupingCubit.state.selectedSubGroupingList,
                                      cashAccounts: widget.cashBalanceReportCubit.cashBalanceAccountCubit.state.selectedAccountsList,
                                      numberOfPeriod: widget.cashBalanceReportCubit.cashBalanceNumberOfPeriodCubit.state.selectedCashBalanceNumberOfPeriod,
                                      period: widget.cashBalanceReportCubit.cashBalancePeriodCubit.state.selectedCashBalancePeriod,
                                      currency: widget.cashBalanceReportCubit.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency,
                                      denomination: widget.cashBalanceReportCubit.cashBalanceDenominationCubit.state.selectedCashBalanceDenomination,
                                      asOnDate: widget.cashBalanceReportCubit.cashBalanceAsOnDateCubit.state.asOnDate,
                                    );

                                  } else if (index == 2) {
                                    DeleteFavoriteDialog.show(context: context,
                                    onCancel: (){
                                      Navigator.of(context).pop();
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
                                )
                                    :null,
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
                                if(widget.isSummary && !widget.isFavorite)
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
                    } else if (reportState is CashBalanceReportError) {
                      if (reportState.errorType ==
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
                            if(widget.isSummary && !widget.isFavorite)
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
                                        return CashBalanceFilterModal(
                                          favorite: widget.favorite,
                                          isFavorite: widget.isFavorite,
                                          cashBalanceEntityCubit:
                                          widget.cashBalanceEntityCubit,
                                          cashBalanceLoadingCubit:
                                          widget.cashBalanceLoadingCubit,
                                          cashBalanceSortCubit:
                                          widget.cashBalanceSortCubit,
                                          cashBalancePrimaryGroupingCubit:
                                          widget.cashBalancePrimaryGroupingCubit,
                                          cashBalancePrimarySubGroupingCubit: widget
                                              .cashBalancePrimarySubGroupingCubit,
                                          cashBalanceAsOnDateCubit:
                                          widget.cashBalanceAsOnDateCubit,
                                          cashBalanceCurrencyCubit:
                                          widget.cashBalanceCurrencyCubit,
                                          cashBalanceDenominationCubit:
                                          widget.cashBalanceDenominationCubit,
                                          cashBalanceNumberOfPeriodCubit:
                                          widget.cashBalanceNumberOfPeriodCubit,
                                          cashBalancePeriodCubit:
                                          widget.cashBalancePeriodCubit,
                                          cashBalanceReportCubit:
                                          widget.cashBalanceReportCubit,
                                          cashBalanceAccountCubit:
                                          widget.cashBalanceAccountCubit,
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
                                      return CashBalanceFilterModal(
                                        favorite: widget.favorite,
                                        isFavorite: widget.isFavorite,
                                        cashBalanceEntityCubit:
                                        widget.cashBalanceEntityCubit,
                                        cashBalanceLoadingCubit:
                                        widget.cashBalanceLoadingCubit,
                                        cashBalanceSortCubit:
                                        widget.cashBalanceSortCubit,
                                        cashBalancePrimaryGroupingCubit:
                                        widget.cashBalancePrimaryGroupingCubit,
                                        cashBalancePrimarySubGroupingCubit: widget
                                            .cashBalancePrimarySubGroupingCubit,
                                        cashBalanceAsOnDateCubit:
                                        widget.cashBalanceAsOnDateCubit,
                                        cashBalanceCurrencyCubit:
                                        widget.cashBalanceCurrencyCubit,
                                        cashBalanceDenominationCubit:
                                        widget.cashBalanceDenominationCubit,
                                        cashBalanceNumberOfPeriodCubit:
                                        widget.cashBalanceNumberOfPeriodCubit,
                                        cashBalancePeriodCubit:
                                        widget.cashBalancePeriodCubit,
                                        cashBalanceReportCubit:
                                        widget.cashBalanceReportCubit,
                                        cashBalanceAccountCubit:
                                        widget.cashBalanceAccountCubit,
                                      );
                                    },
                                  );
                                },
                                menu: CustomPopupMenu(
                                    onSelect: (int index) async {
                                  if (index == 1) {
                                    context
                                        .read<FavoritesCubit>()
                                        .saveFilters(
                                      context: context,
                                      shouldUpdate: false,
                                      isPinned: false,
                                      reportId: FavoriteConstants.cashBalanceId,
                                      reportName: "${widget.favorite?.reportname} Copy",
                                      entity: widget.cashBalanceReportCubit.cashBalanceEntityCubit.state.selectedCashBalanceEntity,
                                      cashBalancePrimaryGrouping: widget.cashBalanceReportCubit.cashBalancePrimaryGroupingCubit.state.selectedGrouping,
                                      cashBalancePrimarySubGrouping: widget.cashBalanceReportCubit.cashBalancePrimarySubGroupingCubit.state.selectedSubGroupingList,
                                      cashAccounts: widget.cashBalanceReportCubit.cashBalanceAccountCubit.state.selectedAccountsList,
                                      numberOfPeriod: widget.cashBalanceReportCubit.cashBalanceNumberOfPeriodCubit.state.selectedCashBalanceNumberOfPeriod,
                                      period: widget.cashBalanceReportCubit.cashBalancePeriodCubit.state.selectedCashBalancePeriod,
                                      currency: widget.cashBalanceReportCubit.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency,
                                      denomination: widget.cashBalanceReportCubit.cashBalanceDenominationCubit.state.selectedCashBalanceDenomination,
                                      asOnDate: widget.cashBalanceReportCubit.cashBalanceAsOnDateCubit.state.asOnDate,
                                    );

                                  } else if (index == 2) {

                                    DeleteFavoriteDialog.show(context: context,
                                    onCancel: (){
                                      Navigator.of(context).pop();
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
                                if(widget.isSummary && !widget.isFavorite)
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

                          if(widget.isSummary && !widget.isFavorite)
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
                                    reportId: FavoriteConstants.cashBalanceId,
                                    reportName: "${widget.favorite?.reportname} Copy",
                                    entity: widget.cashBalanceReportCubit.cashBalanceEntityCubit.state.selectedCashBalanceEntity,
                                    cashBalancePrimaryGrouping: widget.cashBalanceReportCubit.cashBalancePrimaryGroupingCubit.state.selectedGrouping,
                                    cashBalancePrimarySubGrouping: widget.cashBalanceReportCubit.cashBalancePrimarySubGroupingCubit.state.selectedSubGroupingList,
                                    cashAccounts: widget.cashBalanceReportCubit.cashBalanceAccountCubit.state.selectedAccountsList,
                                    numberOfPeriod: widget.cashBalanceReportCubit.cashBalanceNumberOfPeriodCubit.state.selectedCashBalanceNumberOfPeriod,
                                    period: widget.cashBalanceReportCubit.cashBalancePeriodCubit.state.selectedCashBalancePeriod,
                                    currency: widget.cashBalanceReportCubit.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency,
                                    denomination: widget.cashBalanceReportCubit.cashBalanceDenominationCubit.state.selectedCashBalanceDenomination,
                                    asOnDate: widget.cashBalanceReportCubit.cashBalanceAsOnDateCubit.state.asOnDate,
                                  );

                                } else if (index == 2) {
                                  DeleteFavoriteDialog.show(context: context,
                                  onCancel: (){
                                    Navigator.of(context).pop();
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
                              if(widget.isSummary && !widget.isFavorite)
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
  }
}


class TextAbbr extends StatefulWidget {
  final void Function(double) setHeight;
  final String text;
  const TextAbbr({super.key,
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
      textAlign:
      TextAlign
          .center,
      style: Theme.of(
          context)
          .textTheme
          .titleSmall
          ?.copyWith(
        color: AppColor.grey,
        fontWeight:
        FontWeight.normal,
      ),
    );
  }
}
