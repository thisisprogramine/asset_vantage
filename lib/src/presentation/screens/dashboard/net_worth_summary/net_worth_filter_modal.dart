import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/domain/entities/net_worth/net_worth_return_percent_entity.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/networth_holding_method/networth_holding_method_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/networth_holding_method/networth_holding_method_state.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/networth_partnership_method/networth_partnership_method_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/networth_partnership_method/networth_partnership_method_state.dart';
import 'package:asset_vantage/src/presentation/screens/dashboard/net_worth_summary/net_worth_entity_list.dart';
import 'package:asset_vantage/src/presentation/screens/dashboard/net_worth_summary/net_worth_holding_method_list.dart';
import 'package:asset_vantage/src/presentation/screens/dashboard/net_worth_summary/net_worth_partnership_filter_list.dart';
import 'package:asset_vantage/src/presentation/screens/dashboard/net_worth_summary/net_worth_subgrouping_list.dart';
import 'package:asset_vantage/src/presentation/widgets/crossSign.dart';
import 'package:asset_vantage/src/presentation/widgets/filter_name_with_cross.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../config/constants/size_constants.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/authentication/user_entity.dart';
import '../../../../domain/entities/currency/currency_entity.dart';
import '../../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../../domain/entities/denomination/denomination_entity.dart';
import '../../../../domain/entities/favorites/favorites_entity.dart';
import '../../../../domain/entities/net_worth/net_worth_grouping_entity.dart';
import '../../../../domain/entities/net_worth/net_worth_sub_grouping_enity.dart';
import '../../../../domain/entities/number_of_period/number_of_period.dart';
import '../../../../domain/entities/period/period_enitity.dart';
import '../../../../utilities/helper/app_helper.dart';
import '../../../../utilities/helper/ui_helper.dart';
import '../../../blocs/authentication/user/user_cubit.dart';
import '../../../blocs/favorites/favorites_cubit.dart';
import '../../../blocs/net_worth/net_worth_as_on_date/net_worth_as_on_date_cubit.dart';
import '../../../blocs/net_worth/net_worth_currency/net_worth_currency_cubit.dart';
import '../../../blocs/net_worth/net_worth_denomination/net_worth_denomination_cubit.dart';
import '../../../blocs/net_worth/net_worth_entity/net_worth_entity_cubit.dart';
import '../../../blocs/net_worth/net_worth_grouping/net_worth_grouping_cubit.dart';
import '../../../blocs/net_worth/net_worth_loading/net_worth_loading_cubit.dart';
import '../../../blocs/net_worth/net_worth_number_of_period/net_worth_number_of_period_cubit.dart';
import '../../../blocs/net_worth/net_worth_period/net_worth_period_cubit.dart';
import '../../../blocs/net_worth/net_worth_report/net_worth_report_cubit.dart';
import '../../../blocs/net_worth/net_worth_return_percent/net_worth_return_percent_cubit.dart';
import '../../../blocs/net_worth/net_worth_sub_grouping/net_worth_sub_grouping_cubit.dart';
import '../../../theme/theme_color.dart';
import '../../../widgets/apply_button.dart';
import 'net_worth_currency_filter.dart';
import 'net_worth_date_picker_filter.dart';
import 'net_worth_denomination_filter_list.dart';
import 'net_worth_grouping_list.dart';
import 'net_worth_number_of_period_filter_list.dart';
import 'net_worth_period_filter_list.dart';
import 'net_worth_return_percent_list.dart';

class NetWorthFilterModalSheet extends StatefulWidget {
  final NetWorthEntityCubit netWorthEntityCubit;
  final NetWorthGroupingCubit netWorthGroupingCubit;
  final NetWorthPrimarySubGroupingCubit netWorthPrimarySubGroupingCubit;
  final NetWorthPeriodCubit netWorthPeriodCubit;
  final NetWorthPartnershipMethodCubit netWorthPartnershipMethodCubit;
  final NetWorthHoldingMethodCubit netWorthHoldingMethodCubit;
  final NetWorthNumberOfPeriodCubit netWorthNumberOfPeriodCubit;
  final NetWorthReturnPercentCubit netWorthReturnPercentCubit;
  final NetWorthCurrencyCubit netWorthCurrencyCubit;
  final NetWorthDenominationCubit netWorthDenominationCubit;
  final NetWorthAsOnDateCubit netWorthAsOnDateCubit;
  final NetWorthLoadingCubit netWorthLoadingCubit;
  final NetWorthReportCubit netWorthReportCubit;
  final FavoritesCubit favoritesCubit;
  final bool isFavorite;
  final bool fromBlankWidget;
  final Favorite? favorite;

  const NetWorthFilterModalSheet({
    super.key,
    this.isFavorite = false,
    this.fromBlankWidget = false,
    this.favorite,
    required this.favoritesCubit,
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
    required this.netWorthPartnershipMethodCubit,
    required this.netWorthHoldingMethodCubit,
  });

  @override
  State<NetWorthFilterModalSheet> createState() =>
      _NetWorthFilterModalSheetState();
}

class _NetWorthFilterModalSheetState extends State<NetWorthFilterModalSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  late Animation<Offset> _animation1;
  bool buttonsActive = false;
  int currentIndex = 0;
  bool isHoldingMethodVisible= false;

  EntityData? saveEntity;
  EntityData? tempSaveEntity;
  GroupingEntity? savedPrimaryGrouping;
  List<SubGroupingItemData?>? savedPrimarySubGrouping;
  List<SubGroupingItemData?>? savedAccounts;
  PeriodItemData? savedPeriod;
  NumberOfPeriodItemData? savedNumberOfPeriod;
  ReturnPercentItemData? savedReturnPercent;
  Currency? savedCurrency;
  DenominationData? savedDenominationData;
  String? savedAsOnDate;
  bool shouldResetFilter = true;

  @override
  void initState() {
    super.initState();

    print("${widget.fromBlankWidget} FROM PERIOD:: ${widget.netWorthPeriodCubit.state.selectedNetWorthPeriod?.name}");
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _animation1 =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(-1, 0))
            .animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _animation =
        Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    saveEntity = widget.netWorthEntityCubit.state.selectedNetWorthEntity;
    savedPrimaryGrouping = widget.netWorthGroupingCubit.state.selectedGrouping;
    savedPrimarySubGrouping =
        widget.netWorthPrimarySubGroupingCubit.state.selectedSubGroupingList;
    savedPeriod = widget.netWorthPeriodCubit.state.selectedNetWorthPeriod;
    savedNumberOfPeriod =
        widget.netWorthNumberOfPeriodCubit.state.selectedNetWorthNumberOfPeriod;
    savedReturnPercent =
        widget.netWorthReturnPercentCubit.state.selectedNetWorthReturnPercent;
    savedCurrency = widget.netWorthCurrencyCubit.state.selectedNetWorthCurrency;
    savedDenominationData =
        widget.netWorthDenominationCubit.state.selectedNetWorthDenomination;
    savedAsOnDate = widget.netWorthAsOnDateCubit.state.asOnDate;
  }

  @override
  void dispose() {
    _resetFilters(shouldReset: shouldResetFilter);
    super.dispose();
  }

  _resetFilters({required bool shouldReset}) {
    if (shouldReset) {
      tempSaveEntity = null;
      widget.netWorthEntityCubit
          .changeSelectedNetWorthEntity(selectedEntity: saveEntity);
      widget.netWorthGroupingCubit.changeSelectedNetWorthPrimaryGrouping(
        selectedGrouping: savedPrimaryGrouping,
      );
      widget.netWorthPrimarySubGroupingCubit.loadNetWorthPrimarySubGrouping(
          context: context,
          selectedEntity: saveEntity,
          selectedGrouping: savedPrimaryGrouping,
          asOnDate: savedAsOnDate);
      widget.netWorthReturnPercentCubit.changeSelectedNetWorthReturnPercent(selectedReturnPercent: savedReturnPercent);
      widget.netWorthPeriodCubit
          .changeSelectedNetWorthPeriod(selectedPeriod: savedPeriod);
      widget.netWorthNumberOfPeriodCubit.changeSelectedNetWorthNumberOfPeriod(
          selectedNumberOfPeriod: savedNumberOfPeriod);
      widget.netWorthCurrencyCubit
          .changeSelectedNetWorthCurrency(selectedCurrency: savedCurrency, netWorthDenominationCubit: widget.netWorthDenominationCubit);
      widget.netWorthDenominationCubit.changeSelectedNetWorthDenomination(
          selectedDenomination: savedDenominationData);
      widget.netWorthAsOnDateCubit.changeAsOnDate(asOnDate: savedAsOnDate);
    }
  }

  bool checkToActiveButtons() {
    if ((tempSaveEntity ?? saveEntity)?.id !=
            widget.netWorthEntityCubit.state.selectedNetWorthEntity?.id ||
        savedPrimaryGrouping?.id !=
            widget.netWorthGroupingCubit.state.selectedGrouping?.id ||
        savedPeriod?.id !=
            widget.netWorthPeriodCubit.state.selectedNetWorthPeriod?.id ||
        savedNumberOfPeriod?.id !=
            widget.netWorthNumberOfPeriodCubit.state
                .selectedNetWorthNumberOfPeriod?.id ||
        savedCurrency?.id !=
            widget.netWorthCurrencyCubit.state.selectedNetWorthCurrency?.id ||
        savedDenominationData?.id !=
            widget.netWorthDenominationCubit.state.selectedNetWorthDenomination
                ?.id ||
        savedAsOnDate != widget.netWorthAsOnDateCubit.state.asOnDate ||
        savedReturnPercent?.id !=
            widget.netWorthReturnPercentCubit.state
                .selectedNetWorthReturnPercent?.id ||
        !(const DeepCollectionEquality.unordered().equals(
            savedPrimarySubGrouping
                ?.map(
                  (e) => e?.id,
                )
                .toList(),
            widget.netWorthPrimarySubGroupingCubit.state.selectedSubGroupingList
                ?.map(
                  (e) => e?.id,
                )
                .toList()))) {
      return true;
    } else {
      return false;
    }
  }


  List<Widget> _childWidgets(BuildContext context, ScrollController scroll) {
    return [
      SlideTransition(
        position: _animation1,
        child: Container(
          padding: EdgeInsets.only(
            top: Sizes.dimen_10.w,
            left: Sizes.dimen_14.w,
            right: Sizes.dimen_14.w,
          ),
          child: Column(
            children: [
              Container(
                height: Sizes.dimen_2.h,
                width: Sizes.dimen_48.w,
                decoration: BoxDecoration(
                    color: AppColor.textGrey,
                    borderRadius: BorderRadius.circular(Sizes.dimen_32.r)),
              ),
              UIHelper.verticalSpaceSmall,

              const FilterNameWithCross(text: StringConstants.netWorthFilterHeader),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                    bottom: Sizes.dimen_6.h,
                  ),
                  controller: scroll,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                    BlocBuilder<NetWorthEntityCubit, NetWorthEntityState>(
                        bloc: widget.netWorthEntityCubit,
                        builder: (context, state) {
                          if (state is NetWorthEntityLoaded) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                  child: Text(StringConstants.entityGroupFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                                ),
                                Semantics(
                                  identifier: StringConstants.entityGrpFilterKey,
                                  child: TextField(
                                    onTap: () {
                                      currentIndex = 1;
                                      setState(() {});
                                      _animationController.forward();
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(Sizes.dimen_8.r),
                                        borderSide: const BorderSide(
                                          color: AppColor.grey,
                                          width: 1,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(Sizes.dimen_8.r),
                                        borderSide: const BorderSide(
                                          color: AppColor.grey,
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(Sizes.dimen_8.r),
                                        borderSide: const BorderSide(
                                          color: AppColor.grey,
                                          width: 1,
                                        ),
                                      ),

                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: Sizes.dimen_14.w,
                                        vertical: Sizes.dimen_12.w,
                                      ),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      suffixIcon: const Icon(
                                        Icons.keyboard_arrow_right,
                                        color: AppColor.textGrey,
                                      ),
                                      hintText: tempSaveEntity != null
                                          ? tempSaveEntity?.name
                                          : state.selectedNetWorthEntity?.name ??
                                              '--',
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            color: AppColor.textGrey?.withValues(alpha: 0.5),
                                          ),
                                    ),
                                    readOnly: true,
                                  ),
                                ),
                              ],
                            );
                          } else if (state is NetWorthEntityError) {
                            if (state.errorType == AppErrorType.unauthorised) {
                              AppHelpers.logout(context: context);
                            }
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                  child: Text(StringConstants.entityGroupFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                                ),
                                TextField(
                                  onTap: () {},
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(Sizes.dimen_12.r),
                                      borderSide: const BorderSide(
                                        color: AppColor.grey,
                                        width: 1,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(Sizes.dimen_12.r),
                                      borderSide: const BorderSide(
                                        color: AppColor.grey,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(Sizes.dimen_12.r),
                                      borderSide: const BorderSide(
                                        color: AppColor.grey,
                                        width: 1,
                                      ),
                                    ),

                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: Sizes.dimen_14.w,
                                      vertical: Sizes.dimen_16.w,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    suffixIcon: const Icon(
                                      Icons.keyboard_arrow_right,
                                      color: AppColor.textGrey,
                                    ),
                                    hintText: "ERROR",
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: AppColor.textGrey,
                                        ),
                                  ),
                                  readOnly: true,
                                ),
                              ],
                            );
                          }
                          return SizedBox(
                            width: ScreenUtil().screenWidth,
                            height: Sizes.dimen_24.h,
                            child: Shimmer.fromColors(
                              baseColor: AppColor.grey.withOpacity(0.1),
                              highlightColor: AppColor.grey.withOpacity(0.2),
                              direction: ShimmerDirection.ltr,
                              period: const Duration(seconds: 1),
                              child: Container(
                                width: ScreenUtil().screenWidth,
                                height: Sizes.dimen_24.h,
                                decoration: BoxDecoration(
                                    color: AppColor.grey,
                                    borderRadius: BorderRadius.circular(5.0)),
                              ),
                            ),
                          );
                        }),
                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                    BlocBuilder<NetWorthPartnershipMethodCubit, NetWorthPartnershipMethodState>(
                      bloc: widget.netWorthPartnershipMethodCubit,
                      builder: (context,state){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                              child: Text(StringConstants.partnershipMethod, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                            ),
                            Semantics(
                              identifier: StringConstants.partnershipMethodKey,
                              child: TextField(
                                onTap: () {
                                  currentIndex = 2;
                                  setState(() {});
                                  _animationController.forward();
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(Sizes.dimen_8.r),
                                    borderSide: const BorderSide(
                                      color: AppColor.grey,
                                      width: 1,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(Sizes.dimen_8.r),
                                    borderSide: const BorderSide(
                                      color: AppColor.grey,
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(Sizes.dimen_8.r),
                                    borderSide: const BorderSide(
                                      color: AppColor.grey,
                                      width: 1,
                                    ),
                                  ),

                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: Sizes.dimen_14.w,
                                    vertical: Sizes.dimen_12.w,
                                  ),
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                                  suffixIcon: const Icon(
                                    Icons.keyboard_arrow_right,
                                    color: AppColor.textGrey,
                                  ),
                                  hintText: state.selectedNetWorthPartnershipMethod?.name ??
                                  '--',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                    color: AppColor.textGrey?.withValues(alpha: 0.5),
                                  ),
                                ),
                                readOnly: true,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                    BlocBuilder<NetWorthPartnershipMethodCubit,
                        NetWorthPartnershipMethodState>(
                      bloc: widget.netWorthPartnershipMethodCubit,
                      builder: (context,partnershipState){

                        isHoldingMethodVisible = partnershipState.selectedNetWorthPartnershipMethod != null &&
                            partnershipState.selectedNetWorthPartnershipMethod?.name != "None";
                            //partnershipState.selectedNetWorthPartnershipMethod?.name!="None";
                        if(isHoldingMethodVisible){
                          return BlocBuilder<NetWorthHoldingMethodCubit, NetWorthHoldingMethodState>(
                            bloc: widget.netWorthHoldingMethodCubit,
                            builder: (context,state){
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                    child: Text(StringConstants.holdingMethod, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                                  ),
                                  Semantics(
                                    identifier: StringConstants.holdingMethodKey,
                                    child: TextField(
                                      onTap: () {
                                        print("Current isHoldingMethodVisible: $isHoldingMethodVisible");
                                        currentIndex = isHoldingMethodVisible ? 3: 0;
                                        print("Setting currentIndex to: $currentIndex");
                                        //setState(() {});
                                        setState(() {});
                                        _animationController.forward();
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(Sizes.dimen_8.r),
                                          borderSide: const BorderSide(
                                            color: AppColor.grey,
                                            width: 1,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(Sizes.dimen_8.r),
                                          borderSide: const BorderSide(
                                            color: AppColor.grey,
                                            width: 1,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(Sizes.dimen_8.r),
                                          borderSide: const BorderSide(
                                            color: AppColor.grey,
                                            width: 1,
                                          ),
                                        ),

                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: Sizes.dimen_14.w,
                                          vertical: Sizes.dimen_12.w,
                                        ),
                                        floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                        suffixIcon: const Icon(
                                          Icons.keyboard_arrow_right,
                                          color: AppColor.textGrey,
                                        ),
                                        hintText: state.selectedNetworthHoldingMethod?.name ??
                                            '--',
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                          color: AppColor.textGrey?.withValues(alpha: 0.5),
                                        ),
                                      ),
                                      readOnly: true,
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                      }
                      return const SizedBox.shrink();
                      },
                    ),
                    BlocBuilder<NetWorthGroupingCubit,
                            NetWorthPrimaryGroupingState>(
                        bloc: widget.netWorthGroupingCubit,
                        builder: (context, state) {
                          if (state is NetWorthPrimaryGroupingLoaded) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                  child: Text(StringConstants.primaryGrpFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                                ),
                                Semantics(
                                  identifier: StringConstants.primaryGrpFilterKey,
                                  child: TextField(
                                    onTap: () {
                                      print("Current isHoldingMethodVisible: $isHoldingMethodVisible");

                                      currentIndex = isHoldingMethodVisible ? 4: 3; //3;
                                      print("Setting currentIndex to: $currentIndex");

                                      setState(() {});
                                      _animationController.forward();
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(Sizes.dimen_8.r),
                                        borderSide: const BorderSide(
                                          color: AppColor.grey,
                                          width: 1,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(Sizes.dimen_8.r),
                                        borderSide: const BorderSide(
                                          color: AppColor.grey,
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(Sizes.dimen_8.r),
                                        borderSide: const BorderSide(
                                          color: AppColor.grey,
                                          width: 1,
                                        ),
                                      ),

                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: Sizes.dimen_14.w,
                                        vertical: Sizes.dimen_12.w,
                                      ),
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                      suffixIcon: const Icon(
                                        Icons.keyboard_arrow_right,
                                        color: AppColor.textGrey,
                                      ),
                                      hintText: state.selectedGrouping?.name
                                                        ?.replaceAll('-', ' ') ??
                                          '--',
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                        color: AppColor.textGrey?.withValues(alpha: 0.5),
                                      ),
                                    ),
                                    readOnly: true,
                                  ),
                                ),
                              ],
                            );
                          } else if (state is NetWorthPrimaryGroupingError) {
                            if (state.errorType == AppErrorType.unauthorised) {
                              AppHelpers.logout(context: context);
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                  child: Text(StringConstants.primaryGrpFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                                ),
                                TextField(
                                  onTap: () {},
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(Sizes.dimen_12.r),
                                      borderSide: const BorderSide(
                                        color: AppColor.grey,
                                        width: 1,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(Sizes.dimen_12.r),
                                      borderSide: const BorderSide(
                                        color: AppColor.grey,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(Sizes.dimen_12.r),
                                      borderSide: const BorderSide(
                                        color: AppColor.grey,
                                        width: 1,
                                      ),
                                    ),

                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: Sizes.dimen_14.w,
                                      vertical: Sizes.dimen_16.w,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    suffixIcon: const Icon(
                                      Icons.keyboard_arrow_right,
                                      color: AppColor.textGrey,
                                    ),
                                    hintText: "ERROR",
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: AppColor.textGrey,
                                        ),
                                  ),
                                  readOnly: true,
                                ),
                              ],
                            );
                          }
                          return SizedBox(
                            width: ScreenUtil().screenWidth,
                            height: Sizes.dimen_24.h,
                            child: Shimmer.fromColors(
                              baseColor: AppColor.grey.withOpacity(0.1),
                              highlightColor: AppColor.grey.withOpacity(0.2),
                              direction: ShimmerDirection.ltr,
                              period: const Duration(seconds: 1),
                              child: Container(
                                width: ScreenUtil().screenWidth,
                                height: Sizes.dimen_24.h,
                                decoration: BoxDecoration(
                                    color: AppColor.grey,
                                    borderRadius: BorderRadius.circular(5.0)),
                              ),
                            ),
                          );
                        }),
                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                    BlocBuilder<NetWorthGroupingCubit,
                            NetWorthPrimaryGroupingState>(
                        bloc: widget.netWorthGroupingCubit,
                        builder: (context, primaryState) {
                          return BlocBuilder<NetWorthPrimarySubGroupingCubit,
                                  NetWorthPrimarySubGroupingState>(
                              bloc: widget.netWorthPrimarySubGroupingCubit,
                              builder: (context, state) {
                                if (state is NetWorthPrimarySubGroupingLoaded &&
                                    primaryState
                                        is NetWorthPrimaryGroupingLoaded) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                        child: Text(StringConstants.primarySubGrpFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                                      ),
                                      Semantics(
                                        identifier: StringConstants.primarySubGrpFilterKey,
                                        child: TextField(
                                          onTap: () {
                                            currentIndex = isHoldingMethodVisible ? 5 : 4;//4;
                                            setState(() {});
                                            _animationController.forward();
                                          },
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(Sizes.dimen_8.r),
                                              borderSide: const BorderSide(
                                                color: AppColor.grey,
                                                width: 1,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(Sizes.dimen_8.r),
                                              borderSide: const BorderSide(
                                                color: AppColor.grey,
                                                width: 1,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(Sizes.dimen_8.r),
                                              borderSide: const BorderSide(
                                                color: AppColor.grey,
                                                width: 1,
                                              ),
                                            ),

                                            contentPadding: EdgeInsets.symmetric(
                                              horizontal: Sizes.dimen_14.w,
                                              vertical: Sizes.dimen_12.w,
                                            ),
                                            floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                            suffixIcon: const Icon(
                                              Icons.keyboard_arrow_right,
                                              color: AppColor.textGrey,
                                            ),
                                            hintText: (state.selectedSubGroupingList
                                                ?.isNotEmpty ??
                                                false)
                                                ? '${state.selectedSubGroupingList?.length} Selected'
                                                : 'None Selected',
                                            hintStyle: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                              color: AppColor.textGrey?.withValues(alpha: 0.5),
                                            ),
                                          ),
                                          readOnly: true,
                                        ),
                                      ),
                                    ],
                                  );
                                } else if (state
                                    is NetWorthPrimarySubGroupingError) {
                                  if (state.errorType ==
                                      AppErrorType.unauthorised) {
                                    AppHelpers.logout(context: context);
                                  }
                                  return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                        child: Text(StringConstants.primarySubGrpFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                                      ),
                                      TextField(
                                        onTap: () {},
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                Sizes.dimen_12.r),
                                            borderSide: const BorderSide(
                                              color: AppColor.grey,
                                              width: 1,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                Sizes.dimen_12.r),
                                            borderSide: const BorderSide(
                                              color: AppColor.grey,
                                              width: 1,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                Sizes.dimen_12.r),
                                            borderSide: const BorderSide(
                                              color: AppColor.grey,
                                              width: 1,
                                            ),
                                          ),

                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: Sizes.dimen_14.w,
                                            vertical: Sizes.dimen_16.w,
                                          ),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          suffixIcon: const Icon(
                                            Icons.keyboard_arrow_right,
                                            color: AppColor.textGrey,
                                          ),
                                          hintText: "ERROR",
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: AppColor.textGrey,
                                              ),
                                        ),
                                        readOnly: true,
                                      ),
                                    ],
                                  );
                                }
                                return SizedBox(
                                  width: ScreenUtil().screenWidth,
                                  height: Sizes.dimen_24.h,
                                  child: Shimmer.fromColors(
                                    baseColor: AppColor.grey.withOpacity(0.1),
                                    highlightColor:
                                        AppColor.grey.withOpacity(0.2),
                                    direction: ShimmerDirection.ltr,
                                    period: const Duration(seconds: 1),
                                    child: Container(
                                      width: ScreenUtil().screenWidth,
                                      height: Sizes.dimen_24.h,
                                      decoration: BoxDecoration(
                                          color: AppColor.grey,
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                    ),
                                  ),
                                );
                              });
                        }),
                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                    BlocBuilder<NetWorthPeriodCubit, NetWorthPeriodState>(
                        bloc: widget.netWorthPeriodCubit,
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                child: Text(StringConstants.periodFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                              ),
                              Semantics(
                                identifier: StringConstants.periodFilterKey,
                                child: TextField(
                                  onTap: () {
                                    currentIndex =  isHoldingMethodVisible ? 6 :5;//5;
                                    setState(() {});
                                    _animationController.forward();
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(Sizes.dimen_8.r),
                                      borderSide: const BorderSide(
                                        color: AppColor.grey,
                                        width: 1,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(Sizes.dimen_8.r),
                                      borderSide: const BorderSide(
                                        color: AppColor.grey,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(Sizes.dimen_8.r),
                                      borderSide: const BorderSide(
                                        color: AppColor.grey,
                                        width: 1,
                                      ),
                                    ),

                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: Sizes.dimen_14.w,
                                      vertical: Sizes.dimen_12.w,
                                    ),
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                    suffixIcon: const Icon(
                                      Icons.keyboard_arrow_right,
                                      color: AppColor.textGrey,
                                    ),
                                    hintText: state.selectedNetWorthPeriod?.name ?? '--',
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                      color: AppColor.textGrey?.withValues(alpha: 0.5),
                                    ),
                                  ),
                                  readOnly: true,
                                ),
                              ),
                            ],
                          );
                        }),
                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                    BlocBuilder<NetWorthNumberOfPeriodCubit,
                            NetWorthNumberOfPeriodState>(
                        bloc: widget.netWorthNumberOfPeriodCubit,
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                child: Text(StringConstants.noOfPeriodFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                              ),
                              Semantics(
                                identifier: StringConstants.noOfPeriodFilterKey,
                                child: TextField(
                                  onTap: () {
                                    currentIndex =  isHoldingMethodVisible ? 7: 6;//6;
                                    setState(() {});
                                    _animationController.forward();
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(Sizes.dimen_8.r),
                                      borderSide: const BorderSide(
                                        color: AppColor.grey,
                                        width: 1,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(Sizes.dimen_8.r),
                                      borderSide: const BorderSide(
                                        color: AppColor.grey,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(Sizes.dimen_8.r),
                                      borderSide: const BorderSide(
                                        color: AppColor.grey,
                                        width: 1,
                                      ),
                                    ),

                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: Sizes.dimen_14.w,
                                      vertical: Sizes.dimen_12.w,
                                    ),
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                    suffixIcon: const Icon(
                                      Icons.keyboard_arrow_right,
                                      color: AppColor.textGrey,
                                    ),
                                    hintText: state.selectedNetWorthNumberOfPeriod?.name ??
                                        '--',
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                      color: AppColor.textGrey?.withValues(alpha: 0.5),
                                    ),
                                  ),
                                  readOnly: true,
                                ),
                              ),
                            ],
                          );
                          return TextField(
                            onTap: () {
                              currentIndex = 5;
                              setState(() {});
                              _animationController.forward();
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(Sizes.dimen_12.r),
                                borderSide: const BorderSide(
                                  color: AppColor.grey,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(Sizes.dimen_12.r),
                                borderSide: const BorderSide(
                                  color: AppColor.grey,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(Sizes.dimen_12.r),
                                borderSide: const BorderSide(
                                  color: AppColor.grey,
                                  width: 1,
                                ),
                              ),
                              label: Text(
                                StringConstants.periodFilterString,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: AppColor.textGrey,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: Sizes.dimen_14.w,
                                vertical: Sizes.dimen_16.w,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: const Icon(
                                Icons.keyboard_arrow_right,
                                color: AppColor.textGrey,
                              ),
                              hintText:
                                  state.selectedNetWorthNumberOfPeriod?.name ??
                                      '--',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppColor.textGrey,
                                  ),
                            ),
                            readOnly: true,
                          );
                        }),
                    UIHelper.verticalSpace(Sizes.dimen_2.h),

                    BlocBuilder<NetWorthCurrencyCubit, NetWorthCurrencyState>(
                        bloc: widget.netWorthCurrencyCubit,
                        builder: (context, state) {
                          if (state is NetWorthCurrencyLoaded) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                  child: Text(StringConstants.currencyFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                                ),
                                Semantics(
                                  identifier:StringConstants.currencyFilterKey,
                                  child: TextField(
                                    onTap: () {
                                      currentIndex =  isHoldingMethodVisible ?8 : 7;//7;
                                      setState(() {});
                                      _animationController.forward();
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(Sizes.dimen_8.r),
                                        borderSide: const BorderSide(
                                          color: AppColor.grey,
                                          width: 1,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(Sizes.dimen_8.r),
                                        borderSide: const BorderSide(
                                          color: AppColor.grey,
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(Sizes.dimen_8.r),
                                        borderSide: const BorderSide(
                                          color: AppColor.grey,
                                          width: 1,
                                        ),
                                      ),

                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: Sizes.dimen_14.w,
                                        vertical: Sizes.dimen_12.w,
                                      ),
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                      suffixIcon: const Icon(
                                        Icons.keyboard_arrow_right,
                                        color: AppColor.textGrey,
                                      ),
                                      hintText: state.selectedNetWorthCurrency?.code ??
                                          '--',
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                        color: AppColor.textGrey?.withValues(alpha: 0.5),
                                      ),
                                    ),
                                    readOnly: true,
                                  ),
                                ),
                              ],
                            );
                            return TextField(
                              onTap: () {
                                currentIndex = 7;
                                setState(() {});
                                _animationController.forward();
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(Sizes.dimen_12.r),
                                  borderSide: const BorderSide(
                                    color: AppColor.grey,
                                    width: 1,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(Sizes.dimen_12.r),
                                  borderSide: const BorderSide(
                                    color: AppColor.grey,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(Sizes.dimen_12.r),
                                  borderSide: const BorderSide(
                                    color: AppColor.grey,
                                    width: 1,
                                  ),
                                ),
                                label: Text(
                                  "Currency",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: AppColor.textGrey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: Sizes.dimen_14.w,
                                  vertical: Sizes.dimen_16.w,
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                suffixIcon: const Icon(
                                  Icons.keyboard_arrow_right,
                                  color: AppColor.textGrey,
                                ),
                                hintText:
                                    state.selectedNetWorthCurrency?.code ??
                                        '--',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: AppColor.textGrey,
                                    ),
                              ),
                              readOnly: true,
                            );
                          } else if (state is NetWorthCurrencyError) {
                            if (state.errorType == AppErrorType.unauthorised) {
                              AppHelpers.logout(context: context);
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                  child: Text(StringConstants.currencyFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                                ),
                                TextField(
                                  onTap: () {},
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(Sizes.dimen_12.r),
                                      borderSide: const BorderSide(
                                        color: AppColor.grey,
                                        width: 1,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(Sizes.dimen_12.r),
                                      borderSide: const BorderSide(
                                        color: AppColor.grey,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(Sizes.dimen_12.r),
                                      borderSide: const BorderSide(
                                        color: AppColor.grey,
                                        width: 1,
                                      ),
                                    ),

                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: Sizes.dimen_14.w,
                                      vertical: Sizes.dimen_16.w,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    suffixIcon: const Icon(
                                      Icons.keyboard_arrow_right,
                                      color: AppColor.textGrey,
                                    ),
                                    hintText: "ERROR",
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: AppColor.textGrey,
                                        ),
                                  ),
                                  readOnly: true,
                                ),
                              ],
                            );
                          }
                          return SizedBox(
                            width: ScreenUtil().screenWidth,
                            height: Sizes.dimen_24.h,
                            child: Shimmer.fromColors(
                              baseColor: AppColor.grey.withOpacity(0.1),
                              highlightColor: AppColor.grey.withOpacity(0.2),
                              direction: ShimmerDirection.ltr,
                              period: const Duration(seconds: 1),
                              child: Container(
                                width: ScreenUtil().screenWidth,
                                height: Sizes.dimen_24.h,
                                decoration: BoxDecoration(
                                    color: AppColor.grey,
                                    borderRadius: BorderRadius.circular(5.0)),
                              ),
                            ),
                          );
                        }),
                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                    BlocBuilder<NetWorthDenominationCubit,
                            NetWorthDenominationState>(
                        bloc: widget.netWorthDenominationCubit,
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                child: Text(StringConstants.denominationFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                              ),
                              Semantics(
                                identifier:StringConstants.denominationFilterKey,
                                child: TextField(
                                  onTap: () {
                                    currentIndex = isHoldingMethodVisible ? 9: 8; //8;
                                    setState(() {});
                                    _animationController.forward();
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(Sizes.dimen_8.r),
                                      borderSide: const BorderSide(
                                        color: AppColor.grey,
                                        width: 1,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(Sizes.dimen_8.r),
                                      borderSide: const BorderSide(
                                        color: AppColor.grey,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(Sizes.dimen_8.r),
                                      borderSide: const BorderSide(
                                        color: AppColor.grey,
                                        width: 1,
                                      ),
                                    ),

                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: Sizes.dimen_14.w,
                                      vertical: Sizes.dimen_12.w,
                                    ),
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                    suffixIcon: const Icon(
                                      Icons.keyboard_arrow_right,
                                      color: AppColor.textGrey,
                                    ),
                                    hintText: state.selectedNetWorthDenomination?.title ??
                                        "--",
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                      color: AppColor.textGrey?.withValues(alpha: 0.5),
                                    ),
                                  ),
                                  readOnly: true,
                                ),
                              ),
                            ],
                          );
                        }),
                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                    BlocBuilder<NetWorthAsOnDateCubit, NetWorthAsOnDateState>(
                        bloc: widget.netWorthAsOnDateCubit,
                        builder: (context, state) {
                          return BlocBuilder<UserCubit, UserEntity?>(
                              builder: (context, user) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                      child: Text(StringConstants.asOnDateFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                                    ),
                                    Semantics(
                                      identifier:StringConstants.asOnDateFilterKey,
                                      child: TextField(
                                        onTap: () {
                                          currentIndex =  isHoldingMethodVisible ? 10 : 9; //9;
                                          setState(() {});
                                          _animationController.forward();
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(Sizes.dimen_8.r),
                                            borderSide: const BorderSide(
                                              color: AppColor.grey,
                                              width: 1,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(Sizes.dimen_8.r),
                                            borderSide: const BorderSide(
                                              color: AppColor.grey,
                                              width: 1,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(Sizes.dimen_8.r),
                                            borderSide: const BorderSide(
                                              color: AppColor.grey,
                                              width: 1,
                                            ),
                                          ),

                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: Sizes.dimen_14.w,
                                            vertical: Sizes.dimen_12.w,
                                          ),
                                          floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                          suffixIcon: const Icon(
                                            Icons.keyboard_arrow_right,
                                            color: AppColor.textGrey,
                                          ),
                                          hintText: DateFormat(user?.dateFormat ?? 'yyyy-MM-dd')
                                              .format(DateTime.parse(state.asOnDate ??
                                              DateTime.now().toString())),
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                            color: AppColor.textGrey?.withValues(alpha: 0.5),
                                          ),
                                        ),
                                        readOnly: true,
                                      ),
                                    ),
                                  ],
                                );
                          });
                        })
                  ],
                ),
              ),
              BlocBuilder<NetWorthLoadingCubit, bool>(
                bloc: widget.netWorthLoadingCubit,
                builder: (context, state) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
                    child: ApplyButton(
                      isEnabled: state,
                      text: StringConstants.applyButton,
                      onPressed: () {
                        widget.netWorthEntityCubit
                            .changeSelectedNetWorthEntity(
                            selectedEntity:
                            tempSaveEntity ?? saveEntity)
                            .then((value) {
                          widget.netWorthReportCubit
                              .reloadNetWorthReport(
                            fromBlankWidget: widget.fromBlankWidget,
                            context: context,
                            favoriteCubit: widget.favoritesCubit,
                            isFavorite: widget.isFavorite,
                            favorite: widget.favorite,
                          );
                        });
                        shouldResetFilter = false;
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                }
              ),
              UIHelper.verticalSpaceSmall
            ],
          ),
        ),
      ),
      SlideTransition(
        position: _animation,
        child: BlocBuilder<NetWorthEntityCubit, NetWorthEntityState>(
            bloc: widget.netWorthEntityCubit,
            builder: (context, state) {
              if (state is NetWorthEntityLoaded) {
                return NetWorthEntityList(
                  scrollController: scroll,
                  netWorthEntityCubit: widget.netWorthEntityCubit,
                  netWorthLoadingCubit: widget.netWorthLoadingCubit,
                  asOnDate: widget.netWorthAsOnDateCubit.state.asOnDate,
                  netWorthGroupingCubit: widget.netWorthGroupingCubit,
                  netWorthPrimarySubGroupingCubit:
                      widget.netWorthPrimarySubGroupingCubit,
                  entity: tempSaveEntity ?? saveEntity,
                  onDone: (entity) {
                    _animationController.reverse();
                    currentIndex = 0;
                    tempSaveEntity = entity;
                    Future.delayed(const Duration(milliseconds: 100), () {
                      buttonsActive = checkToActiveButtons();
                      setState(() {});
                    });
                  },
                );
              }
              return const SizedBox.shrink();
            }),
      ),
      SlideTransition(
        position: _animation,
        child: BlocBuilder<NetWorthPartnershipMethodCubit,
            NetWorthPartnershipMethodState>(
            bloc: widget.netWorthPartnershipMethodCubit,
            builder: (context, state) {
              return NetWorthPartnershipFilterList(
                scrollController: scroll,
                netWorthPartnershipMethodCubit: widget.netWorthPartnershipMethodCubit,
                onDone: () {
                  _animationController.reverse();
                  currentIndex = 0;
                  buttonsActive = checkToActiveButtons();
                  setState(() {});
                },
                netWorthPrimarySubGroupingCubit: widget.netWorthPrimarySubGroupingCubit,
                netWorthGroupingCubit: widget.netWorthGroupingCubit,
                asOnDate: widget.netWorthAsOnDateCubit.state.asOnDate,
                netWorthEntityCubit: widget.netWorthEntityCubit,
                netWorthLoadingCubit: widget.netWorthLoadingCubit,
                netWorthHoldingMethodCubit: widget.netWorthHoldingMethodCubit,
                selectedEntity: tempSaveEntity ?? saveEntity,
              );
            }),
      ),
      if(isHoldingMethodVisible)
        SlideTransition(
          position: _animation,
          child: BlocBuilder<NetWorthHoldingMethodCubit,
              NetWorthHoldingMethodState>(
              bloc: widget.netWorthHoldingMethodCubit,
              builder: (context, state) {
                return NetWorthHoldingMethodList(
                  scrollController: scroll,
                  netWorthHoldingMethodCubit: widget.netWorthHoldingMethodCubit,
                  onDone: () {
                    _animationController.reverse();
                    currentIndex = 0;
                    buttonsActive = checkToActiveButtons();
                    setState(() {});
                  },
                  netWorthLoadingCubit: widget.netWorthLoadingCubit,
                  netWorthPrimarySubGroupingCubit: widget.netWorthPrimarySubGroupingCubit,
                  netWorthEntityCubit: widget.netWorthEntityCubit,
                  asOnDate: widget.netWorthAsOnDateCubit.state.asOnDate,
                  netWorthGroupingCubit: widget.netWorthGroupingCubit,
                  netWorthPartnershipMethodCubit: widget.netWorthPartnershipMethodCubit,
                  selectedEntity: tempSaveEntity ?? saveEntity,
                );
              }),
        ),

      SlideTransition(
        position: _animation,
        child: BlocBuilder<NetWorthGroupingCubit, NetWorthPrimaryGroupingState>(
            bloc: widget.netWorthGroupingCubit,
            builder: (context, state) {
              if (state is NetWorthPrimaryGroupingLoaded) {
                return NetWorthGroupingFilterList(
                  scrollController: scroll,
                  netWorthLoadingCubit: widget.netWorthLoadingCubit,
                  netWorthGroupingCubit: widget.netWorthGroupingCubit,
                  netWorthEntityCubit: widget.netWorthEntityCubit,
                  netWorthPrimarySubGroupingCubit:
                      widget.netWorthPrimarySubGroupingCubit,
                  asOnDate: widget.netWorthAsOnDateCubit.state.asOnDate,
                  selectedEntity: tempSaveEntity ?? saveEntity,
                  onDone: () {
                    _animationController.reverse();
                    currentIndex = 0;
                    Future.delayed(const Duration(milliseconds: 100), () {
                      buttonsActive = checkToActiveButtons();
                      setState(() {});
                    });
                  },
                );
              }
              return const SizedBox.shrink();
            }),
      ),
      SlideTransition(
        position: _animation,
        child: BlocBuilder<NetWorthPrimarySubGroupingCubit,
                NetWorthPrimarySubGroupingState>(
            bloc: widget.netWorthPrimarySubGroupingCubit,
            builder: (context, state) {
              if (state is NetWorthPrimarySubGroupingLoaded) {
                return NetWorthSubGroupingFilterList(
                  scrollController: scroll,
                  netWorthGroupingCubit: widget.netWorthGroupingCubit,
                  netWorthPrimarySubGroupingCubit:
                      widget.netWorthPrimarySubGroupingCubit,
                  onDone: () {
                    _animationController.reverse();
                    currentIndex = 0;
                    buttonsActive = checkToActiveButtons();
                    setState(() {});
                  },
                );
              }
              return const SizedBox.shrink();
            }),
      ),
      SlideTransition(
        position: _animation,
        child: BlocBuilder<NetWorthPeriodCubit, NetWorthPeriodState>(
            bloc: widget.netWorthPeriodCubit,
            builder: (context, state) {
              return NetWorthPeriodFilterList(
                scrollController: scroll,
                netWorthPeriodCubit: widget.netWorthPeriodCubit,
                onDone: () {
                  _animationController.reverse();
                  currentIndex = 0;
                  buttonsActive = checkToActiveButtons();
                  setState(() {});
                },
              );
            }),
      ),
      SlideTransition(
        position: _animation,
        child: BlocBuilder<NetWorthNumberOfPeriodCubit,
                NetWorthNumberOfPeriodState>(
            bloc: widget.netWorthNumberOfPeriodCubit,
            builder: (context, state) {
              return NetWorthNumberOfPeriodFilterList(
                scrollController: scroll,
                netWorthNumberOfPeriodCubit: widget.netWorthNumberOfPeriodCubit,
                onDone: () {
                  _animationController.reverse();
                  currentIndex = 0;
                  buttonsActive = checkToActiveButtons();
                  setState(() {});
                },
              );
            }),
      ),
      // SlideTransition(
      //   position: _animation,
      //   child:
      //       BlocBuilder<NetWorthReturnPercentCubit, NetWorthReturnPercentState>(
      //           bloc: widget.netWorthReturnPercentCubit,
      //           builder: (context, state) {
      //             return NetWorthReturnPercentFilterList(
      //               scrollController: scroll,
      //               netWorthReturnPercentCubit:
      //                   widget.netWorthReturnPercentCubit,
      //               onDone: () {
      //                 _animationController.reverse();
      //                 currentIndex = 0;
      //                 buttonsActive = checkToActiveButtons();
      //                 setState(() {});
      //               },
      //             );
      //           }),
      // ),
      SlideTransition(
        position: _animation,
        child: BlocBuilder<NetWorthCurrencyCubit, NetWorthCurrencyState>(
            bloc: widget.netWorthCurrencyCubit,
            builder: (context, state) {
              return NetWorthCurrencyFilter(
                netWorthDenominationCubit: widget.netWorthDenominationCubit,
                scrollController: scroll,
                netWorthCurrencyCubit: widget.netWorthCurrencyCubit,
                onDone: () {
                  _animationController.reverse();
                  currentIndex = 0;
                  buttonsActive = checkToActiveButtons();
                  setState(() {});
                },
              );
            }),
      ),
      SlideTransition(
        position: _animation,
        child:
            BlocBuilder<NetWorthDenominationCubit, NetWorthDenominationState>(
                bloc: widget.netWorthDenominationCubit,
                builder: (context, state) {
                  return NetWorthDenominationFilter(
                    scrollController: scroll,
                    netWorthDenominationCubit: widget.netWorthDenominationCubit,
                    onDone: () {
                      _animationController.reverse();
                      currentIndex = 0;
                      buttonsActive = checkToActiveButtons();
                      setState(() {});
                    },
                  );
                }),
      ),
      SlideTransition(
        position: _animation,
        child: BlocBuilder<NetWorthAsOnDateCubit, NetWorthAsOnDateState>(
            bloc: widget.netWorthAsOnDateCubit,
            builder: (context, state) {
              return NetWorthDatePickerFilter(
                scrollController: scroll,
                dateLimit: '',
                netWorthAsonDateCubit: widget.netWorthAsOnDateCubit,
                onDone: () {
                  _animationController.reverse();
                  currentIndex = 0;
                  buttonsActive = checkToActiveButtons();
                  setState(() {});
                },
              );
            }),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.3,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return _childWidgets(context, scrollController)[currentIndex];
        });
  }
}
