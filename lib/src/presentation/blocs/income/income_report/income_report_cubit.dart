


import 'dart:developer';

import 'package:asset_vantage/src/data/models/currency/currency_model.dart';
import 'package:asset_vantage/src/data/models/denomination/denomination_model.dart';
import 'package:asset_vantage/src/data/models/income/income_account_model.dart';
import 'package:asset_vantage/src/data/models/number_of_period/number_of_period_model.dart';
import 'package:asset_vantage/src/data/models/period/period_model.dart';
import 'package:asset_vantage/src/domain/entities/currency/currency_entity.dart';
import 'package:asset_vantage/src/domain/params/income/income_report_params.dart';
import 'package:asset_vantage/src/domain/usecases/income/income_filter/selected_accounts/save_income_selected_accounts.dart';
import 'package:asset_vantage/src/domain/usecases/income/income_filter/selected_denomination/save_income_selected_denomination.dart';
import 'package:asset_vantage/src/domain/usecases/income/income_filter/selected_entity/save_income_selected_entity.dart';
import 'package:asset_vantage/src/domain/usecases/income/income_filter/selected_number_of_period/save_income_selected_number_of_period.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_as_on_date/income_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_currency/income_currency_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_denomination/income_denomination_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_loading/income_loading_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_sort_cubit/income_sort_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

import '../../../../config/constants/favorite_constants.dart';
import '../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../data/models/preferences/user_preference.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../../domain/entities/favorites/favorites_entity.dart';
import '../../../../domain/entities/income/income_chart_data.dart';
import '../../../../domain/entities/income/income_report_entity.dart';
import '../../../../domain/entities/number_of_period/number_of_period.dart';
import '../../../../domain/entities/period/period_enitity.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/usecases/income/get_income_report.dart';
import '../../../../domain/usecases/income/income_filter/selected_currency/save_income_selected_currency.dart';
import '../../../../domain/usecases/income/income_filter/selected_period/save_income_selected_period.dart';
import '../../../../domain/usecases/preferences/get_user_preference.dart';
import '../../../../utilities/helper/favorite_helper.dart';
import '../../authentication/login_check/login_check_cubit.dart';
import '../../favorites/favorites_cubit.dart';
import '../income_account/income_account_cubit.dart';
import '../income_entity/income_entity_cubit.dart';
import '../income_number_of_period/income_number_of_period_cubit.dart';
import '../income_period/income_period_cubit.dart';
import '../income_timestamp/income_timestamp_cubit.dart';

part 'income_report_state.dart';

class IncomeReportCubit extends Cubit<IncomeReportState> {
  final IncomeEntityCubit incomeEntityCubit;
  final IncomeAccountCubit incomeAccountCubit;
  final IncomePeriodCubit incomePeriodCubit;
  final IncomeNumberOfPeriodCubit incomeNumberOfPeriodCubit;
  final IncomeCurrencyCubit incomeCurrencyCubit;
  final IncomeDenominationCubit incomeDenominationCubit;
  final IncomeAsOnDateCubit incomeAsOnDateCubit;
  final IncomeSortCubit incomeSortCubit;
  final GetIncomeReport getIncomeReport;
  final GetUserPreference userPreference;
  final IncomeTimestampCubit incomeTimestampCubit;
  final LoginCheckCubit loginCheckCubit;
  final IncomeLoadingCubit incomeLoadingCubit;

  final SaveIncomeSelectedEntity saveIncomeSelectedEntity;
  final SaveIncomeSelectedAccounts saveIncomeSelectedAccounts;
  final SaveIncomeSelectedPeriod saveIncomeSelectedPeriod;
  final SaveIncomeSelectedNumberOfPeriod saveIncomeSelectedNumberOfPeriod;
  final SaveIncomeSelectedCurrency saveIncomeSelectedCurrency;
  final SaveIncomeSelectedDenomination saveIncomeSelectedDenomination;


  IncomeReportCubit({
    required this.incomeEntityCubit,
    required this.incomeAccountCubit,
    required this.incomePeriodCubit,
    required this.incomeNumberOfPeriodCubit,
    required this.incomeCurrencyCubit,
    required this.incomeDenominationCubit,
    required this.incomeAsOnDateCubit,
    required this.incomeSortCubit,
    required this.getIncomeReport,
    required this.userPreference,
    required this.incomeTimestampCubit,
    required this.loginCheckCubit,
    required this.incomeLoadingCubit,
    required this.saveIncomeSelectedEntity,
    required this.saveIncomeSelectedAccounts,
    required this.saveIncomeSelectedPeriod,
    required this.saveIncomeSelectedNumberOfPeriod,
    required this.saveIncomeSelectedCurrency,
    required this.saveIncomeSelectedDenomination,
  }) : super(IncomeReportInitial());

  Future<void> loadIncomeReport({required BuildContext context,
    Entity? universalEntity,
    String? universalAsOnDate
  }) async{

    emit(const IncomeReportLoading());

    final Either<AppError, UserPreference> eitherUserPreference = await userPreference(NoParams());

    eitherUserPreference.fold((l) {

    }, (pref) async {
      incomeLoadingCubit.startLoading();
      await incomeEntityCubit.loadIncomeEntity(context: context, favoriteEntity: universalEntity);
      await saveIncomeSelectedEntity(Entity(
          id: incomeEntityCubit.state.selectedIncomeEntity?.id,
          name: incomeEntityCubit.state.selectedIncomeEntity?.name,
          type: incomeEntityCubit.state.selectedIncomeEntity?.type,
          currency: incomeEntityCubit.state.selectedIncomeEntity?.currency,
          accountingyear: incomeEntityCubit.state.selectedIncomeEntity?.accountingyear
      ));
      await incomeAsOnDateCubit.changeAsOnDate(asOnDate: universalAsOnDate);
      await incomeAccountCubit.loadIncomeAccount(context: context, selectedEntity: incomeEntityCubit.state.selectedIncomeEntity, asOnDate: incomeAsOnDateCubit.state.asOnDate);
      await incomePeriodCubit.loadIncomePeriod(context: context);
      await incomeNumberOfPeriodCubit.loadIncomeNumberOfPeriod(context: context);
      await incomeDenominationCubit.loadIncomeDenomination(context: context);
      await incomeCurrencyCubit.loadIncomeCurrency(context: context, incomeDenominationCubit: incomeDenominationCubit, selectedEntity: incomeEntityCubit.state.selectedIncomeEntity);
      incomeLoadingCubit.endLoading();
      final Either<AppError, IncomeReportEntity> eitherIncome = await getIncomeReport(
          IncomeReportParams(
            context: context,
            entity: incomeEntityCubit.state.selectedIncomeEntity,
            accountnumbers: incomeAccountCubit.state.selectedAccountList,
            reportingCurrency: incomeCurrencyCubit.state.selectedIncomeCurrency,
            dates: _getFormattedDates(selectedEntity: incomeEntityCubit.state.selectedIncomeEntity,
                period: incomePeriodCubit.state.selectedIncomePeriod,
                numberOfPeriod: incomeNumberOfPeriodCubit.state.selectedIncomeNumberOfPeriod,
                asOnDate: incomeAsOnDateCubit.state.asOnDate),
            period: incomePeriodCubit.state.selectedIncomePeriod,
            numberOfPeriod: incomeNumberOfPeriodCubit.state.selectedIncomeNumberOfPeriod,
            asOnDate: incomeAsOnDateCubit.state.asOnDate,
            purpose: pref.regionUrl

          )
      );

      eitherIncome.fold((error) {
        if(error.appErrorType==AppErrorType.unauthorised){
          loginCheckCubit.loginCheck();
        }
        emit(IncomeReportError(errorType: error.appErrorType));
      }, (incomeReport) {
        emit(IncomeReportLoaded(chartData: incomeReport.report.reversed.toList()));
      });
    });

  }

  Future<void> loadIncomeReportForFavorites({required BuildContext context, FavoritesCubit? favoriteCubit, required Favorite? favorite, String? universalAsOnDate}) async{

    emit(const IncomeReportLoading());

    final Either<AppError, UserPreference> eitherUserPreference = await userPreference(NoParams());

    eitherUserPreference.fold((l) {

    }, (pref) async {
      incomeLoadingCubit.startLoading();
      await incomeEntityCubit.loadIncomeEntity(context: context, favoriteEntity: favorite?.filter?[FavoriteConstants.entityFilter] != null ? Entity.fromJson(favorite?.filter?[FavoriteConstants.entityFilter]) : null);
      await incomeAsOnDateCubit.changeAsOnDate(asOnDate: universalAsOnDate ?? favorite?.filter?[FavoriteConstants.asOnDate]);
      await incomeAccountCubit.loadIncomeAccount(
        context: context,
          favoriteAccounts: favorite?.filter?[FavoriteConstants.accounts] != null ? FavoriteHelper.getIncomeAccounts(favorite?.filter?[FavoriteConstants.accounts]) : null,
          selectedEntity: incomeEntityCubit.state.selectedIncomeEntity,
          asOnDate: incomeAsOnDateCubit.state.asOnDate);
      await incomePeriodCubit.loadIncomePeriod(context: context, favoritePeriod: favorite?.filter?[FavoriteConstants.period]!=null?PeriodItem.fromJson(favorite?.filter?[FavoriteConstants.period]):null);
      await incomeNumberOfPeriodCubit.loadIncomeNumberOfPeriod(context: context, favoriteNumberOfPeriod: favorite?.filter?[FavoriteConstants.numberOfPeriod]!=null?NumberOfPeriodItem.fromJson(favorite?.filter?[FavoriteConstants.numberOfPeriod]):null);
      await incomeDenominationCubit.loadIncomeDenomination(context: context, favoriteDenData: favorite?.filter?[FavoriteConstants.denomination] != null ? DenData.fromJson(favorite?.filter?[FavoriteConstants.denomination]) : null);
      await incomeCurrencyCubit.loadIncomeCurrency(context: context, incomeDenominationCubit: incomeDenominationCubit, favoriteCurrency: favorite?.filter?[FavoriteConstants.currency] != null ? CurrencyData.fromJson(favorite?.filter?[FavoriteConstants.currency]) : null, selectedEntity: incomeEntityCubit.state.selectedIncomeEntity);
      incomeLoadingCubit.endLoading();
      final Either<AppError, IncomeReportEntity> eitherIncome = await getIncomeReport(
          IncomeReportParams(
            context: context,
              entity: incomeEntityCubit.state.selectedIncomeEntity,
              accountnumbers: incomeAccountCubit.state.selectedAccountList,
              reportingCurrency: incomeCurrencyCubit.state.selectedIncomeCurrency,
              dates: _getFormattedDates(selectedEntity: incomeEntityCubit.state.selectedIncomeEntity,
                  period: incomePeriodCubit.state.selectedIncomePeriod,
                  numberOfPeriod: incomeNumberOfPeriodCubit.state.selectedIncomeNumberOfPeriod,
                  asOnDate: incomeAsOnDateCubit.state.asOnDate),
              period: incomePeriodCubit.state.selectedIncomePeriod,
              numberOfPeriod: incomeNumberOfPeriodCubit.state.selectedIncomeNumberOfPeriod,
              asOnDate: incomeAsOnDateCubit.state.asOnDate,
              purpose: pref.regionUrl

          )
      );

      eitherIncome.fold((error) {
        if(error.appErrorType==AppErrorType.unauthorised){
          loginCheckCubit.loginCheck();
        }
        emit(IncomeReportError(errorType: error.appErrorType));
      }, (incomeReport) {
        if(favoriteCubit != null && universalAsOnDate != null) {
          favoriteCubit.saveFilters(
            context: context,
            shouldUpdate: true,
            isPinned: favorite?.isPined ?? false,
            itemId: favorite?.id.toString(),
            reportId: FavoriteConstants.incomeId,
            reportName: favorite?.reportname ?? FavoriteConstants.incomeName,
            entity: incomeEntityCubit.state.selectedIncomeEntity,
            incomeAccounts: incomeAccountCubit.state.selectedAccountList,
            period: incomePeriodCubit.state.selectedIncomePeriod,
            numberOfPeriod: incomeNumberOfPeriodCubit.state.selectedIncomeNumberOfPeriod,
            currency: incomeCurrencyCubit.state.selectedIncomeCurrency,
            denomination: incomeDenominationCubit.state.selectedIncomeDenomination,
            asOnDate: incomeAsOnDateCubit.state.asOnDate,
          );
        }
        emit(IncomeReportLoaded(chartData: incomeReport.report.reversed.toList()));
      });
    });

  }


  Future<void> reloadIncomeReport({required BuildContext context, FavoritesCubit? favoriteCubit, bool fromBlankWidget = false, bool isFavorite = false, Favorite? favorite}) async{

    emit(const IncomeReportLoading());

    if(!isFavorite){
      await saveIncomeSelectedEntity(Entity(
          id: incomeEntityCubit.state.selectedIncomeEntity?.id,
          name: incomeEntityCubit.state.selectedIncomeEntity?.name,
          type: incomeEntityCubit.state.selectedIncomeEntity?.type,
          currency: incomeEntityCubit.state.selectedIncomeEntity?.currency,
          accountingyear: incomeEntityCubit.state.selectedIncomeEntity?.accountingyear
      ));

      await saveIncomeSelectedAccounts({"entityid": incomeEntityCubit.state.selectedIncomeEntity?.id, "entitytype": incomeEntityCubit.state.selectedIncomeEntity?.type}, IncomeAccountModel(
          incomeAccount: incomeAccountCubit.state.selectedAccountList?.map((element) => IncomeAccount(
            id: element?.id,
            accountname: element?.accountname,
            accounttype: element?.accounttype,
          )
          ).toList()));

      await saveIncomeSelectedPeriod(PeriodItem(
          id: incomePeriodCubit.state.selectedIncomePeriod?.id,
          gaps: incomePeriodCubit.state.selectedIncomePeriod?.gaps,
          name: incomePeriodCubit.state.selectedIncomePeriod?.name
      ));

      await saveIncomeSelectedNumberOfPeriod(NumberOfPeriodItem(
          id: incomeNumberOfPeriodCubit.state.selectedIncomeNumberOfPeriod?.id,
          value: incomeNumberOfPeriodCubit.state.selectedIncomeNumberOfPeriod?.value,
          name: incomeNumberOfPeriodCubit.state.selectedIncomeNumberOfPeriod?.name
      ));

      await saveIncomeSelectedCurrency(CurrencyData(
          id: incomeCurrencyCubit.state.selectedIncomeCurrency?.id,
          code: incomeCurrencyCubit.state.selectedIncomeCurrency?.code,
          format: incomeCurrencyCubit.state.selectedIncomeCurrency?.format
      ));

      await saveIncomeSelectedDenomination(DenData(
          id: incomeDenominationCubit.state.selectedIncomeDenomination?.id,
          key: incomeDenominationCubit.state.selectedIncomeDenomination?.key,
          title: incomeDenominationCubit.state.selectedIncomeDenomination?.title,
          suffix: incomeDenominationCubit.state.selectedIncomeDenomination?.suffix,
          denomination: incomeDenominationCubit.state.selectedIncomeDenomination?.denomination
      ));
    }

    if(fromBlankWidget) {
      favoriteCubit?.saveFilters(
        context: context,
        shouldUpdate: true,
        isPinned: favorite?.isPined ?? false,
        itemId: favorite?.id.toString(),
        reportId: FavoriteConstants.incomeId,
        reportName: favorite?.reportname ?? FavoriteConstants.incomeName,
        entity: incomeEntityCubit.state.selectedIncomeEntity,
        incomeAccounts: incomeAccountCubit.state.selectedAccountList,
        period: incomePeriodCubit.state.selectedIncomePeriod,
        numberOfPeriod: incomeNumberOfPeriodCubit.state.selectedIncomeNumberOfPeriod,
        currency: incomeCurrencyCubit.state.selectedIncomeCurrency,
        denomination: incomeDenominationCubit.state.selectedIncomeDenomination,
        asOnDate: incomeAsOnDateCubit.state.asOnDate,
      );
    }

    final Either<AppError, UserPreference> eitherUserPreference = await userPreference(NoParams());

    eitherUserPreference.fold((l) {

    }, (pref) async {

      final Either<AppError, IncomeReportEntity> eitherIncome = await getIncomeReport(
          IncomeReportParams(
            context: context,
              entity: incomeEntityCubit.state.selectedIncomeEntity,
              accountnumbers: incomeAccountCubit.state.selectedAccountList,
              reportingCurrency: incomeCurrencyCubit.state.selectedIncomeCurrency,
              dates: _getFormattedDates(selectedEntity: incomeEntityCubit.state.selectedIncomeEntity,
                  period: incomePeriodCubit.state.selectedIncomePeriod,
                  numberOfPeriod: incomeNumberOfPeriodCubit.state.selectedIncomeNumberOfPeriod,
                  asOnDate: incomeAsOnDateCubit.state.asOnDate),
              period: incomePeriodCubit.state.selectedIncomePeriod,
              numberOfPeriod: incomeNumberOfPeriodCubit.state.selectedIncomeNumberOfPeriod,
              asOnDate: incomeAsOnDateCubit.state.asOnDate,
              purpose: pref.regionUrl

          )
      );

      log("DATE_RANGE: ${_getFormattedDates(selectedEntity: incomeEntityCubit.state.selectedIncomeEntity,
          period: incomePeriodCubit.state.selectedIncomePeriod,
          numberOfPeriod: incomeNumberOfPeriodCubit.state.selectedIncomeNumberOfPeriod,
          asOnDate: incomeAsOnDateCubit.state.asOnDate)}");

      eitherIncome.fold((error) {
        if(error.appErrorType==AppErrorType.unauthorised){
          loginCheckCubit.loginCheck();
        }
        emit(IncomeReportError(errorType: error.appErrorType));
      }, (incomeReport) {
        if(isFavorite) {
          favoriteCubit?.saveFilters(
            context: context,
              shouldUpdate: true,
              isPinned: favorite?.isPined ?? false,
              itemId: favorite?.id.toString(),
              reportId: FavoriteConstants.incomeId,
              reportName: favorite?.reportname ?? FavoriteConstants.incomeName,
              entity: incomeEntityCubit.state.selectedIncomeEntity,
              incomeAccounts: incomeAccountCubit.state.selectedAccountList,
              period: incomePeriodCubit.state.selectedIncomePeriod,
              numberOfPeriod: incomeNumberOfPeriodCubit.state.selectedIncomeNumberOfPeriod,
              currency: incomeCurrencyCubit.state.selectedIncomeCurrency,
              denomination: incomeDenominationCubit.state.selectedIncomeDenomination,
              asOnDate: incomeAsOnDateCubit.state.asOnDate,
          );
        }
        emit(IncomeReportLoaded(chartData: incomeReport.report.reversed.toList()));
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
