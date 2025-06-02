import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/domain/entities/dashboard/dashboard_list_entity.dart';
import 'package:asset_vantage/src/domain/entities/favorites/favorites_entity.dart';
import 'package:asset_vantage/src/presentation/blocs/favorites/favorites_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_holding_method/performance_holding_method_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_holding_method/performance_holding_method_state.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_number_of_period/performance_number_of_period_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_partnership_method/performance_partnership_method_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_partnership_method/performance_partnership_method_state.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_primary_grouping/performance_primary_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/screens/performance_report/performance_as_on_date_filter.dart';
import 'package:asset_vantage/src/presentation/screens/performance_report/performance_holding_filter_list.dart';
import 'package:asset_vantage/src/presentation/screens/performance_report/performance_partnership_filter_list.dart';
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
import '../../../domain/entities/currency/currency_entity.dart';
import '../../../domain/entities/denomination/denomination_entity.dart';
import '../../../domain/entities/performance/performance_primary_grouping_entity.dart'
    as primary;
import '../../../domain/entities/performance/performance_primary_sub_grouping_enity.dart'
    as primarySub;
import '../../../domain/entities/performance/performance_secondary_grouping_entity.dart'
    as secondary;
import '../../../domain/entities/performance/performance_secondary_sub_grouping_enity.dart'
    as secondarySub;
import '../../../domain/entities/return_percentage/return_percentage_entity.dart';
import '../../../utilities/helper/app_helper.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../blocs/authentication/user/user_cubit.dart';
import '../../blocs/performance/performance_as_on_date/performance_as_on_date_cubit.dart';
import '../../blocs/performance/performance_currency/performance_currency_cubit.dart';
import '../../blocs/performance/performance_denomination/performance_denomination_cubit.dart';
import '../../blocs/performance/performance_entity/performance_entity_cubit.dart';
import '../../blocs/performance/performance_loading/performance_loading_cubit.dart';
import '../../blocs/performance/performance_period/performance_period_cubit.dart';
import '../../blocs/performance/performance_primary_sub_grouping/performance_primary_sub_grouping_cubit.dart';
import '../../blocs/performance/performance_report/performance_report_cubit.dart';
import '../../blocs/performance/performance_return_percent/performance_return_percent_cubit.dart';
import '../../blocs/performance/performance_secondary_grouping/performance_secondary_grouping_cubit.dart';
import '../../blocs/performance/performance_secondary_sub_grouping/performance_secondary_sub_grouping_cubit.dart';
import '../../theme/theme_color.dart';
import '../../widgets/apply_button.dart';
import '../../widgets/crossSign.dart';
import 'performance_currency_filter.dart';
import 'performance_denomination_filter.dart';
import 'performance_entity_filter.dart';
import 'performance_number_of_period_filter.dart';
import 'performance_period_filter.dart';
import 'performance_primary_grouping_filter.dart';
import 'performance_primary_sub_grouping_filter.dart';
import 'performance_return_percent_filter.dart';
import 'performance_secondary_grouping_filter.dart';
import 'performance_secondary_sub_grouping_filter.dart';

class PerformanceUniversalFilter extends StatefulWidget {
  final Function() changeBool;
  Function() changeBoolFromDetails;
  final PerformanceEntityCubit performanceEntityCubit;
  final PerformancePrimaryGroupingCubit performancePrimaryGroupingCubit;
  final PerformanceSecondaryGroupingCubit performanceSecondaryGroupingCubit;
  final PerformancePrimarySubGroupingCubit performancePrimarySubGroupingCubit;
  final PerformanceSecondarySubGroupingCubit
      performanceSecondarySubGroupingCubit;
  final PerformancePeriodCubit performancePeriodCubit;
  final PerformancePartnershipMethodCubit performancePartnershipMethodCubit;
  final PerformanceHoldingMethodCubit performanceHoldingMethodCubit;
  final PerformanceNumberOfPeriodCubit performanceNumberOfPeriodCubit;
  final PerformanceReturnPercentCubit performanceReturnPercentCubit;
  final PerformanceCurrencyCubit performanceCurrencyCubit;
  final PerformanceDenominationCubit performanceDenominationCubit;
  final PerformanceAsOnDateCubit performanceAsOnDateCubit;
  final PerformanceReportCubit performanceReportCubit;
  final PerformanceLoadingCubit performanceLoadingCubit;
  final bool isFavorite;
  final bool fromBlankWidget;
  final Favorite? favorite;

   PerformanceUniversalFilter({
    super.key,
    required this.isFavorite,
    required this.changeBool,
    required this.changeBoolFromDetails,
    this.favorite,
    required this.performanceEntityCubit,
    required this.performancePrimaryGroupingCubit,
    required this.performanceSecondaryGroupingCubit,
    required this.performancePrimarySubGroupingCubit,
    required this.performanceSecondarySubGroupingCubit,
    required this.performanceNumberOfPeriodCubit,
    required this.performanceReturnPercentCubit,
    required this.performanceCurrencyCubit,
    required this.performanceDenominationCubit,
    required this.performanceAsOnDateCubit,
    required this.performancePeriodCubit,
    required this.performanceReportCubit,
    required this.performanceLoadingCubit,
    this.fromBlankWidget = false,
     required this.performancePartnershipMethodCubit,
     required this.performanceHoldingMethodCubit,
  });

  @override
  State<PerformanceUniversalFilter> createState() =>
      _PerformanceUniversalFilterState();
}

class _PerformanceUniversalFilterState extends State<PerformanceUniversalFilter>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  late Animation<Offset> _animation1;
  int currentIndex = 0;
  bool buttonsActive = false;
  bool isHoldingMethodVisible= false;

  EntityData? saveEntity;
  EntityData? tempSaveEntity;
  primary.GroupingEntity? savedPrimaryGrouping;
  secondary.GroupingEntity? savedSecondaryGrouping;
  List<primarySub.SubGroupingItemData?>? savedPrimarySubGrouping;
  List<secondarySub.SubGroupingItemData?>? savedSecondarySubGrouping;
  List<ReturnPercentItemData?>? savedReturnPercentItemDataList;
  Currency? savedCurrency;
  DenominationData? savedDenominationData;
  String? savedAsOnDate;
  bool shouldResetFilter = true;
  bool onDoneClicked = false;

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

    saveEntity = widget.performanceEntityCubit.state.selectedPerformanceEntity;
    savedPrimaryGrouping =
        widget.performancePrimaryGroupingCubit.state.selectedGrouping;
    savedSecondaryGrouping =
        widget.performanceSecondaryGroupingCubit.state.selectedGrouping;
    savedPrimarySubGrouping =
        widget.performancePrimarySubGroupingCubit.state.selectedSubGroupingList;
    savedSecondarySubGrouping = widget
        .performanceSecondarySubGroupingCubit.state.selectedSubGroupingList;
    savedReturnPercentItemDataList = widget.performanceReturnPercentCubit.state
        .selectedPerformanceReturnPercentList;
    savedCurrency =
        widget.performanceCurrencyCubit.state.selectedPerformanceCurrency;
    savedDenominationData = widget
        .performanceDenominationCubit.state.selectedPerformanceDenomination;
    savedAsOnDate = widget.performanceAsOnDateCubit.state.asOnDate;
  }

  @override
  void dispose() {
    _resetFilters(shouldReset: shouldResetFilter);
    super.dispose();
  }

  _resetFilters({required bool shouldReset}) {
    if (shouldReset) {
      tempSaveEntity = null;
      widget.performanceEntityCubit
          .changeSelectedPerformanceEntity(selectedEntity: saveEntity);
      widget.performancePrimaryGroupingCubit
          .changeSelectedPerformancePrimaryGrouping(
              selectedGrouping: savedPrimaryGrouping);
      widget.performanceSecondaryGroupingCubit
          .changeSelectedPerformanceSecondaryGrouping(
              selectedGrouping: savedSecondaryGrouping);
      widget.performancePrimarySubGroupingCubit
          .loadPerformancePrimarySubGrouping(
          context: context,
              selectedEntity: saveEntity,
              selectedGrouping: savedPrimaryGrouping,
              asOnDate: savedAsOnDate);
      widget.performanceSecondarySubGroupingCubit
          .loadPerformanceSecondarySubGrouping(
          context: context,
              selectedEntity: saveEntity,
              primarySubGroupingItem: widget.performancePrimarySubGroupingCubit.state.selectedSubGroupingList,
              selectedGrouping: savedSecondaryGrouping,
              asOnDate: savedAsOnDate);
      widget.performanceReturnPercentCubit
          .changeSelectedPerformanceReturnPercent(
          context: context,
              selectedReturnPercentList: savedReturnPercentItemDataList ?? []);
      widget.performanceCurrencyCubit
          .changeSelectedPerformanceCurrency(selectedCurrency: savedCurrency, performanceDenominationCubit: widget.performanceDenominationCubit);
      widget.performanceDenominationCubit.changeSelectedPerformanceDenomination(
          selectedDenomination: savedDenominationData);
      widget.performanceAsOnDateCubit.changeAsOnDate(asOnDate: savedAsOnDate);
    }
  }

  bool checkToActiveButtons() {
    if ((tempSaveEntity ?? saveEntity)?.id !=
                widget.performanceEntityCubit.state.selectedPerformanceEntity
                    ?.id ||
            savedPrimaryGrouping?.id !=
                widget.performancePrimaryGroupingCubit.state.selectedGrouping
                    ?.id ||
            savedSecondaryGrouping?.id !=
                widget.performanceSecondaryGroupingCubit.state.selectedGrouping
                    ?.id ||
            savedCurrency?.id !=
                widget.performanceCurrencyCubit.state
                    .selectedPerformanceCurrency?.id ||
            savedDenominationData?.id !=
                widget.performanceDenominationCubit.state
                    .selectedPerformanceDenomination?.id ||
            savedAsOnDate != widget.performanceAsOnDateCubit.state.asOnDate ||
            !(const DeepCollectionEquality.unordered().equals(
                savedPrimarySubGrouping
                    ?.map(
                      (e) => e?.id,
                    )
                    .toList(),
                widget.performancePrimarySubGroupingCubit.state
                    .selectedSubGroupingList
                    ?.map(
                      (e) => e?.id,
                    )
                    .toList())) ||
            !(const DeepCollectionEquality.unordered().equals(
                savedSecondarySubGrouping
                    ?.map(
                      (e) => e?.id,
                    )
                    .toList(),
                widget.performanceSecondarySubGroupingCubit.state
                    .selectedSubGroupingList
                    ?.map(
                      (e) => e?.id,
                    )
                    .toList())) ||
            !(const DeepCollectionEquality.unordered().equals(
                savedReturnPercentItemDataList
                    ?.map(
                      (e) => e?.id,
                    )
                    .toList(),
                widget.performanceReturnPercentCubit.state
                    .selectedPerformanceReturnPercentList
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
              const FilterNameWithCross(text: StringConstants.performanceFilterHeader),
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
                    BlocBuilder<PerformanceEntityCubit,
                            PerformanceEntityState>(
                        bloc: widget.performanceEntityCubit,
                        builder: (context, state) {
                          if (state is PerformanceEntityLoaded) {
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
                                        : state.selectedPerformanceEntity?.name ??
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
                          else if (state is PerformanceEntityError) {
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
                                  onTap: () {
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
                                    hintText: "ERROR",
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
                    BlocBuilder<PerformancePartnershipMethodCubit, PerformancePartnershipMethodState>(
                      bloc: widget.performancePartnershipMethodCubit,
                      builder: (context,state){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                              child: Text(StringConstants.partnershipMethod, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
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
                                hintText: state.selectedPerformancePartnershipMethod?.name
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
                      },

                    ),
                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                    BlocBuilder<PerformancePartnershipMethodCubit,
                        PerformancePartnershipMethodState>(
                      bloc: widget.performancePartnershipMethodCubit,
                      builder: (context,partnershipState){
                        isHoldingMethodVisible = partnershipState.selectedPerformancePartnershipMethod != null &&
                            partnershipState.selectedPerformancePartnershipMethod?.name != "None";

                        if(isHoldingMethodVisible){
                          return BlocBuilder<PerformanceHoldingMethodCubit,PerformanceHoldingMethodState>(
                            bloc: widget.performanceHoldingMethodCubit,
                            builder: (context,state){
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                    child: Text(StringConstants.holdingMethod, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                                  ),
                                  TextField(
                                    onTap: () {
                                      currentIndex = isHoldingMethodVisible ? 3:0;
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
                                      hintText: state.selectedPerformanceHoldingMethod?.name
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
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                    BlocBuilder<PerformancePrimaryGroupingCubit,
                            PerformancePrimaryGroupingState>(
                        bloc: widget.performancePrimaryGroupingCubit,
                        builder: (context, state) {
                          if (state is PerformancePrimaryGroupingLoaded) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                  child: Text(StringConstants.primaryGrpFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                                ),
                                TextField(
                                  onTap: () {
                                    currentIndex = isHoldingMethodVisible? 4:3;
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
                          }
                          else if (state is PerformancePrimaryGroupingError) {
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
                                  onTap: () {
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
                                    hintText: "ERROR",
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
                    BlocBuilder<PerformancePrimaryGroupingCubit,
                            PerformancePrimaryGroupingState>(
                        bloc: widget.performancePrimaryGroupingCubit,
                        builder: (context, primaryState) {
                          return BlocBuilder<
                                  PerformancePrimarySubGroupingCubit,
                                  PerformancePrimarySubGroupingState>(
                              bloc: widget.performancePrimarySubGroupingCubit,
                              builder: (context, state) {
                                if (state
                                        is PerformancePrimarySubGroupingLoaded &&
                                    primaryState
                                        is PerformancePrimaryGroupingLoaded) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                        child: Text(StringConstants.primarySubGrpFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                                      ),
                                      TextField(
                                        onTap: () {
                                          currentIndex = isHoldingMethodVisible? 5: 4;
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
                                    is PerformancePrimarySubGroupingError) {
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
                    BlocBuilder<PerformanceSecondaryGroupingCubit,
                            PerformanceSecondaryGroupingState>(
                        bloc: widget.performanceSecondaryGroupingCubit,
                        builder: (context, state) {
                          if (state is PerformanceSecondaryGroupingLoaded) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                  child: Text(StringConstants.secondaryGrpFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                                ),
                                TextField(
                                  onTap: () {
                                    currentIndex = isHoldingMethodVisible? 6: 5;
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
                          }
                          else if (state is PerformanceSecondaryGroupingError) {
                            if (state.errorType == AppErrorType.unauthorised) {
                              AppHelpers.logout(context: context);
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                  child: Text(StringConstants.secondaryGrpFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                                ),
                                TextField(
                                  onTap: () {
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
                                    hintText: "ERROR",
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
                    BlocBuilder<PerformanceSecondaryGroupingCubit,
                            PerformanceSecondaryGroupingState>(
                        bloc: widget.performanceSecondaryGroupingCubit,
                        builder: (context, primaryState) {
                          return BlocBuilder<
                                  PerformanceSecondarySubGroupingCubit,
                                  PerformanceSecondarySubGroupingState>(
                              bloc: widget.performanceSecondarySubGroupingCubit,
                              builder: (context, state) {
                                if (state
                                        is PerformanceSecondarySubGroupingLoaded &&
                                    primaryState
                                        is PerformanceSecondaryGroupingLoaded) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                        child: Text(StringConstants.secondarySubGrpFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                                      ),
                                      TextField(
                                        onTap: () {
                                          currentIndex = isHoldingMethodVisible? 7: 6;
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
                                    is PerformanceSecondarySubGroupingError) {
                                  if (state.errorType ==
                                      AppErrorType.unauthorised) {
                                    AppHelpers.logout(context: context);
                                  }
                                  return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                  Padding(
                                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                child: Text(StringConstants.secondarySubGrpFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
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
                    BlocBuilder<PerformanceReturnPercentCubit,
                            PerformanceReturnPercentState>(
                        bloc: widget.performanceReturnPercentCubit,
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                child: Text(StringConstants.returnPercentageFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                              ),
                              TextField(
                                onTap: () {
                                  currentIndex = isHoldingMethodVisible? 8: 7;
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
                                      .selectedPerformanceReturnPercentList
                                      ?.isNotEmpty ??
                                      false)
                                      ? '${state.selectedPerformanceReturnPercentList?.length} Selected'
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
                        }),
                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                    BlocBuilder<PerformanceCurrencyCubit,
                            PerformanceCurrencyState>(
                        bloc: widget.performanceCurrencyCubit,
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                child: Text(StringConstants.currencyFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                              ),
                              TextField(
                                onTap: () {
                                  currentIndex = isHoldingMethodVisible? 9 : 8;
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
                                  hintText: state.selectedPerformanceCurrency?.code ??
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
                    BlocBuilder<PerformanceDenominationCubit,
                            PerformanceDenominationState>(
                        bloc: widget.performanceDenominationCubit,
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
                                  currentIndex = isHoldingMethodVisible?10 : 9;
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
                                      .selectedPerformanceDenomination?.title ??
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
                      return BlocBuilder<PerformanceAsOnDateCubit,
                              PerformanceAsOnDateState>(
                          bloc: widget.performanceAsOnDateCubit,
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
                                    currentIndex = isHoldingMethodVisible ? 11 :10;
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
                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                  ],
                ),
              ),
              BlocBuilder<PerformanceLoadingCubit, bool>(
                  bloc: widget.performanceLoadingCubit,
                  builder: (context, state) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
                      child: ApplyButton(
                        isEnabled: state,
                        text: StringConstants.applyButton,
                        onPressed: () async{
                          widget.performanceEntityCubit
                              .changeSelectedPerformanceEntity(
                              selectedEntity:
                              tempSaveEntity ?? saveEntity)
                              .then((value) {
                            widget.performanceReportCubit
                                .reloadPerformanceReport(
                              fromBlankWidget: widget.fromBlankWidget,
                              context: context,
                              favoriteCubit: context.read<FavoritesCubit>(),
                              isFavorite: widget.isFavorite,
                              favorite: widget.favorite,
                            );
                          });
                          shouldResetFilter = false;
                          widget.changeBool();
                          widget.changeBoolFromDetails();
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
          child: BlocBuilder<PerformanceEntityCubit, PerformanceEntityState>(
              bloc: widget.performanceEntityCubit,
              builder: (context, state) {
                if (state is PerformanceEntityLoaded) {
                  return PerformanceEntityFilter(
                    scrollController: scroll,
                    performanceEntityCubit: widget.performanceEntityCubit,
                    performancePrimaryGroupingCubit:
                        widget.performancePrimaryGroupingCubit,
                    performancePrimarySubGroupingCubit:
                        widget.performancePrimarySubGroupingCubit,
                    performanceSecondaryGroupingCubit:
                        widget.performanceSecondaryGroupingCubit,
                    performanceSecondarySubGroupingCubit:
                        widget.performanceSecondarySubGroupingCubit,
                    asOnDate: widget.performanceAsOnDateCubit.state.asOnDate,
                    performanceLoadingCubit: widget.performanceLoadingCubit,
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
              })),
      SlideTransition(
        position: _animation,
        child: BlocBuilder<PerformancePartnershipMethodCubit,
            PerformancePartnershipMethodState>(
          bloc: widget.performancePartnershipMethodCubit,
            builder: (context,state){
              return PerformancePartnershipFilterList(
                  scrollController: scroll,
                  performancePartnershipMethodCubit: widget.performancePartnershipMethodCubit,
                  onDone: (){
                    _animationController.reverse();
                    currentIndex = 0;
                    buttonsActive = checkToActiveButtons();
                    setState(() {});
                  },
                  performancePrimarySubGroupingCubit: widget.performancePrimarySubGroupingCubit,
                  performancePrimaryGroupingCubit: widget.performancePrimaryGroupingCubit,
                  performanceEntityCubit: widget.performanceEntityCubit,
                  performanceLoadingCubit: widget.performanceLoadingCubit,
                  asOnDate: widget.performanceAsOnDateCubit.state.asOnDate,
                performanceSecondarySubGroupingCubit: widget.performanceSecondarySubGroupingCubit,
                performanceSecondaryGroupingCubit: widget.performanceSecondaryGroupingCubit,
                performanceHoldingMethodCubit: widget.performanceHoldingMethodCubit,
                selectedEntity: tempSaveEntity ?? saveEntity,);
            }),
      ),
      if(isHoldingMethodVisible)
        SlideTransition(
        position: _animation,
        child: BlocBuilder<PerformanceHoldingMethodCubit,
            PerformanceHoldingMethodState>(
            bloc: widget.performanceHoldingMethodCubit,
            builder: (context,state){
              return PerformanceHoldingFilterList(
                scrollController: scroll,
                performancePartnershipMethodCubit: widget.performancePartnershipMethodCubit,
                onDone: (){
                  _animationController.reverse();
                  currentIndex = 0;
                  buttonsActive = checkToActiveButtons();
                  setState(() {});
                },
                performancePrimarySubGroupingCubit: widget.performancePrimarySubGroupingCubit,
                performancePrimaryGroupingCubit: widget.performancePrimaryGroupingCubit,
                performanceEntityCubit: widget.performanceEntityCubit,
                performanceLoadingCubit: widget.performanceLoadingCubit,
                asOnDate: widget.performanceAsOnDateCubit.state.asOnDate,
                performanceSecondarySubGroupingCubit: widget.performanceSecondarySubGroupingCubit,
                performanceSecondaryGroupingCubit: widget.performanceSecondaryGroupingCubit,
                performanceHoldingMethodCubit: widget.performanceHoldingMethodCubit,
                selectedEntity: tempSaveEntity ?? saveEntity,);
            }),
      ),

      SlideTransition(
          position: _animation,
          child: BlocBuilder<PerformancePrimaryGroupingCubit,
                  PerformancePrimaryGroupingState>(
              bloc: widget.performancePrimaryGroupingCubit,
              builder: (context, state) {
                if (state is PerformancePrimaryGroupingLoaded) {
                  return PerformancePrimaryGroupingFilter(
                    scrollController: scroll,
                    performancePrimaryGroupingCubit:
                        widget.performancePrimaryGroupingCubit,
                    performancePrimarySubGroupingCubit:
                        widget.performancePrimarySubGroupingCubit,
                    performanceEntityCubit: widget.performanceEntityCubit,
                    asOnDate: widget.performanceAsOnDateCubit.state.asOnDate,
                    performanceLoadingCubit: widget.performanceLoadingCubit,
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
              })),
      SlideTransition(
        position: _animation,
        child: BlocBuilder<PerformancePrimarySubGroupingCubit,
                PerformancePrimarySubGroupingState>(
            bloc: widget.performancePrimarySubGroupingCubit,
            builder: (context, state) {
              if (state is PerformancePrimarySubGroupingLoaded) {
                return PerformancePrimarySubGroupingFilter(
                  scrollController: scroll,
                  asOnDate: widget.performanceAsOnDateCubit.state.asOnDate,
                  selectedEntity: tempSaveEntity ?? saveEntity,
                  performancePrimarySubGroupingCubit:
                      widget.performancePrimarySubGroupingCubit,
                  performanceSecondaryGroupingCubit: widget.performanceSecondaryGroupingCubit,
                  performancePrimaryGroupingCubit:
                      widget.performancePrimaryGroupingCubit,
                  onDone: () {
                    _animationController.reverse();
                    currentIndex = 0;
                    buttonsActive = checkToActiveButtons();
                    setState(() {});
                  }, performanceSecondarySubGroupingCubit: widget.performanceSecondarySubGroupingCubit,
                );
              }
              return const SizedBox.shrink();
            }),
      ),
      SlideTransition(
          position: _animation,
          child: BlocBuilder<PerformanceSecondaryGroupingCubit,
                  PerformanceSecondaryGroupingState>(
              bloc: widget.performanceSecondaryGroupingCubit,
              builder: (context, state) {
                if (state is PerformanceSecondaryGroupingLoaded) {
                  return PerformanceSecondaryGroupingFilter(
                    scrollController: scroll,
                    performancePrimarySubGroupingCubit: widget.performancePrimarySubGroupingCubit,
                    performanceSecondaryGroupingCubit:
                        widget.performanceSecondaryGroupingCubit,
                    performanceSecondarySubGroupingCubit:
                        widget.performanceSecondarySubGroupingCubit,
                    performanceEntityCubit: widget.performanceEntityCubit,
                    asOnDate: widget.performanceAsOnDateCubit.state.asOnDate,
                    performanceLoadingCubit: widget.performanceLoadingCubit,
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
              })),
      SlideTransition(
          position: _animation,
          child: BlocBuilder<PerformanceSecondarySubGroupingCubit,
                  PerformanceSecondarySubGroupingState>(
              bloc: widget.performanceSecondarySubGroupingCubit,
              builder: (context, state) {
                if (state is PerformanceSecondarySubGroupingLoaded) {
                  return PerformanceSecondarySubGroupingFilter(
                    scrollController: scroll,
                    performanceSecondarySubGroupingCubit:
                        widget.performanceSecondarySubGroupingCubit,
                    performanceSecondaryGroupingCubit:
                        widget.performanceSecondaryGroupingCubit,
                    onDone: () {
                      _animationController.reverse();
                      currentIndex = 0;
                      buttonsActive = checkToActiveButtons();
                      setState(() {});
                    },
                  );
                }
                return const SizedBox.shrink();
              })),
      SlideTransition(
          position: _animation,
          child: BlocBuilder<PerformanceReturnPercentCubit,
                  PerformanceReturnPercentState>(
              bloc: widget.performanceReturnPercentCubit,
              builder: (context, state) {
                return PerformanceReturnPercentFilter(
                  scrollController: scroll,
                  performanceReturnPercentCubit:
                      widget.performanceReturnPercentCubit,
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
              BlocBuilder<PerformanceCurrencyCubit, PerformanceCurrencyState>(
                  bloc: widget.performanceCurrencyCubit,
                  builder: (context, state) {
                    return PerformanceCurrencyFilter(
                      performanceDenominationCubit: widget.performanceDenominationCubit,
                      scrollController: scroll,
                      performanceCurrencyCubit: widget.performanceCurrencyCubit,
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
          child: BlocBuilder<PerformanceDenominationCubit,
                  PerformanceDenominationState>(
              bloc: widget.performanceDenominationCubit,
              builder: (context, state) {
                return PerformanceDenominationFilter(
                  scrollController: scroll,
                  performanceDenominationCubit:
                      widget.performanceDenominationCubit,
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
              BlocBuilder<PerformanceAsOnDateCubit, PerformanceAsOnDateState>(
                  bloc: widget.performanceAsOnDateCubit,
                  builder: (context, state) {
                    return PerformanceAsOnDateFilter(
                      scrollController: scroll,
                      dateLimit: '',
                      performanceAsOnDateCubit: widget.performanceAsOnDateCubit,
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
