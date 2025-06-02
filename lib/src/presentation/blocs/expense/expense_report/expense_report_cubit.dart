


import 'package:asset_vantage/src/data/models/currency/currency_model.dart';
import 'package:asset_vantage/src/data/models/denomination/denomination_model.dart';
import 'package:asset_vantage/src/data/models/number_of_period/number_of_period_model.dart';
import 'package:asset_vantage/src/data/models/period/period_model.dart';
import 'package:asset_vantage/src/presentation/blocs/expense/expense_loading/expense_loading_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

import '../../../../config/constants/favorite_constants.dart';
import '../../../../data/models/expense/expense_account_model.dart';
import '../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../data/models/preferences/user_preference.dart';
import '../../../../domain/entities/expense/expense_report_entity.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../../domain/entities/expense/expense_chart_data.dart';
import '../../../../domain/entities/favorites/favorites_entity.dart';
import '../../../../domain/entities/number_of_period/number_of_period.dart';
import '../../../../domain/entities/period/period_enitity.dart';
import '../../../../domain/params/expense/expense_report_params.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/usecases/expense/get_expense_report.dart';
import '../../../../domain/usecases/expense/expense_filter/selected_accounts/save_expense_selected_accounts.dart';
import '../../../../domain/usecases/expense/expense_filter/selected_currency/save_expense_selected_currency.dart';
import '../../../../domain/usecases/expense/expense_filter/selected_denomination/save_expense_selected_denomination.dart';
import '../../../../domain/usecases/expense/expense_filter/selected_entity/save_expense_selected_entity.dart';
import '../../../../domain/usecases/expense/expense_filter/selected_number_of_period/save_expense_selected_number_of_period.dart';
import '../../../../domain/usecases/expense/expense_filter/selected_period/save_expense_selected_period.dart';
import '../../../../domain/usecases/preferences/get_user_preference.dart';
import '../../../../utilities/helper/favorite_helper.dart';
import '../../authentication/login_check/login_check_cubit.dart';
import '../../favorites/favorites_cubit.dart';
import '../expense_account/expense_account_cubit.dart';
import '../expense_as_on_date/expense_as_on_date_cubit.dart';
import '../expense_currency/expense_currency_cubit.dart';
import '../expense_denomination/expense_denomination_cubit.dart';
import '../expense_entity/expense_entity_cubit.dart';
import '../expense_number_of_period/expense_number_of_period_cubit.dart';
import '../expense_period/expense_period_cubit.dart';
import '../expense_sort_cubit/expense_sort_cubit.dart';
import '../expense_timestamp/expense_timestamp_cubit.dart';

part 'expense_report_state.dart';

class ExpenseReportCubit extends Cubit<ExpenseReportState> {
  final ExpenseEntityCubit expenseEntityCubit;
  final ExpenseAccountCubit expenseAccountCubit;
  final ExpensePeriodCubit expensePeriodCubit;
  final ExpenseNumberOfPeriodCubit expenseNumberOfPeriodCubit;
  final ExpenseCurrencyCubit expenseCurrencyCubit;
  final ExpenseDenominationCubit expenseDenominationCubit;
  final ExpenseAsOnDateCubit expenseAsOnDateCubit;
  final ExpenseSortCubit expenseSortCubit;
  final GetExpenseReport getExpenseReport;
  final GetUserPreference userPreference;
  final ExpenseTimestampCubit expenseTimestampCubit;
  final LoginCheckCubit loginCheckCubit;
  final ExpenseLoadingCubit expenseLoadingCubit;

  final SaveExpenseSelectedEntity saveExpenseSelectedEntity;
  final SaveExpenseSelectedAccounts saveExpenseSelectedAccounts;
  final SaveExpenseSelectedPeriod saveExpenseSelectedPeriod;
  final SaveExpenseSelectedNumberOfPeriod saveExpenseSelectedNumberOfPeriod;
  final SaveExpenseSelectedCurrency saveExpenseSelectedCurrency;
  final SaveExpenseSelectedDenomination saveExpenseSelectedDenomination;


  ExpenseReportCubit({
    required this.expenseEntityCubit,
    required this.expenseAccountCubit,
    required this.expensePeriodCubit,
    required this.expenseNumberOfPeriodCubit,
    required this.expenseCurrencyCubit,
    required this.expenseDenominationCubit,
    required this.expenseAsOnDateCubit,
    required this.expenseSortCubit,
    required this.getExpenseReport,
    required this.userPreference,
    required this.expenseTimestampCubit,
    required this.loginCheckCubit,
    required this.expenseLoadingCubit,
    required this.saveExpenseSelectedEntity,
    required this.saveExpenseSelectedAccounts,
    required this.saveExpenseSelectedPeriod,
    required this.saveExpenseSelectedNumberOfPeriod,
    required this.saveExpenseSelectedCurrency,
    required this.saveExpenseSelectedDenomination,
  }) : super(ExpenseReportInitial());

  Future<void> loadExpenseReport({required BuildContext context,
    Entity? universalEntity,
    String? universalAsOnDate
  }) async{

    emit(const ExpenseReportLoading());

    final Either<AppError, UserPreference> eitherUserPreference = await userPreference(NoParams());

    eitherUserPreference.fold((l) {

    }, (pref) async {
      expenseLoadingCubit.startLoading();
      await expenseEntityCubit.loadExpenseEntity(context: context, favoriteEntity: universalEntity);
      await saveExpenseSelectedEntity(Entity(
          id: expenseEntityCubit.state.selectedExpenseEntity?.id,
          name: expenseEntityCubit.state.selectedExpenseEntity?.name,
          type: expenseEntityCubit.state.selectedExpenseEntity?.type,
          currency: expenseEntityCubit.state.selectedExpenseEntity?.currency,
          accountingyear: expenseEntityCubit.state.selectedExpenseEntity?.accountingyear
      ));
      await expenseAsOnDateCubit.changeAsOnDate(asOnDate: universalAsOnDate);
      await expenseAccountCubit.loadExpenseAccount(context: context, selectedEntity: expenseEntityCubit.state.selectedExpenseEntity, asOnDate: expenseAsOnDateCubit.state.asOnDate);
      await expensePeriodCubit.loadExpensePeriod(context: context);
      await expenseNumberOfPeriodCubit.loadExpenseNumberOfPeriod(context: context);
      await expenseDenominationCubit.loadExpenseDenomination(context: context);
      await expenseCurrencyCubit.loadExpenseCurrency(context: context, selectedEntity: expenseEntityCubit.state.selectedExpenseEntity, expenseDenominationCubit: expenseDenominationCubit);
      expenseLoadingCubit.endLoading();
      final Either<AppError, ExpenseReportEntity> eitherExpense = await getExpenseReport(
          ExpenseReportParams(
            context: context,
            entity: expenseEntityCubit.state.selectedExpenseEntity,
            accountnumbers: expenseAccountCubit.state.selectedAccountList,
            reportingCurrency: expenseCurrencyCubit.state.selectedExpenseCurrency,
            dates: _getFormattedDates(selectedEntity: expenseEntityCubit.state.selectedExpenseEntity,
                period: expensePeriodCubit.state.selectedExpensePeriod,
                numberOfPeriod: expenseNumberOfPeriodCubit.state.selectedExpenseNumberOfPeriod,
                asOnDate: expenseAsOnDateCubit.state.asOnDate),
            period: expensePeriodCubit.state.selectedExpensePeriod,
            numberOfPeriod: expenseNumberOfPeriodCubit.state.selectedExpenseNumberOfPeriod,
            asOnDate: expenseAsOnDateCubit.state.asOnDate,
            purpose: pref.regionUrl
          )
      );

      eitherExpense.fold((error) {
        if(error.appErrorType==AppErrorType.unauthorised){
          loginCheckCubit.loginCheck();
        }
        emit(ExpenseReportError(errorType: error.appErrorType));
      }, (ExpenseReport) {
        emit(ExpenseReportLoaded(chartData: ExpenseReport.report.reversed.toList()));
      });
    });

  }

  Future<void> loadExpenseReportForFavorites({required BuildContext context, FavoritesCubit? favoriteCubit, required Favorite? favorite, String? universalAsOnDate}) async{

    emit(const ExpenseReportLoading());

    final Either<AppError, UserPreference> eitherUserPreference = await userPreference(NoParams());

    eitherUserPreference.fold((l) {

    }, (pref) async {
      expenseLoadingCubit.startLoading();
      await expenseEntityCubit.loadExpenseEntity(context: context, favoriteEntity: favorite?.filter?[FavoriteConstants.entityFilter] != null ? Entity.fromJson(favorite?.filter?[FavoriteConstants.entityFilter]) : null);
      await expenseAsOnDateCubit.changeAsOnDate(asOnDate: universalAsOnDate ?? favorite?.filter?[FavoriteConstants.asOnDate]);
      await expenseAccountCubit.loadExpenseAccount(
        context: context,
          favoriteAccounts: favorite?.filter?[FavoriteConstants.accounts] != null ? FavoriteHelper.getExpenseAccounts(favorite?.filter?[FavoriteConstants.accounts]) : null,
          selectedEntity: expenseEntityCubit.state.selectedExpenseEntity,
          asOnDate: expenseAsOnDateCubit.state.asOnDate);
      await expensePeriodCubit.loadExpensePeriod(context: context, favoritePeriod: favorite?.filter?[FavoriteConstants.period]!=null?PeriodItem.fromJson(favorite?.filter?[FavoriteConstants.period]):null);
      await expenseNumberOfPeriodCubit.loadExpenseNumberOfPeriod(context: context, favoriteNumberOfPeriod: favorite?.filter?[FavoriteConstants.numberOfPeriod]!=null?NumberOfPeriodItem.fromJson(favorite?.filter?[FavoriteConstants.numberOfPeriod]):null);
      await expenseDenominationCubit.loadExpenseDenomination(context: context, favoriteDenData: favorite?.filter?[FavoriteConstants.denomination] != null ? DenData.fromJson(favorite?.filter?[FavoriteConstants.denomination]) : null);
      await expenseCurrencyCubit.loadExpenseCurrency(context: context,expenseDenominationCubit: expenseDenominationCubit, favoriteCurrency: favorite?.filter?[FavoriteConstants.currency] != null ? CurrencyData.fromJson(favorite?.filter?[FavoriteConstants.currency]) : null, selectedEntity: expenseEntityCubit.state.selectedExpenseEntity);
      expenseLoadingCubit.endLoading();
      final Either<AppError, ExpenseReportEntity> eitherIncome = await getExpenseReport(
          ExpenseReportParams(
            context: context,
              entity: expenseEntityCubit.state.selectedExpenseEntity,
              accountnumbers: expenseAccountCubit.state.selectedAccountList,
              reportingCurrency: expenseCurrencyCubit.state.selectedExpenseCurrency,
              dates: _getFormattedDates(selectedEntity: expenseEntityCubit.state.selectedExpenseEntity,
                  period: expensePeriodCubit.state.selectedExpensePeriod,
                  numberOfPeriod: expenseNumberOfPeriodCubit.state.selectedExpenseNumberOfPeriod,
                  asOnDate: expenseAsOnDateCubit.state.asOnDate),
              period: expensePeriodCubit.state.selectedExpensePeriod,
              numberOfPeriod: expenseNumberOfPeriodCubit.state.selectedExpenseNumberOfPeriod,
              asOnDate: expenseAsOnDateCubit.state.asOnDate,
              purpose: pref.regionUrl

          )
      );

      eitherIncome.fold((error) {
        if(error.appErrorType==AppErrorType.unauthorised){
          loginCheckCubit.loginCheck();
        }
        emit(ExpenseReportError(errorType: error.appErrorType));
      }, (incomeReport) {
        if(favoriteCubit != null && universalAsOnDate != null) {
          favoriteCubit.saveFilters(
            context: context,
            shouldUpdate: true,
            isPinned: favorite?.isPined ?? false,
            itemId: favorite?.id.toString(),
            reportId: FavoriteConstants.expenseId,
            reportName: favorite?.reportname ?? FavoriteConstants.expenseName,
            entity: expenseEntityCubit.state.selectedExpenseEntity,
            expenseAccounts: expenseAccountCubit.state.selectedAccountList,
            period: expensePeriodCubit.state.selectedExpensePeriod,
            numberOfPeriod: expenseNumberOfPeriodCubit.state.selectedExpenseNumberOfPeriod,
            currency: expenseCurrencyCubit.state.selectedExpenseCurrency,
            denomination: expenseDenominationCubit.state.selectedExpenseDenomination,
            asOnDate: expenseAsOnDateCubit.state.asOnDate,
          );
        }
        emit(ExpenseReportLoaded(chartData: incomeReport.report.reversed.toList()));
      });
    });

  }

  Future<void> reloadExpenseReport({required BuildContext context, FavoritesCubit? favoriteCubit, bool fromBlankWidget = false, bool isFavorite = false, Favorite? favorite}) async{

    emit(const ExpenseReportLoading());

    if(!isFavorite){
      await saveExpenseSelectedEntity(Entity(
          id: expenseEntityCubit.state.selectedExpenseEntity?.id,
          name: expenseEntityCubit.state.selectedExpenseEntity?.name,
          type: expenseEntityCubit.state.selectedExpenseEntity?.type,
          currency: expenseEntityCubit.state.selectedExpenseEntity?.currency,
          accountingyear: expenseEntityCubit.state.selectedExpenseEntity?.accountingyear
      ));

      await saveExpenseSelectedAccounts({"entityid": expenseEntityCubit.state.selectedExpenseEntity?.id, "entitytype": expenseEntityCubit.state.selectedExpenseEntity?.type}, ExpenseAccountModel(
          expenseAccount: expenseAccountCubit.state.selectedAccountList?.map((element) => ExpenseAccount(
            id: element?.id,
            accountname: element?.accountname,
            accounttype: element?.accounttype,
          )
          ).toList()));

      await saveExpenseSelectedPeriod(PeriodItem(
          id: expensePeriodCubit.state.selectedExpensePeriod?.id,
          gaps: expensePeriodCubit.state.selectedExpensePeriod?.gaps,
          name: expensePeriodCubit.state.selectedExpensePeriod?.name
      ));

      await saveExpenseSelectedNumberOfPeriod(NumberOfPeriodItem(
          id: expenseNumberOfPeriodCubit.state.selectedExpenseNumberOfPeriod?.id,
          value: expenseNumberOfPeriodCubit.state.selectedExpenseNumberOfPeriod?.value,
          name: expenseNumberOfPeriodCubit.state.selectedExpenseNumberOfPeriod?.name
      ));

      await saveExpenseSelectedCurrency(CurrencyData(
          id: expenseCurrencyCubit.state.selectedExpenseCurrency?.id,
          code: expenseCurrencyCubit.state.selectedExpenseCurrency?.code,
          format: expenseCurrencyCubit.state.selectedExpenseCurrency?.format
      ));

      await saveExpenseSelectedDenomination(DenData(
          id: expenseDenominationCubit.state.selectedExpenseDenomination?.id,
          key: expenseDenominationCubit.state.selectedExpenseDenomination?.key,
          title: expenseDenominationCubit.state.selectedExpenseDenomination?.title,
          suffix: expenseDenominationCubit.state.selectedExpenseDenomination?.suffix,
          denomination: expenseDenominationCubit.state.selectedExpenseDenomination?.denomination
      ));
    }

    if(fromBlankWidget) {
      favoriteCubit?.saveFilters(
        context: context,
        shouldUpdate: true,
        isPinned: favorite?.isPined ?? false,
        itemId: favorite?.id.toString(),
        reportId: FavoriteConstants.expenseId,
        reportName: favorite?.reportname ?? FavoriteConstants.expenseName,
        entity: expenseEntityCubit.state.selectedExpenseEntity,
        expenseAccounts: expenseAccountCubit.state.selectedAccountList,
        period: expensePeriodCubit.state.selectedExpensePeriod,
        numberOfPeriod: expenseNumberOfPeriodCubit.state.selectedExpenseNumberOfPeriod,
        currency: expenseCurrencyCubit.state.selectedExpenseCurrency,
        denomination: expenseDenominationCubit.state.selectedExpenseDenomination,
        asOnDate: expenseAsOnDateCubit.state.asOnDate,
      );
    }

    final Either<AppError, UserPreference> eitherUserPreference = await userPreference(NoParams());

    eitherUserPreference.fold((l) {

    }, (pref) async {

      final Either<AppError, ExpenseReportEntity> eitherExpense = await getExpenseReport(
          ExpenseReportParams(
            context: context,
              entity: expenseEntityCubit.state.selectedExpenseEntity,
              accountnumbers: expenseAccountCubit.state.selectedAccountList,
              reportingCurrency: expenseCurrencyCubit.state.selectedExpenseCurrency,
              dates: _getFormattedDates(selectedEntity: expenseEntityCubit.state.selectedExpenseEntity,
                  period: expensePeriodCubit.state.selectedExpensePeriod,
                  numberOfPeriod: expenseNumberOfPeriodCubit.state.selectedExpenseNumberOfPeriod,
                  asOnDate: expenseAsOnDateCubit.state.asOnDate),
              period: expensePeriodCubit.state.selectedExpensePeriod,
              numberOfPeriod: expenseNumberOfPeriodCubit.state.selectedExpenseNumberOfPeriod,
              asOnDate: expenseAsOnDateCubit.state.asOnDate,
              purpose: pref.regionUrl

          )
      );

      eitherExpense.fold((error) {
        if(error.appErrorType==AppErrorType.unauthorised){
          loginCheckCubit.loginCheck();
        }
        emit(ExpenseReportError(errorType: error.appErrorType));
      }, (expenseReport) {
        if(isFavorite) {
          favoriteCubit?.saveFilters(
            context: context,
              shouldUpdate: true,
              isPinned: favorite?.isPined ?? false,
              itemId: favorite?.id.toString(),
              reportId: FavoriteConstants.expenseId,
              reportName: favorite?.reportname ?? FavoriteConstants.expenseName,
              entity: expenseEntityCubit.state.selectedExpenseEntity,
              expenseAccounts: expenseAccountCubit.state.selectedAccountList,
              period: expensePeriodCubit.state.selectedExpensePeriod,
              numberOfPeriod: expenseNumberOfPeriodCubit.state.selectedExpenseNumberOfPeriod,
              currency: expenseCurrencyCubit.state.selectedExpenseCurrency,
              denomination: expenseDenominationCubit.state.selectedExpenseDenomination,
              asOnDate: expenseAsOnDateCubit.state.asOnDate,
          );
        }
        emit(ExpenseReportLoaded(chartData: expenseReport.report.reversed.toList()));
      });
    });

  }

  String _getFormattedDates({EntityData? selectedEntity, PeriodItemData? period, NumberOfPeriodItemData? numberOfPeriod, String? asOnDate}) {

    String formattedDates = '';

    formattedDates = '';

    bool isFirstIteration = true;

    List<String> dateList = [];

    DateTime currentDate = asOnDate != null ? DateTime.parse(asOnDate) : DateTime.now();
    DateTime firstDate = asOnDate != null ? DateTime.parse(asOnDate) : DateTime.now();
    int fiscalYearGap = 0;
    fiscalYearGap = _getFiscalYearGap(selectedEntity);

    for(int i = 0; i < 12 /*(numberOfPeriod?.value ?? 0)*/; i++) {
      if(period?.gaps == 1) {
        final date = "${currentDate.year}-${currentDate.month < 10 ? "0${currentDate.month}" : currentDate.month}-${Jiffy(currentDate).daysInMonth < 10 ? "0${Jiffy(currentDate).daysInMonth}" : Jiffy(currentDate).daysInMonth}";

        currentDate = Jiffy(currentDate).subtract(months: isFirstIteration ? 0 : 1).dateTime;
        firstDate = Jiffy(DateTime.parse(date)).subtract(months: isFirstIteration ? 0 : 1).dateTime;

        if(isFirstIteration) {
          dateList.add("${firstDate.year}-${firstDate.month < 10 ? "0${firstDate.month}" : firstDate.month}-01_${DateFormat('yyyy-MM-dd').format(Jiffy(currentDate).dateTime)}");
          isFirstIteration = false;
        }else {
          dateList.add("${firstDate.year}-${firstDate.month < 10 ? "0${firstDate.month}" : firstDate.month}-01_${firstDate.year}-${firstDate.month < 10 ? "0${firstDate.month}" : firstDate.month}-${Jiffy(currentDate).daysInMonth}");
        }

        firstDate.subtract(const Duration(days: 1));

      }else if(period?.gaps == 3) {

        final date = "${currentDate.year}-${currentDate.month < 10 ? "0${currentDate.month}" : currentDate.month}-${Jiffy(currentDate).daysInMonth < 10 ? "0${Jiffy(currentDate).daysInMonth}" : Jiffy(currentDate).daysInMonth}";
        firstDate = Jiffy(DateTime.parse(date)).subtract(months: isFirstIteration ? 2 : 3).dateTime;

        currentDate = Jiffy(currentDate).subtract(months: isFirstIteration ? 2 : 3).dateTime;
        dateList
            .add("${firstDate.year}-${firstDate.month < 10 ? "0${firstDate.month}"
            : firstDate.month}-01_${isFirstIteration
            ? DateFormat('yyyy-MM-dd')
            .format((Jiffy(DateTime.parse(date)).subtract(months: 1).dateTime)
            .add(Duration(days: currentDate.day)))
            : DateFormat('yyyy-MM-${Jiffy(DateTime.parse(date)).subtract(months: 1).daysInMonth}')
            .format(Jiffy(DateTime.parse(date)).subtract(months: 1).dateTime)}");
        firstDate.subtract(const Duration(days: 1));

        isFirstIteration = false;

      }else if(period?.gaps == 12) {
        final date = "${currentDate.year}-${currentDate.month < 10 ? "0${currentDate.month}" : currentDate.month}-${Jiffy(currentDate).daysInMonth < 10 ? "0${Jiffy(currentDate).daysInMonth}" : Jiffy(currentDate).daysInMonth}";
        firstDate = Jiffy(DateTime.parse(date)).subtract(months: isFirstIteration ? 0 : 12).dateTime;


        currentDate = Jiffy(currentDate).subtract(months: isFirstIteration ? 0 : 12).dateTime;

        if(isFirstIteration) {
          dateList.add("${firstDate.year}-01-01_${DateFormat('yyyy-MM-dd').format(Jiffy(DateTime.parse(asOnDate ?? date)).dateTime)}");
          isFirstIteration = false;
        }else {
          dateList.add("${firstDate.year}-01-01_${firstDate.year}-12-31");
        }

        firstDate.subtract(const Duration(days: 1));

      }else if(period?.gaps == -1) {

        final date = "${currentDate.year}-${currentDate.month < 10 ? "0${currentDate.month}" : currentDate.month}-${Jiffy(currentDate).daysInMonth < 10 ? "0${Jiffy(currentDate).daysInMonth}" : Jiffy(currentDate).daysInMonth}";

        firstDate = Jiffy(DateTime.parse(date)).subtract(months: fiscalYearGap).dateTime;
        currentDate = Jiffy(currentDate).subtract(months: fiscalYearGap).dateTime;

        if(isFirstIteration) {
          dateList.add("${DateFormat('yyyy-MM-01').format(Jiffy(DateTime.parse(asOnDate ?? date)).subtract(months: fiscalYearGap).dateTime)}_${DateFormat('yyyy-MM-dd').format(Jiffy(DateTime.parse(asOnDate ?? date)).dateTime)}");
          isFirstIteration = false;
          fiscalYearGap = 12;
        }else {
          dateList.add("${firstDate.year}-${firstDate.month < 10 ? "0${firstDate.month}" : firstDate.month}-01_${DateFormat('yyyy-MM-${Jiffy(DateTime.parse(date)).subtract(months: 1).daysInMonth}').format(Jiffy(DateTime.parse(date)).subtract(months: 1).dateTime)}");
        }

        firstDate.subtract(const Duration(days: 1));
      }
    }

    dateList.forEach((date) {
      formattedDates = formattedDates + '$date,';
    });
    return formattedDates.substring(0, formattedDates.length-1);
  }

  int _getFiscalYearGap(EntityData? selectedEntity) {

    int fiscalYearGap = 0;
    int entityFiscalYearMonth = 0;
    int currentMonth = DateTime.now().month;

    final entityDate = selectedEntity?.accountingyear?.substring(0, selectedEntity.accountingyear?.indexOf('to')).trim();

    switch(entityDate) {
      case "1-January":
        entityFiscalYearMonth = 1;
        break;
      case "1-February":
        entityFiscalYearMonth = 2;
        break;
      case "1-March":
        entityFiscalYearMonth = 3;
        break;
      case "1-April":
        entityFiscalYearMonth = 4;
        break;
      case "1-May":
        entityFiscalYearMonth = 5;
        break;
      case "1-June":
        entityFiscalYearMonth = 6;
        break;
      case "1-July":
        entityFiscalYearMonth = 7;
        break;
      case "1-August":
        entityFiscalYearMonth = 8;
        break;
      case "1-September":
        entityFiscalYearMonth = 9;
        break;
      case "1-October":
        entityFiscalYearMonth = 10;
        break;
      case "1-November":
        entityFiscalYearMonth = 11;
        break;
      case "1-December":
        entityFiscalYearMonth = 12;
        break;
    }

    if(currentMonth > entityFiscalYearMonth){
      fiscalYearGap = currentMonth - entityFiscalYearMonth;
    }else if(currentMonth < entityFiscalYearMonth) {
      fiscalYearGap = 12 - (currentMonth - entityFiscalYearMonth);
    }

    return fiscalYearGap;
  }

}
