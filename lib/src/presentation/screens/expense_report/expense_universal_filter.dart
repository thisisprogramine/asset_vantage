import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/domain/entities/number_of_period/number_of_period.dart';
import 'package:asset_vantage/src/presentation/blocs/expense/expense_loading/expense_loading_cubit.dart';
import 'package:asset_vantage/src/presentation/screens/expense_report/expense_account_filter.dart';
import 'package:asset_vantage/src/presentation/screens/expense_report/expense_as_on_date_filter.dart';
import 'package:asset_vantage/src/presentation/screens/expense_report/expense_currency_filter.dart';
import 'package:asset_vantage/src/presentation/screens/expense_report/expense_denomination_filter.dart';
import 'package:asset_vantage/src/presentation/screens/expense_report/expense_number_of_period_filter.dart';
import 'package:asset_vantage/src/presentation/screens/expense_report/expense_period_filter.dart';
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
import '../../../domain/entities/expense/expense_account_entity.dart';
import '../../../domain/entities/favorites/favorites_entity.dart';
import '../../../domain/entities/period/period_enitity.dart';
import '../../../utilities/helper/app_helper.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../blocs/authentication/user/user_cubit.dart';
import '../../blocs/expense/expense_account/expense_account_cubit.dart';
import '../../blocs/expense/expense_as_on_date/expense_as_on_date_cubit.dart';
import '../../blocs/expense/expense_currency/expense_currency_cubit.dart';
import '../../blocs/expense/expense_denomination/expense_denomination_cubit.dart';
import '../../blocs/expense/expense_entity/expense_entity_cubit.dart';
import '../../blocs/expense/expense_number_of_period/expense_number_of_period_cubit.dart';
import '../../blocs/expense/expense_period/expense_period_cubit.dart';
import '../../blocs/expense/expense_report/expense_report_cubit.dart';
import '../../blocs/favorites/favorites_cubit.dart';
import '../../theme/theme_color.dart';
import '../../widgets/apply_button.dart';
import '../../widgets/crossSign.dart';
import 'expense_entity_filter.dart';

class ExpenseUniversalFilter extends StatefulWidget {
  final ExpenseEntityCubit expenseEntityCubit;
  final ExpenseLoadingCubit expenseLoadingCubit;
  final ExpenseAccountCubit expenseAccountCubit;
  final ExpensePeriodCubit expensePeriodCubit;
  final ExpenseNumberOfPeriodCubit expenseNumberOfPeriodCubit;
  final ExpenseCurrencyCubit expenseCurrencyCubit;
  final ExpenseDenominationCubit expenseDenominationCubit;
  final ExpenseAsOnDateCubit expenseAsOnDateCubit;
  final ExpenseReportCubit expenseReportCubit;
  final bool isFavorite;
  final bool fromBlankWidget;
  final Favorite? favorite;

  const ExpenseUniversalFilter({
    super.key,
    required this.isFavorite,
    this.fromBlankWidget = false,
    this.favorite,
    required this.expenseLoadingCubit,
    required this.expenseEntityCubit,
    required this.expenseAccountCubit,
    required this.expenseNumberOfPeriodCubit,
    required this.expenseCurrencyCubit,
    required this.expenseDenominationCubit,
    required this.expenseAsOnDateCubit,
    required this.expensePeriodCubit,
    required this.expenseReportCubit,
  });

  @override
  State<ExpenseUniversalFilter> createState() => _ExpenseUniversalFilterState();
}

class _ExpenseUniversalFilterState extends State<ExpenseUniversalFilter>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  late Animation<Offset> _animation1;
  int currentIndex = 0;
  bool buttonsActive = false;

  EntityData? saveEntity;
  EntityData? tempSaveEntity;
  List<AccountEntity?>? savedAccount;
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

    saveEntity = widget.expenseEntityCubit.state.selectedExpenseEntity;
    savedAccount = widget.expenseAccountCubit.state.selectedAccountList;
    savedPeriod = widget.expensePeriodCubit.state.selectedExpensePeriod;
    savedNumberOfPeriod =
        widget.expenseNumberOfPeriodCubit.state.selectedExpenseNumberOfPeriod;
    savedCurrency = widget.expenseCurrencyCubit.state.selectedExpenseCurrency;
    savedDenominationData =
        widget.expenseDenominationCubit.state.selectedExpenseDenomination;
    savedAsOnDate = widget.expenseAsOnDateCubit.state.asOnDate;
  }

  @override
  void dispose() {
    _resetFilters(shouldReset: shouldResetFilter);
    super.dispose();
  }

  _resetFilters({required bool shouldReset}) {
    if (shouldReset) {
      tempSaveEntity = null;
      widget.expenseEntityCubit
          .changeSelectedExpenseEntity(selectedEntity: saveEntity);
      widget.expenseAccountCubit.changeSelectedExpenseAccount(
          selectedExpenseAccountList: savedAccount ?? []);
      widget.expensePeriodCubit
          .changeSelectedExpensePeriod(selectedPeriod: savedPeriod);
      widget.expenseNumberOfPeriodCubit.changeSelectedExpenseNumberOfPeriod(
          selectedNumberOfPeriod: savedNumberOfPeriod);
      widget.expenseCurrencyCubit
          .changeSelectedExpenseCurrency(selectedCurrency: savedCurrency, expenseDenominationCubit: widget.expenseDenominationCubit);
      widget.expenseDenominationCubit.changeSelectedExpenseDenomination(
          selectedDenomination: savedDenominationData);
      widget.expenseAsOnDateCubit.changeAsOnDate(asOnDate: savedAsOnDate);
    }
  }

  bool checkToActiveButtons() {
    if ((tempSaveEntity ?? saveEntity)?.id !=
            widget.expenseEntityCubit.state.selectedExpenseEntity?.id ||
        savedPeriod?.id !=
            widget.expensePeriodCubit.state.selectedExpensePeriod?.id ||
        savedNumberOfPeriod?.id !=
            widget.expenseNumberOfPeriodCubit.state
                .selectedExpenseNumberOfPeriod?.id ||
        savedCurrency?.id !=
            widget.expenseCurrencyCubit.state.selectedExpenseCurrency?.id ||
        savedDenominationData?.id !=
            widget.expenseDenominationCubit.state.selectedExpenseDenomination
                ?.id ||
        savedAsOnDate != widget.expenseAsOnDateCubit.state.asOnDate ||
        !(const DeepCollectionEquality.unordered().equals(
            savedAccount
                ?.map(
                  (e) => e?.id,
                )
                .toList(),
            widget.expenseAccountCubit.state.selectedAccountList
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
              const FilterNameWithCross(text: StringConstants.expenseFilterHeader),
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
                    BlocBuilder<ExpenseEntityCubit, ExpenseEntityState>(
                        bloc: widget.expenseEntityCubit,
                        builder: (context, state) {
                          if (state is ExpenseEntityLoaded) {
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
                                        : state.selectedExpenseEntity?.name ?? '--',
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
                                hintText: tempSaveEntity != null
                                    ? tempSaveEntity?.name
                                    : state.selectedExpenseEntity?.name ?? '--',
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
                          else if (state is ExpenseEntityError) {
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
                    BlocBuilder<ExpenseAccountCubit, ExpenseAccountState>(
                        bloc: widget.expenseAccountCubit,
                        builder: (context, state) {
                          if (state is ExpenseAccountLoaded) {
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
                                    hintText: (state.selectedExpenseAccountList
                                        ?.isNotEmpty ??
                                        false)
                                        ? "${state.selectedExpenseAccountList?.length} Selected"
                                        : "None Selected",
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
                                hintText: (state.selectedExpenseAccountList
                                            ?.isNotEmpty ??
                                        false)
                                    ? "${state.selectedExpenseAccountList?.length} Selected"
                                    : "None Selected",
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
                          else if (state is ExpenseAccountError) {
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
                        }),
                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                    BlocBuilder<ExpensePeriodCubit, ExpensePeriodState>(
                        bloc: widget.expensePeriodCubit,
                        builder: (context, state) {
                          if (state is ExpensePeriodLoaded) {
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
                        }),
                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                    BlocBuilder<ExpenseNumberOfPeriodCubit,
                            ExpenseNumberOfPeriodState>(
                        bloc: widget.expenseNumberOfPeriodCubit,
                        builder: (context, state) {
                          if (state is ExpenseNumberOfPeriodLoaded) {
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
                                    hintText:  state.selectedExpenseNumberOfPeriod?.name ??
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
                                hintText:
                                    state.selectedExpenseNumberOfPeriod?.name ??
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
                    BlocBuilder<ExpenseCurrencyCubit, ExpenseCurrencyState>(
                        bloc: widget.expenseCurrencyCubit,
                        builder: (context, state) {
                          if (state is ExpenseCurrencyLoaded) {
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
                                    hintText: state.selectedExpenseCurrency?.code ?? '--',
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
                                hintText:
                                    state.selectedExpenseCurrency?.code ?? '--',
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
                          else if (state is ExpenseCurrencyError) {
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
                        }),
                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                    BlocBuilder<ExpenseDenominationCubit,
                            ExpenseDenominationState>(
                        bloc: widget.expenseDenominationCubit,
                        builder: (context, state) {
                          if (state is ExpenseDenominationLoaded) {
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
                                hintText:
                                    state.selectedDenomination?.title ?? '--',
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
                        }),
                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                    BlocBuilder<UserCubit, UserEntity?>(
                        builder: (context, user) {
                      return BlocBuilder<ExpenseAsOnDateCubit,
                              ExpenseAsOnDateState>(
                          bloc: widget.expenseAsOnDateCubit,
                          builder: (context, state) {
                            if (state is AsOnDateChanged) {
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
                                  hintText:
                                      "${DateFormat(user?.dateFormat ?? 'yyyy-MM-dd').format(DateTime.parse(state.asOnDate ?? DateTime.now().toString()))}",
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
                          });
                    }),
                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                  ],
                ),
              ),
              BlocBuilder<ExpenseLoadingCubit, bool>(
                  bloc: widget.expenseLoadingCubit,
                  builder: (context, state) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
                      child: ApplyButton(
                        isEnabled: state,
                        text: StringConstants.applyButton,
                        onPressed: () {
                          widget.expenseEntityCubit.changeSelectedExpenseEntity(selectedEntity: tempSaveEntity ?? saveEntity).then((value) {
                            widget.expenseReportCubit.reloadExpenseReport(context: context,favoriteCubit: context.read<FavoritesCubit>(), fromBlankWidget: widget.fromBlankWidget, isFavorite: widget.isFavorite, favorite: widget.favorite,);
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
          child: BlocBuilder<ExpenseEntityCubit, ExpenseEntityState>(
              bloc: widget.expenseEntityCubit,
              builder: (context, state) {
                if (state is ExpenseEntityLoaded) {
                  return ExpenseEntityFilter(
                    scrollController: scroll,
                    expenseEntityCubit: widget.expenseEntityCubit,
                    expenseLoadingCubit: widget.expenseLoadingCubit,
                    asOnDate: widget.expenseAsOnDateCubit.state.asOnDate,
                    expenseAccountCubit: widget.expenseAccountCubit,
                    entity: tempSaveEntity,
                    onDone: (entity) {
                      _animationController.reverse();
                      currentIndex = 0;
                      if (entity != null) {
                        tempSaveEntity = entity;
                      }
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
          child: BlocBuilder<ExpenseAccountCubit, ExpenseAccountState>(
              bloc: widget.expenseAccountCubit,
              builder: (context, state) {
                if (state is ExpenseAccountLoaded) {
                  return ExpenseAccountFilter(
                    scrollController: scroll,
                    expenseAccountCubit: widget.expenseAccountCubit,
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
          child: BlocBuilder<ExpensePeriodCubit, ExpensePeriodState>(
              bloc: widget.expensePeriodCubit,
              builder: (context, state) {
                if (state is ExpensePeriodLoaded) {
                  return ExpensePeriodFilter(
                    scrollController: scroll,
                    expensePeriodCubit: widget.expensePeriodCubit,
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
          child: BlocBuilder<ExpenseNumberOfPeriodCubit,
                  ExpenseNumberOfPeriodState>(
              bloc: widget.expenseNumberOfPeriodCubit,
              builder: (context, state) {
                if (state is ExpenseNumberOfPeriodLoaded) {
                  return ExpenseNumberOfPeriodFilter(
                    scrollController: scroll,
                    expenseNumberOfPeriodCubit:
                        widget.expenseNumberOfPeriodCubit,
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
          child: BlocBuilder<ExpenseCurrencyCubit, ExpenseCurrencyState>(
              bloc: widget.expenseCurrencyCubit,
              builder: (context, state) {
                if (state is ExpenseCurrencyLoaded) {
                  return ExpenseCurrencyFilter(
                    expenseDenominationCubit: widget.expenseDenominationCubit,
                    scrollController: scroll,
                    expenseCurrencyCubit: widget.expenseCurrencyCubit,
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
          child:
              BlocBuilder<ExpenseDenominationCubit, ExpenseDenominationState>(
                  bloc: widget.expenseDenominationCubit,
                  builder: (context, state) {
                    if (state is ExpenseDenominationLoaded) {
                      return ExpenseDenominationFilter(
                        scrollController: scroll,
                        expenseDenominationCubit:
                            widget.expenseDenominationCubit,
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
          child: BlocBuilder<ExpenseAsOnDateCubit, ExpenseAsOnDateState>(
              bloc: widget.expenseAsOnDateCubit,
              builder: (context, state) {
                if (state is AsOnDateChanged) {
                  return ExpenseAsOnDateFilter(
                    expenseAsOnDateCubit: widget.expenseAsOnDateCubit,
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
