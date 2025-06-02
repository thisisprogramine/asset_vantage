import 'dart:async';

import 'package:asset_vantage/src/config/constants/dashboard.dart';
import 'package:asset_vantage/src/config/constants/size_constants.dart';
import 'package:asset_vantage/src/config/extensions/num_extensions.dart';
import 'package:asset_vantage/src/config/extensions/string_extensions.dart';
import 'package:asset_vantage/src/data/models/dashboard/dashboard_entity_model.dart';
import 'package:asset_vantage/src/domain/entities/app_error.dart';
import 'package:asset_vantage/src/presentation/arguments/net_worth_argument.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_as_on_date/net_worth_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_currency/net_worth_currency_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_denomination/net_worth_denomination_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_entity/net_worth_entity_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_return_percent/net_worth_return_percent_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/networth_holding_method/networth_holding_method_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/networth_partnership_method/networth_partnership_method_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/stealth/stealth_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/universal_filter/enitity_universal_filter/universal_entity_filter_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/universal_filter/favourite_as_on_date_universal_filter/favourite_universal_filter_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/screens/dashboard/net_worth_summary/net_worth_filter_modal.dart';
import 'package:asset_vantage/src/presentation/theme/theme_color.dart';
import 'package:asset_vantage/src/presentation/widgets/custom_popup_menu.dart';
import 'package:asset_vantage/src/presentation/widgets/delete_favorite_dialog.dart';
import 'package:asset_vantage/src/presentation/widgets/entity_asondate_label.dart';
import 'package:asset_vantage/src/presentation/widgets/filter_icon.dart';
import 'package:asset_vantage/src/utilities/helper/ui_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:shimmer/shimmer.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../../config/constants/favorite_constants.dart';
import '../../../../config/constants/strings_constants.dart';
import '../../../../domain/entities/authentication/user_entity.dart';
import '../../../../domain/entities/favorites/favorites_entity.dart';
import '../../../../domain/entities/net_worth/net_worth_chart_data.dart';
import '../../../../utilities/helper/app_helper.dart';
import '../../../../utilities/helper/flash_helper.dart';
import '../../../blocs/authentication/user/user_cubit.dart';
import '../../../blocs/currency_filter/currency_filter_cubit.dart';
import '../../../blocs/favorites/favorites_cubit.dart';
import '../../../blocs/net_worth/net_worth_grouping/net_worth_grouping_cubit.dart';
import '../../../blocs/net_worth/net_worth_loading/net_worth_loading_cubit.dart';
import '../../../blocs/net_worth/net_worth_number_of_period/net_worth_number_of_period_cubit.dart';
import '../../../blocs/net_worth/net_worth_period/net_worth_period_cubit.dart';
import '../../../blocs/net_worth/net_worth_report/net_worth_report_cubit.dart';
import '../../../blocs/net_worth/net_worth_sub_grouping/net_worth_sub_grouping_cubit.dart';
import '../../../blocs/universal_filter/as_on_date_universal_filter/universal_filter_as_on_date_cubit.dart';
import '../../../widgets/EditableTitle.dart';
import '../../../widgets/blue_dot_icon.dart';
import '../../../widgets/editable_title_row.dart';
import '../../../widgets/favorite_icon.dart';
import '../../../widgets/filter_personalization_hint.dart';
import '../../../widgets/loading_widgets/loading_bg.dart';
import '../../../widgets/loading_widgets/net_worth_loader.dart';

typedef ChildFunction = void Function(
    BuildContext, void Function() resetFilters);

class NetWorthSummaryChartWidget extends StatefulWidget {
  final bool isFavorite;
  final Favorite? favorite;
  final NetWorthEntityCubit netWorthEntityCubit;
  final NetWorthGroupingCubit netWorthGroupingCubit;
  final NetWorthPrimarySubGroupingCubit netWorthPrimarySubGroupingCubit;
  final NetWorthPeriodCubit netWorthPeriodCubit;
  final NetWorthNumberOfPeriodCubit netWorthNumberOfPeriodCubit;
  final NetWorthPartnershipMethodCubit netWorthPartnershipMethodCubit;
  final NetWorthHoldingMethodCubit netWorthHoldingMethodCubit;
  final NetWorthReturnPercentCubit netWorthReturnPercentCubit;
  final NetWorthCurrencyCubit netWorthCurrencyCubit;
  final NetWorthDenominationCubit netWorthDenominationCubit;
  final NetWorthAsOnDateCubit netWorthAsOnDateCubit;
  final NetWorthLoadingCubit netWorthLoadingCubit;
  final NetWorthReportCubit netWorthReportCubit;
  final UniversalEntityFilterCubit universalEntityFilterCubit;
  final UniversalFilterAsOnDateCubit universalFilterAsOnDateCubit;
  final FavouriteUniversalFilterAsOnDateCubit favouriteUniversalFilterAsOnDateCubit;
  const NetWorthSummaryChartWidget({
    super.key,
    this.isFavorite = false,
    this.favorite,
    required this.universalFilterAsOnDateCubit,
    required this.universalEntityFilterCubit,
    required this.netWorthAsOnDateCubit,
    required this.netWorthReportCubit,
    required this.netWorthDenominationCubit,
    required this.netWorthCurrencyCubit,
    required this.netWorthReturnPercentCubit,
    required this.netWorthNumberOfPeriodCubit,
    required this.netWorthPeriodCubit,
    required this.netWorthPrimarySubGroupingCubit,
    required this.netWorthGroupingCubit,
    required this.netWorthEntityCubit,
    required this.netWorthLoadingCubit,
    required this.favouriteUniversalFilterAsOnDateCubit,
    required this.netWorthPartnershipMethodCubit,
    required this.netWorthHoldingMethodCubit,
  });

  @override
  State<NetWorthSummaryChartWidget> createState() =>
      _NetWorthSummaryChartWidgetState();
}

class _NetWorthSummaryChartWidgetState
    extends State<NetWorthSummaryChartWidget> {
  bool canEdit = false;
  List<NetWorthChartData>? chartData;
  int? activeIndex;
  int currentPageIndex = 0;
  int periodItemVal = 0;
  final numberOfItemScalable =
      ((((ScreenUtil().screenWidth) - (Sizes.dimen_14.r + Sizes.dimen_10.w)) /
                  Sizes.dimen_100.w)
              .toInt()) *
          2;
  final PageController _pageController = PageController();
  late void Function() resetFilterChild;
  double height = (Sizes.dimen_38) * 2 + Sizes.dimen_14.w;
  double textAbbrHeight = Sizes.dimen_10.h;

  void setChildHeight(double newHeight) => setState(() {
        height = newHeight;
      });

  void setAbbrHeight(double newHeight) => setState(() {
    textAbbrHeight = newHeight;
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: widget.netWorthDenominationCubit,
        ),
        BlocProvider.value(
          value: widget.netWorthGroupingCubit,
        ),
        BlocProvider.value(
          value: widget.netWorthReturnPercentCubit,
        ),
        BlocProvider.value(
          value: widget.netWorthLoadingCubit,
        ),
        BlocProvider.value(
          value: widget.netWorthAsOnDateCubit,
        ),
        BlocProvider.value(
          value: widget.netWorthEntityCubit,
        ),
        BlocProvider.value(
          value: widget.netWorthCurrencyCubit,
        ),
        BlocProvider.value(
          value: widget.netWorthNumberOfPeriodCubit,
        ),
        BlocProvider.value(
          value: widget.netWorthPeriodCubit,
        ),
        BlocProvider.value(
          value: widget.netWorthPrimarySubGroupingCubit,
        ),
        BlocProvider.value(
          value: widget.netWorthReportCubit,
        ),
      ],
      child: BlocBuilder<StealthCubit, bool>(builder: (context, stealthValue) {
        return Container(

          child: Container(

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [


                BlocBuilder<NetWorthReportCubit, NetWorthReportState>(
                    bloc: widget.netWorthReportCubit,
                    builder: (context, state) {
                      return BlocBuilder<NetWorthDenominationCubit,
                              NetWorthDenominationState>(
                          bloc: widget.netWorthDenominationCubit,
                          builder: (context, denominationState) {
                            return BlocBuilder<NetWorthCurrencyCubit,
                                    NetWorthCurrencyState>(
                                bloc: widget.netWorthCurrencyCubit,
                                builder: (context, currencyState) {
                                  if (state is NetWorthReportLoaded) {
                                    return BlocBuilder<
                                            NetWorthNumberOfPeriodCubit,
                                            NetWorthNumberOfPeriodState>(
                                        builder: (context, periodState) {

                                      if(state.chartData.isNotEmpty) {
                                        chartData = state.chartData.sublist(
                                            state.chartData.length -
                                                (periodState
                                                    .selectedNetWorthNumberOfPeriod
                                                    ?.value ??
                                                    0),
                                            state.chartData.length);
                                        if (periodItemVal !=
                                            periodState
                                                .selectedNetWorthNumberOfPeriod
                                                ?.value) {
                                          activeIndex = chartData!.length - 1;
                                        }
                                        periodItemVal = periodState
                                            .selectedNetWorthNumberOfPeriod
                                            ?.value ??
                                            0;
                                        int greatestMarketValue =
                                        AppHelpers.getNetWorthGreaterValue(
                                            netWorthList: chartData!);
                                        return Padding(
                                          padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_11.w,),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                decoration: !widget.isFavorite ? BoxDecoration(
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
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [

                                                    SizedBox.shrink(),

                                                    if(!widget.isFavorite)
                                                      Flexible(
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Flexible(
                                                              child: Column(
                                                                children: [
                                                                  ...[
                                                                    BlocBuilder<UserCubit, UserEntity?>(
                                                                        builder: (context, user) {
                                                                          return BlocBuilder<NetWorthEntityCubit, NetWorthEntityState>(
                                                                              builder: (context, entityState) {
                                                                                return BlocBuilder<NetWorthAsOnDateCubit, NetWorthAsOnDateState>(
                                                                                    builder: (context, asOnDate) {
                                                                                      return Row(
                                                                                        children: [
                                                                                          if(entityState.selectedNetWorthEntity?.id != widget.universalEntityFilterCubit.state.selectedUniversalEntity?.id ||
                                                                                              !((entityState.selectedNetWorthEntity?.type?.contains(widget.universalEntityFilterCubit.state.selectedUniversalEntity?.type ?? 'None') ?? true))
                                                                                          )
                                                                                            ...[

                                                                                              EntityAsonDateLabels(text: "${entityState.selectedNetWorthEntity?.name}"),
                                                                                              UIHelper.horizontalSpaceSmall
                                                                                            ],
                                                                                          if(!(asOnDate.asOnDate?.contains(widget.universalFilterAsOnDateCubit.state.asOnDate ?? "None") ?? true))

                                                                                            EntityAsonDateLabels(text: DateFormat(user?.dateFormat ?? 'dd MMM yyyy').format(DateTime.parse(asOnDate.asOnDate ?? DateTime.now().toString()))),

                                                                                          if((asOnDate.asOnDate?.contains(widget.universalFilterAsOnDateCubit.state.asOnDate ?? "None") ?? true) && !(entityState.selectedNetWorthEntity?.id != widget.universalEntityFilterCubit.state.selectedUniversalEntity?.id ||
                                                                                              !((entityState.selectedNetWorthEntity?.type?.contains(widget.universalEntityFilterCubit.state.selectedUniversalEntity?.type ?? 'None') ?? true))))
                                                                                            Column(
                                                                                              children: [

                                                                                                const FilterPersonalizationHint(),
                                                                                                UIHelper.verticalSpace(Sizes.dimen_2.h),
                                                                                              ],
                                                                                            ),
                                                                                        ],
                                                                                      );
                                                                                    }
                                                                                );
                                                                              }
                                                                          );
                                                                        }
                                                                    ),
                                                                  ],
                                                                  Row(
                                                                    children: [
                                                                      Text(StringConstants.netWorthFilterHeader, style: Theme.of(context).textTheme.titleSmall,),
                                                                      UIHelper.horizontalSpaceSmall,
                                                                      Expanded(
                                                                        child: Text(
                                                                          (chartData![activeIndex!]
                                                                              .closingValue <
                                                                              0
                                                                              ? "${NumberFormat.simpleCurrency(name: context.read<NetWorthCurrencyCubit>().state.selectedNetWorthCurrency?.code).currencySymbol} (${NumberFormat(context.read<NetWorthCurrencyCubit>().state.selectedNetWorthCurrency?.format ?? '###,###,##0.00').format(chartData![activeIndex!].closingValue.denominate(denominator: denominationState.selectedNetWorthDenomination?.denomination))}${denominationState.selectedNetWorthDenomination?.suffix})"
                                                                              .stealth(
                                                                              stealthValue)
                                                                              : "${NumberFormat.simpleCurrency(name: context.read<NetWorthCurrencyCubit>().state.selectedNetWorthCurrency?.code).currencySymbol} ${NumberFormat(context.read<NetWorthCurrencyCubit>().state.selectedNetWorthCurrency?.format ?? '###,###,##0.00').format(chartData![activeIndex!].closingValue.denominate(denominator: denominationState.selectedNetWorthDenomination?.denomination))}${denominationState.selectedNetWorthDenomination?.suffix}")
                                                                              .stealth(stealthValue),
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .titleLarge
                                                                              ?.copyWith(
                                                                              color: chartData![
                                                                              activeIndex!]
                                                                                  .closingValue <
                                                                                  0
                                                                                  ? AppColor.red
                                                                                  : AppColor
                                                                                  .textGrey,
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .bold),
                                                                          maxLines: 1,
                                                                          overflow: TextOverflow.ellipsis,
                                                                        ),
                                                                      ),

                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            BlocBuilder<NetWorthEntityCubit, NetWorthEntityState>(
                                                                builder: (context, entityState) {
                                                                  return BlocBuilder<NetWorthAsOnDateCubit, NetWorthAsOnDateState>(
                                                                      builder: (context, asOnDate) {
                                                                        return GestureDetector(
                                                                          onTap: () async {
                                                                            showModalBottomSheet(
                                                                              context: context,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.only(
                                                                                  topLeft: Radius.circular(Sizes.dimen_10.r),
                                                                                  topRight: Radius.circular(Sizes.dimen_10.r),
                                                                                ),
                                                                              ),
                                                                              isScrollControlled: true,
                                                                              builder: (context) {
                                                                                return NetWorthFilterModalSheet(
                                                                                  isFavorite: widget.isFavorite,
                                                                                  favorite: widget.favorite,
                                                                                  favoritesCubit: context.read<FavoritesCubit>(),
                                                                                  netWorthGroupingCubit:
                                                                                  widget.netWorthGroupingCubit,
                                                                                  netWorthReturnPercentCubit:
                                                                                  widget.netWorthReturnPercentCubit,
                                                                                  netWorthPrimarySubGroupingCubit:
                                                                                  widget.netWorthPrimarySubGroupingCubit,
                                                                                  netWorthNumberOfPeriodCubit:
                                                                                  widget.netWorthNumberOfPeriodCubit,
                                                                                  netWorthLoadingCubit: widget.netWorthLoadingCubit,
                                                                                  netWorthEntityCubit: widget.netWorthEntityCubit,
                                                                                  netWorthDenominationCubit:
                                                                                  widget.netWorthDenominationCubit,
                                                                                  netWorthReportCubit: widget.netWorthReportCubit,
                                                                                  netWorthAsOnDateCubit:
                                                                                  widget.netWorthAsOnDateCubit,
                                                                                  netWorthCurrencyCubit:
                                                                                  widget.netWorthCurrencyCubit,
                                                                                  netWorthPeriodCubit: widget.netWorthPeriodCubit,
                                                                                  netWorthPartnershipMethodCubit: widget.netWorthPartnershipMethodCubit,
                                                                                  netWorthHoldingMethodCubit: widget.netWorthHoldingMethodCubit,
                                                                                );
                                                                              },
                                                                            );
                                                                          },
                                                                          child: Stack(
                                                                            children: [
                                                                              if(!((asOnDate.asOnDate?.contains(widget.universalFilterAsOnDateCubit.state.asOnDate ?? "None") ?? true) && !(entityState.selectedNetWorthEntity?.id != widget.universalEntityFilterCubit.state.selectedUniversalEntity?.id ||
                                                                                  !((entityState.selectedNetWorthEntity?.type?.contains(widget.universalEntityFilterCubit.state.selectedUniversalEntity?.type ?? 'None') ?? true)))))

                                                                                 const BlueDotIcon(),

                                                                              const FilterIcon()
                                                                            ],
                                                                          ),
                                                                        );
                                                                      }
                                                                  );
                                                                }
                                                            ),
                                                            SizedBox(width: Sizes.dimen_4.h,),

                                                          ],
                                                        ),
                                                      )
                                                    else
                                                      ...[
                                                        UIHelper.verticalSpace(Sizes.dimen_2.h),
                                                        Flexible(
                                                          child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        BlocBuilder<FavoritesCubit, FavoritesState>(
                                                                            builder: (context, favoriteState) {
                                                                              return Flexible(
                                                                                child:  EditableTitleRow(
                                                                                  isNetworth:true,
                                                                                  canEdit: canEdit,
                                                                                  favorite: widget.favorite,
                                                                                  title: widget.favorite?.reportname,
                                                                                  onEditComplete: () {
                                                                                    setState((){
                                                                                      canEdit = false;
                                                                                    });
                                                                                  },
                                                                                  isFav: widget.isFavorite,
                                                                                  defaultTitle: "Networth",
                                                                                  onEditToggle: () {
                                                                                    setState((){
                                                                                      canEdit = !canEdit;
                                                                                    });
                                                                                  },

                                                                                ),

                                                                              );

                                                                            }
                                                                        )
                                                                      ],
                                                                    ),
                                                                    BlocBuilder<UserCubit, UserEntity?>(
                                                                        builder: (context, user) {
                                                                          return BlocBuilder<NetWorthEntityCubit, NetWorthEntityState>(
                                                                              builder: (context, entityState) {
                                                                                return BlocBuilder<NetWorthAsOnDateCubit, NetWorthAsOnDateState>(
                                                                                    builder: (context, asOnDate) {

                                                                                      return Row(
                                                                                        children: [

                                                                                          EntityAsonDateLabels(text: "${entityState.selectedNetWorthEntity?.name}"),
                                                                                          UIHelper.horizontalSpaceSmall,

                                                                                          if(!(asOnDate.asOnDate?.contains(widget.favouriteUniversalFilterAsOnDateCubit.state.asOnDate ?? "None") ?? true))

                                                                                            EntityAsonDateLabels(text: DateFormat(user?.dateFormat ?? 'dd MMM yyyy').format(DateTime.parse(asOnDate.asOnDate ?? DateTime.now().toString())))
                                                                                        ],
                                                                                      );
                                                                                    }
                                                                                );
                                                                              }
                                                                          );
                                                                        }
                                                                    ),
                                                                    Text(
                                                                      (chartData![activeIndex!]
                                                                          .closingValue <
                                                                          0
                                                                          ? "${NumberFormat.simpleCurrency(name: context.read<NetWorthCurrencyCubit>().state.selectedNetWorthCurrency?.code).currencySymbol} (${NumberFormat(context.read<NetWorthCurrencyCubit>().state.selectedNetWorthCurrency?.format ?? '###,###,##0.00').format(chartData![activeIndex!].closingValue.denominate(denominator: denominationState.selectedNetWorthDenomination?.denomination))}${denominationState.selectedNetWorthDenomination?.suffix})"
                                                                          .stealth(
                                                                          stealthValue)
                                                                          : "${NumberFormat.simpleCurrency(name: context.read<NetWorthCurrencyCubit>().state.selectedNetWorthCurrency?.code).currencySymbol} ${NumberFormat(context.read<NetWorthCurrencyCubit>().state.selectedNetWorthCurrency?.format ?? '###,###,##0.00').format(chartData![activeIndex!].closingValue.denominate(denominator: denominationState.selectedNetWorthDenomination?.denomination))}${denominationState.selectedNetWorthDenomination?.suffix}")
                                                                          .stealth(stealthValue),
                                                                      style: Theme.of(context)
                                                                          .textTheme
                                                                          .titleLarge
                                                                          ?.copyWith(
                                                                          color: chartData![
                                                                          activeIndex!]
                                                                              .closingValue <
                                                                              0
                                                                              ? AppColor.red
                                                                              : AppColor
                                                                              .textGrey,
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),


                                                                  ],
                                                                ),
                                                              ),

                                                              CustomPopupMenu(
                                                                isNetWorth:true,
                                                                onSelect: (int index) async {
                                                                if (index == 1) {
                                                                  context
                                                                      .read<FavoritesCubit>()
                                                                      .saveFilters(
                                                                    context: context,
                                                                    shouldUpdate: false,
                                                                    isPinned: false,
                                                                    reportId: FavoriteConstants.netWorthId,
                                                                    reportName: "${widget.favorite?.reportname} Copy",
                                                                    entity: widget.netWorthReportCubit.netWorthEntityCubit.state.selectedNetWorthEntity,
                                                                    netWorthPrimaryGrouping: widget.netWorthReportCubit.netWorthPrimaryGroupingCubit.state.selectedGrouping,
                                                                    netWorthPrimarySubGrouping: widget.netWorthReportCubit.netWorthPrimarySubGroupingCubit.state.selectedSubGroupingList,
                                                                    numberOfPeriod: widget.netWorthReportCubit.netWorthNumberOfPeriodCubit.state.selectedNetWorthNumberOfPeriod,
                                                                    period: widget.netWorthReportCubit.netWorthPeriodCubit.state.selectedNetWorthPeriod,
                                                                    currency: widget.netWorthReportCubit.netWorthCurrencyCubit.state.selectedNetWorthCurrency,
                                                                    denomination: widget.netWorthReportCubit.netWorthDenominationCubit.state.selectedNetWorthDenomination,
                                                                    asOnDate: widget.netWorthReportCubit.netWorthAsOnDateCubit.state.asOnDate,
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
                                                                        print("ONE");
                                                                        Navigator.of(context).pop();
                                                                      });
                                                                }
                                                              },),
                                                              SizedBox(width:Sizes.dimen_12.w),
                                                              SizedBox(height: Sizes.dimen_9.h,),
                                                              GestureDetector(
                                                                onTap: () async {
                                                                  showModalBottomSheet(
                                                                    context: context,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.only(
                                                                        topLeft: Radius.circular(Sizes.dimen_10.r),
                                                                        topRight: Radius.circular(Sizes.dimen_10.r),
                                                                      ),
                                                                    ),
                                                                    isScrollControlled: true,
                                                                    builder: (context) {
                                                                      return NetWorthFilterModalSheet(
                                                                        isFavorite: widget.isFavorite,
                                                                        favorite: widget.favorite,
                                                                        favoritesCubit: context.read<FavoritesCubit>(),
                                                                        netWorthGroupingCubit:
                                                                        widget.netWorthGroupingCubit,
                                                                        netWorthReturnPercentCubit:
                                                                        widget.netWorthReturnPercentCubit,
                                                                        netWorthPrimarySubGroupingCubit:
                                                                        widget.netWorthPrimarySubGroupingCubit,
                                                                        netWorthNumberOfPeriodCubit:
                                                                        widget.netWorthNumberOfPeriodCubit,
                                                                        netWorthLoadingCubit: widget.netWorthLoadingCubit,
                                                                        netWorthEntityCubit: widget.netWorthEntityCubit,
                                                                        netWorthDenominationCubit:
                                                                        widget.netWorthDenominationCubit,
                                                                        netWorthReportCubit: widget.netWorthReportCubit,
                                                                        netWorthAsOnDateCubit:
                                                                        widget.netWorthAsOnDateCubit,
                                                                        netWorthCurrencyCubit:
                                                                        widget.netWorthCurrencyCubit,
                                                                        netWorthPeriodCubit: widget.netWorthPeriodCubit,
                                                                        netWorthPartnershipMethodCubit: widget.netWorthPartnershipMethodCubit,
                                                                        netWorthHoldingMethodCubit: widget.netWorthHoldingMethodCubit,
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child: const FilterIcon(isNetworthFav: true,)


                                                              ),
                                                              SizedBox(width: Sizes.dimen_2.w,)
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    BlocBuilder<NetWorthReturnPercentCubit, NetWorthReturnPercentState>(
                                                        bloc: widget
                                                            .netWorthReturnPercentCubit,
                                                        builder: (context,
                                                            returnPercent) {
                                                          if (returnPercent
                                                              .selectedNetWorthReturnPercent
                                                              ?.value ==
                                                              0 ||
                                                              (returnPercent
                                                                  .selectedNetWorthReturnPercent
                                                                  ?.value ==
                                                                  2 &&
                                                                  chartData?[activeIndex!]
                                                                      .inceptionIrrPercent ==
                                                                      null) ||
                                                              (returnPercent
                                                                  .selectedNetWorthReturnPercent
                                                                  ?.value ==
                                                                  3 &&
                                                                  chartData?[activeIndex!]
                                                                      .periodTWRPercent ==
                                                                      null)) {
                                                            return const SizedBox
                                                                .shrink();
                                                          }
                                                          return returnPercent.selectedNetWorthReturnPercent?.name != null
                                                              ? Row(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                            children: [
                                                              Text(
                                                                "${returnPercent.selectedNetWorthReturnPercent?.name} ${returnPercent.selectedNetWorthReturnPercent?.id == "inc_xirr" ? ((chartData?[activeIndex!].inceptionIrrPercent ?? 0) > 0 ? (chartData?[activeIndex!].inceptionIrrPercent?.abs().toStringAsFixed(2)) : '(${(chartData?[activeIndex!].inceptionIrrPercent ?? 0).abs().toStringAsFixed(2)})') : ((chartData?[activeIndex!].periodTWRPercent ?? 0) > 0 ? (chartData?[activeIndex!].periodTWRPercent?.abs().toStringAsFixed(2)) : '(${(chartData?[activeIndex!].periodTWRPercent ?? 0).abs().toStringAsFixed(2)})')}%",
                                                                style: Theme.of(
                                                                    context)
                                                                    .textTheme
                                                                    .bodyLarge
                                                                    ?.copyWith(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                                ),
                                                              ),
                                                              UIHelper
                                                                  .horizontalSpace(
                                                                  Sizes.dimen_6
                                                                      .w),
                                                              ((returnPercent.selectedNetWorthReturnPercent?.id ==
                                                                  "inc_xirr"
                                                                  ? (chartData?[activeIndex!]
                                                                  .inceptionIrrPercent)
                                                                  : (chartData?[activeIndex!]
                                                                  .periodTWRPercent)) ??
                                                                  0) >=
                                                                  0.0
                                                                  ? Icon(
                                                                CupertinoIcons
                                                                    .triangle_fill,
                                                                size: Sizes
                                                                    .dimen_9
                                                                    .sp,
                                                                color: AppColor
                                                                    .green,
                                                              )
                                                                  : RotatedBox(
                                                                quarterTurns:
                                                                2,
                                                                child: Icon(
                                                                  CupertinoIcons
                                                                      .triangle_fill,
                                                                  size: Sizes
                                                                      .dimen_9
                                                                      .sp,
                                                                  color:
                                                                  AppColor
                                                                      .red,
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                              : const SizedBox.shrink();
                                                        }),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: (ScreenUtil().screenHeight *
                                                    0.28) *
                                                    0.69+textAbbrHeight,
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  alignment: Alignment.bottomCenter,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                        bottom: textAbbrHeight,
                                                      ),
                                                      decoration:
                                                      const BoxDecoration(

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
                                                            8,
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
                                                      height: ((ScreenUtil()
                                                          .screenHeight *
                                                          0.28) *
                                                          0.69)+textAbbrHeight -
                                                          Sizes.dimen_8.w,
                                                      width: (ScreenUtil()
                                                          .screenWidth) -
                                                          (Sizes.dimen_32.r +
                                                              Sizes.dimen_32.w),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: List.generate(
                                                          chartData!.length,
                                                              (index) {
                                                            NetWorthChartData
                                                            currentMap =
                                                            chartData![index];
                                                            return Expanded(
                                                              child: Row(
                                                                children: [
                                                                  !([
                                                                    11,
                                                                    12
                                                                  ].contains(periodState
                                                                      .selectedNetWorthNumberOfPeriod
                                                                      ?.value ??
                                                                      -1))
                                                                      ? Expanded(
                                                                    child:
                                                                    Container(),
                                                                  )
                                                                      : const SizedBox
                                                                      .shrink(),
                                                                  SizedBox(
                                                                    width: (periodState.selectedNetWorthNumberOfPeriod?.value ??
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
                                                                            children: [
                                                                              GestureDetector(
                                                                                onTap:
                                                                                    () {
                                                                                  activeIndex = index;
                                                                                  currentPageIndex = 0;
                                                                                  _pageController.animateToPage(
                                                                                    0,
                                                                                    duration: const Duration(milliseconds: 100),
                                                                                    curve: Curves.easeIn,
                                                                                  );
                                                                                  setState(() {});
                                                                                },
                                                                                child:
                                                                                AnimatedOpacity(
                                                                                  opacity: index == activeIndex ? 1 : 0.4,
                                                                                  duration: const Duration(milliseconds: 300),
                                                                                  curve: Curves.easeIn,
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Expanded(
                                                                                        flex: greatestMarketValue - currentMap.closingValue.toInt(),
                                                                                        child: Container(
                                                                                          color: AppColor.transparent,
                                                                                        ),
                                                                                      ),
                                                                                      ...currentMap.children!
                                                                                          .map((e) {
                                                                                        final colorList = DashBoardNetWorthChartBarColors.getColorScheme(currentMap.children!.length);
                                                                                        final currInd = currentMap.children!.indexOf(e);
                                                                                        return Expanded(
                                                                                          flex: e.closingValue < 0 ? 0 : e.closingValue.toInt(),
                                                                                          child: Container(
                                                                                            color: Color(int.parse("0xFF${colorList[currInd > colorList.length - 1 ? currInd % colorList.length : currInd]}")),
                                                                                          ),
                                                                                        );
                                                                                      })
                                                                                          .toList()
                                                                                          .reversed,
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
                                                                        TextAbbr(setHeight: setAbbrHeight, text: AppHelpers
                                                                            .getNetWorthMonthAbbreviation(
                                                                          date:
                                                                          currentMap.endDate,
                                                                          length: (periodState.selectedNetWorthNumberOfPeriod?.value ?? -1) <= 6
                                                                              ? 3
                                                                              : 1,
                                                                        ),)
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
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Flexible(
                                                    child: Container(
                                                      alignment:
                                                      Alignment.centerLeft,
                                                      margin: EdgeInsets.symmetric(
                                                          vertical:
                                                          Sizes.dimen_6.h),
                                                      child: BlocBuilder<UserCubit,
                                                          UserEntity?>(
                                                          builder: (context, user) {
                                                            return Text(
                                                              "Effective Date:  ${DateFormat(user?.dateFormat ?? 'yyyy-MM-dd').format(DateTime.parse(chartData![activeIndex!].endDate))}",
                                                              style: Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge
                                                                  ?.copyWith(
                                                                fontWeight: FontWeight.bold,
                                                                height: 1,
                                                                overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                              ),
                                                            );
                                                          }),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: (height) * 2.4 +
                                                              Sizes.dimen_14.w,
                                                          child: RawScrollbar(
                                                            controller: _pageController,
                                                            thickness: Sizes.dimen_2,
                                                            radius: const Radius.circular(Sizes.dimen_10),
                                                            notificationPredicate: (notification) => true,
                                                            thumbVisibility: true,
                                                            trackVisibility: true,
                                                            interactive: true,
                                                            thumbColor: AppColor.grey,
                                                            trackColor: AppColor.grey.withValues(alpha: 0.2),
                                                            child: PageView(
                                                              controller: _pageController,
                                                              scrollDirection:
                                                              Axis.vertical,
                                                              onPageChanged: (value) =>
                                                                  setState(() {
                                                                    currentPageIndex = value;
                                                                  }),
                                                              children: List.generate(
                                                                  (chartData![activeIndex!]
                                                                      .children!
                                                                      .length %
                                                                      numberOfItemScalable !=
                                                                      0
                                                                      ? (chartData![activeIndex!]
                                                                      .children!
                                                                      .length ~/
                                                                      numberOfItemScalable) +
                                                                      1
                                                                      : chartData![
                                                                  activeIndex!]
                                                                      .children!
                                                                      .length ~/
                                                                      numberOfItemScalable),
                                                                      (index) {
                                                                    return Wrap(
                                                                      spacing: Sizes.dimen_20.w,
                                                                      runSpacing:
                                                                      Sizes.dimen_16.w,
                                                                      children: chartData![
                                                                      activeIndex!]
                                                                          .children!
                                                                          .sublist(
                                                                          index == 0
                                                                              ? index
                                                                              : (index *
                                                                              numberOfItemScalable),
                                                                          ((index + 1) *
                                                                              numberOfItemScalable) >
                                                                              chartData![
                                                                              activeIndex!]
                                                                                  .children!
                                                                                  .length
                                                                              ? null
                                                                              : ((index +
                                                                              1) *
                                                                              numberOfItemScalable))
                                                                          .map((e) {
                                                                        final List<String>
                                                                        colorList =
                                                                        DashBoardNetWorthChartBarColors
                                                                            .getColorScheme(
                                                                            chartData![
                                                                            activeIndex!]
                                                                                .children!
                                                                                .length);
                                                                        final currInd =
                                                                        chartData![
                                                                        activeIndex!]
                                                                            .children!
                                                                            .indexOf(e);
                                                                        return ChildItemWithTooltip(
                                                                          colorList: colorList,
                                                                          currInd: currInd,
                                                                          stealthValue:
                                                                          stealthValue,
                                                                          denominationState:
                                                                          denominationState,
                                                                          e: e,
                                                                          setHeight:
                                                                          setChildHeight,
                                                                        );
                                                                      }).toList(),
                                                                    );
                                                                  }),
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                ],
                                              ),
                                              if(widget.isFavorite)
                                                UIHelper.verticalSpaceSmall
                                            ],
                                          ),
                                        );
                                      }else {
                                        return widget.isFavorite
                                            ? NetWorthLoader(
                                          isFavorite: widget.isFavorite,
                                          isError: true,
                                          noPositionFound: true,
                                          menu: CustomPopupMenu(
                                            isLoading:true,
                                            onSelect: (int index) async {
                                            if (index == 1) {
                                              context
                                                  .read<FavoritesCubit>()
                                                  .saveFilters(
                                                context: context,
                                                shouldUpdate: false,
                                                isPinned: false,
                                                reportId: FavoriteConstants.netWorthId,
                                                reportName: "${widget.favorite?.reportname} Copy",
                                                entity: widget.netWorthReportCubit.netWorthEntityCubit.state.selectedNetWorthEntity,
                                                netWorthPrimaryGrouping: widget.netWorthReportCubit.netWorthPrimaryGroupingCubit.state.selectedGrouping,
                                                netWorthPrimarySubGrouping: widget.netWorthReportCubit.netWorthPrimarySubGroupingCubit.state.selectedSubGroupingList,
                                                numberOfPeriod: widget.netWorthReportCubit.netWorthNumberOfPeriodCubit.state.selectedNetWorthNumberOfPeriod,
                                                period: widget.netWorthReportCubit.netWorthPeriodCubit.state.selectedNetWorthPeriod,
                                                currency: widget.netWorthReportCubit.netWorthCurrencyCubit.state.selectedNetWorthCurrency,
                                                denomination: widget.netWorthReportCubit.netWorthDenominationCubit.state.selectedNetWorthDenomination,
                                                asOnDate: widget.netWorthReportCubit.netWorthAsOnDateCubit.state.asOnDate,
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
                                          },),
                                          onRetry: () {
                                            showModalBottomSheet(
                                              context: context,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(Sizes.dimen_10.r),
                                                  topRight: Radius.circular(Sizes.dimen_10.r),
                                                ),
                                              ),
                                              isScrollControlled: true,
                                              builder: (context) {
                                                return NetWorthFilterModalSheet(
                                                  isFavorite: widget.isFavorite,
                                                  favorite: widget.favorite,
                                                  favoritesCubit: context.read<FavoritesCubit>(),
                                                  netWorthGroupingCubit:
                                                  widget.netWorthGroupingCubit,
                                                  netWorthReturnPercentCubit:
                                                  widget.netWorthReturnPercentCubit,
                                                  netWorthPrimarySubGroupingCubit:
                                                  widget.netWorthPrimarySubGroupingCubit,
                                                  netWorthNumberOfPeriodCubit:
                                                  widget.netWorthNumberOfPeriodCubit,
                                                  netWorthLoadingCubit: widget.netWorthLoadingCubit,
                                                  netWorthEntityCubit: widget.netWorthEntityCubit,
                                                  netWorthDenominationCubit:
                                                  widget.netWorthDenominationCubit,
                                                  netWorthReportCubit: widget.netWorthReportCubit,
                                                  netWorthAsOnDateCubit:
                                                  widget.netWorthAsOnDateCubit,
                                                  netWorthCurrencyCubit:
                                                  widget.netWorthCurrencyCubit,
                                                  netWorthPeriodCubit: widget.netWorthPeriodCubit,
                                                  netWorthPartnershipMethodCubit: widget.netWorthPartnershipMethodCubit,
                                                  netWorthHoldingMethodCubit: widget.netWorthHoldingMethodCubit,
                                                );
                                              },
                                            );
                                          },
                                        )
                                            : Expanded(child: NetWorthLoader(
                                          isFavorite: widget.isFavorite,
                                          isError: true,
                                          noPositionFound: true,
                                          onRetry: () {
                                            showModalBottomSheet(
                                              context: context,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(Sizes.dimen_10.r),
                                                  topRight: Radius.circular(Sizes.dimen_10.r),
                                                ),
                                              ),
                                              isScrollControlled: true,
                                              builder: (context) {
                                                return NetWorthFilterModalSheet(
                                                  isFavorite: widget.isFavorite,
                                                  favorite: widget.favorite,
                                                  favoritesCubit: context.read<FavoritesCubit>(),
                                                  netWorthGroupingCubit:
                                                  widget.netWorthGroupingCubit,
                                                  netWorthReturnPercentCubit:
                                                  widget.netWorthReturnPercentCubit,
                                                  netWorthPrimarySubGroupingCubit:
                                                  widget.netWorthPrimarySubGroupingCubit,
                                                  netWorthNumberOfPeriodCubit:
                                                  widget.netWorthNumberOfPeriodCubit,
                                                  netWorthLoadingCubit: widget.netWorthLoadingCubit,
                                                  netWorthEntityCubit: widget.netWorthEntityCubit,
                                                  netWorthDenominationCubit:
                                                  widget.netWorthDenominationCubit,
                                                  netWorthReportCubit: widget.netWorthReportCubit,
                                                  netWorthAsOnDateCubit:
                                                  widget.netWorthAsOnDateCubit,
                                                  netWorthCurrencyCubit:
                                                  widget.netWorthCurrencyCubit,
                                                  netWorthPeriodCubit: widget.netWorthPeriodCubit,
                                                  netWorthPartnershipMethodCubit: widget.netWorthPartnershipMethodCubit,
                                                  netWorthHoldingMethodCubit: widget.netWorthHoldingMethodCubit,
                                                );
                                              },
                                            );
                                          },
                                        ));
                                      }
                                    });
                                  }
                                  else if (state is NetWorthReportLoading) {
                                    return widget.isFavorite
                                        ? NetWorthLoader(
                                      isFavorite: widget.isFavorite,
                                      isError: false,
                                      menu: CustomPopupMenu(
                                        isLoading:true,
                                        onSelect: (int index) async {
                                        if (index == 1) {
                                          context
                                              .read<FavoritesCubit>()
                                              .saveFilters(
                                            context: context,
                                            shouldUpdate: false,
                                            isPinned: false,
                                            reportId: FavoriteConstants.netWorthId,
                                            reportName: "${widget.favorite?.reportname} Copy",
                                            entity: widget.netWorthReportCubit.netWorthEntityCubit.state.selectedNetWorthEntity,
                                            netWorthPrimaryGrouping: widget.netWorthReportCubit.netWorthPrimaryGroupingCubit.state.selectedGrouping,
                                            netWorthPrimarySubGrouping: widget.netWorthReportCubit.netWorthPrimarySubGroupingCubit.state.selectedSubGroupingList,
                                            numberOfPeriod: widget.netWorthReportCubit.netWorthNumberOfPeriodCubit.state.selectedNetWorthNumberOfPeriod,
                                            period: widget.netWorthReportCubit.netWorthPeriodCubit.state.selectedNetWorthPeriod,
                                            currency: widget.netWorthReportCubit.netWorthCurrencyCubit.state.selectedNetWorthCurrency,
                                            denomination: widget.netWorthReportCubit.netWorthDenominationCubit.state.selectedNetWorthDenomination,
                                            asOnDate: widget.netWorthReportCubit.netWorthAsOnDateCubit.state.asOnDate,
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
                                      },),
                                      onRetry: () {
                                        showModalBottomSheet(
                                          context: context,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(Sizes.dimen_10.r),
                                              topRight: Radius.circular(Sizes.dimen_10.r),
                                            ),
                                          ),
                                          isScrollControlled: true,
                                          builder: (context) {
                                            return NetWorthFilterModalSheet(
                                              isFavorite: widget.isFavorite,
                                              favorite: widget.favorite,
                                              favoritesCubit: context.read<FavoritesCubit>(),
                                              netWorthGroupingCubit:
                                              widget.netWorthGroupingCubit,
                                              netWorthReturnPercentCubit:
                                              widget.netWorthReturnPercentCubit,
                                              netWorthPrimarySubGroupingCubit:
                                              widget.netWorthPrimarySubGroupingCubit,
                                              netWorthNumberOfPeriodCubit:
                                              widget.netWorthNumberOfPeriodCubit,
                                              netWorthLoadingCubit: widget.netWorthLoadingCubit,
                                              netWorthEntityCubit: widget.netWorthEntityCubit,
                                              netWorthDenominationCubit:
                                              widget.netWorthDenominationCubit,
                                              netWorthReportCubit: widget.netWorthReportCubit,
                                              netWorthAsOnDateCubit:
                                              widget.netWorthAsOnDateCubit,
                                              netWorthCurrencyCubit:
                                              widget.netWorthCurrencyCubit,
                                              netWorthPeriodCubit: widget.netWorthPeriodCubit,
                                              netWorthPartnershipMethodCubit: widget.netWorthPartnershipMethodCubit,
                                              netWorthHoldingMethodCubit: widget.netWorthHoldingMethodCubit,
                                            );
                                          },
                                        );
                                      },
                                    )
                                        : Expanded(child: NetWorthLoader(
                                      isFavorite: widget.isFavorite,
                                      isError: false,
                                      onRetry: () {
                                        showModalBottomSheet(
                                          context: context,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(Sizes.dimen_10.r),
                                              topRight: Radius.circular(Sizes.dimen_10.r),
                                            ),
                                          ),
                                          isScrollControlled: true,
                                          builder: (context) {
                                            return NetWorthFilterModalSheet(
                                              isFavorite: widget.isFavorite,
                                              favorite: widget.favorite,
                                              favoritesCubit: context.read<FavoritesCubit>(),
                                              netWorthGroupingCubit:
                                              widget.netWorthGroupingCubit,
                                              netWorthReturnPercentCubit:
                                              widget.netWorthReturnPercentCubit,
                                              netWorthPrimarySubGroupingCubit:
                                              widget.netWorthPrimarySubGroupingCubit,
                                              netWorthNumberOfPeriodCubit:
                                              widget.netWorthNumberOfPeriodCubit,
                                              netWorthLoadingCubit: widget.netWorthLoadingCubit,
                                              netWorthEntityCubit: widget.netWorthEntityCubit,
                                              netWorthDenominationCubit:
                                              widget.netWorthDenominationCubit,
                                              netWorthReportCubit: widget.netWorthReportCubit,
                                              netWorthAsOnDateCubit:
                                              widget.netWorthAsOnDateCubit,
                                              netWorthCurrencyCubit:
                                              widget.netWorthCurrencyCubit,
                                              netWorthPeriodCubit: widget.netWorthPeriodCubit,
                                              netWorthPartnershipMethodCubit: widget.netWorthPartnershipMethodCubit,
                                              netWorthHoldingMethodCubit: widget.netWorthHoldingMethodCubit,
                                            );
                                          },
                                        );
                                      },
                                    ));
                                  } else if (state is NetWorthReportError) {
                                    if (state.errorType ==
                                        AppErrorType.unauthorised) {
                                      AppHelpers.logout(context: context);
                                    }
                                    return widget.isFavorite
                                        ? NetWorthLoader(
                                      isFavorite: widget.isFavorite,
                                      isError: true,
                                      menu: CustomPopupMenu(
                                        isLoading:true,
                                        onSelect: (int index) async {
                                        if (index == 1) {
                                          context
                                              .read<FavoritesCubit>()
                                              .saveFilters(
                                            context: context,
                                            shouldUpdate: false,
                                            isPinned: false,
                                            reportId: FavoriteConstants.netWorthId,
                                            reportName: "${widget.favorite?.reportname} Copy",
                                            entity: widget.netWorthReportCubit.netWorthEntityCubit.state.selectedNetWorthEntity,
                                            netWorthPrimaryGrouping: widget.netWorthReportCubit.netWorthPrimaryGroupingCubit.state.selectedGrouping,
                                            netWorthPrimarySubGrouping: widget.netWorthReportCubit.netWorthPrimarySubGroupingCubit.state.selectedSubGroupingList,
                                            numberOfPeriod: widget.netWorthReportCubit.netWorthNumberOfPeriodCubit.state.selectedNetWorthNumberOfPeriod,
                                            period: widget.netWorthReportCubit.netWorthPeriodCubit.state.selectedNetWorthPeriod,
                                            currency: widget.netWorthReportCubit.netWorthCurrencyCubit.state.selectedNetWorthCurrency,
                                            denomination: widget.netWorthReportCubit.netWorthDenominationCubit.state.selectedNetWorthDenomination,
                                            asOnDate: widget.netWorthReportCubit.netWorthAsOnDateCubit.state.asOnDate,
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
                                      },),
                                      onRetry: () {
                                        showModalBottomSheet(
                                          context: context,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(Sizes.dimen_10.r),
                                              topRight: Radius.circular(Sizes.dimen_10.r),
                                            ),
                                          ),
                                          isScrollControlled: true,
                                          builder: (context) {
                                            return NetWorthFilterModalSheet(
                                              isFavorite: widget.isFavorite,
                                              favorite: widget.favorite,
                                              favoritesCubit: context.read<FavoritesCubit>(),
                                              netWorthGroupingCubit:
                                              widget.netWorthGroupingCubit,
                                              netWorthReturnPercentCubit:
                                              widget.netWorthReturnPercentCubit,
                                              netWorthPrimarySubGroupingCubit:
                                              widget.netWorthPrimarySubGroupingCubit,
                                              netWorthNumberOfPeriodCubit:
                                              widget.netWorthNumberOfPeriodCubit,
                                              netWorthLoadingCubit: widget.netWorthLoadingCubit,
                                              netWorthEntityCubit: widget.netWorthEntityCubit,
                                              netWorthDenominationCubit:
                                              widget.netWorthDenominationCubit,
                                              netWorthReportCubit: widget.netWorthReportCubit,
                                              netWorthAsOnDateCubit:
                                              widget.netWorthAsOnDateCubit,
                                              netWorthCurrencyCubit:
                                              widget.netWorthCurrencyCubit,
                                              netWorthPeriodCubit: widget.netWorthPeriodCubit,
                                              netWorthPartnershipMethodCubit: widget.netWorthPartnershipMethodCubit,
                                              netWorthHoldingMethodCubit: widget.netWorthHoldingMethodCubit,
                                            );
                                          },
                                        );
                                      },
                                    )
                                        : Expanded(child: NetWorthLoader(
                                      isFavorite: widget.isFavorite,
                                      isError: true,
                                      onRetry: () {
                                        showModalBottomSheet(
                                          context: context,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(Sizes.dimen_10.r),
                                              topRight: Radius.circular(Sizes.dimen_10.r),
                                            ),
                                          ),
                                          isScrollControlled: true,
                                          builder: (context) {
                                            return NetWorthFilterModalSheet(
                                              isFavorite: widget.isFavorite,
                                              favorite: widget.favorite,
                                              favoritesCubit: context.read<FavoritesCubit>(),
                                              netWorthGroupingCubit:
                                              widget.netWorthGroupingCubit,
                                              netWorthReturnPercentCubit:
                                              widget.netWorthReturnPercentCubit,
                                              netWorthPrimarySubGroupingCubit:
                                              widget.netWorthPrimarySubGroupingCubit,
                                              netWorthNumberOfPeriodCubit:
                                              widget.netWorthNumberOfPeriodCubit,
                                              netWorthLoadingCubit: widget.netWorthLoadingCubit,
                                              netWorthEntityCubit: widget.netWorthEntityCubit,
                                              netWorthDenominationCubit:
                                              widget.netWorthDenominationCubit,
                                              netWorthReportCubit: widget.netWorthReportCubit,
                                              netWorthAsOnDateCubit:
                                              widget.netWorthAsOnDateCubit,
                                              netWorthCurrencyCubit:
                                              widget.netWorthCurrencyCubit,
                                              netWorthPeriodCubit: widget.netWorthPeriodCubit,
                                              netWorthPartnershipMethodCubit: widget.netWorthPartnershipMethodCubit,
                                              netWorthHoldingMethodCubit: widget.netWorthHoldingMethodCubit,
                                            );
                                          },
                                        );
                                      },
                                    ));
                                  }
                                  return widget.isFavorite
                                      ? NetWorthLoader(
                                        isFavorite: widget.isFavorite,
                                        isError: false,
                                        menu: CustomPopupMenu(onSelect: (int index) async {
                                          if (index == 1) {
                                            context
                                                .read<FavoritesCubit>()
                                                .saveFilters(
                                              context: context,
                                              shouldUpdate: false,
                                              isPinned: false,
                                              reportId: FavoriteConstants.netWorthId,
                                              reportName: "${widget.favorite?.reportname} Copy",
                                              entity: widget.netWorthReportCubit.netWorthEntityCubit.state.selectedNetWorthEntity,
                                              netWorthPrimaryGrouping: widget.netWorthReportCubit.netWorthPrimaryGroupingCubit.state.selectedGrouping,
                                              netWorthPrimarySubGrouping: widget.netWorthReportCubit.netWorthPrimarySubGroupingCubit.state.selectedSubGroupingList,
                                              numberOfPeriod: widget.netWorthReportCubit.netWorthNumberOfPeriodCubit.state.selectedNetWorthNumberOfPeriod,
                                              period: widget.netWorthReportCubit.netWorthPeriodCubit.state.selectedNetWorthPeriod,
                                              currency: widget.netWorthReportCubit.netWorthCurrencyCubit.state.selectedNetWorthCurrency,
                                              denomination: widget.netWorthReportCubit.netWorthDenominationCubit.state.selectedNetWorthDenomination,
                                              asOnDate: widget.netWorthReportCubit.netWorthAsOnDateCubit.state.asOnDate,
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
                                        },),
                                        onRetry: () {
                                          showModalBottomSheet(
                                            context: context,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(Sizes.dimen_10.r),
                                                topRight: Radius.circular(Sizes.dimen_10.r),
                                              ),
                                            ),
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return NetWorthFilterModalSheet(
                                                isFavorite: widget.isFavorite,
                                                favorite: widget.favorite,
                                                favoritesCubit: context.read<FavoritesCubit>(),
                                                netWorthGroupingCubit:
                                                widget.netWorthGroupingCubit,
                                                netWorthReturnPercentCubit:
                                                widget.netWorthReturnPercentCubit,
                                                netWorthPrimarySubGroupingCubit:
                                                widget.netWorthPrimarySubGroupingCubit,
                                                netWorthNumberOfPeriodCubit:
                                                widget.netWorthNumberOfPeriodCubit,
                                                netWorthLoadingCubit: widget.netWorthLoadingCubit,
                                                netWorthEntityCubit: widget.netWorthEntityCubit,
                                                netWorthDenominationCubit:
                                                widget.netWorthDenominationCubit,
                                                netWorthReportCubit: widget.netWorthReportCubit,
                                                netWorthAsOnDateCubit:
                                                widget.netWorthAsOnDateCubit,
                                                netWorthCurrencyCubit:
                                                widget.netWorthCurrencyCubit,
                                                netWorthPeriodCubit: widget.netWorthPeriodCubit,
                                                netWorthPartnershipMethodCubit: widget.netWorthPartnershipMethodCubit,
                                                netWorthHoldingMethodCubit: widget.netWorthHoldingMethodCubit,
                                              );
                                            },
                                          );
                                        },
                                      )
                                      : Expanded(child: NetWorthLoader(
                                    isFavorite: widget.isFavorite,
                                    isError: false,
                                    onRetry: () {
                                      showModalBottomSheet(
                                        context: context,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(Sizes.dimen_10.r),
                                            topRight: Radius.circular(Sizes.dimen_10.r),
                                          ),
                                        ),
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return NetWorthFilterModalSheet(
                                            isFavorite: widget.isFavorite,
                                            favorite: widget.favorite,
                                            favoritesCubit: context.read<FavoritesCubit>(),
                                            netWorthGroupingCubit:
                                            widget.netWorthGroupingCubit,
                                            netWorthReturnPercentCubit:
                                            widget.netWorthReturnPercentCubit,
                                            netWorthPrimarySubGroupingCubit:
                                            widget.netWorthPrimarySubGroupingCubit,
                                            netWorthNumberOfPeriodCubit:
                                            widget.netWorthNumberOfPeriodCubit,
                                            netWorthLoadingCubit: widget.netWorthLoadingCubit,
                                            netWorthEntityCubit: widget.netWorthEntityCubit,
                                            netWorthDenominationCubit:
                                            widget.netWorthDenominationCubit,
                                            netWorthReportCubit: widget.netWorthReportCubit,
                                            netWorthAsOnDateCubit:
                                            widget.netWorthAsOnDateCubit,
                                            netWorthCurrencyCubit:
                                            widget.netWorthCurrencyCubit,
                                            netWorthPeriodCubit: widget.netWorthPeriodCubit,
                                            netWorthPartnershipMethodCubit: widget.netWorthPartnershipMethodCubit,
                                            netWorthHoldingMethodCubit: widget.netWorthHoldingMethodCubit,
                                          );
                                        },
                                      );
                                    },
                                  ));
                                });
                          });
                    }),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class ChildItemWithTooltip extends StatefulWidget {
  final bool stealthValue;
  final List<String> colorList;
  final int currInd;
  final NetWorthChartData e;
  final NetWorthDenominationState denominationState;
  final void Function(double) setHeight;
  const ChildItemWithTooltip({
    super.key,
    required this.stealthValue,
    required this.currInd,
    required this.colorList,
    required this.denominationState,
    required this.e,
    required this.setHeight,
  });

  @override
  State<ChildItemWithTooltip> createState() => _ChildItemWithTooltipState();
}

class _ChildItemWithTooltipState extends State<ChildItemWithTooltip>
    with WidgetsBindingObserver {
  late final SuperTooltipController _tooltipController =
      SuperTooltipController();
  double? _oldSize;

  @override
  void dispose() {
    _tooltipController.dispose();
    super.dispose();
  }

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
    Timer? timer;
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.circle,
                color: Color(int.parse(
                    "0xFF${widget.colorList[widget.currInd > widget.colorList.length - 1 ? widget.currInd % widget.colorList.length : widget.currInd]}")),
                size: Sizes.dimen_10.sp,
              ),
              SizedBox(
                width: Sizes.dimen_4.w,
              ),
              Text(
                widget.e.title,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: Sizes.dimen_13.sp,
                      overflow: TextOverflow.ellipsis,
                      color: AppColor.grey,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: Sizes.dimen_2.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [


                Text(
                  "${NumberFormat.simpleCurrency(name: context.read<NetWorthCurrencyCubit>().state.selectedNetWorthCurrency?.code).currencySymbol} ${(widget.e.closingValue < 0    ? "(${NumberFormat(context.read<NetWorthCurrencyCubit>().state.selectedNetWorthCurrency?.format ?? '###,###,##0.00').format(widget.e.closingValue.abs().denominate(denominator: widget.denominationState.selectedNetWorthDenomination?.denomination))}${widget.denominationState.selectedNetWorthDenomination?.suffix})"    : "${NumberFormat(context.read<NetWorthCurrencyCubit>().state.selectedNetWorthCurrency?.format ?? '###,###,##0.00').format(widget.e.closingValue.abs().denominate(denominator: widget.denominationState.selectedNetWorthDenomination?.denomination))}${widget.denominationState.selectedNetWorthDenomination?.suffix}")}"    .stealth(widget.stealthValue),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: Sizes.dimen_14.sp,
                      color: widget.stealthValue
                          ? null
                          : widget.e.closingValue < 0
                              ? AppColor.red
                              : AppColor.textGrey,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      showBarrier: true,
      popupDirection: TooltipDirection.up,
      child: SizedBox(
        width: Sizes.dimen_100.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.circle,
                    color: Color(int.parse(
                        "0xFF${widget.colorList[widget.currInd > widget.colorList.length - 1 ? widget.currInd % widget.colorList.length : widget.currInd]}")),
                    size: Sizes.dimen_10.sp,
                  ),
                  SizedBox(
                    width: Sizes.dimen_4.w,
                  ),
                  Flexible(
                    child: Text(
                      widget.e.title,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: Sizes.dimen_13.sp,
                            overflow: TextOverflow.ellipsis,
                            color: AppColor.grey,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: Sizes.dimen_2.w),
                child: Row(
                  children: [

                    Flexible(
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        "${NumberFormat.simpleCurrency(    name: context.read<NetWorthCurrencyCubit>().state.selectedNetWorthCurrency?.code).currencySymbol} ${(widget.e.closingValue < 0    ? "(${NumberFormat(context.read<NetWorthCurrencyCubit>().state.selectedNetWorthCurrency?.format ?? '###,###,##0.00').format(widget.e.closingValue.abs().denominate(denominator: widget.denominationState.selectedNetWorthDenomination?.denomination))}${widget.denominationState.selectedNetWorthDenomination?.suffix})"    : "${NumberFormat(context.read<NetWorthCurrencyCubit>().state.selectedNetWorthCurrency?.format ?? '###,###,##0.00').format(widget.e.closingValue.abs().denominate(denominator: widget.denominationState.selectedNetWorthDenomination?.denomination))}${widget.denominationState.selectedNetWorthDenomination?.suffix}")}"    .stealth(widget.stealthValue),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontSize: Sizes.dimen_14.sp,
                                color: widget.stealthValue
                                    ? null
                                    : widget.e.closingValue < 0
                                        ? AppColor.red
                                        : AppColor.textGrey,
                                fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
    return Container(
      margin: EdgeInsets.only(top: Sizes.dimen_2.h),
      child: Text(
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
      ),
    );
  }
}
