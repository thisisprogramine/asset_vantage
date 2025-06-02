import 'dart:developer';

import 'package:asset_vantage/src/config/constants/size_constants.dart';
import 'package:asset_vantage/src/presentation/arguments/expense_report_argument.dart';
import 'package:asset_vantage/src/presentation/arguments/income_report_argument.dart';
import 'package:asset_vantage/src/presentation/arguments/performance_argument.dart';
import 'package:asset_vantage/src/presentation/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/constants/favorite_constants.dart';
import '../../domain/entities/favorites/favorites_entity.dart';
import '../../domain/entities/net_worth/net_worth_return_percent_entity.dart';
import '../../utilities/helper/favorite_helper.dart';
import '../arguments/cash_balance_argument.dart';
import '../arguments/net_worth_argument.dart';
import '../blocs/favorites/favorites_cubit.dart';

class FavoriteIcon extends StatefulWidget {
  final PerformanceArgument? performanceArgument;
  final IncomeReportArgument? incomeArgument;
  final ExpenseReportArgument? expenseArgument;
  final CashBalanceArgument? cashBalanceArgument;
  final NetWorthArgument? netWorthArgument;
  final List<Favorite>? favorites;

  FavoriteIcon({
    this.performanceArgument,
    this.expenseArgument,
    this.incomeArgument,
    required this.favorites,
    this.cashBalanceArgument,
    this.netWorthArgument,
  });

  @override
  _FavoriteIconState createState() =>
      _FavoriteIconState();
}

class _FavoriteIconState
    extends State<FavoriteIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isCombinationExist = false;

  @override
  void initState() {
    super.initState();
    print("NW_FILTERS: ${widget.netWorthArgument?.netWorthPrimaryGroupingCubit.state.selectedGrouping}");
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if(widget.performanceArgument!=null){
      isCombinationExist = FavoriteHelper.isPerformanceCombinationExist(
        favorites: widget.favorites,
        entity: widget.performanceArgument?.performanceEntityCubit.state.selectedPerformanceEntity,
        primaryGrouping: widget.performanceArgument?.performancePrimaryGroupingCubit.state.selectedGrouping,
        primarySubGrouping: widget.performanceArgument?.performancePrimarySubGroupingCubit.state.selectedSubGroupingList,
        secondaryGrouping: widget.performanceArgument?.performanceSecondaryGroupingCubit.state.selectedGrouping,
        secondarySubGrouping: widget.performanceArgument?.performanceSecondarySubGroupingCubit.state.selectedSubGroupingList,
        returnPercent: widget.performanceArgument?.performanceReturnPercentCubit.state.selectedPerformanceReturnPercentList,
        currency: widget.performanceArgument?.performanceCurrencyCubit.state.selectedPerformanceCurrency,
        denomination: widget.performanceArgument?.performanceDenominationCubit.state.selectedPerformanceDenomination,
        asOnDate: widget.performanceArgument?.performanceAsOnDateCubit.state.asOnDate,
      );
      setState(() {});
    }else if(widget.incomeArgument!=null){
      isCombinationExist = FavoriteHelper.isIncomeCombinationExist(
        favorites: widget.favorites,
        entity: widget.incomeArgument?.incomeEntityCubit.state.selectedIncomeEntity,
        accounts: widget.incomeArgument?.incomeAccountCubit.state.selectedAccountList,
        numberOfPeriod: widget.incomeArgument?.incomeNumberOfPeriodCubit.state.selectedIncomeNumberOfPeriod,
        period: widget.incomeArgument?.incomePeriodCubit.state.selectedIncomePeriod,
        currency: widget.incomeArgument?.incomeCurrencyCubit.state.selectedIncomeCurrency,
        denomination: widget.incomeArgument?.incomeDenominationCubit.state.selectedIncomeDenomination,
        asOnDate: widget.incomeArgument?.incomeAsOnDateCubit.state.asOnDate,
      );
      setState(() {});
    }else if(widget.expenseArgument!=null){
      isCombinationExist = FavoriteHelper.isExpenseCombinationExist(
        favorites: widget.favorites,
        entity: widget.expenseArgument?.expenseEntityCubit.state.selectedExpenseEntity,
        accounts: widget.expenseArgument?.expenseAccountCubit.state.selectedAccountList,
        numberOfPeriod: widget.expenseArgument?.expenseNumberOfPeriodCubit.state.selectedExpenseNumberOfPeriod,
        period: widget.expenseArgument?.expensePeriodCubit.state.selectedExpensePeriod,
        currency: widget.expenseArgument?.expenseCurrencyCubit.state.selectedExpenseCurrency,
        denomination: widget.expenseArgument?.expenseDenominationCubit.state.selectedExpenseDenomination,
        asOnDate: widget.expenseArgument?.expenseAsOnDateCubit.state.asOnDate,
      );
      setState(() {});
    }else if(widget.cashBalanceArgument!=null){
      isCombinationExist = FavoriteHelper.isCashBalanceCombinationExist(
        favorites: widget.favorites,
        entity: widget.cashBalanceArgument?.cashBalanceEntityCubit.state.selectedCashBalanceEntity,
        accounts: widget.cashBalanceArgument?.cashBalanceAccountCubit.state.selectedAccountsList,
        primaryGrouping: widget.cashBalanceArgument?.cashBalancePrimaryGroupingCubit.state.selectedGrouping,
        primarySubGrouping: widget.cashBalanceArgument?.cashBalancePrimarySubGroupingCubit.state.selectedSubGroupingList,
        numberOfPeriod: widget.cashBalanceArgument?.cashBalanceNumberOfPeriodCubit.state.selectedCashBalanceNumberOfPeriod,
        period: widget.cashBalanceArgument?.cashBalancePeriodCubit.state.selectedCashBalancePeriod,
        currency: widget.cashBalanceArgument?.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency,
        denomination: widget.cashBalanceArgument?.cashBalanceDenominationCubit.state.selectedCashBalanceDenomination,
        asOnDate: widget.cashBalanceArgument?.cashBalanceAsOnDateCubit.state.asOnDate,
      );
      setState(() {});
    }else if(widget.netWorthArgument!=null){
      isCombinationExist = FavoriteHelper.isNetWorthCombinationExist(
        msg: "From Init State",
        favorites: widget.favorites,
        entity: widget.netWorthArgument?.netWorthEntityCubit.state.selectedNetWorthEntity,
        primaryGrouping: widget.netWorthArgument?.netWorthPrimaryGroupingCubit.state.selectedGrouping,
        primarySubGrouping: widget.netWorthArgument?.netWorthPrimarySubGroupingCubit.state.selectedSubGroupingList,
        numberOfPeriod: widget.netWorthArgument?.netWorthNumberOfPeriodCubit.state.selectedNetWorthNumberOfPeriod,
        period: widget.netWorthArgument?.netWorthPeriodCubit.state.selectedNetWorthPeriod,
        currency: widget.netWorthArgument?.netWorthCurrencyCubit.state.selectedNetWorthCurrency,
        returnPercentage: [widget.netWorthArgument?.netWorthReturnPercentCubit.state.selectedNetWorthReturnPercent],
        denomination: widget.netWorthArgument?.netWorthDenominationCubit.state.selectedNetWorthDenomination,
        asOnDate: widget.netWorthArgument?.netWorthAsOnDateCubit.state.asOnDate,
      );
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant FavoriteIcon oldWidget) {
    if(widget.performanceArgument!=null){
      isCombinationExist = FavoriteHelper.isPerformanceCombinationExist(
        favorites: widget.favorites,
        entity: widget.performanceArgument?.performanceEntityCubit.state.selectedPerformanceEntity,
        primaryGrouping: widget.performanceArgument?.performancePrimaryGroupingCubit.state.selectedGrouping,
        primarySubGrouping: widget.performanceArgument?.performancePrimarySubGroupingCubit.state.selectedSubGroupingList,
        secondaryGrouping: widget.performanceArgument?.performanceSecondaryGroupingCubit.state.selectedGrouping,
        secondarySubGrouping: widget.performanceArgument?.performanceSecondarySubGroupingCubit.state.selectedSubGroupingList,
        returnPercent: widget.performanceArgument?.performanceReturnPercentCubit.state.selectedPerformanceReturnPercentList,
        currency: widget.performanceArgument?.performanceCurrencyCubit.state.selectedPerformanceCurrency,
        denomination: widget.performanceArgument?.performanceDenominationCubit.state.selectedPerformanceDenomination,
        asOnDate: widget.performanceArgument?.performanceAsOnDateCubit.state.asOnDate,
      );
      setState(() {});
    }else if(widget.incomeArgument!=null){
      isCombinationExist = FavoriteHelper.isIncomeCombinationExist(
        favorites: widget.favorites,
        entity: widget.incomeArgument?.incomeEntityCubit.state.selectedIncomeEntity,
        accounts: widget.incomeArgument?.incomeAccountCubit.state.selectedAccountList,
        numberOfPeriod: widget.incomeArgument?.incomeNumberOfPeriodCubit.state.selectedIncomeNumberOfPeriod,
        period: widget.incomeArgument?.incomePeriodCubit.state.selectedIncomePeriod,
        currency: widget.incomeArgument?.incomeCurrencyCubit.state.selectedIncomeCurrency,
        denomination: widget.incomeArgument?.incomeDenominationCubit.state.selectedIncomeDenomination,
        asOnDate: widget.incomeArgument?.incomeAsOnDateCubit.state.asOnDate,
      );
      setState(() {});
    }else if(widget.expenseArgument!=null){
      isCombinationExist = FavoriteHelper.isExpenseCombinationExist(
        favorites: widget.favorites,
        entity: widget.expenseArgument?.expenseEntityCubit.state.selectedExpenseEntity,
        accounts: widget.expenseArgument?.expenseAccountCubit.state.selectedAccountList,
        numberOfPeriod: widget.expenseArgument?.expenseNumberOfPeriodCubit.state.selectedExpenseNumberOfPeriod,
        period: widget.expenseArgument?.expensePeriodCubit.state.selectedExpensePeriod,
        currency: widget.expenseArgument?.expenseCurrencyCubit.state.selectedExpenseCurrency,
        denomination: widget.expenseArgument?.expenseDenominationCubit.state.selectedExpenseDenomination,
        asOnDate: widget.expenseArgument?.expenseAsOnDateCubit.state.asOnDate,
      );
      setState(() {});
    }else if(widget.cashBalanceArgument!=null){
      isCombinationExist = FavoriteHelper.isCashBalanceCombinationExist(
        favorites: widget.favorites,
        entity: widget.cashBalanceArgument?.cashBalanceEntityCubit.state.selectedCashBalanceEntity,
        accounts: widget.cashBalanceArgument?.cashBalanceAccountCubit.state.selectedAccountsList,
        primaryGrouping: widget.cashBalanceArgument?.cashBalancePrimaryGroupingCubit.state.selectedGrouping,
        primarySubGrouping: widget.cashBalanceArgument?.cashBalancePrimarySubGroupingCubit.state.selectedSubGroupingList,
        numberOfPeriod: widget.cashBalanceArgument?.cashBalanceNumberOfPeriodCubit.state.selectedCashBalanceNumberOfPeriod,
        period: widget.cashBalanceArgument?.cashBalancePeriodCubit.state.selectedCashBalancePeriod,
        currency: widget.cashBalanceArgument?.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency,
        denomination: widget.cashBalanceArgument?.cashBalanceDenominationCubit.state.selectedCashBalanceDenomination,
        asOnDate: widget.cashBalanceArgument?.cashBalanceAsOnDateCubit.state.asOnDate,
      );
      setState(() {});
    }else if(widget.netWorthArgument!=null){
      isCombinationExist = FavoriteHelper.isNetWorthCombinationExist(
        msg: "From didUpdateWidget",
        favorites: widget.favorites,
        entity: widget.netWorthArgument?.netWorthEntityCubit.state.selectedNetWorthEntity,
        primaryGrouping: widget.netWorthArgument?.netWorthPrimaryGroupingCubit.state.selectedGrouping,
        primarySubGrouping: widget.netWorthArgument?.netWorthPrimarySubGroupingCubit.state.selectedSubGroupingList,
        numberOfPeriod: widget.netWorthArgument?.netWorthNumberOfPeriodCubit.state.selectedNetWorthNumberOfPeriod,
        period: widget.netWorthArgument?.netWorthPeriodCubit.state.selectedNetWorthPeriod,
        currency: widget.netWorthArgument?.netWorthCurrencyCubit.state.selectedNetWorthCurrency,
        returnPercentage: [widget.netWorthArgument?.netWorthReturnPercentCubit.state.selectedNetWorthReturnPercent],
        denomination: widget.netWorthArgument?.netWorthDenominationCubit.state.selectedNetWorthDenomination,
        asOnDate: widget.netWorthArgument?.netWorthAsOnDateCubit.state.asOnDate,
      );
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if(!isCombinationExist) {
          if(widget.performanceArgument!=null){
            context.read<FavoritesCubit>().saveFilters(
              context: context,
              isPinned: false,
              reportId: FavoriteConstants.performanceId,
              reportName: FavoriteConstants.performanceName,
              isMarketValueSelected: widget.performanceArgument?.isMarketValueSelected,
              entity: widget.performanceArgument?.performanceEntityCubit.state.selectedPerformanceEntity,
              performancePrimaryGrouping: widget.performanceArgument?.performancePrimaryGroupingCubit.state.selectedGrouping,
              performancePrimarySubGrouping: widget.performanceArgument?.performancePrimarySubGroupingCubit.state.selectedSubGroupingList,
              performanceSecondaryGrouping: widget.performanceArgument?.performanceSecondaryGroupingCubit.state.selectedGrouping,
              performanceSecondarySubGrouping: widget.performanceArgument?.performanceSecondarySubGroupingCubit.state.selectedSubGroupingList,
              performanceReturnPercent: widget.performanceArgument?.performanceReturnPercentCubit.state.selectedPerformanceReturnPercentList,
              currency: widget.performanceArgument?.performanceCurrencyCubit.state.selectedPerformanceCurrency,
              denomination: widget.performanceArgument?.performanceDenominationCubit.state.selectedPerformanceDenomination,
              asOnDate: widget.performanceArgument?.performanceAsOnDateCubit.state.asOnDate,
            );
          }else if(widget.incomeArgument!=null){
            context.read<FavoritesCubit>().saveFilters(
              context: context,
              isPinned: false,
              reportId: FavoriteConstants.incomeId,
              reportName: FavoriteConstants.incomeName,
              entity: widget.incomeArgument?.incomeEntityCubit.state.selectedIncomeEntity,
              incomeAccounts: widget.incomeArgument?.incomeAccountCubit.state.selectedAccountList,
              numberOfPeriod: widget.incomeArgument?.incomeNumberOfPeriodCubit.state.selectedIncomeNumberOfPeriod,
              period: widget.incomeArgument?.incomePeriodCubit.state.selectedIncomePeriod,
              currency: widget.incomeArgument?.incomeCurrencyCubit.state.selectedIncomeCurrency,
              denomination: widget.incomeArgument?.incomeDenominationCubit.state.selectedIncomeDenomination,
              asOnDate: widget.incomeArgument?.incomeAsOnDateCubit.state.asOnDate,
            );
          }else if(widget.expenseArgument!=null){
            context.read<FavoritesCubit>().saveFilters(
              context: context,
              isPinned: false,
              reportId: FavoriteConstants.expenseId,
              reportName: FavoriteConstants.expenseName,
              entity: widget.expenseArgument?.expenseEntityCubit.state.selectedExpenseEntity,
              expenseAccounts: widget.expenseArgument?.expenseAccountCubit.state.selectedAccountList,
              numberOfPeriod: widget.expenseArgument?.expenseNumberOfPeriodCubit.state.selectedExpenseNumberOfPeriod,
              period: widget.expenseArgument?.expensePeriodCubit.state.selectedExpensePeriod,
              currency: widget.expenseArgument?.expenseCurrencyCubit.state.selectedExpenseCurrency,
              denomination: widget.expenseArgument?.expenseDenominationCubit.state.selectedExpenseDenomination,
              asOnDate: widget.expenseArgument?.expenseAsOnDateCubit.state.asOnDate,
            );
          }else if(widget.cashBalanceArgument!=null){
            context.read<FavoritesCubit>().saveFilters(
              context: context,
              isPinned: false,
              reportId: FavoriteConstants.cashBalanceId,
              reportName: FavoriteConstants.cashBalanceName,
              entity: widget.cashBalanceArgument?.cashBalanceEntityCubit.state.selectedCashBalanceEntity,
              cashBalancePrimaryGrouping: widget.cashBalanceArgument?.cashBalancePrimaryGroupingCubit.state.selectedGrouping,
              cashBalancePrimarySubGrouping: widget.cashBalanceArgument?.cashBalancePrimarySubGroupingCubit.state.selectedSubGroupingList,
              cashAccounts: widget.cashBalanceArgument?.cashBalanceAccountCubit.state.selectedAccountsList,
              numberOfPeriod: widget.cashBalanceArgument?.cashBalanceNumberOfPeriodCubit.state.selectedCashBalanceNumberOfPeriod,
              period: widget.cashBalanceArgument?.cashBalancePeriodCubit.state.selectedCashBalancePeriod,
              currency: widget.cashBalanceArgument?.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency,
              denomination: widget.cashBalanceArgument?.cashBalanceDenominationCubit.state.selectedCashBalanceDenomination,
              asOnDate: widget.cashBalanceArgument?.cashBalanceAsOnDateCubit.state.asOnDate,
            );
          }else if(widget.netWorthArgument!=null){
            context.read<FavoritesCubit>().saveFilters(
              context: context,
              isPinned: false,
              reportId: FavoriteConstants.netWorthId,
              reportName: FavoriteConstants.netWorthName,
              entity: widget.netWorthArgument?.netWorthEntityCubit.state.selectedNetWorthEntity,
              netWorthPrimaryGrouping: widget.netWorthArgument?.netWorthPrimaryGroupingCubit.state.selectedGrouping,
              netWorthPrimarySubGrouping: widget.netWorthArgument?.netWorthPrimarySubGroupingCubit.state.selectedSubGroupingList,
              netWorthReturnPercent: [widget.netWorthArgument?.netWorthReturnPercentCubit.state.selectedNetWorthReturnPercent],
              numberOfPeriod: widget.netWorthArgument?.netWorthNumberOfPeriodCubit.state.selectedNetWorthNumberOfPeriod,
              period: widget.netWorthArgument?.netWorthPeriodCubit.state.selectedNetWorthPeriod,
              currency: widget.netWorthArgument?.netWorthCurrencyCubit.state.selectedNetWorthCurrency,
              denomination: widget.netWorthArgument?.netWorthDenominationCubit.state.selectedNetWorthDenomination,
              asOnDate: widget.netWorthArgument?.netWorthAsOnDateCubit.state.asOnDate,
            );
          }
          HapticFeedback.lightImpact();
          SystemSound.play(SystemSoundType.click);

          _controller.forward();
          await Future.delayed(const Duration(milliseconds: 100));
          _controller.reverse();
        }else {
        }
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: Container(
              padding: EdgeInsets.only(right: Sizes.dimen_4),
              child: SvgPicture.asset(
                  isCombinationExist ? "assets/svgs/bookmark.svg" : "assets/svgs/un_bookmark.svg",

              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}