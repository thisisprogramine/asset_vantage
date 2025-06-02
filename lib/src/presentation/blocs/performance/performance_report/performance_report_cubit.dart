

import 'package:asset_vantage/src/data/models/partnership_method/holding_method_model.dart';
import 'package:asset_vantage/src/domain/entities/currency/currency_entity.dart';
import 'package:asset_vantage/src/domain/entities/dashboard/dashboard_list_entity.dart';
import 'package:asset_vantage/src/domain/entities/partnership_method/holding_method_entities.dart';
import 'package:asset_vantage/src/domain/entities/partnership_method/partnership_method.dart';
import 'package:asset_vantage/src/domain/params/performance/performance_report_params.dart';
import 'package:asset_vantage/src/domain/usecases/performance/performance_filter/selected_partnership_method/save_performance_selected_partnership_method.dart';
import 'package:asset_vantage/src/domain/usecases/preferences/get_user_preference.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_as_on_date/performance_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_denomination/performance_denomination_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_holding_method/performance_holding_method_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_partnership_method/performance_partnership_method_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_primary_sub_grouping/performance_primary_sub_grouping_cubit.dart';
import 'package:asset_vantage/src/utilities/helper/favorite_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/constants/favorite_constants.dart';
import '../../../../data/models/currency/currency_model.dart';
import '../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../data/models/denomination/denomination_model.dart';
import '../../../../data/models/partnership_method/partnership_method_model.dart';
import '../../../../data/models/performance/performance_primary_grouping_model.dart';
import '../../../../data/models/performance/performance_primary_sub_grouping_model.dart' as primary;
import '../../../../data/models/performance/performance_primary_sub_grouping_model.dart';
import '../../../../data/models/performance/performance_secondary_grouping_model.dart';
import '../../../../data/models/performance/performance_secondary_sub_grouping_model.dart' as secondary;
import '../../../../data/models/performance/performance_secondary_sub_grouping_model.dart';
import '../../../../data/models/preferences/user_preference.dart';
import '../../../../data/models/return_percentage/return_percentage_model.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/favorites/favorites_entity.dart';
import '../../../../domain/entities/performance/performance_primary_grouping_entity.dart';
import '../../../../domain/entities/performance/performance_report_entity.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/usecases/performance/get_performance_report.dart';
import '../../../../domain/usecases/performance/performance_filter/selected_currency/save_performance_selected_currency.dart';
import '../../../../domain/usecases/performance/performance_filter/selected_denomination/save_performance_selected_denomination.dart';
import '../../../../domain/usecases/performance/performance_filter/selected_entity/save_performance_selected_entity.dart';
import '../../../../domain/usecases/performance/performance_filter/selected_holding_method/save_performance_selected_holding_method.dart';
import '../../../../domain/usecases/performance/performance_filter/selected_primary_grouping/save_performance_selected_primary_grouping.dart';
import '../../../../domain/usecases/performance/performance_filter/selected_primary_sub_grouping/save_performance_selected_primary_sub_grouping.dart';
import '../../../../domain/usecases/performance/performance_filter/selected_return_percent/save_performance_selected_return_percent.dart';
import '../../../../domain/usecases/performance/performance_filter/selected_secondary_grouping/save_performance_selected_secondary_grouping.dart';
import '../../../../domain/usecases/performance/performance_filter/selected_secondary_sub_grouping/save_performance_selected_secondary_sub_grouping.dart';
import '../../authentication/login_check/login_check_cubit.dart';
import '../../favorites/favorites_cubit.dart';
import '../../loading/loading_cubit.dart';
import '../performance_currency/performance_currency_cubit.dart';
import '../performance_entity/performance_entity_cubit.dart';
import '../performance_loading/performance_loading_cubit.dart';
import '../performance_number_of_period/performance_number_of_period_cubit.dart';
import '../performance_period/performance_period_cubit.dart';
import '../performance_primary_grouping/performance_primary_grouping_cubit.dart';
import '../performance_return_percent/performance_return_percent_cubit.dart';
import '../performance_secondary_grouping/performance_secondary_grouping_cubit.dart';
import '../performance_secondary_sub_grouping/performance_secondary_sub_grouping_cubit.dart';
import '../performance_sort_cubit/performance_sort_cubit.dart';

part 'performance_report_state.dart';

class PerformanceReportCubit extends Cubit<PerformanceReportState> {
  final LoadingCubit loadingCubit;
  final PerformanceSortCubit performanceSortCubit;
  final PerformanceEntityCubit performanceEntityCubit;
  final GetPerformanceReport getPerformanceReport;
  final GetUserPreference userPreference;
  final LoginCheckCubit loginCheckCubit;
  final PerformancePrimaryGroupingCubit performancePrimaryGroupingCubit;
  final PerformancePartnershipMethodCubit performancePartnershipMethodCubit;
  final PerformanceHoldingMethodCubit performanceHoldingMethodCubit;
  final PerformancePrimarySubGroupingCubit performancePrimarySubGroupingCubit;
  final PerformanceSecondaryGroupingCubit performanceSecondaryGroupingCubit;
  final PerformanceSecondarySubGroupingCubit performanceSecondarySubGroupingCubit;
  final PerformancePeriodCubit performancePeriodCubit;
  final PerformanceNumberOfPeriodCubit performanceNumberOfPeriodCubit;
  final PerformanceReturnPercentCubit performanceReturnPercentCubit;
  final PerformanceDenominationCubit performanceDenominationCubit;
  final PerformanceCurrencyCubit performanceCurrencyCubit;
  final PerformanceAsOnDateCubit performanceAsOnDateCubit;
  final PerformanceLoadingCubit performanceLoadingCubit;

  final SavePerformanceSelectedEntity savePerformanceSelectedEntity;
  final SavePerformanceSelectedPartnershipMethod savePerformanceSelectedPartnershipMethod;
  final SavePerformanceSelectedHoldingMethod savePerformanceSelectedHoldingMethod;
  final SavePerformanceSelectedPrimaryGrouping savePerformanceSelectedPrimaryGrouping;
  final SavePerformanceSelectedPrimarySubGrouping savePerformanceSelectedPrimarySubGrouping;
  final SavePerformanceSelectedSecondaryGrouping savePerformanceSelectedSecondaryGrouping;
  final SavePerformanceSelectedSecondarySubGrouping savePerformanceSelectedSecondarySubGrouping;
  final SavePerformanceSelectedReturnPercent savePerformanceSelectedReturnPercent;
  final SavePerformanceSelectedCurrency savePerformanceSelectedCurrency;
  final SavePerformanceSelectedDenomination savePerformanceSelectedDenomination;



  PerformanceReportCubit(   {
    required this.loadingCubit,
    required this.performanceSortCubit,
    required this.performanceEntityCubit,
    required this.getPerformanceReport,
    required this.userPreference,
    required this.loginCheckCubit,
    required this.performancePrimaryGroupingCubit,
    required this.performancePrimarySubGroupingCubit,
    required this.performanceSecondaryGroupingCubit,
    required this.performanceSecondarySubGroupingCubit,
    required this.performancePeriodCubit,
    required this.performanceNumberOfPeriodCubit,
    required this.performanceReturnPercentCubit,
    required this.performanceDenominationCubit,
    required this.performanceCurrencyCubit,
    required this.performanceAsOnDateCubit,
    required this.performanceLoadingCubit,
    required this.performancePartnershipMethodCubit,
    required this.performanceHoldingMethodCubit,


    required this.savePerformanceSelectedEntity,
    required this.savePerformanceSelectedHoldingMethod,
    required this.savePerformanceSelectedPrimaryGrouping,
    required this.savePerformanceSelectedPrimarySubGrouping,
    required this.savePerformanceSelectedSecondaryGrouping,
    required this.savePerformanceSelectedSecondarySubGrouping,
    required this.savePerformanceSelectedReturnPercent,
    required this.savePerformanceSelectedCurrency,
    required this.savePerformanceSelectedDenomination,
    required this.savePerformanceSelectedPartnershipMethod,

  }) : super(PerformanceReportInitial());

  Future<void> loadPerformanceReport({required BuildContext context,
    required String tileName,
    Entity? universalEntity,
    String? universalAsOnDate,
  }) async{

    emit(const PerformanceReportLoading());

    final Either<AppError, UserPreference> eitherUserPreference = await userPreference(NoParams());

    eitherUserPreference.fold((l) {

    }, (pref) async {
      performanceLoadingCubit.startLoading();
      await performancePeriodCubit.loadPerformancePeriod(context: context);
      await performanceNumberOfPeriodCubit.loadPerformanceNumberOfPeriod(context: context);
      await performanceReturnPercentCubit.loadPerformanceReturnPercent(context: context);
      await performanceDenominationCubit.loadPerformanceDenomination(context: context);
      await performanceEntityCubit.loadPerformanceEntity(context: context, favoriteEntity: universalEntity);
      await savePerformanceSelectedEntity(Entity(
          id: performanceEntityCubit.state.selectedPerformanceEntity?.id,
          name: performanceEntityCubit.state.selectedPerformanceEntity?.name,
          type: performanceEntityCubit.state.selectedPerformanceEntity?.type,
          currency: performanceEntityCubit.state.selectedPerformanceEntity?.currency,
          accountingyear: performanceEntityCubit.state.selectedPerformanceEntity?.accountingyear
      ));
      await performanceAsOnDateCubit.changeAsOnDate(asOnDate: universalAsOnDate);

      await performancePartnershipMethodCubit.loadPerformancePartnershipMethod(
          context: context, tileName: tileName);

      await performanceHoldingMethodCubit.loadPerformanceHoldingMethod(
          context: context, tileName: tileName);

      await performancePrimaryGroupingCubit.loadPerformancePrimaryGrouping(
        context: context,
          selectedEntity: performanceEntityCubit.state.selectedPerformanceEntity,
        asOnDate: performanceAsOnDateCubit.state.asOnDate
      );
      await performancePrimarySubGroupingCubit.loadPerformancePrimarySubGrouping(
        context: context,
          selectedEntity: performanceEntityCubit.state.selectedPerformanceEntity,
          selectedGrouping: performancePrimaryGroupingCubit.state.selectedGrouping,
          asOnDate: performanceAsOnDateCubit.state.asOnDate,
          selectedPartnershipMethod: performancePartnershipMethodCubit.state.selectedPerformancePartnershipMethod,
        selectedHoldingMethod: performanceHoldingMethodCubit.state.selectedPerformanceHoldingMethod
      );
      await performanceSecondaryGroupingCubit.loadPerformanceSecondaryGrouping(
        context: context,
          selectedEntity: performanceEntityCubit.state.selectedPerformanceEntity,
        asOnDate: performanceAsOnDateCubit.state.asOnDate
      );
      await performanceSecondarySubGroupingCubit.loadPerformanceSecondarySubGrouping(
        context: context,
          selectedEntity: performanceEntityCubit.state.selectedPerformanceEntity,
          primarySubGroupingItem: performancePrimarySubGroupingCubit.state.selectedSubGroupingList,
          selectedGrouping: performanceSecondaryGroupingCubit.state.selectedGrouping,
          asOnDate: performanceAsOnDateCubit.state.asOnDate
      );
      await performanceCurrencyCubit.loadPerformanceCurrency(context: context, performanceDenominationCubit: performanceDenominationCubit, selectedEntity: performanceEntityCubit.state.selectedPerformanceEntity);
      performanceLoadingCubit.endLoading();

      final Either<AppError, PerformanceReportEntity> eitherPerformance = await getPerformanceReport(
          PerformanceReportParams(
            context: context,
            entity: performanceEntityCubit.state.selectedPerformanceEntity,
            primaryGrouping: performancePrimaryGroupingCubit.state.selectedGrouping,
            secondaryGrouping: performanceSecondaryGroupingCubit.state.selectedGrouping,
            primarySubGrouping: performancePrimarySubGroupingCubit.state.selectedSubGroupingList,
            secondarySubGrouping: performanceSecondarySubGroupingCubit.state.selectedSubGroupingList,
            partnershipMethod: performancePartnershipMethodCubit.state.selectedPerformancePartnershipMethod?.name,
            holdingMethod: performanceHoldingMethodCubit.state.selectedPerformanceHoldingMethod?.value,
            returnPercentItemData: performanceReturnPercentCubit.state.selectedPerformanceReturnPercentList,
            currency: performanceCurrencyCubit.state.selectedPerformanceCurrency,
            asOnDate: performanceAsOnDateCubit.state.asOnDate,
          )
      );

      eitherPerformance.fold((error) {
        if(error.appErrorType==AppErrorType.unauthorised){
          loginCheckCubit.loginCheck();
        }
        emit(PerformanceReportError(errorType: error.appErrorType));
      }, (performance) {

        emit(PerformanceReportLoaded(chartData: performance));
      });
    });

  }

  Future<void> loadPerformanceReportForFavorites({required BuildContext context, required Favorite? favorite, required String tileName,FavoritesCubit? favoriteCubit, String? universalAsOnDate}) async{

    emit(const PerformanceReportLoading());

    final Either<AppError, UserPreference> eitherUserPreference = await userPreference(NoParams());

    eitherUserPreference.fold((l) {

    }, (pref) async {
      performanceLoadingCubit.startLoading();
      await performanceEntityCubit.loadPerformanceEntity(context: context, favoriteEntity: favorite?.filter?[FavoriteConstants.entityFilter] != null ? Entity.fromJson(favorite?.filter?[FavoriteConstants.entityFilter]) : null);
      await performanceAsOnDateCubit.changeAsOnDate(asOnDate: universalAsOnDate ?? favorite?.filter?[FavoriteConstants.asOnDate]);
      await performancePartnershipMethodCubit.loadPerformancePartnershipMethod(
          context: context, tileName: tileName,
      favoritePartnershipMethodItemData: favorite?.filter?[FavoriteConstants.partnershipMethod] !=null ? PartnershipMethodItem.fromJson(favorite?.filter?[FavoriteConstants.partnershipMethod]) : null,);

      await performanceHoldingMethodCubit.loadPerformanceHoldingMethod(
          context: context, tileName: tileName,
      favoriteHoldingMethodItemData: favorite?.filter?[FavoriteConstants.holdingMethod] != null ? HoldingMethodItem.fromJson(favorite?.filter?[FavoriteConstants.holdingMethod]) : null);

      await performancePrimaryGroupingCubit.loadPerformancePrimaryGrouping(
        context: context,
          favoritePrimaryGrouping: favorite?.filter?[FavoriteConstants.primaryGrouping] != null ? PrimaryGrouping.fromJson(favorite?.filter?[FavoriteConstants.primaryGrouping]) : null,
          selectedEntity: performanceEntityCubit.state.selectedPerformanceEntity,
          asOnDate: performanceAsOnDateCubit.state.asOnDate
      );
      await performancePrimarySubGroupingCubit.loadPerformancePrimarySubGrouping(
        context: context,
        favoriteSubGroupingItem: favorite?.filter?[FavoriteConstants.primarySubGrouping] != null ? FavoriteHelper.getPrimarySubGrouping(favorite?.filter?[FavoriteConstants.primarySubGrouping]) : null,
          selectedEntity: performanceEntityCubit.state.selectedPerformanceEntity,
          selectedGrouping: performancePrimaryGroupingCubit.state.selectedGrouping,
          asOnDate: performanceAsOnDateCubit.state.asOnDate,
        selectedPartnershipMethod: performancePartnershipMethodCubit.state.selectedPerformancePartnershipMethod,
        selectedHoldingMethod: performanceHoldingMethodCubit.state.selectedPerformanceHoldingMethod
      );
      await performanceSecondaryGroupingCubit.loadPerformanceSecondaryGrouping(
        context: context,
        favoriteSecondaryGrouping: favorite?.filter?[FavoriteConstants.secondaryGrouping] != null ? SecondaryGrouping.fromJson(favorite?.filter?[FavoriteConstants.secondaryGrouping]) : null,
          selectedEntity: performanceEntityCubit.state.selectedPerformanceEntity,
          asOnDate: performanceAsOnDateCubit.state.asOnDate
      );
      await performanceSecondarySubGroupingCubit.loadPerformanceSecondarySubGrouping(
        context: context,
        favoriteSubGroupingItem: favorite?.filter?[FavoriteConstants.secondarySubGrouping] != null ? FavoriteHelper.getSecondarySubGrouping(favorite?.filter?[FavoriteConstants.secondarySubGrouping]) : null,
          selectedEntity: performanceEntityCubit.state.selectedPerformanceEntity,
          primarySubGroupingItem: performancePrimarySubGroupingCubit.state.selectedSubGroupingList,
          selectedGrouping: performanceSecondaryGroupingCubit.state.selectedGrouping,
          asOnDate: performanceAsOnDateCubit.state.asOnDate
      );
      await performancePeriodCubit.loadPerformancePeriod(context: context);
      await performanceNumberOfPeriodCubit.loadPerformanceNumberOfPeriod(context: context);
      await performanceReturnPercentCubit.loadPerformanceReturnPercent(context: context, favoriteReturnPercentItem: favorite?.filter?[FavoriteConstants.returnPercent] != null ? FavoriteHelper.getReturnPercent(favorite?.filter?[FavoriteConstants.returnPercent]) : null);
      await performanceDenominationCubit.loadPerformanceDenomination(context: context, favoriteDenData: favorite?.filter?[FavoriteConstants.denomination] != null ? DenData.fromJson(favorite?.filter?[FavoriteConstants.denomination]) : null);
      await performanceCurrencyCubit.loadPerformanceCurrency(context: context, performanceDenominationCubit: performanceDenominationCubit, favoriteCurrency: favorite?.filter?[FavoriteConstants.currency] != null ? CurrencyData.fromJson(favorite?.filter?[FavoriteConstants.currency]) : null, selectedEntity: performanceEntityCubit.state.selectedPerformanceEntity);
      performanceLoadingCubit.endLoading();

      final Either<AppError, PerformanceReportEntity> eitherPerformance = await getPerformanceReport(
          PerformanceReportParams(
            context: context,
            entity: performanceEntityCubit.state.selectedPerformanceEntity,
            primaryGrouping: performancePrimaryGroupingCubit.state.selectedGrouping,
            secondaryGrouping: performanceSecondaryGroupingCubit.state.selectedGrouping,
            primarySubGrouping: performancePrimarySubGroupingCubit.state.selectedSubGroupingList,
            partnershipMethod: performancePartnershipMethodCubit.state.selectedPerformancePartnershipMethod?.name,
            holdingMethod: performanceHoldingMethodCubit.state.selectedPerformanceHoldingMethod?.value,
            secondarySubGrouping: performanceSecondarySubGroupingCubit.state.selectedSubGroupingList,
            returnPercentItemData: performanceReturnPercentCubit.state.selectedPerformanceReturnPercentList,
            currency: performanceCurrencyCubit.state.selectedPerformanceCurrency,
            asOnDate: performanceAsOnDateCubit.state.asOnDate,

          )
      );

      eitherPerformance.fold((error) {

        emit(PerformanceReportError(errorType: error.appErrorType));
      }, (performance) {
        if(favoriteCubit != null && universalAsOnDate != null) {
          favoriteCubit.saveFilters(
              context: context,
              shouldUpdate: true,
              isPinned: favorite?.isPined ?? false,
              itemId: favorite?.id.toString(),
              reportId: FavoriteConstants.performanceId,
              reportName: favorite?.reportname ?? FavoriteConstants.performanceName,
              isMarketValueSelected: favorite?.filter?[FavoriteConstants.isMarketValueSelected],
              entity: performanceEntityCubit.state.selectedPerformanceEntity,
              partnershipMethod: performancePartnershipMethodCubit.state.selectedPerformancePartnershipMethod,
              holdingMethodPerformance: performanceHoldingMethodCubit.state.selectedPerformanceHoldingMethod,
              performancePrimaryGrouping: performancePrimaryGroupingCubit.state.selectedGrouping,
              performancePrimarySubGrouping: performancePrimarySubGroupingCubit.state.selectedSubGroupingList,
              performanceSecondaryGrouping: performanceSecondaryGroupingCubit.state.selectedGrouping,
              performanceSecondarySubGrouping: performanceSecondarySubGroupingCubit.state.selectedSubGroupingList,
              performanceReturnPercent: performanceReturnPercentCubit.state.selectedPerformanceReturnPercentList,
              currency: performanceCurrencyCubit.state.selectedPerformanceCurrency,
              denomination: performanceDenominationCubit.state.selectedPerformanceDenomination,
              asOnDate: performanceAsOnDateCubit.state.asOnDate
          );
        }
        emit(PerformanceReportLoaded(chartData: performance));
      });
    });

  }

  Future<void> reloadPerformanceReport({required BuildContext context, FavoritesCubit? favoriteCubit, bool isFavorite = false, bool fromBlankWidget = false, Favorite? favorite}) async{

    emit(const PerformanceReportLoading());

    if(!isFavorite) {
      await savePerformanceSelectedEntity(Entity(
          id: performanceEntityCubit.state.selectedPerformanceEntity?.id,
          name: performanceEntityCubit.state.selectedPerformanceEntity?.name,
          type: performanceEntityCubit.state.selectedPerformanceEntity?.type,
          currency: performanceEntityCubit.state.selectedPerformanceEntity?.currency,
          accountingyear: performanceEntityCubit.state.selectedPerformanceEntity?.accountingyear
      ));

      await savePerformanceSelectedPartnershipMethod(
        "Performance",PartnershipMethodItemData(
        id: performancePartnershipMethodCubit.state.selectedPerformancePartnershipMethod?.id,
        name: performancePartnershipMethodCubit.state.selectedPerformancePartnershipMethod?.name
      ));

      await savePerformanceSelectedHoldingMethod(
        "Performance",HoldingMethodItemData(
        id: performanceHoldingMethodCubit.state.selectedPerformanceHoldingMethod?.id,
        name: performanceHoldingMethodCubit.state.selectedPerformanceHoldingMethod?.name,
      ));

      await savePerformanceSelectedPrimaryGrouping(PrimaryGrouping(
          id: performancePrimaryGroupingCubit.state.selectedGrouping?.id,
          name: performancePrimaryGroupingCubit.state.selectedGrouping?.name
      ));

      await savePerformanceSelectedPrimarySubGrouping(
          {"entityid": performanceEntityCubit.state.selectedPerformanceEntity?.id, "entitytype": performanceEntityCubit.state.selectedPerformanceEntity?.type, "id": performancePrimaryGroupingCubit.state.selectedGrouping?.id},
          PerformancePrimarySubGroupingModel(
              subGrouping: performancePrimarySubGroupingCubit.state.selectedSubGroupingList?.map((element) => primary.SubGroupingItem(
                  id: element?.id,
                  name: element?.name
              )
              ).toList()).toJson()
      );

      await savePerformanceSelectedSecondaryGrouping(SecondaryGrouping(
          id: performanceSecondaryGroupingCubit.state.selectedGrouping?.id,
          name: performanceSecondaryGroupingCubit.state.selectedGrouping?.name
      ));

      await savePerformanceSelectedSecondarySubGrouping(
          {"entityid": performanceEntityCubit.state.selectedPerformanceEntity?.id, "entitytype": performanceEntityCubit.state.selectedPerformanceEntity?.type, "id": performanceSecondaryGroupingCubit.state.selectedGrouping},
          PerformanceSecondarySubGroupingModel(
              subGrouping: performanceSecondarySubGroupingCubit.state.selectedSubGroupingList?.map((element) => secondary.SubGroupingItem(
                  id: element?.id,
                  name: element?.name
              )
              ).toList()).toJson()
      );

      await savePerformanceSelectedReturnPercent(ReturnPercentModel(
          allReturnPercentList: performanceReturnPercentCubit.state.selectedPerformanceReturnPercentList?.map((element) => ReturnPercentItem(
            id: element?.id,
            value: element?.value ?? ReturnType.MTD,
            key: element?.key,
            name: element?.name,
          )).toList()
      ).toJson());

      await savePerformanceSelectedCurrency(CurrencyData(
          id: performanceCurrencyCubit.state.selectedPerformanceCurrency?.id,
          code: performanceCurrencyCubit.state.selectedPerformanceCurrency?.code,
          format: performanceCurrencyCubit.state.selectedPerformanceCurrency?.format
      ));

      await savePerformanceSelectedDenomination(DenData(
        id: performanceDenominationCubit.state.selectedPerformanceDenomination?.id,
        key: performanceDenominationCubit.state.selectedPerformanceDenomination?.key,
        title: performanceDenominationCubit.state.selectedPerformanceDenomination?.title,
        suffix: performanceDenominationCubit.state.selectedPerformanceDenomination?.suffix,
        denomination: performanceDenominationCubit.state.selectedPerformanceDenomination?.denomination,
      ));

    }

    if(fromBlankWidget) {
      favoriteCubit?.saveFilters(
          context: context,
          shouldUpdate: true,
          isPinned: favorite?.isPined ?? false,
          itemId: favorite?.id.toString(),
          reportId: FavoriteConstants.performanceId,
          reportName: favorite?.reportname ?? FavoriteConstants.performanceName,
          isMarketValueSelected: favorite?.filter?[FavoriteConstants.isMarketValueSelected],
          entity: performanceEntityCubit.state.selectedPerformanceEntity,
          partnershipMethod: performancePartnershipMethodCubit.state.selectedPerformancePartnershipMethod,
          holdingMethodPerformance: performanceHoldingMethodCubit.state.selectedPerformanceHoldingMethod,
          performancePrimaryGrouping: performancePrimaryGroupingCubit.state.selectedGrouping,
          performancePrimarySubGrouping: performancePrimarySubGroupingCubit.state.selectedSubGroupingList,
          performanceSecondaryGrouping: performanceSecondaryGroupingCubit.state.selectedGrouping,
          performanceSecondarySubGrouping: performanceSecondarySubGroupingCubit.state.selectedSubGroupingList,
          performanceReturnPercent: performanceReturnPercentCubit.state.selectedPerformanceReturnPercentList,
          currency: performanceCurrencyCubit.state.selectedPerformanceCurrency,
          denomination: performanceDenominationCubit.state.selectedPerformanceDenomination,
          asOnDate: performanceAsOnDateCubit.state.asOnDate
      );
    }

    final Either<AppError, UserPreference> eitherUserPreference = await userPreference(NoParams());

    eitherUserPreference.fold((l) {

    }, (pref) async {

      final Either<AppError, PerformanceReportEntity> eitherPerformance = await getPerformanceReport(
          PerformanceReportParams(
            context: context,
            entity: performanceEntityCubit.state.selectedPerformanceEntity,
            partnershipMethod: performancePartnershipMethodCubit.state.selectedPerformancePartnershipMethod?.name,
            holdingMethod: performanceHoldingMethodCubit.state.selectedPerformanceHoldingMethod?.value,
            primaryGrouping: performancePrimaryGroupingCubit.state.selectedGrouping,
            secondaryGrouping: performanceSecondaryGroupingCubit.state.selectedGrouping,
            primarySubGrouping: performancePrimarySubGroupingCubit.state.selectedSubGroupingList,
            secondarySubGrouping: performanceSecondarySubGroupingCubit.state.selectedSubGroupingList,
            returnPercentItemData: performanceReturnPercentCubit.state.selectedPerformanceReturnPercentList,
            currency: performanceCurrencyCubit.state.selectedPerformanceCurrency,
            asOnDate: performanceAsOnDateCubit.state.asOnDate,
          )
      );


      eitherPerformance.fold((error) {
        if(error.appErrorType==AppErrorType.unauthorised){
          loginCheckCubit.loginCheck();
        }
        emit(PerformanceReportError(errorType: error.appErrorType));
      }, (performance) {
        if(isFavorite) {
          favoriteCubit?.saveFilters(
            context: context,
              shouldUpdate: true,
              isPinned: favorite?.isPined ?? false,
              itemId: favorite?.id.toString(),
              reportId: FavoriteConstants.performanceId,
              reportName: favorite?.reportname ?? FavoriteConstants.performanceName,
              isMarketValueSelected: favorite?.filter?[FavoriteConstants.isMarketValueSelected],
              entity: performanceEntityCubit.state.selectedPerformanceEntity,
              partnershipMethod: performancePartnershipMethodCubit.state.selectedPerformancePartnershipMethod,
              holdingMethodPerformance: performanceHoldingMethodCubit.state.selectedPerformanceHoldingMethod,
              performancePrimaryGrouping: performancePrimaryGroupingCubit.state.selectedGrouping,
              performancePrimarySubGrouping: performancePrimarySubGroupingCubit.state.selectedSubGroupingList,
              performanceSecondaryGrouping: performanceSecondaryGroupingCubit.state.selectedGrouping,
              performanceSecondarySubGrouping: performanceSecondarySubGroupingCubit.state.selectedSubGroupingList,
              performanceReturnPercent: performanceReturnPercentCubit.state.selectedPerformanceReturnPercentList,
              currency: performanceCurrencyCubit.state.selectedPerformanceCurrency,
              denomination: performanceDenominationCubit.state.selectedPerformanceDenomination,
              asOnDate: performanceAsOnDateCubit.state.asOnDate
          );
        }

        emit(PerformanceReportLoaded(chartData: performance));
      });
    });

  }

}
