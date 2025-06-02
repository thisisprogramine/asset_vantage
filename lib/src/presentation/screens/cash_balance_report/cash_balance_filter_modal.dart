import 'dart:developer';

import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/domain/entities/number_of_period/number_of_period.dart';
import 'package:asset_vantage/src/domain/entities/period/period_enitity.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_accounts/cash_balance_account_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_currency/cash_balance_currency_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_entity/cash_balance_entity_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_grouping/cash_balance_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_number_of_period/cash_balance_number_of_period_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_period/cash_balance_period_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_sort_cubit/cash_balance_sort_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_sub_grouping/cash_balance_sub_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/screens/cash_balance_report/cash_balance_account_list.dart';
import 'package:asset_vantage/src/presentation/screens/cash_balance_report/cash_balance_entity_filter_list.dart';
import 'package:asset_vantage/src/presentation/screens/cash_balance_report/cash_balance_period_filter.dart';
import 'package:asset_vantage/src/presentation/screens/cash_balance_report/cash_balance_primary_grouping_list.dart';
import 'package:asset_vantage/src/presentation/widgets/filter_name_with_cross.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:collection/collection.dart';

import '../../../config/constants/size_constants.dart';
import '../../../domain/entities/app_error.dart';
import '../../../domain/entities/authentication/user_entity.dart';
import '../../../domain/entities/cash_balance/cash_balance_grouping_entity.dart';
import '../../../domain/entities/cash_balance/cash_balance_sub_grouping_entity.dart';
import '../../../domain/entities/currency/currency_entity.dart';
import '../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../domain/entities/denomination/denomination_entity.dart';
import '../../../domain/entities/favorites/favorites_entity.dart';
import '../../../utilities/helper/app_helper.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../blocs/authentication/user/user_cubit.dart';
import '../../blocs/cash_balance/cash_balance_as_on_date/cash_balance_as_on_date_cubit.dart';
import '../../blocs/cash_balance/cash_balance_denomination/cash_balance_denomination_cubit.dart';
import '../../blocs/cash_balance/cash_balance_loading/cash_balance_loading_cubit.dart';
import '../../blocs/cash_balance/cash_balance_report/cash_balance_report_cubit.dart';
import '../../blocs/favorites/favorites_cubit.dart';
import '../../blocs/performance/performance_loading/performance_loading_cubit.dart';
import '../../theme/theme_color.dart';
import '../../widgets/apply_button.dart';
import '../../widgets/crossSign.dart';
import 'cash_balance_as_on_date_filter.dart';
import 'cash_balance_currency_filter.dart';
import 'cash_balance_denomination_filter.dart';
import 'cash_balance_number_of_period_filter.dart';
import 'cash_balance_sub_grouping_list.dart';

class CashBalanceFilterModal extends StatefulWidget {
  final CashBalanceEntityCubit cashBalanceEntityCubit;
  final CashBalanceSortCubit cashBalanceSortCubit;
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
  final bool isFavorite;
  final bool fromBlankWidget;
  final Favorite? favorite;
  const CashBalanceFilterModal({
    super.key,
    required this.isFavorite,
    this.fromBlankWidget = false,
    this.favorite,
    required this.cashBalanceEntityCubit,
    required this.cashBalanceSortCubit,
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
  });

  @override
  State<CashBalanceFilterModal> createState() => _CashBalanceFilterModalState();
}

class _CashBalanceFilterModalState extends State<CashBalanceFilterModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  late Animation<Offset> _animation1;
  int currentIndex = 0;
  bool buttonsActive = false;

  EntityData? saveEntity;
  EntityData? tempSaveEntity;
  GroupingEntity? savedPrimaryGrouping;
  List<SubGroupingItemData?>? savedPrimarySubGrouping;
  List<SubGroupingItemData?>? savedAccounts;
  PeriodItemData? savedPeriod;
  NumberOfPeriodItemData? savedNumberOfPeriod;
  Currency? savedCurrency;
  DenominationData? savedDenominationData;
  String? savedAsOnDate;
  bool shouldResetFilter = true;

  @override
  void initState() {
    super.initState();
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

    saveEntity = widget.cashBalanceEntityCubit.state.selectedCashBalanceEntity;
    savedPrimaryGrouping =
        widget.cashBalancePrimaryGroupingCubit.state.selectedGrouping;
    savedPrimarySubGrouping =
        widget.cashBalancePrimarySubGroupingCubit.state.selectedSubGroupingList;
    savedAccounts = [...?widget.cashBalanceAccountCubit.state.selectedAccountsList];
    savedPeriod = widget.cashBalancePeriodCubit.state.selectedCashBalancePeriod;
    savedNumberOfPeriod = widget
        .cashBalanceNumberOfPeriodCubit.state.selectedCashBalanceNumberOfPeriod;
    savedCurrency =
        widget.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency;
    savedDenominationData = widget
        .cashBalanceDenominationCubit.state.selectedCashBalanceDenomination;
    savedAsOnDate = widget.cashBalanceAsOnDateCubit.state.asOnDate;
  }

  @override
  void dispose() {
    _resetFilters(shouldReset: shouldResetFilter);
    super.dispose();
  }

  _resetFilters({required bool shouldReset}) {
    if (shouldReset) {
      tempSaveEntity = null;
      widget.cashBalanceEntityCubit
          .changeSelectedCashBalanceEntity(selectedEntity: saveEntity);
      widget.cashBalancePrimaryGroupingCubit
          .changeSelectedCashBalancePrimaryGrouping(
              selectedGrouping: savedPrimaryGrouping,);
      widget.cashBalancePrimarySubGroupingCubit
          .loadCashBalancePrimarySubGrouping(
          context: context,
              selectedEntity: saveEntity,
              selectedGrouping: savedPrimaryGrouping,
              asOnDate: savedAsOnDate,
              tileName: 'cash_balance');
      widget.cashBalanceAccountCubit.loadCashBalanceAccounts(
          context: context,
          tileName: "cash_balance",
          primarySubGrouping: savedPrimarySubGrouping,
          primaryGrouping: savedPrimaryGrouping,
          selectedEntity: saveEntity,
          asOnDate: savedAsOnDate);
      widget.cashBalancePeriodCubit
          .changeSelectedCashBalancePeriod(selectedPeriod: savedPeriod);
      widget.cashBalanceNumberOfPeriodCubit
          .changeSelectedCashBalanceNumberOfPeriod(
              selectedNumberOfPeriod: savedNumberOfPeriod);
      widget.cashBalanceCurrencyCubit
          .changeSelectedCashBalanceCurrency(selectedCurrency: savedCurrency, cashBalanceDenominationCubit: widget.cashBalanceDenominationCubit);
      widget.cashBalanceDenominationCubit.changeSelectedCashBalanceDenomination(
          selectedDenomination: savedDenominationData);
      widget.cashBalanceAsOnDateCubit.changeAsOnDate(asOnDate: savedAsOnDate);
    }
  }

  bool checkToActiveButtons() {
    if ((tempSaveEntity ?? saveEntity)?.id !=
        widget.cashBalanceEntityCubit.state.selectedCashBalanceEntity?.id ||
        savedPrimaryGrouping?.id !=
            widget.cashBalancePrimaryGroupingCubit.state.selectedGrouping?.id ||
        savedPeriod?.id!= widget.cashBalancePeriodCubit.state.selectedCashBalancePeriod?.id ||
        savedNumberOfPeriod?.id!=widget.cashBalanceNumberOfPeriodCubit.state.selectedCashBalanceNumberOfPeriod?.id ||
        savedCurrency?.id !=
            widget.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency?.id ||
        savedDenominationData?.id !=
            widget.cashBalanceDenominationCubit.state
                .selectedCashBalanceDenomination?.id ||
        savedAsOnDate != widget.cashBalanceAsOnDateCubit.state.asOnDate ||
        !(const DeepCollectionEquality.unordered().equals(
            savedPrimarySubGrouping
                ?.map(
                  (e) => e?.id,
            )
                .toList(),
            widget.cashBalancePrimarySubGroupingCubit.state
                .selectedSubGroupingList
                ?.map(
                  (e) => e?.id,
            )
                .toList())) ||
        !(const DeepCollectionEquality.unordered().equals(
            savedAccounts
                ?.map(
                  (e) => e?.id,
            )
                .toList(),
            widget.cashBalanceAccountCubit.state
                .selectedAccountsList
                ?.map(
                  (e) => e?.id,
            )
                .toList()))) {
      return true;
    } else {
      return false;
    }
  }

  List<Widget> _childFilters(BuildContext context, ScrollController scroll) {
    return [
      SlideTransition(
        position: _animation1,
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_12.w),
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

              const FilterNameWithCross(text: StringConstants.cashBalanceFilterHeader),
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
                    BlocBuilder<CashBalanceEntityCubit, CashBalanceEntityState>(
                        bloc: widget.cashBalanceEntityCubit,
                        builder: (context, state) {
                          if (state is CashBalanceEntityLoaded) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                  child: Text(StringConstants.entityGroupFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                                ),
                                TextField(
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
                                        : state.selectedCashBalanceEntity?.name ??
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
                              ],
                            );
                          } else if (state is CashBalanceEntityError) {
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
                    BlocBuilder<CashBalancePrimaryGroupingCubit,
                            CashBalancePrimaryGroupingState>(
                        bloc: widget.cashBalancePrimaryGroupingCubit,
                        builder: (context, state) {
                          if (state is CashBalancePrimaryGroupingLoaded) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                  child: Text(StringConstants.primaryGrpFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                                ),
                                TextField(
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
                              ],
                            );
                          } else if (state is CashBalancePrimaryGroupingError) {
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
                    BlocBuilder<CashBalancePrimaryGroupingCubit,
                            CashBalancePrimaryGroupingState>(
                        bloc: widget.cashBalancePrimaryGroupingCubit,
                        builder: (context, primaryState) {
                          return BlocBuilder<CashBalancePrimarySubGroupingCubit,
                                  CashBalancePrimarySubGroupingState>(
                              bloc: widget.cashBalancePrimarySubGroupingCubit,
                              builder: (context, state) {
                                if (state
                                        is CashBalancePrimarySubGroupingLoaded &&
                                    primaryState
                                        is CashBalancePrimaryGroupingLoaded) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                        child: Text(StringConstants.primarySubGrpFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                                      ),
                                      TextField(
                                        onTap: () {
                                          currentIndex = 3;
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
                                    ],
                                  );
                                } else if (state
                                    is CashBalancePrimarySubGroupingError) {
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
                    BlocBuilder<CashBalanceAccountCubit,
                            CashBalanceAccountState>(
                        bloc: widget.cashBalanceAccountCubit,
                        builder: (context, state) {
                          if (state is CashBalanceAccountLoaded) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                  child: Text(StringConstants.accountsFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                                ),
                                TextField(
                                  onTap: () {
                                    currentIndex = 4;
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
                                    hintText: (state
                                        .selectedAccountsList?.isNotEmpty ??
                                        false)
                                        ? '${state.selectedAccountsList?.length} Selected'
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
                              ],
                            );
                          }
                          else if (state is CashBalanceAccountError) {
                            if (state.errorType == AppErrorType.unauthorised) {
                              AppHelpers.logout(context: context);
                            }
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                  child: Text(StringConstants.accountsFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
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
                    BlocBuilder<CashBalancePeriodCubit, CashBalancePeriodState>(
                        bloc: widget.cashBalancePeriodCubit,
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                child: Text(StringConstants.periodFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                              ),
                              TextField(
                                onTap: () {
                                  currentIndex = 5;
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
                                  hintText: state.selectedCashBalancePeriod?.name ?? '--',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                    color: AppColor.textGrey?.withValues(alpha: 0.5),
                                  ),
                                ),
                                readOnly: true,
                              ),
                            ],
                          );
                        }),
                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                    BlocBuilder<CashBalanceNumberOfPeriodCubit,
                            CashBalanceNumberOfPeriodState>(
                        bloc: widget.cashBalanceNumberOfPeriodCubit,
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                child: Text(StringConstants.noOfPeriodFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                              ),
                              TextField(
                                onTap: () {
                                  currentIndex = 6;
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
                                  hintText: state.selectedCashBalanceNumberOfPeriod
                                      ?.name ??
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
                            ],
                          );
                        }),
                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                    BlocBuilder<CashBalanceCurrencyCubit,
                            CashBalanceCurrencyState>(
                        bloc: widget.cashBalanceCurrencyCubit,
                        builder: (context, state) {
                          if (state is CashBalanceCurrencyLoaded) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                  child: Text(StringConstants.currencyFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                                ),
                                TextField(
                                  onTap: () {
                                    currentIndex = 7;
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
                                    hintText: state.selectedCashBalanceCurrency?.code ??
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
                              ],
                            );
                          }
                          else if (state is CashBalanceCurrencyError) {
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
                    BlocBuilder<CashBalanceDenominationCubit,
                            CashBalanceDenominationState>(
                        bloc: widget.cashBalanceDenominationCubit,
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                child: Text(StringConstants.denominationFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                              ),
                              TextField(
                                onTap: () {
                                  currentIndex = 8;
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
                                  hintText: state
                                      .selectedCashBalanceDenomination?.title ??
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
                            ],
                          );
                        }),
                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                    BlocBuilder<UserCubit, UserEntity?>(
                        builder: (context, user) {
                      return BlocBuilder<CashBalanceAsOnDateCubit,
                              CashBalanceAsOnDateState>(
                          bloc: widget.cashBalanceAsOnDateCubit,
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                  child: Text(StringConstants.asOnDateFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                                ),
                                TextField(
                                  onTap: () {
                                    currentIndex = 9;
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
                                    hintText: "${DateFormat(user?.dateFormat ?? 'yyyy-MM-dd').format(DateTime.parse(state.asOnDate ?? DateTime.now().toString()))}",
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                      color: AppColor.textGrey?.withValues(alpha: 0.5),
                                    ),
                                  ),
                                  readOnly: true,
                                ),
                              ],
                            );
                          });
                    }),
                  ],
                ),
              ),
              BlocBuilder<CashBalanceLoadingCubit, bool>(
                  bloc: widget.cashBalanceLoadingCubit,
                  builder: (context, state) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
                      child: ApplyButton(
                        isEnabled: state,
                        text: StringConstants.applyButton,
                        onPressed: () {
                          widget.cashBalanceEntityCubit
                              .changeSelectedCashBalanceEntity(
                              selectedEntity: tempSaveEntity ?? saveEntity)
                              .then((value) {
                            widget.cashBalanceReportCubit
                                .reloadCashBalanceReport(
                              context: context,
                              tileName: "cash_balance",favoriteCubit: context.read<FavoritesCubit>(), fromBlankWidget: widget.fromBlankWidget, isFavorite: widget.isFavorite, favorite: widget.favorite,);
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
          child: BlocBuilder<CashBalanceEntityCubit, CashBalanceEntityState>(
              bloc: widget.cashBalanceEntityCubit,
              builder: (context, state) {
                if (state is CashBalanceEntityLoaded) {
                  return CashBalanceEntityFilter(
                    scrollController: scroll,
                    cashBalanceEntityCubit: widget.cashBalanceEntityCubit,
                    cashBalanceLoadingCubit: widget.cashBalanceLoadingCubit,
                    asOnDate: widget.cashBalanceAsOnDateCubit.state.asOnDate,
                    cashBalancePrimaryGroupingCubit:
                        widget.cashBalancePrimaryGroupingCubit,
                    cashBalancePrimarySubGroupingCubit:
                        widget.cashBalancePrimarySubGroupingCubit,
                    cashBalanceAccountCubit: widget.cashBalanceAccountCubit,
                    entity: tempSaveEntity ?? saveEntity,
                    onDone: (entity) {
                      _animationController.reverse();
                      currentIndex = 0;
                      tempSaveEntity = entity;
                      Future.delayed(const Duration(milliseconds: 100),(){
                        buttonsActive = checkToActiveButtons();
                        setState(() {});
                      });
                    },
                  );
                }
                return const SizedBox.shrink();
              })),
      SlideTransition(
          position: _animation,
          child: BlocBuilder<CashBalancePrimaryGroupingCubit,
                  CashBalancePrimaryGroupingState>(
              bloc: widget.cashBalancePrimaryGroupingCubit,
              builder: (context, state) {
                if (state is CashBalancePrimaryGroupingLoaded) {
                  return CashBalancePrimaryGroupingFilter(
                    scrollController: scroll,
                    cashBalanceAccountCubit: widget.cashBalanceAccountCubit,
                    cashBalanceLoadingCubit: widget.cashBalanceLoadingCubit,
                    cashBalancePrimaryGroupingCubit:
                        widget.cashBalancePrimaryGroupingCubit,
                    cashBalanceEntityCubit: widget.cashBalanceEntityCubit,
                    cashBalancePrimarySubGroupingCubit:
                        widget.cashBalancePrimarySubGroupingCubit,
                    asOnDate: widget.cashBalanceAsOnDateCubit.state.asOnDate,
                    selectedEntity: tempSaveEntity ?? saveEntity,
                    onDone: () {
                      _animationController.reverse();
                      currentIndex = 0;
                      Future.delayed(const Duration(milliseconds: 100),(){
                        buttonsActive = checkToActiveButtons();
                        setState(() {});
                      });
                    },
                  );
                }
                return const SizedBox.shrink();
              })),
      SlideTransition(
        position: _animation,
        child: BlocBuilder<CashBalancePrimarySubGroupingCubit,
                CashBalancePrimarySubGroupingState>(
            bloc: widget.cashBalancePrimarySubGroupingCubit,
            builder: (context, state) {
              if (state is CashBalancePrimarySubGroupingLoaded) {
                return CashBalancePrimarySubGroupingFilter(
                  scrollController: scroll,
                  cashBalancePrimaryGroupingCubit:
                      widget.cashBalancePrimaryGroupingCubit,
                  cashBalanceAccountCubit: widget.cashBalanceAccountCubit,
                  cashBalanceAsOnDateCubit: widget.cashBalanceAsOnDateCubit,
                  selectedEntity: tempSaveEntity ?? saveEntity,
                  cashBalancePrimarySubGroupingCubit:
                      widget.cashBalancePrimarySubGroupingCubit,
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
        child: BlocBuilder<CashBalanceAccountCubit, CashBalanceAccountState>(
            bloc: widget.cashBalanceAccountCubit,
            builder: (context, state) {
              if (state is CashBalanceAccountLoaded) {
                return CashBalanceAccountFilter(
                  scrollController: scroll,
                  cashBalanceAccountCubit: widget.cashBalanceAccountCubit,
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
          child: BlocBuilder<CashBalancePeriodCubit, CashBalancePeriodState>(
              bloc: widget.cashBalancePeriodCubit,
              builder: (context, state) {
                return CashBalancePeriodFilter(
                  scrollController: scroll,
                  cashBalancePeriodCubit: widget.cashBalancePeriodCubit,
                  onDone: () {
                    _animationController.reverse();
                    currentIndex = 0;
                    buttonsActive = checkToActiveButtons();
                    setState(() {});
                  },
                );
              })),
      SlideTransition(
          position: _animation,
          child: BlocBuilder<CashBalanceNumberOfPeriodCubit,
                  CashBalanceNumberOfPeriodState>(
              bloc: widget.cashBalanceNumberOfPeriodCubit,
              builder: (context, state) {
                return CashBalanceNumberOfPeriodFilter(
                  scrollController: scroll,
                  cashBalanceNumberOfPeriodCubit:
                      widget.cashBalanceNumberOfPeriodCubit,
                  onDone: () {
                    _animationController.reverse();
                    currentIndex = 0;
                    buttonsActive = checkToActiveButtons();
                    setState(() {});
                  },
                );
              })),
      SlideTransition(
          position: _animation,
          child:
              BlocBuilder<CashBalanceCurrencyCubit, CashBalanceCurrencyState>(
                  bloc: widget.cashBalanceCurrencyCubit,
                  builder: (context, state) {
                    return CashBalanceCurrencyFilter(
                      cashBalanceDenominationCubit: widget.cashBalanceDenominationCubit,
                      scrollController: scroll,
                      cashBalanceCurrencyCubit: widget.cashBalanceCurrencyCubit,
                      onDone: () {
                        _animationController.reverse();
                        currentIndex = 0;
                        buttonsActive = checkToActiveButtons();
                        setState(() {});
                      },
                    );
                  })),
      SlideTransition(
          position: _animation,
          child: BlocBuilder<CashBalanceDenominationCubit,
                  CashBalanceDenominationState>(
              bloc: widget.cashBalanceDenominationCubit,
              builder: (context, state) {
                return CashBalanceDenominationFilter(
                  scrollController: scroll,
                  cashBalanceDenominationCubit:
                      widget.cashBalanceDenominationCubit,
                  onDone: () {
                    _animationController.reverse();
                    currentIndex = 0;
                    buttonsActive = checkToActiveButtons();
                    setState(() {});
                  },
                );
              })),
      SlideTransition(
          position: _animation,
          child:
              BlocBuilder<CashBalanceAsOnDateCubit, CashBalanceAsOnDateState>(
                  bloc: widget.cashBalanceAsOnDateCubit,
                  builder: (context, state) {
                    return CashBalanceAsOnDateFilter(
                      scrollController: scroll,
                      dateLimit: '',
                      cashBalanceAsOnDateCubit: widget.cashBalanceAsOnDateCubit,
                      onDone: () {
                        _animationController.reverse();
                        currentIndex = 0;
                        buttonsActive = checkToActiveButtons();
                        setState(() {});
                      },
                    );
                  })),
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
          return _childFilters(context, scrollController)[currentIndex];
        });
  }
}
