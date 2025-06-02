
import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/domain/entities/number_of_period/number_of_period.dart';
import 'package:asset_vantage/src/presentation/screens/income_report/income_account_filter.dart';
import 'package:asset_vantage/src/presentation/screens/income_report/income_as_on_date_filter.dart';
import 'package:asset_vantage/src/presentation/screens/income_report/income_currency_filter.dart';
import 'package:asset_vantage/src/presentation/screens/income_report/income_denomination_filter.dart';
import 'package:asset_vantage/src/presentation/screens/income_report/income_number_of_period_filter.dart';
import 'package:asset_vantage/src/presentation/screens/income_report/income_period_filter.dart';
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
import '../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../domain/entities/denomination/denomination_entity.dart';
import '../../../domain/entities/favorites/favorites_entity.dart';
import '../../../domain/entities/income/income_account_entity.dart';
import '../../../domain/entities/period/period_enitity.dart';
import '../../../utilities/helper/app_helper.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../blocs/authentication/user/user_cubit.dart';
import '../../blocs/favorites/favorites_cubit.dart';
import '../../blocs/income/income_account/income_account_cubit.dart';
import '../../blocs/income/income_as_on_date/income_as_on_date_cubit.dart';
import '../../blocs/income/income_currency/income_currency_cubit.dart';
import '../../blocs/income/income_denomination/income_denomination_cubit.dart';
import '../../blocs/income/income_entity/income_entity_cubit.dart';
import '../../blocs/income/income_loading/income_loading_cubit.dart';
import '../../blocs/income/income_number_of_period/income_number_of_period_cubit.dart';
import '../../blocs/income/income_period/income_period_cubit.dart';
import '../../blocs/income/income_report/income_report_cubit.dart';
import '../../theme/theme_color.dart';
import '../../widgets/apply_button.dart';
import '../../widgets/crossSign.dart';
import 'income_entity_filter.dart';

class IncomeUniversalFilter extends StatefulWidget {
  final IncomeEntityCubit incomeEntityCubit;
  final IncomeAccountCubit incomeAccountCubit;
  final IncomePeriodCubit incomePeriodCubit;
  final IncomeNumberOfPeriodCubit incomeNumberOfPeriodCubit;
  final IncomeCurrencyCubit incomeCurrencyCubit;
  final IncomeDenominationCubit incomeDenominationCubit;
  final IncomeAsOnDateCubit incomeAsOnDateCubit;
  final IncomeReportCubit incomeReportCubit;
  final IncomeLoadingCubit incomeLoadingCubit;
  final bool isFavorite;
  final bool fromBlankWidget;
  final Favorite? favorite;

  const IncomeUniversalFilter({
    super.key,
    required this.isFavorite,
    this.fromBlankWidget = false,
    this.favorite,
    required this.incomeEntityCubit,
    required this.incomeAccountCubit,
    required this.incomeNumberOfPeriodCubit,
    required this.incomeCurrencyCubit,
    required this.incomeDenominationCubit,
    required this.incomeAsOnDateCubit,
    required this.incomePeriodCubit,
    required this.incomeReportCubit,
    required this.incomeLoadingCubit,
  });

  @override
  State<IncomeUniversalFilter> createState() => _IncomeUniversalFilterState();
}

class _IncomeUniversalFilterState extends State<IncomeUniversalFilter> with SingleTickerProviderStateMixin{
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  late Animation<Offset> _animation1;
  int currentIndex = 0;
  bool buttonsActive = false;

  EntityData? saveEntity;
  EntityData? tempSaveEntity;
  List<Account?>? savedAccount;
  PeriodItemData? savedPeriod;
  NumberOfPeriodItemData? savedNumberOfPeriod;
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

    saveEntity = widget.incomeEntityCubit.state.selectedIncomeEntity;
    savedAccount = widget.incomeAccountCubit.state.selectedAccountList;
    savedPeriod = widget.incomePeriodCubit.state.selectedIncomePeriod;
    savedNumberOfPeriod = widget.incomeNumberOfPeriodCubit.state.selectedIncomeNumberOfPeriod;
    savedCurrency = widget.incomeCurrencyCubit.state.selectedIncomeCurrency;
    savedDenominationData = widget.incomeDenominationCubit.state.selectedIncomeDenomination;
    savedAsOnDate = widget.incomeAsOnDateCubit.state.asOnDate;
  }

  @override
  void dispose() {
    _resetFilters(shouldReset: shouldResetFilter);
    super.dispose();
  }

  _resetFilters({required bool shouldReset}) {
    if(shouldReset) {
      tempSaveEntity = null;
      widget.incomeEntityCubit.changeSelectedIncomeEntity(selectedEntity: saveEntity);
      widget.incomeAccountCubit.changeSelectedIncomeAccount(selectedIncomeAccountList: savedAccount ?? []);
      widget.incomePeriodCubit.changeSelectedIncomePeriod(selectedPeriod: savedPeriod);
      widget.incomeNumberOfPeriodCubit.changeSelectedIncomeNumberOfPeriod(selectedNumberOfPeriod: savedNumberOfPeriod);
      widget.incomeCurrencyCubit.changeSelectedIncomeCurrency(selectedCurrency: savedCurrency, incomeDenominationCubit: widget.incomeDenominationCubit);
      widget.incomeDenominationCubit.changeSelectedIncomeDenomination(selectedDenomination: savedDenominationData);
      widget.incomeAsOnDateCubit.changeAsOnDate(asOnDate: savedAsOnDate);
    }
  }

  bool checkToActiveButtons() {
    if ((tempSaveEntity ?? saveEntity)?.id !=
        widget.incomeEntityCubit.state.selectedIncomeEntity?.id ||
        savedPeriod?.id!= widget.incomePeriodCubit.state.selectedIncomePeriod?.id ||
        savedNumberOfPeriod?.id!=widget.incomeNumberOfPeriodCubit.state.selectedIncomeNumberOfPeriod?.id ||
        savedCurrency?.id !=
            widget.incomeCurrencyCubit.state.selectedIncomeCurrency?.id ||
        savedDenominationData?.id !=
            widget.incomeDenominationCubit.state
                .selectedIncomeDenomination?.id ||
        savedAsOnDate != widget.incomeAsOnDateCubit.state.asOnDate ||
        !(const DeepCollectionEquality.unordered().equals(
            savedAccount
                ?.map(
                  (e) => e?.id,
            )
                .toList(),
            widget.incomeAccountCubit.state
                .selectedAccountList
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
          padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_12.w),
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
              const FilterNameWithCross(text: StringConstants.incomeFilterHeader),
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
                    BlocBuilder<IncomeEntityCubit, IncomeEntityState>(
                      bloc: widget.incomeEntityCubit,
                      builder: (context, state) {
                        if(state is IncomeEntityLoaded) {
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
                                  hintText: tempSaveEntity != null ? tempSaveEntity?.name : state.selectedIncomeEntity?.name ?? '--',
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
                          return TextField(
                            onTap: () {
                              currentIndex = 1;
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
                                "Entity/Group",
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
                              hintText: tempSaveEntity != null ? tempSaveEntity?.name : state.selectedIncomeEntity?.name ?? '--',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                color: AppColor.textGrey,
                              ),
                            ),
                            readOnly: true,
                          );
                        }
                        else if (state is IncomeEntityError) {
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
                      }
                    ),
                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                    BlocBuilder<IncomeAccountCubit, IncomeAccountState>(
                        bloc: widget.incomeAccountCubit,
                        builder: (context, state) {
                          if(state is IncomeAccountLoaded) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                  child: Text(StringConstants.accountsFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
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
                                    hintText: (state.selectedIncomeAccountList?.isNotEmpty ?? false) ? "${state.selectedIncomeAccountList?.length} Selected" : "None Selected",
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
                            return TextField(
                              onTap: () {
                                currentIndex = 2;
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
                                  "Accounts",
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
                                hintText: (state.selectedIncomeAccountList?.isNotEmpty ?? false) ? "${state.selectedIncomeAccountList?.length} Selected" : "None Selected",
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                  color: AppColor.textGrey,
                                ),
                              ),
                              readOnly: true,
                            );
                          }
                          else if (state is IncomeAccountError) {
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
                        }
                    ),
                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                    BlocBuilder<IncomePeriodCubit, IncomePeriodState>(
                        bloc: widget.incomePeriodCubit,
                        builder: (context, state) {
                          if(state is IncomePeriodLoaded) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                  child: Text(StringConstants.periodFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
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
                                    hintText: state.selectedPeriod?.name ?? '--',
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
                            return TextField(
                              onTap: () {
                                currentIndex = 3;
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
                                  "Period",
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
                                hintText: state.selectedPeriod?.name ?? '--',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                  color: AppColor.textGrey,
                                ),
                              ),
                              readOnly: true,
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
                        }
                    ),
                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                    BlocBuilder<IncomeNumberOfPeriodCubit, IncomeNumberOfPeriodState>(
                        bloc: widget.incomeNumberOfPeriodCubit,
                        builder: (context, state) {
                          if(state is IncomeNumberOfPeriodLoaded) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                  child: Text(StringConstants.noOfPeriodFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
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
                                    hintText:  state.selectedIncomeNumberOfPeriod?.name ?? '--',
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
                            return TextField(
                              onTap: () {
                                currentIndex = 4;
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
                                hintText: state.selectedIncomeNumberOfPeriod?.name ?? '--',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                  color: AppColor.textGrey,
                                ),
                              ),
                              readOnly: true,
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
                        }
                    ),
                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                    BlocBuilder<IncomeCurrencyCubit, IncomeCurrencyState>(
                        bloc: widget.incomeCurrencyCubit,
                        builder: (context, state) {
                          if(state is IncomeCurrencyLoaded) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                  child: Text(StringConstants.currencyFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
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
                                    hintText: state.selectedIncomeCurrency?.code ?? '--',
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
                                hintText: state.selectedIncomeCurrency?.code ?? '--',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                  color: AppColor.textGrey,
                                ),
                              ),
                              readOnly: true,
                            );
                          }
                          else if (state is IncomeCurrencyError) {
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
                        }
                    ),
                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                    BlocBuilder<IncomeDenominationCubit, IncomeDenominationState>(
                        bloc: widget.incomeDenominationCubit,
                        builder: (context, state) {
                          if(state is IncomeDenominationLoaded) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                  child: Text(StringConstants.denominationFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
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
                                    hintText: state.selectedDenomination?.title ?? '--',
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
                            return TextField(
                              onTap: () {
                                currentIndex = 6;
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
                                  "Denomination",
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
                                hintText: state.selectedDenomination?.title ?? '--',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                  color: AppColor.textGrey,
                                ),
                              ),
                              readOnly: true,
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
                        }
                    ),
                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                    BlocBuilder<UserCubit, UserEntity?>(
                        builder: (context, user) {
                        return BlocBuilder<IncomeAsOnDateCubit, IncomeAsOnDateState>(
                            bloc: widget.incomeAsOnDateCubit,
                            builder: (context, state) {
                              if(state is AsOnDateChanged) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                      child: Text(StringConstants.asOnDateFilterString, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
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
                                      "As on Date",
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
                                    hintText: "${DateFormat(user?.dateFormat ?? 'yyyy-MM-dd').format(DateTime.parse(state.asOnDate ?? DateTime.now().toString()))}",
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                      color: AppColor.textGrey,
                                    ),
                                  ),
                                  readOnly: true,
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
                            }
                        );
                      }
                    ),
                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                  ],
                ),
              ),
              BlocBuilder<IncomeLoadingCubit, bool>(
                  bloc: widget.incomeLoadingCubit,
                  builder: (context, state) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
                      child: ApplyButton(
                        isEnabled: state,
                        text: StringConstants.applyButton,
                        onPressed: () {
                          widget.incomeEntityCubit.changeSelectedIncomeEntity(selectedEntity: tempSaveEntity ?? saveEntity).then((value) {
                            widget.incomeReportCubit.reloadIncomeReport(context: context,favoriteCubit: context.read<FavoritesCubit>(), fromBlankWidget: widget.fromBlankWidget, isFavorite: widget.isFavorite, favorite: widget.favorite,);
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
          child: BlocBuilder<IncomeEntityCubit, IncomeEntityState>(
            bloc: widget.incomeEntityCubit,
            builder: (context, state) {
              if(state is IncomeEntityLoaded) {
                return IncomeEntityFilter(
                  scrollController: scroll,
                  incomeEntityCubit: widget.incomeEntityCubit,
                  asOnDate: widget.incomeAsOnDateCubit.state.asOnDate,
                  incomeLoadingCubit: widget.incomeLoadingCubit,
                  incomeAccountCubit: widget.incomeAccountCubit,
                  entity: tempSaveEntity,
                  onDone: (entity) {
                    _animationController.reverse();
                    currentIndex = 0;
                    if(entity != null) {
                      tempSaveEntity = entity;
                    }
                    Future.delayed(const Duration(milliseconds: 100),(){
                      buttonsActive = checkToActiveButtons();
                      setState(() {});
                    });
                  },
                );
              }
              return const SizedBox.shrink();
            }
          )
      ),
      SlideTransition(
          position: _animation,
          child: BlocBuilder<IncomeAccountCubit, IncomeAccountState>(
              bloc: widget.incomeAccountCubit,
              builder: (context, state) {
                if(state is IncomeAccountLoaded) {
                  return IncomeAccountFilter(
                    scrollController: scroll,
                    incomeAccountCubit: widget.incomeAccountCubit,
                    onDone: () {
                      _animationController.reverse();
                      currentIndex = 0;
                      buttonsActive = checkToActiveButtons();
                      setState(() {});
                    },
                  );
                }
                return const SizedBox.shrink();
              }
          )
      ),
      SlideTransition(
          position: _animation,
          child: BlocBuilder<IncomePeriodCubit, IncomePeriodState>(
              bloc: widget.incomePeriodCubit,
              builder: (context, state) {
                if(state is IncomePeriodLoaded) {
                  return IncomePeriodFilter(
                    scrollController: scroll,
                    incomePeriodCubit: widget.incomePeriodCubit,
                    onDone: () {
                      _animationController.reverse();
                      currentIndex = 0;
                      buttonsActive = checkToActiveButtons();
                      setState(() {});
                    },
                  );
                }
                return const SizedBox.shrink();
              }
          )
      ),
      SlideTransition(
          position: _animation,
          child: BlocBuilder<IncomeNumberOfPeriodCubit, IncomeNumberOfPeriodState>(
              bloc: widget.incomeNumberOfPeriodCubit,
              builder: (context, state) {
                if(state is IncomeNumberOfPeriodLoaded) {
                  return IncomeNumberOfPeriodFilter(
                    scrollController: scroll,
                    incomeNumberOfPeriodCubit: widget.incomeNumberOfPeriodCubit,
                    onDone: () {
                      _animationController.reverse();
                      currentIndex = 0;
                      buttonsActive = checkToActiveButtons();
                      setState(() {});
                    },
                  );
                }
                return const SizedBox.shrink();
              }
          )
      ),
      SlideTransition(
          position: _animation,
          child: BlocBuilder<IncomeCurrencyCubit, IncomeCurrencyState>(
              bloc: widget.incomeCurrencyCubit,
              builder: (context, state) {
                if(state is IncomeCurrencyLoaded) {
                  return IncomeCurrencyFilter(
                    incomeDenominationCubit: widget.incomeDenominationCubit,
                    scrollController: scroll,
                    incomeCurrencyCubit: widget.incomeCurrencyCubit,
                    onDone: () {
                      _animationController.reverse();
                      currentIndex = 0;
                      buttonsActive = checkToActiveButtons();
                      setState(() {});
                    },
                  );
                }
                return const SizedBox.shrink();
              }
          )
      ),
      SlideTransition(
          position: _animation,
          child: BlocBuilder<IncomeDenominationCubit, IncomeDenominationState>(
              bloc: widget.incomeDenominationCubit,
              builder: (context, state) {
                if(state is IncomeDenominationLoaded) {
                  return IncomeDenominationFilter(
                    scrollController: scroll,
                    incomeDenominationCubit: widget.incomeDenominationCubit,
                    onDone: () {
                      _animationController.reverse();
                      currentIndex = 0;
                      buttonsActive = checkToActiveButtons();
                      setState(() {});
                    },
                  );
                }
                return const SizedBox.shrink();
              }
          )
      ),
      SlideTransition(
          position: _animation,
          child: BlocBuilder<IncomeAsOnDateCubit, IncomeAsOnDateState>(
              bloc: widget.incomeAsOnDateCubit,
              builder: (context, state) {
                if(state is AsOnDateChanged) {
                  return IncomeAsOnDateFilter(
                    incomeAsOnDateCubit: widget.incomeAsOnDateCubit,
                    dateLimit: '',
                    scrollController: scroll,
                    onDone: () {
                      _animationController.reverse();
                      currentIndex = 0;
                      buttonsActive = checkToActiveButtons();
                      setState(() {});
                    },
                  );
                }
                return const SizedBox.shrink();
              }
          )
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
          return _childFilters(context, scrollController)[currentIndex];
        });
  }
}
