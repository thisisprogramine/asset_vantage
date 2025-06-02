import 'dart:developer';

import 'package:asset_vantage/src/data/models/net_worth/net_worth_return_percent_model.dart';
import 'package:asset_vantage/src/data/models/partnership_method/partnership_method_model.dart';
import 'package:asset_vantage/src/domain/entities/partnership_method/holding_method_entities.dart';
import 'package:asset_vantage/src/domain/entities/partnership_method/partnership_method.dart';
import 'package:asset_vantage/src/domain/usecases/net_worth/net_worth_filter/selected_holding_method/save_selected_holding_method.dart';
import 'package:asset_vantage/src/domain/usecases/net_worth/net_worth_filter/selected_as_on_date/save_networth_selected_as_on_date.dart';
import 'package:asset_vantage/src/domain/usecases/net_worth/net_worth_filter/selected_partnership_method/save_networth_selected_partnership_method.dart';
import 'package:asset_vantage/src/domain/usecases/preferences/get_user_preference.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_as_on_date/net_worth_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_currency/net_worth_currency_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_denomination/net_worth_denomination_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_entity/net_worth_entity_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_grouping/net_worth_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_return_percent/net_worth_return_percent_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/networth_holding_method/networth_holding_method_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/networth_partnership_method/networth_partnership_method_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

import '../../../../config/constants/favorite_constants.dart';
import '../../../../data/models/currency/currency_model.dart';
import '../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../data/models/denomination/denomination_model.dart';
import '../../../../data/models/net_worth/net_worth_grouping_model.dart';
import '../../../../data/models/net_worth/net_worth_sub_grouping_model.dart';
import '../../../../data/models/number_of_period/number_of_period_model.dart';
import '../../../../data/models/period/period_model.dart';
import '../../../../data/models/preferences/user_preference.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../../domain/entities/favorites/favorites_entity.dart';
import '../../../../domain/entities/net_worth/net_worth_chart_data.dart';
import '../../../../domain/entities/net_worth/net_worth_entity.dart';
import '../../../../domain/entities/number_of_period/number_of_period.dart';
import '../../../../domain/entities/period/period_enitity.dart';
import '../../../../domain/params/net_worth/net_worth_report_params.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/usecases/net_worth/get_net_worth_report.dart';
import '../../../../domain/usecases/net_worth/net_worth_filter/selected_currency/save_net_worth_selected_currency.dart';
import '../../../../domain/usecases/net_worth/net_worth_filter/selected_denomination/save_net_worth_selected_denomination.dart';
import '../../../../domain/usecases/net_worth/net_worth_filter/selected_entity/save_net_worth_selected_entity.dart';
import '../../../../domain/usecases/net_worth/net_worth_filter/selected_number_of_period/save_net_worth_selected_number_of_period.dart';
import '../../../../domain/usecases/net_worth/net_worth_filter/selected_period/save_net_worth_selected_period.dart';
import '../../../../domain/usecases/net_worth/net_worth_filter/selected_primary_grouping/save_net_worth_selected_primary_grouping.dart';
import '../../../../domain/usecases/net_worth/net_worth_filter/selected_primary_sub_grouping/save_net_worth_selected_sub_groups.dart';
import '../../../../domain/usecases/net_worth/net_worth_filter/selected_return_percent/save_net_worth_selected_return_percent.dart';
import '../../../../utilities/helper/favorite_helper.dart';
import '../../authentication/login_check/login_check_cubit.dart';
import '../../authentication/token/token_cubit.dart';
import '../../favorites/favorites_cubit.dart';
import '../../loading/loading_cubit.dart';
import '../net_worth_loading/net_worth_loading_cubit.dart';
import '../net_worth_number_of_period/net_worth_number_of_period_cubit.dart';
import '../net_worth_period/net_worth_period_cubit.dart';
import '../net_worth_sub_grouping/net_worth_sub_grouping_cubit.dart';

part 'net_worth_report_state.dart';

class NetWorthReportCubit extends Cubit<NetWorthReportState> {
  final NetWorthLoadingCubit netWorthLoadingCubit;
  final LoadingCubit loadingCubit;
  final GetNetWorthReport getNetWorthReport;
  final GetUserPreference userPreference;
  final LoginCheckCubit loginCheckCubit;
  final NetWorthEntityCubit netWorthEntityCubit;
  final NetWorthGroupingCubit netWorthPrimaryGroupingCubit;
  final NetWorthPrimarySubGroupingCubit netWorthPrimarySubGroupingCubit;
  final NetWorthPeriodCubit netWorthPeriodCubit;
  final NetWorthNumberOfPeriodCubit netWorthNumberOfPeriodCubit;
  final NetWorthPartnershipMethodCubit netWorthPartnershipMethodCubit;
  final NetWorthHoldingMethodCubit netWorthHoldingMethodCubit;
  final NetWorthReturnPercentCubit netWorthReturnPercentCubit;
  final NetWorthDenominationCubit netWorthDenominationCubit;
  final NetWorthCurrencyCubit netWorthCurrencyCubit;
  final NetWorthAsOnDateCubit netWorthAsOnDateCubit;

  final SaveNetWorthSelectedEntity saveNetWorthSelectedEntity;
  final SaveNetWorthSelectedPartnershipMethod saveNetWorthSelectedPartnershipMethod;
  final SaveNetWorthSelectedHoldingMethod saveNetWorthSelectedHoldingMethod;
  final SaveNetWorthSelectedPrimaryGrouping saveNetWorthSelectedPrimaryGrouping;
  final SaveNetWorthSelectedPrimarySubGrouping saveNetWorthSelectedPrimarySubGrouping;
  final SaveNetWorthSelectedPeriod saveNetWorthSelectedPeriod;
  final SaveNetWorthSelectedNumberOfPeriod saveNetWorthSelectedNumberOfPeriod;
  final SaveNetWorthSelectedReturnPercent saveNetWorthSelectedReturnPercent;
  final SaveNetWorthSelectedCurrency saveNetWorthSelectedCurrency;
  final SaveNetWorthSelectedDenomination saveNetWorthSelectedDenomination;
  final SaveNetWorthSelectedAsOnDate saveNetWorthSelectedAsOnDate;

  NetWorthReportCubit( {
    required this.netWorthLoadingCubit,
    required this.loadingCubit,
    required this.getNetWorthReport,
    required this.userPreference,
    required this.loginCheckCubit,
    required this.saveNetWorthSelectedPrimaryGrouping,
  required this.saveNetWorthSelectedEntity,
    required this.saveNetWorthSelectedPartnershipMethod,
    required this.netWorthHoldingMethodCubit,
    required this.saveNetWorthSelectedPrimarySubGrouping,
  required this.saveNetWorthSelectedPeriod,
  required this.saveNetWorthSelectedNumberOfPeriod,
  required this.saveNetWorthSelectedReturnPercent,
  required this.saveNetWorthSelectedCurrency,
  required this.saveNetWorthSelectedDenomination,
  required this.saveNetWorthSelectedAsOnDate,
  required this.netWorthNumberOfPeriodCubit,
  required this.netWorthPeriodCubit,
  required this.netWorthReturnPercentCubit,
  required this.netWorthAsOnDateCubit,
  required this.netWorthCurrencyCubit,
  required this.netWorthDenominationCubit,
  required this.netWorthEntityCubit,
  required this.netWorthPrimaryGroupingCubit,
  required this.netWorthPrimarySubGroupingCubit,
  required this.netWorthPartnershipMethodCubit,
  required this.saveNetWorthSelectedHoldingMethod,

  }) : super(NetWorthReportInitial());

  Future<void> loadNetWorthReport({required BuildContext context, required String tileName,
    Entity? universalEntity,
    String? universalAsOnDate,
  }) async {
    context.read<TokenCubit>().checkIfTokenExpired();

    emit(const NetWorthReportLoading());

    final Either<AppError,
        UserPreference> eitherUserPreference = await userPreference(NoParams());

    eitherUserPreference.fold((l) {

    }, (pref) async {
      netWorthLoadingCubit.startLoading();
      await netWorthEntityCubit.loadNetWorthEntity(context: context, favoriteEntity: universalEntity);
      await saveNetWorthSelectedEntity(Entity(
          id: netWorthEntityCubit.state.selectedNetWorthEntity?.id,
          name: netWorthEntityCubit.state.selectedNetWorthEntity?.name,
          type: netWorthEntityCubit.state.selectedNetWorthEntity?.type,
          currency: netWorthEntityCubit.state.selectedNetWorthEntity?.currency,
          accountingyear: netWorthEntityCubit.state.selectedNetWorthEntity
              ?.accountingyear
      ));

      await netWorthAsOnDateCubit.changeAsOnDate(asOnDate: universalAsOnDate);
      await saveNetWorthSelectedAsOnDate(
          netWorthAsOnDateCubit.state.asOnDate ?? "");

      await netWorthPartnershipMethodCubit.loadNetWorthPartnershipMethod(
          context: context, tileName: tileName);

      await netWorthHoldingMethodCubit.loadNetWorthHoldingMethod(
          context: context, tileName: tileName);

      await netWorthPrimaryGroupingCubit.loadNetWorthPrimaryGrouping(
          context: context,
          selectedEntity: netWorthEntityCubit.state.selectedNetWorthEntity,
          asOnDate: netWorthAsOnDateCubit.state.asOnDate
      );
      await netWorthPrimarySubGroupingCubit.loadNetWorthPrimarySubGrouping(
          context: context,
          selectedEntity: netWorthEntityCubit.state.selectedNetWorthEntity,
          selectedGrouping: netWorthPrimaryGroupingCubit.state.selectedGrouping,
          asOnDate: netWorthAsOnDateCubit.state.asOnDate,
          selectedPartnershipMethod: netWorthPartnershipMethodCubit.state.selectedNetWorthPartnershipMethod,
          selectedHoldingMethod: netWorthHoldingMethodCubit.state.selectedNetworthHoldingMethod
      );
      await netWorthPeriodCubit.loadNetWorthPeriod(tileName: tileName, context: context);
      await netWorthNumberOfPeriodCubit.loadNetWorthNumberOfPeriod(
          context: context,
          tileName: tileName);
      await netWorthReturnPercentCubit.loadNetWorthReturnPercent(context: context);
      await netWorthDenominationCubit.loadNetWorthDenomination(context: context);
      await netWorthCurrencyCubit.loadNetWorthCurrency(
          netWorthDenominationCubit: netWorthDenominationCubit,
          context: context,
          selectedEntity: netWorthEntityCubit.state.selectedNetWorthEntity);
      netWorthLoadingCubit.endLoading();

      String formatedSubGrouping = '';

      netWorthPrimarySubGroupingCubit.state.selectedSubGroupingList?.forEach((
          grp) {
        formatedSubGrouping = formatedSubGrouping + ('${grp?.id},' ?? '');
      });

      eitherUserPreference.fold((l) {}, (pref) async {
        final Either<AppError, NetWorthReportEntity> eitherNetWorth =
        await getNetWorthReport(NetWorthReportParams(
          context: context,
          entityId:
          "${netWorthEntityCubit.state.selectedNetWorthEntity
              ?.id}${netWorthEntityCubit.state.selectedNetWorthEntity?.type ==
              "Entity" ? "" : "_EntityGroup"}",
          entityName: netWorthEntityCubit.state.selectedNetWorthEntity?.name,
          entityType: netWorthEntityCubit.state.selectedNetWorthEntity?.type ==
              "Entity" ? "0" : "1",
          partnershipMethod: netWorthPartnershipMethodCubit.state.selectedNetWorthPartnershipMethod?.name,
          holdingMethod: netWorthHoldingMethodCubit.state.selectedNetworthHoldingMethod?.value,
          filter1: "${netWorthPrimaryGroupingCubit.state.selectedGrouping?.id}",
          filter1name: netWorthPrimaryGroupingCubit.state.selectedGrouping
              ?.name,
          filter4: formatedSubGrouping,
          columnList: netWorthReturnPercentCubit.state
              .selectedNetWorthReturnPercent?.id,
          transactionPeriods: _getFormattedDates(
              selectedEntity: netWorthEntityCubit.state.selectedNetWorthEntity,
              period: netWorthPeriodCubit.state.selectedNetWorthPeriod,
              numberOfPeriod: netWorthNumberOfPeriodCubit.state
                  .selectedNetWorthNumberOfPeriod,
              asOnDate: netWorthAsOnDateCubit.state.asOnDate),
          currencycode: netWorthCurrencyCubit.state.selectedNetWorthCurrency
              ?.code,
          currencyid: netWorthCurrencyCubit.state.selectedNetWorthCurrency?.id,
          period: netWorthPeriodCubit.state.selectedNetWorthPeriod?.name,
          numberOfPeriod: netWorthNumberOfPeriodCubit.state
              .selectedNetWorthNumberOfPeriod?.name,
        ));

        eitherNetWorth.fold((error) {

          emit(NetWorthReportError(errorType: error.appErrorType));
        }, (netWorth) {
          emit(NetWorthReportLoaded(chartData: netWorth.report));
        });
      });
    });
  }

  Future<void> loadNetWorthReportForFavorites({required BuildContext context, FavoritesCubit? favoriteCubit, required String tileName,required Favorite? favorite, String? universalAsOnDate}) async{

    emit(const NetWorthReportLoading());

    final Either<AppError, UserPreference> eitherUserPreference = await userPreference(NoParams());

    eitherUserPreference.fold((l) {

    }, (pref) async {
      netWorthLoadingCubit.startLoading();
      await netWorthEntityCubit.loadNetWorthEntity(context: context, favoriteEntity: favorite?.filter?[FavoriteConstants.entityFilter] != null ? Entity.fromJson(favorite?.filter?[FavoriteConstants.entityFilter]) : null);
      await netWorthAsOnDateCubit.changeAsOnDate(asOnDate: universalAsOnDate ?? favorite?.filter?[FavoriteConstants.asOnDate]);
      await netWorthPartnershipMethodCubit.loadNetWorthPartnershipMethod(
        favoritePartnershipMethodItemData: favorite?.filter?[FavoriteConstants.partnershipMethod] !=null ? PartnershipMethodItem.fromJson(favorite?.filter?[FavoriteConstants.partnershipMethod]) : null,
          context: context,
          tileName: tileName);
      netWorthHoldingMethodCubit.loadNetWorthHoldingMethod(
          context: context, tileName: tileName);
      await netWorthPrimaryGroupingCubit.loadNetWorthPrimaryGrouping(
          context: context,
          favoritePrimaryGrouping: favorite?.filter?[FavoriteConstants.primaryGrouping] != null ? PrimaryGrouping.fromJson(favorite?.filter?[FavoriteConstants.primaryGrouping]) : null,
          selectedEntity: netWorthEntityCubit.state.selectedNetWorthEntity,
          asOnDate: netWorthAsOnDateCubit.state.asOnDate
      );
      await netWorthReturnPercentCubit.loadNetWorthReturnPercent(context: context, favoriteReturnPercentItem: ((favorite?.filter?[FavoriteConstants.returnPercent] != null ? FavoriteHelper.getReturnPercentForNerWorth(favorite?.filter?[FavoriteConstants.returnPercent]) : null)?.isNotEmpty) ?? false ? (FavoriteHelper.getReturnPercentForNerWorth(favorite?.filter?[FavoriteConstants.returnPercent])?[0]) : null);
      await netWorthDenominationCubit.loadNetWorthDenomination(context: context, favoriteDenData: favorite?.filter?[FavoriteConstants.denomination] != null ? DenData.fromJson(favorite?.filter?[FavoriteConstants.denomination]) : null);
      await netWorthCurrencyCubit.loadNetWorthCurrency(context: context, netWorthDenominationCubit: netWorthDenominationCubit, favoriteCurrency: favorite?.filter?[FavoriteConstants.currency] != null ? CurrencyData.fromJson(favorite?.filter?[FavoriteConstants.currency]) : null, selectedEntity: netWorthEntityCubit.state.selectedNetWorthEntity);
      await netWorthPeriodCubit.loadNetWorthPeriod(favoritePeriod: favorite?.filter?[FavoriteConstants.period] != null ? PeriodItem.fromJson(favorite?.filter?[FavoriteConstants.period]) : null, tileName: tileName, context: context);
      await netWorthNumberOfPeriodCubit.loadNetWorthNumberOfPeriod(
          favoriteNumberOfPeriodItemData: favorite?.filter?[FavoriteConstants.numberOfPeriod] != null ? NumberOfPeriodItem.fromJson(favorite?.filter?[FavoriteConstants.numberOfPeriod]) : null,
          context: context,
          tileName: tileName);
      
      await netWorthPrimarySubGroupingCubit.loadNetWorthPrimarySubGrouping(
        context: context,
          favoriteSubGroupingItem: favorite?.filter?[FavoriteConstants.primarySubGrouping] != null ? FavoriteHelper.getPrimarySubGroupingForNetWorth(favorite?.filter?[FavoriteConstants.primarySubGrouping]) : null,
          selectedEntity: netWorthEntityCubit.state.selectedNetWorthEntity,
          selectedGrouping: netWorthPrimaryGroupingCubit.state.selectedGrouping,
          asOnDate: netWorthAsOnDateCubit.state.asOnDate,
        selectedPartnershipMethod: netWorthPartnershipMethodCubit.state.selectedNetWorthPartnershipMethod,
        selectedHoldingMethod: netWorthHoldingMethodCubit.state.selectedNetworthHoldingMethod,

      );

      print('Selected Partnership Method: ${netWorthPartnershipMethodCubit.state.selectedNetWorthPartnershipMethod}');
      print('Selected Holding Method: ${netWorthHoldingMethodCubit.state.selectedNetworthHoldingMethod}');


      netWorthLoadingCubit.endLoading();

      String formatedSubGrouping = '';

      netWorthPrimarySubGroupingCubit.state.selectedSubGroupingList?.forEach((
          grp) {
        formatedSubGrouping = formatedSubGrouping + ('${grp?.id},' ?? '');
      });

      eitherUserPreference.fold((l) {}, (pref) async {
        final Either<AppError, NetWorthReportEntity> eitherNetWorth =
        await getNetWorthReport(NetWorthReportParams(
          context: context,
          entityId:
          "${netWorthEntityCubit.state.selectedNetWorthEntity
              ?.id}${netWorthEntityCubit.state.selectedNetWorthEntity?.type ==
              "Entity" ? "" : "_EntityGroup"}",
          entityName: netWorthEntityCubit.state.selectedNetWorthEntity?.name,
          entityType: netWorthEntityCubit.state.selectedNetWorthEntity?.type ==
              "Entity" ? "0" : "1",
          partnershipMethod: netWorthPartnershipMethodCubit.state.selectedNetWorthPartnershipMethod?.name,
          holdingMethod: netWorthHoldingMethodCubit.state.selectedNetworthHoldingMethod?.value,
          filter1: "${netWorthPrimaryGroupingCubit.state.selectedGrouping?.id}",
          filter1name: netWorthPrimaryGroupingCubit.state.selectedGrouping
              ?.name,
          filter4: formatedSubGrouping,
          columnList: netWorthReturnPercentCubit.state
              .selectedNetWorthReturnPercent?.id,
          transactionPeriods: _getFormattedDates(
              selectedEntity: netWorthEntityCubit.state.selectedNetWorthEntity,
              period: netWorthPeriodCubit.state.selectedNetWorthPeriod,
              numberOfPeriod: netWorthNumberOfPeriodCubit.state
                  .selectedNetWorthNumberOfPeriod,
              asOnDate: netWorthAsOnDateCubit.state.asOnDate),
          currencycode: netWorthCurrencyCubit.state.selectedNetWorthCurrency
              ?.code,
          currencyid: netWorthCurrencyCubit.state.selectedNetWorthCurrency?.id,
          period: netWorthPeriodCubit.state.selectedNetWorthPeriod?.name,
          numberOfPeriod: netWorthNumberOfPeriodCubit.state
              .selectedNetWorthNumberOfPeriod?.name,
        ));

        eitherNetWorth.fold((error) {
        if(error.appErrorType==AppErrorType.unauthorised){
          loginCheckCubit.loginCheck();
        }
        emit(NetWorthReportError(errorType: error.appErrorType));
      }, (netWorth) {
          if(favoriteCubit != null && universalAsOnDate != null) {
            favoriteCubit.saveFilters(
                context: context,
                shouldUpdate: true,
                isPinned: favorite?.isPined ?? false,
                itemId: favorite?.id.toString(),
                reportId: FavoriteConstants.netWorthId,
                reportName: favorite?.reportname ??  FavoriteConstants.netWorthName,
                entity: netWorthEntityCubit.state.selectedNetWorthEntity,
                partnershipMethod:netWorthPartnershipMethodCubit.state.selectedNetWorthPartnershipMethod ,
                holdingMethodPerformance: netWorthHoldingMethodCubit.state.selectedNetworthHoldingMethod,
                //holdingMethod: netWorthHoldingMethodCubit.state.selectedNetworthHoldingMethod,
                netWorthPrimaryGrouping: netWorthPrimaryGroupingCubit.state.selectedGrouping,
                netWorthPrimarySubGrouping: netWorthPrimarySubGroupingCubit.state.selectedSubGroupingList,
                period: netWorthPeriodCubit.state.selectedNetWorthPeriod,
                numberOfPeriod: netWorthNumberOfPeriodCubit.state.selectedNetWorthNumberOfPeriod,
                netWorthReturnPercent: [netWorthReturnPercentCubit.state.selectedNetWorthReturnPercent],
                currency: netWorthCurrencyCubit.state.selectedNetWorthCurrency,
                denomination: netWorthDenominationCubit.state.selectedNetWorthDenomination,
                asOnDate: netWorthAsOnDateCubit.state.asOnDate
            );
          }
        emit(NetWorthReportLoaded(chartData: netWorth.report));
      });
    });

  });
    }

  Future<void> reloadNetWorthReport({
    required BuildContext context,
    FavoritesCubit? favoriteCubit,
    bool isFavorite = false,
    bool fromBlankWidget = false,
    Favorite? favorite}) async {
    emit(const NetWorthReportLoading());


    if (!isFavorite) {
      await saveNetWorthSelectedEntity(Entity(
          id: netWorthEntityCubit.state.selectedNetWorthEntity?.id,
          name: netWorthEntityCubit.state.selectedNetWorthEntity?.name,
          type: netWorthEntityCubit.state.selectedNetWorthEntity?.type,
          currency: netWorthEntityCubit.state.selectedNetWorthEntity?.currency,
          accountingyear: netWorthEntityCubit.state.selectedNetWorthEntity
              ?.accountingyear
      ));

      await saveNetWorthSelectedPartnershipMethod(
        "NetWorth",PartnershipMethodItemData(
        id: netWorthPartnershipMethodCubit.state.selectedNetWorthPartnershipMethod?.id,
        name: netWorthPartnershipMethodCubit.state.selectedNetWorthPartnershipMethod?.name,
      ));
      //holding save remaining
      //Map<String,String>? selectedHoldingMethod= netWorthHoldingMethodCubit.state.selectedNetworthHoldingMethod;
       await saveNetWorthSelectedHoldingMethod(
         "NetWorth",HoldingMethodItemData(
         id: netWorthHoldingMethodCubit.state.selectedNetworthHoldingMethod?.id
       )
       );

      await saveNetWorthSelectedPrimaryGrouping(PrimaryGrouping(
          id: netWorthPrimaryGroupingCubit.state.selectedGrouping?.id,
          name: netWorthPrimaryGroupingCubit.state.selectedGrouping?.name
      ));

      await saveNetWorthSelectedPrimarySubGrouping(
          {
            "entityid": netWorthEntityCubit.state.selectedNetWorthEntity?.id,
            "entitytype": netWorthEntityCubit.state.selectedNetWorthEntity
                ?.type,
            "id": netWorthPrimaryGroupingCubit.state.selectedGrouping?.id
          },
          NetWorthSubGroupingModel(
              subGrouping: netWorthPrimarySubGroupingCubit.state
                  .selectedSubGroupingList?.map((element) =>
                  SubGroupingItem(
                      id: element?.id,
                      name: element?.name
                  )
              ).toList()).toJson()
      );

      await saveNetWorthSelectedPeriod("NetWorth", PeriodItemData(
          id: netWorthPeriodCubit.state.selectedNetWorthPeriod?.id,
          name: netWorthPeriodCubit.state.selectedNetWorthPeriod?.name
      ));

      await saveNetWorthSelectedNumberOfPeriod(
          "NetWorth", NumberOfPeriodItemData(
          id: netWorthNumberOfPeriodCubit.state.selectedNetWorthNumberOfPeriod
              ?.id,
          name: netWorthNumberOfPeriodCubit.state.selectedNetWorthNumberOfPeriod
              ?.name
      ));

      await saveNetWorthSelectedReturnPercent(ReturnPercentItem(
        id: netWorthReturnPercentCubit.state.selectedNetWorthReturnPercent?.id,
        value: netWorthReturnPercentCubit.state.selectedNetWorthReturnPercent
            ?.value,
        name: netWorthReturnPercentCubit.state.selectedNetWorthReturnPercent
            ?.name,
      ).toJson());

      await saveNetWorthSelectedCurrency(CurrencyData(
          id: netWorthCurrencyCubit.state.selectedNetWorthCurrency?.id,
          code: netWorthCurrencyCubit.state.selectedNetWorthCurrency?.code,
          format: netWorthCurrencyCubit.state.selectedNetWorthCurrency?.format
      ));

      await saveNetWorthSelectedDenomination(DenData(
        id: netWorthDenominationCubit.state.selectedNetWorthDenomination?.id,
        key: netWorthDenominationCubit.state.selectedNetWorthDenomination?.key,
        title: netWorthDenominationCubit.state.selectedNetWorthDenomination
            ?.title,
        suffix: netWorthDenominationCubit.state.selectedNetWorthDenomination
            ?.suffix,
        denomination: netWorthDenominationCubit.state
            .selectedNetWorthDenomination?.denomination,
      ));

      await saveNetWorthSelectedAsOnDate(
          netWorthAsOnDateCubit.state.asOnDate ?? "");
    }

    if(fromBlankWidget) {
      favoriteCubit?.saveFilters(
          context: context,
          shouldUpdate: true,
          isPinned: favorite?.isPined ?? false,
          itemId: favorite?.id.toString(),
          reportId: FavoriteConstants.netWorthId,
          reportName: favorite?.reportname ??  FavoriteConstants.netWorthName,
          entity: netWorthEntityCubit.state.selectedNetWorthEntity,
          partnershipMethod: netWorthPartnershipMethodCubit.state.selectedNetWorthPartnershipMethod,
          holdingMethodPerformance: netWorthHoldingMethodCubit.state.selectedNetworthHoldingMethod,
          netWorthPrimaryGrouping: netWorthPrimaryGroupingCubit.state.selectedGrouping,
          netWorthPrimarySubGrouping: netWorthPrimarySubGroupingCubit.state.selectedSubGroupingList,
          period: netWorthPeriodCubit.state.selectedNetWorthPeriod,
          numberOfPeriod: netWorthNumberOfPeriodCubit.state.selectedNetWorthNumberOfPeriod,
          netWorthReturnPercent: [netWorthReturnPercentCubit.state.selectedNetWorthReturnPercent],
          currency: netWorthCurrencyCubit.state.selectedNetWorthCurrency,
          denomination: netWorthDenominationCubit.state.selectedNetWorthDenomination,
          asOnDate: netWorthAsOnDateCubit.state.asOnDate
      );
    }

    final Either<AppError,
        UserPreference> eitherUserPreference = await userPreference(NoParams());

    eitherUserPreference.fold((l) {

    }, (pref) async {
      String formatedSubGrouping = '';

      netWorthPrimarySubGroupingCubit.state.selectedSubGroupingList?.forEach((
          grp) {
        formatedSubGrouping = formatedSubGrouping + ('${grp?.id},' ?? '');
      });

      eitherUserPreference.fold((l) {}, (pref) async {
        final Either<AppError, NetWorthReportEntity> eitherNetWorth =
        await getNetWorthReport(NetWorthReportParams(
          context: context,
          entityId:
          "${netWorthEntityCubit.state.selectedNetWorthEntity
              ?.id}${netWorthEntityCubit.state.selectedNetWorthEntity?.type ==
              "Entity" ? "" : "_EntityGroup"}",
          entityName: netWorthEntityCubit.state.selectedNetWorthEntity?.name,
          entityType: netWorthEntityCubit.state.selectedNetWorthEntity?.type ==
              "Entity" ? "0" : "1",
          filter1: "${netWorthPrimaryGroupingCubit.state.selectedGrouping?.id}",
          filter1name: netWorthPrimaryGroupingCubit.state.selectedGrouping
              ?.name,
          filter4: formatedSubGrouping,
          partnershipMethod: netWorthPartnershipMethodCubit.state.selectedNetWorthPartnershipMethod?.name,
          holdingMethod: netWorthHoldingMethodCubit.state.selectedNetworthHoldingMethod?.value,
          columnList: netWorthReturnPercentCubit.state
              .selectedNetWorthReturnPercent?.id,
          transactionPeriods: _getFormattedDates(
              selectedEntity: netWorthEntityCubit.state.selectedNetWorthEntity,
              period: netWorthPeriodCubit.state.selectedNetWorthPeriod,
              numberOfPeriod: netWorthNumberOfPeriodCubit.state
                  .selectedNetWorthNumberOfPeriod,
              asOnDate: netWorthAsOnDateCubit.state.asOnDate),
          currencycode: netWorthCurrencyCubit.state.selectedNetWorthCurrency
              ?.code,
          currencyid: netWorthCurrencyCubit.state.selectedNetWorthCurrency?.id,
          period: netWorthPeriodCubit.state.selectedNetWorthPeriod?.name,
          numberOfPeriod: netWorthNumberOfPeriodCubit.state
              .selectedNetWorthNumberOfPeriod?.name,
        ));


        eitherNetWorth.fold((error) {

          emit(NetWorthReportError(errorType: error.appErrorType));
        }, (netWorth) {
          if(isFavorite) {
            favoriteCubit?.saveFilters(
              context: context,
                shouldUpdate: true,
                isPinned: favorite?.isPined ?? false,
                itemId: favorite?.id.toString(),
                reportId: FavoriteConstants.netWorthId,
                reportName: favorite?.reportname ??  FavoriteConstants.netWorthName,
                entity: netWorthEntityCubit.state.selectedNetWorthEntity,
                partnershipMethod: netWorthPartnershipMethodCubit.state.selectedNetWorthPartnershipMethod,
                holdingMethodPerformance: netWorthHoldingMethodCubit.state.selectedNetworthHoldingMethod,
                netWorthPrimaryGrouping: netWorthPrimaryGroupingCubit.state.selectedGrouping,
                netWorthPrimarySubGrouping: netWorthPrimarySubGroupingCubit.state.selectedSubGroupingList,
                period: netWorthPeriodCubit.state.selectedNetWorthPeriod,
                numberOfPeriod: netWorthNumberOfPeriodCubit.state.selectedNetWorthNumberOfPeriod,
                netWorthReturnPercent: [netWorthReturnPercentCubit.state.selectedNetWorthReturnPercent],
                currency: netWorthCurrencyCubit.state.selectedNetWorthCurrency,
                denomination: netWorthDenominationCubit.state.selectedNetWorthDenomination,
                asOnDate: netWorthAsOnDateCubit.state.asOnDate
            );
          }

          emit(NetWorthReportLoaded(chartData: netWorth.report));
        });
      });
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
    log("entity accounting year::${selectedEntity?.accountingyear}");
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
