import 'dart:developer';

import 'package:asset_vantage/src/data/models/number_of_period/number_of_period_model.dart';
import 'package:asset_vantage/src/data/models/period/period_model.dart';
import 'package:asset_vantage/src/domain/entities/dashboard/dashboard_list_entity.dart';
import 'package:asset_vantage/src/domain/entities/period/period_enitity.dart';
import 'package:asset_vantage/src/domain/usecases/cash_balance/cash_balance_filters/accounts/save_cb_selected_sub_groups.dart';
import 'package:asset_vantage/src/domain/usecases/cash_balance/cash_balance_filters/selected_as_on_date/save_cash_balance_selected_as_on_date.dart';
import 'package:asset_vantage/src/domain/usecases/cash_balance/cash_balance_filters/selected_number_of_period/save_performance_selected_entity.dart';
import 'package:asset_vantage/src/domain/usecases/cash_balance/cash_balance_filters/selected_period/save_performance_selected_entity.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_accounts/cash_balance_account_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_loading/cash_balance_loading_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

import '../../../../config/constants/favorite_constants.dart';
import '../../../../data/models/cash_balance/cash_balance_grouping_model.dart';
import '../../../../data/models/cash_balance/cash_balance_sub_grouping_model.dart';
import '../../../../data/models/currency/currency_model.dart';
import '../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../data/models/denomination/denomination_model.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/cash_balance/cash_balance_entity.dart';
import '../../../../domain/entities/favorites/favorites_entity.dart';
import '../../../../domain/entities/number_of_period/number_of_period.dart';
import '../../../../domain/params/cash_balance/cash_balance_report_params.dart';
import '../../../../domain/usecases/cash_balance/cash_balance_filters/primary_grouping/save_cash_balance_selected_grouping.dart';
import '../../../../domain/usecases/cash_balance/cash_balance_filters/selected_currency/save_cash_balance_selected_currency.dart';
import '../../../../domain/usecases/cash_balance/cash_balance_filters/selected_denomination/save_performance_selected_denomination.dart';
import '../../../../domain/usecases/cash_balance/cash_balance_filters/selected_entity/save_performance_selected_entity.dart';
import '../../../../domain/usecases/cash_balance/cash_balance_filters/sub_grouping/save_cash_balance_selected_sub_grouping.dart';
import '../../../../domain/usecases/cash_balance/get_cash_balance_report.dart';
import '../../../../utilities/helper/favorite_helper.dart';
import '../../authentication/login_check/login_check_cubit.dart';
import '../../favorites/favorites_cubit.dart';
import '../../loading/loading_cubit.dart';
import '../cash_balance_as_on_date/cash_balance_as_on_date_cubit.dart';
import '../cash_balance_currency/cash_balance_currency_cubit.dart';
import '../cash_balance_denomination/cash_balance_denomination_cubit.dart';
import '../cash_balance_entity/cash_balance_entity_cubit.dart';
import '../cash_balance_grouping/cash_balance_grouping_cubit.dart';
import '../cash_balance_number_of_period/cash_balance_number_of_period_cubit.dart';
import '../cash_balance_period/cash_balance_period_cubit.dart';
import '../cash_balance_sort_cubit/cash_balance_sort_cubit.dart';
import '../cash_balance_sub_grouping/cash_balance_sub_grouping_cubit.dart';

part 'cash_balance_report_state.dart';

class CashBalanceReportCubit extends Cubit<CashBalanceReportState> {
  final LoadingCubit loadingCubit;
  final CashBalanceEntityCubit cashBalanceEntityCubit;
  final GetCashBalanceReport getCashBalanceReport;
  final LoginCheckCubit loginCheckCubit;
  final CashBalancePrimaryGroupingCubit cashBalancePrimaryGroupingCubit;
  final CashBalancePrimarySubGroupingCubit cashBalancePrimarySubGroupingCubit;
  final CashBalancePeriodCubit cashBalancePeriodCubit;
  final CashBalanceNumberOfPeriodCubit cashBalanceNumberOfPeriodCubit;
  final CashBalanceDenominationCubit cashBalanceDenominationCubit;
  final CashBalanceCurrencyCubit cashBalanceCurrencyCubit;
  final CashBalanceAsOnDateCubit cashBalanceAsOnDateCubit;
  final CashBalanceAccountCubit cashBalanceAccountCubit;
  final CashBalanceLoadingCubit cashBalanceLoadingCubit;
  final CashBalanceSortCubit cashBalanceSortCubit;

  final SaveCashBalanceSelectedEntity saveCashBalanceSelectedEntity;
  final SaveCashBalanceSelectedPrimaryGrouping
      saveCashBalanceSelectedPrimaryGrouping;
  final SaveCashBalanceSelectedPrimarySubGrouping
      saveCashBalanceSelectedPrimarySubGrouping;
  final SaveCashBalanceSelectedAccounts saveCashBalanceSelectedAccounts;
  final SaveCashBalanceSelectedCurrency saveCashBalanceSelectedCurrency;
  final SaveCashBalanceSelectedDenomination saveCashBalanceSelectedDenomination;
  final SaveCashBalanceSelectedAsOnDate saveCashBalanceSelectedAsOnDate;
  final SaveCashBalanceSelectedPeriod saveCashBalanceSelectedPeriod;
  final SaveCashBalanceSelectedNumberOfPeriod
      saveCashBalanceSelectedNumberOfPeriod;

  CashBalanceReportCubit({
    required this.loadingCubit,
    required this.cashBalanceEntityCubit,
    required this.getCashBalanceReport,
    required this.loginCheckCubit,
    required this.cashBalanceSortCubit,
    required this.cashBalancePrimaryGroupingCubit,
    required this.cashBalancePrimarySubGroupingCubit,
    required this.cashBalancePeriodCubit,
    required this.cashBalanceNumberOfPeriodCubit,
    required this.cashBalanceDenominationCubit,
    required this.cashBalanceCurrencyCubit,
    required this.cashBalanceAsOnDateCubit,
    required this.cashBalanceAccountCubit,
    required this.cashBalanceLoadingCubit,
    required this.saveCashBalanceSelectedEntity,
    required this.saveCashBalanceSelectedPrimaryGrouping,
    required this.saveCashBalanceSelectedPrimarySubGrouping,
    required this.saveCashBalanceSelectedAccounts,
    required this.saveCashBalanceSelectedCurrency,
    required this.saveCashBalanceSelectedDenomination,
    required this.saveCashBalanceSelectedNumberOfPeriod,
    required this.saveCashBalanceSelectedPeriod,
    required this.saveCashBalanceSelectedAsOnDate,
  }) : super(CashBalanceReportInitial());

  Future<void> loadCashBalanceReport({required BuildContext context, required String tileName,
  Entity? universalEntity,
    String? universalAsOnDate,
  }) async {
    emit(const CashBalanceReportLoading());
    cashBalanceLoadingCubit.startLoading();
    await cashBalanceEntityCubit.loadCashBalanceEntity(context: context, tileName: tileName, favoriteEntity: universalEntity);
    await saveCashBalanceSelectedEntity(
        tileName,
        Entity.fromJson(
            cashBalanceEntityCubit.state.selectedCashBalanceEntity?.toJson() ??
                {}));
    await cashBalanceAsOnDateCubit.changeAsOnDate(asOnDate: universalAsOnDate);
    await saveCashBalanceSelectedAsOnDate(
        tileName, cashBalanceAsOnDateCubit.state.asOnDate ?? "");
    await cashBalancePrimaryGroupingCubit.loadCashBalancePrimaryGrouping(
      context: context,
      selectedEntity: cashBalanceEntityCubit.state.selectedCashBalanceEntity,
      asOnDate: cashBalanceAsOnDateCubit.state.asOnDate,
      tileName: tileName,
    );
    await cashBalancePrimarySubGroupingCubit.loadCashBalancePrimarySubGrouping(
      context: context,
        selectedEntity: cashBalanceEntityCubit.state.selectedCashBalanceEntity,
        selectedGrouping:
            cashBalancePrimaryGroupingCubit.state.selectedGrouping,
        asOnDate: cashBalanceAsOnDateCubit.state.asOnDate,
        tileName: tileName);
    await cashBalanceAccountCubit.loadCashBalanceAccounts(
      context: context,
        tileName: tileName,
        selectedEntity: cashBalanceEntityCubit.state.selectedCashBalanceEntity,
        primaryGrouping: cashBalancePrimaryGroupingCubit.state.selectedGrouping,
        primarySubGrouping: cashBalancePrimarySubGroupingCubit.state.selectedSubGroupingList,
        asOnDate: cashBalanceAsOnDateCubit.state.asOnDate);
    await cashBalancePeriodCubit.loadCashBalancePeriod(context: context, tileName: tileName);
    await cashBalanceNumberOfPeriodCubit.loadCashBalanceNumberOfPeriod(
      context: context,
        tileName: tileName);
    await cashBalanceDenominationCubit.loadCashBalanceDenomination(
      context: context,
        tileName: tileName);
    await cashBalanceCurrencyCubit.loadCashBalanceCurrency(
      cashBalanceDenominationCubit: cashBalanceDenominationCubit,
      context: context,
        selectedEntity: cashBalanceEntityCubit.state.selectedCashBalanceEntity,
        tileName: tileName);

    String formatedSubGrouping = '';
    String formattedAccounts = '';
    cashBalancePrimarySubGroupingCubit.state.selectedSubGroupingList
        ?.forEach((grp) {
      formatedSubGrouping = formatedSubGrouping + ('${grp?.id},' ?? '');
    });
    cashBalanceAccountCubit.state.selectedAccountsList?.forEach((grp) {
      formattedAccounts = formattedAccounts + ('${grp?.id},' ?? '');
    });

    cashBalanceLoadingCubit.endLoading();

    final Either<AppError, CashBalanceReportEntity> eitherCashBalance =
        await getCashBalanceReport(CashBalanceReportParams(
          context: context,
      entityId:
          "${cashBalanceEntityCubit.state.selectedCashBalanceEntity?.id}${cashBalanceEntityCubit.state.selectedCashBalanceEntity?.type == "Entity" ? "" : "_EntityGroup"}",
      entityName: cashBalanceEntityCubit.state.selectedCashBalanceEntity?.name,
      entityType:
          cashBalanceEntityCubit.state.selectedCashBalanceEntity?.type ==
                  "Entity"
              ? "0"
              : "1",
      filter1: "${cashBalancePrimaryGroupingCubit.state.selectedGrouping?.id}",
      filter1name: cashBalancePrimaryGroupingCubit.state.selectedGrouping?.name,
      filter4: formatedSubGrouping,
      filter5: formattedAccounts,
      transactionPeriods: _getFormattedDates(
        selectedEntity: cashBalanceEntityCubit.state.selectedCashBalanceEntity,
        period: cashBalancePeriodCubit.state.selectedCashBalancePeriod,
        numberOfPeriod: cashBalanceNumberOfPeriodCubit
            .state.selectedCashBalanceNumberOfPeriod,
        asOnDate: cashBalanceAsOnDateCubit.state.asOnDate,
      ),
      currencycode:
          cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency?.code,
      currencyid:
          cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency?.id,
      period: cashBalancePeriodCubit.state.selectedCashBalancePeriod?.name,
      numberOfPeriod: cashBalanceNumberOfPeriodCubit
          .state.selectedCashBalanceNumberOfPeriod?.name,
          asOnDate: cashBalanceAsOnDateCubit.state.asOnDate
    ));

    eitherCashBalance.fold((error) {
      emit(CashBalanceReportError(errorType: error.appErrorType));
    }, (cashBalance) {
      emit(CashBalanceReportLoaded(chartData: cashBalance));
    });
  }

  Future<void> loadCashBalanceReportForFavorites({required BuildContext context, FavoritesCubit? favoriteCubit, required String tileName, required Favorite? favorite, String? universalAsOnDate}) async {
    emit(const CashBalanceReportLoading());
    cashBalanceLoadingCubit.startLoading();
    await cashBalanceEntityCubit.loadCashBalanceEntity(context: context, tileName: tileName, favoriteEntity: favorite?.filter?[FavoriteConstants.entityFilter] != null ? Entity.fromJson(favorite?.filter?[FavoriteConstants.entityFilter]) : null);
    await cashBalanceAsOnDateCubit.changeAsOnDate(asOnDate: universalAsOnDate ?? favorite?.filter?[FavoriteConstants.asOnDate]);
    await cashBalancePrimaryGroupingCubit.loadCashBalancePrimaryGrouping(
      context: context,
      favoritePrimaryGrouping: favorite?.filter?[FavoriteConstants.primaryGrouping] != null ? PrimaryGrouping.fromJson(favorite?.filter?[FavoriteConstants.primaryGrouping]) : null,
      selectedEntity: cashBalanceEntityCubit.state.selectedCashBalanceEntity,
      asOnDate: cashBalanceAsOnDateCubit.state.asOnDate,
      tileName: tileName,
    );
    await cashBalancePrimarySubGroupingCubit.loadCashBalancePrimarySubGrouping(
      context: context,
      favoriteSubGroupingItemList: favorite?.filter?[FavoriteConstants.primarySubGrouping] != null ? FavoriteHelper.getCashBalancePrimarySubGrouping(favorite?.filter?[FavoriteConstants.primarySubGrouping]) : null,
        selectedEntity: cashBalanceEntityCubit.state.selectedCashBalanceEntity,
        selectedGrouping:
        cashBalancePrimaryGroupingCubit.state.selectedGrouping,
        asOnDate: cashBalanceAsOnDateCubit.state.asOnDate,
        tileName: tileName);
    await cashBalanceAccountCubit.loadCashBalanceAccounts(
      context: context,
      favoriteAccount: favorite?.filter?[FavoriteConstants.accounts] != null ? FavoriteHelper.getCashBalanceAccounts(favorite?.filter?[FavoriteConstants.accounts]) : null,
        tileName: tileName,
        selectedEntity: cashBalanceEntityCubit.state.selectedCashBalanceEntity,
        primaryGrouping: cashBalancePrimaryGroupingCubit.state.selectedGrouping,
        primarySubGrouping: cashBalancePrimarySubGroupingCubit.state.selectedSubGroupingList,
        asOnDate: cashBalanceAsOnDateCubit.state.asOnDate);
    await cashBalancePeriodCubit.loadCashBalancePeriod(
      context: context,
        tileName: tileName,
      favoritePeriod: favorite?.filter?[FavoriteConstants.period]!=null?PeriodItem.fromJson(favorite?.filter?[FavoriteConstants.period]):null
    );
    await cashBalanceNumberOfPeriodCubit.loadCashBalanceNumberOfPeriod(
      context: context,
      favoriteNumberOfPeriodItemData: favorite?.filter?[FavoriteConstants.numberOfPeriod]!=null?NumberOfPeriodItem.fromJson(favorite?.filter?[FavoriteConstants.numberOfPeriod]):null,
        tileName: tileName);
    await cashBalanceDenominationCubit.loadCashBalanceDenomination(
      context: context,
      favoriteDenData: favorite?.filter?[FavoriteConstants.denomination] != null ? DenData.fromJson(favorite?.filter?[FavoriteConstants.denomination]) : null,
        tileName: tileName);
    await cashBalanceCurrencyCubit.loadCashBalanceCurrency(
      cashBalanceDenominationCubit: cashBalanceDenominationCubit,
      context: context,
      favoriteCurrencyData: favorite?.filter?[FavoriteConstants.currency] != null ? CurrencyData.fromJson(favorite?.filter?[FavoriteConstants.currency]) : null,
        selectedEntity: cashBalanceEntityCubit.state.selectedCashBalanceEntity,
        tileName: tileName);

    String formatedSubGrouping = '';
    String formattedAccounts = '';
    cashBalancePrimarySubGroupingCubit.state.selectedSubGroupingList
        ?.forEach((grp) {
      formatedSubGrouping = formatedSubGrouping + ('${grp?.id},' ?? '');
    });
    cashBalanceAccountCubit.state.selectedAccountsList?.forEach((grp) {
      formattedAccounts = formattedAccounts + ('${grp?.id},' ?? '');
    });

    cashBalanceLoadingCubit.endLoading();


    final Either<AppError, CashBalanceReportEntity> eitherCashBalance =
    await getCashBalanceReport(CashBalanceReportParams(
      context: context,
      entityId: "${cashBalanceEntityCubit.state.selectedCashBalanceEntity?.id}",
      entityName: cashBalanceEntityCubit.state.selectedCashBalanceEntity?.name,
      entityType:
      cashBalanceEntityCubit.state.selectedCashBalanceEntity?.type ==
          "Entity"
          ? "0"
          : "1",
      filter1: "${cashBalancePrimaryGroupingCubit.state.selectedGrouping?.id}",
      filter1name: cashBalancePrimaryGroupingCubit.state.selectedGrouping?.name,
      filter4: formatedSubGrouping,
      filter5: formattedAccounts,
      transactionPeriods: _getFormattedDates(
        selectedEntity: cashBalanceEntityCubit.state.selectedCashBalanceEntity,
        period: cashBalancePeriodCubit.state.selectedCashBalancePeriod,
        numberOfPeriod: cashBalanceNumberOfPeriodCubit
            .state.selectedCashBalanceNumberOfPeriod,
        asOnDate: cashBalanceAsOnDateCubit.state.asOnDate,
      ),
      currencycode:
      cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency?.code,
      currencyid:
      cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency?.id,
      period: cashBalancePeriodCubit.state.selectedCashBalancePeriod?.name,
      numberOfPeriod: cashBalanceNumberOfPeriodCubit
          .state.selectedCashBalanceNumberOfPeriod?.name,
      asOnDate: cashBalanceAsOnDateCubit.state.asOnDate
    ));

    eitherCashBalance.fold((error) {
      emit(CashBalanceReportError(errorType: error.appErrorType));
    }, (cashBalance) {
      if(favoriteCubit != null && universalAsOnDate != null) {
        favoriteCubit.saveFilters(
          context: context,
          shouldUpdate: true,
          isPinned: favorite?.isPined ?? false,
          itemId: favorite?.id.toString(),
          reportName: favorite?.reportname ?? FavoriteConstants.cashBalanceName,
          reportId: FavoriteConstants.cashBalanceId,
          entity: cashBalanceEntityCubit.state.selectedCashBalanceEntity,
          cashBalancePrimaryGrouping: cashBalancePrimaryGroupingCubit.state.selectedGrouping,
          cashBalancePrimarySubGrouping: cashBalancePrimarySubGroupingCubit.state.selectedSubGroupingList,
          cashAccounts: cashBalanceAccountCubit.state.selectedAccountsList,
          numberOfPeriod: cashBalanceNumberOfPeriodCubit.state.selectedCashBalanceNumberOfPeriod,
          period: cashBalancePeriodCubit.state.selectedCashBalancePeriod,
          currency: cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency,
          denomination: cashBalanceDenominationCubit.state.selectedCashBalanceDenomination,
          asOnDate: cashBalanceAsOnDateCubit.state.asOnDate,
        );
      }
      emit(CashBalanceReportLoaded(chartData: cashBalance));
    });
  }

  Future<void> reloadCashBalanceReport({required BuildContext context, required String tileName,FavoritesCubit? favoriteCubit, bool fromBlankWidget = false, bool isFavorite = false, Favorite? favorite}) async {
    emit(const CashBalanceReportLoading());

    if(!isFavorite){
      await saveCashBalanceSelectedEntity(
          tileName,
          Entity.fromJson(
              cashBalanceEntityCubit.state.selectedCashBalanceEntity?.toJson() ??
                  {}));

      await saveCashBalanceSelectedPrimaryGrouping(
          tileName,
          Entity.fromJson(
              cashBalanceEntityCubit.state.selectedCashBalanceEntity?.toJson() ??
                  {}),
          PrimaryGrouping.fromJson(
              cashBalancePrimaryGroupingCubit.state.selectedGrouping?.toJson() ??
                  {}));

      log("$tileName::::::${{
        "entityid": cashBalanceEntityCubit.state.selectedCashBalanceEntity?.id,
        "entitytype":
        cashBalanceEntityCubit.state.selectedCashBalanceEntity?.type,
        "id": cashBalancePrimaryGroupingCubit.state.selectedGrouping?.id
      }}::::${CashBalanceSubGroupingModel(subGrouping: cashBalancePrimarySubGroupingCubit.state.selectedSubGroupingList?.map((element) => SubGroupingItem(id: element?.id, name: element?.name)).toList()).toJson()}::::${cashBalancePrimarySubGroupingCubit.state.selectedSubGroupingList?.length}");
      await saveCashBalanceSelectedPrimarySubGrouping(
          tileName,
          {
            "entityid":
            cashBalanceEntityCubit.state.selectedCashBalanceEntity?.id,
            "entitytype":
            cashBalanceEntityCubit.state.selectedCashBalanceEntity?.type,
            "id": cashBalancePrimaryGroupingCubit.state.selectedGrouping?.id
          },
          CashBalanceSubGroupingModel(
              subGrouping: cashBalancePrimarySubGroupingCubit
                  .state.selectedSubGroupingList
                  ?.map((element) =>
                  SubGroupingItem(id: element?.id, name: element?.name))
                  .toList())
              .toJson());

      await saveCashBalanceSelectedAccounts(
          tileName,
          {
            "entityid":
            cashBalanceEntityCubit.state.selectedCashBalanceEntity?.id,
            "entitytype":
            cashBalanceEntityCubit.state.selectedCashBalanceEntity?.type,
            "id": "6"
          },
          CashBalanceSubGroupingModel(
              subGrouping: cashBalanceAccountCubit.state.selectedAccountsList
                  ?.map((element) =>
                  SubGroupingItem(id: element?.id, name: element?.name))
                  .toList())
              .toJson());

      await saveCashBalanceSelectedPeriod(
          tileName,
          PeriodItem.fromJson(
              cashBalancePeriodCubit.state.selectedCashBalancePeriod?.toJson() ??
                  {}));

      await saveCashBalanceSelectedNumberOfPeriod(
          tileName,
          NumberOfPeriodItem.fromJson(cashBalanceNumberOfPeriodCubit
              .state.selectedCashBalanceNumberOfPeriod
              ?.toJson() ??
              {}));

      await saveCashBalanceSelectedCurrency(
          tileName,
          CurrencyData.fromJson(cashBalanceCurrencyCubit
              .state.selectedCashBalanceCurrency
              ?.toJson() ??
              {}));

      await saveCashBalanceSelectedDenomination(
          tileName,
          DenData.fromJson(cashBalanceDenominationCubit
              .state.selectedCashBalanceDenomination
              ?.toJson() ??
              {}));

      await saveCashBalanceSelectedAsOnDate(
          tileName, cashBalanceAsOnDateCubit.state.asOnDate ?? "");
    }

    if(fromBlankWidget) {
      favoriteCubit?.saveFilters(
        context: context,
        shouldUpdate: true,
        isPinned: favorite?.isPined ?? false,
        itemId: favorite?.id.toString(),
        reportName: favorite?.reportname ?? FavoriteConstants.cashBalanceName,
        reportId: FavoriteConstants.cashBalanceId,
        entity: cashBalanceEntityCubit.state.selectedCashBalanceEntity,
        cashBalancePrimaryGrouping: cashBalancePrimaryGroupingCubit.state.selectedGrouping,
        cashBalancePrimarySubGrouping: cashBalancePrimarySubGroupingCubit.state.selectedSubGroupingList,
        cashAccounts: cashBalanceAccountCubit.state.selectedAccountsList,
        numberOfPeriod: cashBalanceNumberOfPeriodCubit.state.selectedCashBalanceNumberOfPeriod,
        period: cashBalancePeriodCubit.state.selectedCashBalancePeriod,
        currency: cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency,
        denomination: cashBalanceDenominationCubit.state.selectedCashBalanceDenomination,
        asOnDate: cashBalanceAsOnDateCubit.state.asOnDate,
      );
    }

    String formatedSubGrouping = '';
    String formattedAccounts = '';
    cashBalanceAccountCubit.state.selectedAccountsList?.forEach((grp) {
      formattedAccounts = formattedAccounts + ('${grp?.id},' ?? '');
    });
    cashBalancePrimarySubGroupingCubit.state.selectedSubGroupingList
        ?.forEach((grp) {
      formatedSubGrouping = formatedSubGrouping + ('${grp?.id},' ?? '');
    });

    final Either<AppError, CashBalanceReportEntity> eitherCashBalance =
        await getCashBalanceReport(
      CashBalanceReportParams(
        context: context,
        entityId:
            "${cashBalanceEntityCubit.state.selectedCashBalanceEntity?.id}${cashBalanceEntityCubit.state.selectedCashBalanceEntity?.type == "Entity" ? "" : "_EntityGroup"}",
        entityName:
            cashBalanceEntityCubit.state.selectedCashBalanceEntity?.name,
        entityType:
            cashBalanceEntityCubit.state.selectedCashBalanceEntity?.type ==
                    "Entity"
                ? "0"
                : "1",
        filter1:
            "${cashBalancePrimaryGroupingCubit.state.selectedGrouping?.id}",
        filter1name:
            cashBalancePrimaryGroupingCubit.state.selectedGrouping?.name,
        filter4: formatedSubGrouping,
        filter5: formattedAccounts,
        transactionPeriods: _getFormattedDates(
          selectedEntity:
              cashBalanceEntityCubit.state.selectedCashBalanceEntity,
          period: cashBalancePeriodCubit.state.selectedCashBalancePeriod,
          numberOfPeriod: cashBalanceNumberOfPeriodCubit
              .state.selectedCashBalanceNumberOfPeriod,
          asOnDate: cashBalanceAsOnDateCubit.state.asOnDate,
        ),
        currencycode:
            cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency?.code,
        currencyid:
            cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency?.id,
        period: cashBalancePeriodCubit.state.selectedCashBalancePeriod?.name,
        numberOfPeriod: cashBalanceNumberOfPeriodCubit
            .state.selectedCashBalanceNumberOfPeriod?.name,
        asOnDate: cashBalanceAsOnDateCubit.state.asOnDate
      ),
    );

    eitherCashBalance.fold((error) {
      emit(CashBalanceReportError(errorType: error.appErrorType));
    }, (cashBalance) {
      if(isFavorite) {
        favoriteCubit?.saveFilters(
          context: context,
          shouldUpdate: true,
          isPinned: favorite?.isPined ?? false,
          itemId: favorite?.id.toString(),
          reportName: favorite?.reportname ?? FavoriteConstants.cashBalanceName,
          reportId: FavoriteConstants.cashBalanceId,
          entity: cashBalanceEntityCubit.state.selectedCashBalanceEntity,
          cashBalancePrimaryGrouping: cashBalancePrimaryGroupingCubit.state.selectedGrouping,
          cashBalancePrimarySubGrouping: cashBalancePrimarySubGroupingCubit.state.selectedSubGroupingList,
          cashAccounts: cashBalanceAccountCubit.state.selectedAccountsList,
          numberOfPeriod: cashBalanceNumberOfPeriodCubit.state.selectedCashBalanceNumberOfPeriod,
          period: cashBalancePeriodCubit.state.selectedCashBalancePeriod,
          currency: cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency,
          denomination: cashBalanceDenominationCubit.state.selectedCashBalanceDenomination,
          asOnDate: cashBalanceAsOnDateCubit.state.asOnDate,
        );
      }
      emit(CashBalanceReportLoaded(chartData: cashBalance));
    });
  }

  List<String> _getFormattedDates(
      {EntityData? selectedEntity,
      PeriodItemData? period,
      NumberOfPeriodItemData? numberOfPeriod,
      String? asOnDate}) {
    String formattedDates = '';

    formattedDates = '';

    bool isFirstIteration = true;

    List<String> dateList = [];

    DateTime currentDate =
        asOnDate != null ? DateTime.parse(asOnDate) : DateTime.now();
    DateTime firstDate =
        asOnDate != null ? DateTime.parse(asOnDate) : DateTime.now();
    int fiscalYearGap = 0;
    fiscalYearGap = _getFiscalYearGap(selectedEntity);

    for (int i = 0; i < 12 /*(numberOfPeriod?.value ?? 0)*/; i++) {
      if (period?.gaps == 1) {
        final date =
            "${currentDate.year}-${currentDate.month < 10 ? "0${currentDate.month}" : currentDate.month}-${Jiffy(currentDate).daysInMonth < 10 ? "0${Jiffy(currentDate).daysInMonth}" : Jiffy(currentDate).daysInMonth}";

        currentDate = Jiffy(currentDate)
            .subtract(months: isFirstIteration ? 0 : 1)
            .dateTime;
        firstDate = Jiffy(DateTime.parse(date))
            .subtract(months: isFirstIteration ? 0 : 1)
            .dateTime;

        if (isFirstIteration) {
          dateList.add(
              "${firstDate.year}-${firstDate.month < 10 ? "0${firstDate.month}" : firstDate.month}-01_${DateFormat('yyyy-MM-dd').format(Jiffy(currentDate).dateTime)}");
          isFirstIteration = false;
        } else {
          dateList.add(
              "${firstDate.year}-${firstDate.month < 10 ? "0${firstDate.month}" : firstDate.month}-01_${firstDate.year}-${firstDate.month < 10 ? "0${firstDate.month}" : firstDate.month}-${Jiffy(currentDate).daysInMonth}");
        }

        firstDate.subtract(const Duration(days: 1));
      } else if (period?.gaps == 3) {

        final date =
            "${currentDate.year}-${currentDate.month < 10 ? "0${currentDate.month}" : currentDate.month}-${Jiffy(currentDate).daysInMonth < 10 ? "0${Jiffy(currentDate).daysInMonth}" : Jiffy(currentDate).daysInMonth}";
        final days31 =
            Jiffy(Jiffy(DateTime.parse(date)).subtract(months: 1).dateTime)
                    .daysInMonth ==
                31;
        firstDate = Jiffy(DateTime.parse(date))
            .subtract(months: isFirstIteration ? 2 : 3)
            .dateTime;

        currentDate = Jiffy(currentDate)
            .subtract(months: isFirstIteration ? 2 : 3)
            .dateTime;
        dateList.add(
            "${firstDate.year}-${firstDate.month < 10 ? "0${firstDate.month}" : firstDate.month}-01_${isFirstIteration ? DateFormat('yyyy-MM-dd').format((Jiffy(DateTime.parse(date)).subtract(months: 1).dateTime).add(Duration(days: days31 ? currentDate.day + 1 : currentDate.day + 1)))
                : DateFormat('yyyy-MM-${Jiffy(DateTime.parse(date)).subtract(months: 1).daysInMonth}').format(Jiffy(DateTime.parse(date)).subtract(months: 1).dateTime)}");
        firstDate.subtract(const Duration(days: 1));

        isFirstIteration = false;
      } else if (period?.gaps == 12) {
        final date =
            "${currentDate.year}-${currentDate.month < 10 ? "0${currentDate.month}" : currentDate.month}-${Jiffy(currentDate).daysInMonth < 10 ? "0${Jiffy(currentDate).daysInMonth}" : Jiffy(currentDate).daysInMonth}";
        firstDate = Jiffy(DateTime.parse(date))
            .subtract(months: isFirstIteration ? 0 : 12)
            .dateTime;

        currentDate = Jiffy(currentDate)
            .subtract(months: isFirstIteration ? 0 : 12)
            .dateTime;

        if (isFirstIteration) {
          dateList.add(
              "${firstDate.year}-01-01_${DateFormat('yyyy-MM-dd').format(Jiffy(DateTime.parse(asOnDate ?? date)).dateTime)}");
          isFirstIteration = false;
        } else {
          dateList.add("${firstDate.year}-01-01_${firstDate.year}-12-31");
        }

        firstDate.subtract(const Duration(days: 1));
      } else if (period?.gaps == -1) {
        final date =
            "${currentDate.year}-${currentDate.month < 10 ? "0${currentDate.month}" : currentDate.month}-${Jiffy(currentDate).daysInMonth < 10 ? "0${Jiffy(currentDate).daysInMonth}" : Jiffy(currentDate).daysInMonth}";

        firstDate = Jiffy(DateTime.parse(date))
            .subtract(months: fiscalYearGap)
            .dateTime;
        currentDate =
            Jiffy(currentDate).subtract(months: fiscalYearGap).dateTime;

        if (isFirstIteration) {
          dateList.add(
              "${DateFormat('yyyy-MM-01').format(Jiffy(DateTime.parse(asOnDate ?? date)).subtract(months: fiscalYearGap).dateTime)}_${DateFormat('yyyy-MM-dd').format(Jiffy(DateTime.parse(asOnDate ?? date)).dateTime)}");
          isFirstIteration = false;
          fiscalYearGap = 12;
        } else {
          dateList.add(
              "${firstDate.year}-${firstDate.month < 10 ? "0${firstDate.month}" : firstDate.month}-01_${DateFormat('yyyy-MM-${Jiffy(DateTime.parse(date)).subtract(months: 1).daysInMonth}').format(Jiffy(DateTime.parse(date)).subtract(months: 1).dateTime)}");
        }

        firstDate.subtract(const Duration(days: 1));
      }
    }
    return dateList;
  }

  int _getFiscalYearGap(EntityData? selectedEntity) {
    int fiscalYearGap = 0;
    int entityFiscalYearMonth = 0;
    int currentMonth = DateTime.now().month;

    final entityDate = selectedEntity?.accountingyear
        ?.substring(0, selectedEntity.accountingyear?.indexOf('to'))
        .trim();

    switch (entityDate) {
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

    if (currentMonth > entityFiscalYearMonth) {
      fiscalYearGap = currentMonth - entityFiscalYearMonth;
    } else if (currentMonth < entityFiscalYearMonth) {
      fiscalYearGap = 12 - (currentMonth - entityFiscalYearMonth);
    }

    return fiscalYearGap;
  }
}
