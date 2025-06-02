import 'dart:developer';
import 'package:asset_vantage/src/config/constants/favorite_constants.dart';
import 'package:asset_vantage/src/data/models/number_of_period/number_of_period_model.dart';
import 'package:asset_vantage/src/data/models/partnership_method/holding_method_model.dart';
import 'package:asset_vantage/src/data/models/period/period_model.dart';
import 'package:asset_vantage/src/domain/entities/expense/expense_account_entity.dart';
import 'package:asset_vantage/src/domain/entities/favorites/favorites_entity.dart';
import 'package:asset_vantage/src/domain/entities/number_of_period/number_of_period.dart';
import 'package:asset_vantage/src/domain/entities/partnership_method/holding_method_entities.dart';
import 'package:asset_vantage/src/domain/entities/partnership_method/partnership_method.dart';
import 'package:asset_vantage/src/domain/entities/period/period_enitity.dart';
import 'package:asset_vantage/src/domain/params/favorites/favorites_sequence_params.dart';
import 'package:asset_vantage/src/domain/usecases/favorites/favorites.dart';
import 'package:asset_vantage/src/domain/usecases/favorites/favorites_sequence.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_report/cash_balance_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/expense/expense_report/expense_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_report/income_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_report/net_worth_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_report/performance_report_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:asset_vantage/src/domain/entities/net_worth/net_worth_return_percent_entity.dart' as returtPerNW;

import '../../../data/models/currency/currency_model.dart';
import '../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../data/models/denomination/denomination_model.dart';
import '../../../data/models/favorites/favorites_model.dart';
import '../../../data/models/partnership_method/partnership_method_model.dart';
import '../../../data/models/performance/performance_primary_grouping_model.dart';
import '../../../data/models/performance/performance_primary_sub_grouping_model.dart'
    as subPrimaryM;
import '../../../data/models/performance/performance_secondary_grouping_model.dart';
import 'package:asset_vantage/src/domain/entities/net_worth/net_worth_grouping_entity.dart' as netWorthGroup;
import 'package:asset_vantage/src/domain/entities/net_worth/net_worth_sub_grouping_enity.dart' as netWorthSubGroup;
import '../../../data/models/preferences/user_preference.dart';
import '../../../data/models/return_percentage/return_percentage_model.dart';
import '../../../domain/entities/app_error.dart';
import '../../../domain/entities/currency/currency_entity.dart';
import '../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../domain/entities/denomination/denomination_entity.dart';
import '../../../domain/entities/favorites/favorites_sequence_enitity.dart';
import '../../../domain/entities/income/income_account_entity.dart';
import '../../../domain/entities/performance/performance_primary_grouping_entity.dart' as primary;
import '../../../domain/entities/cash_balance/cash_balance_grouping_entity.dart' as cashPrimary;
import '../../../domain/entities/performance/performance_primary_sub_grouping_enity.dart' as subPrimary;
import '../../../domain/entities/cash_balance/cash_balance_sub_grouping_entity.dart' as cashSubPrimary;
import '../../../domain/entities/performance/performance_secondary_grouping_entity.dart' as secondary;
import '../../../domain/entities/performance/performance_secondary_sub_grouping_enity.dart' as subSecondary;
import '../../../domain/entities/return_percentage/return_percentage_entity.dart';
import '../../../domain/params/favorites/favorites_params.dart';
import '../../../domain/params/no_params.dart';
import '../../../domain/usecases/preferences/get_user_preference.dart';
import '../../../injector.dart';
import '../authentication/login_check/login_check_cubit.dart';

import '../../../data/models/performance/performance_secondary_sub_grouping_model.dart'
    as subSecondaryM;

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final LoginCheckCubit loginCheckCubit;
  final FavoritesReport favoritesReport;
  final FavoritesSequenceReport favoritesSequence;
  final GetUserPreference getUserPreference;

  FavoritesCubit({
    required this.loginCheckCubit,
    required this.favoritesReport,
    required this.getUserPreference,
    required this.favoritesSequence,
  }) : super(FavoritesInitial());

  Future<void> loadFavorites({required BuildContext context, void Function()? onCollapsed}) async {
    emit(FavoritesLoading());

    final Either<AppError, UserPreference> eitherUserPreference =
        await getUserPreference(NoParams());

    eitherUserPreference.fold((error) {}, (user) async {
      final Either<AppError, FavoritesEntity> eitherFavorites =
          await favoritesReport(FavoritesParams(
            context: context,
              action: FavoriteConstants.fetch,
              userId: user.user?.id.toString(),
              systemName: user.systemName));


      eitherFavorites.fold(
        (error) {

          return emit(FavoritesError(errorType: error.appErrorType));
        },
        (favoritesEntity) {

              List<Favorite>? rearrangedSequence = favoritesEntity.favoriteList;
              if (favoritesEntity.sequenceData?.sequence != null &&
                  (favoritesEntity.sequenceData?.sequence?.isNotEmpty ?? false)) {
                List<Favorite>? assembledList = [];
                for (var item in (favoritesEntity.sequenceData?.sequence ?? [])) {

                  Favorite? fav;

                  for(int i = 0; i < (rearrangedSequence?.length ?? 0); i++) {
                    if(rearrangedSequence?[i].id == item) {
                      fav = rearrangedSequence?[i];
                      break;
                    }
                  }
                  if(fav != null) {
                    assembledList.add(fav);
                  }
                }
                rearrangedSequence = assembledList;
              }
              final cubitList = rearrangedSequence?.map(
                (fav) {
                  if (fav.reportId == "${FavoriteConstants.netWorthId}") {
                    final netWorthReportCubit =
                        getItInstance<NetWorthReportCubit>();
                    netWorthReportCubit.loadNetWorthReportForFavorites(
                      context: context,
                        favorite: fav,
                      tileName: "NetWorth"
                    );
                    return netWorthReportCubit;
                  }else if (fav.reportId == "${FavoriteConstants.performanceId}") {
                    final performanceReportCubit =
                    getItInstance<PerformanceReportCubit>();
                    performanceReportCubit.loadPerformanceReportForFavorites(
                        context: context,
                        favorite: fav,
                      tileName: "Performance"
                    );
                    return performanceReportCubit;
                  } else if (fav.reportId == "${FavoriteConstants.incomeId}") {
                    final incomeReportCubit =
                        getItInstance<IncomeReportCubit>();
                    incomeReportCubit.loadIncomeReportForFavorites(
                      context: context,
                        favorite: fav);
                    return incomeReportCubit;
                  } else if (fav.reportId == "${FavoriteConstants.expenseId}") {
                    final expenseReportCubit =
                        getItInstance<ExpenseReportCubit>();
                    expenseReportCubit.loadExpenseReportForFavorites(
                      context: context,
                        favorite: fav);
                    return expenseReportCubit;
                  }else if(fav.reportId=="${FavoriteConstants.cashBalanceId}") {
                    final cashBalanceReportCubit = getItInstance<CashBalanceReportCubit>();
                    cashBalanceReportCubit.loadCashBalanceReportForFavorites(context: context, tileName: "cash_balance", favorite: fav);
                    return cashBalanceReportCubit;
                  }
                },
              ).toList();

              if(onCollapsed != null) {
                if(rearrangedSequence?.isEmpty ?? true) {
                  onCollapsed.call();
                }
              }

              emit(FavoritesLoaded(
                favoritesList: rearrangedSequence,
                reportCubitList: cubitList,
                sequenceList: favoritesEntity.sequenceData,
              ));
        },
      );
    });
  }

  Future<void> cFavourite() async{
    emit(FavoritesInitial());
    emit(FavoritesLoaded(
      favoritesList: null,  //[]
      reportCubitList: [],
      sequenceList: FavoritesSequenceEntity(sequence: []),
    ));
  }

  Future<void> saveFilters({
    required BuildContext context,
    bool shouldUpdate = false,
    bool isBlankWidget = false,
    String? itemId,
    required bool isPinned,
    required int reportId,
    required String reportName,
    EntityData? entity,
    bool? isMarketValueSelected,
    netWorthGroup.GroupingEntity? netWorthPrimaryGrouping,
    List<netWorthSubGroup.SubGroupingItemData?>? netWorthPrimarySubGrouping,
    primary.GroupingEntity? performancePrimaryGrouping,
    List<subPrimary.SubGroupingItemData?>? performancePrimarySubGrouping,
    cashPrimary.GroupingEntity? cashBalancePrimaryGrouping,
    List<cashSubPrimary.SubGroupingItemData?>? cashBalancePrimarySubGrouping,
    secondary.GroupingEntity? performanceSecondaryGrouping,
    List<subSecondary.SubGroupingItemData?>? performanceSecondarySubGrouping,
    List<ReturnPercentItemData?>? performanceReturnPercent,
    List<returtPerNW.ReturnPercentItemData?>? netWorthReturnPercent,
    List<Account?>? incomeAccounts,
    List<AccountEntity?>? expenseAccounts,
    List<cashSubPrimary.SubGroupingItemData?>? cashAccounts,
    PeriodItemData? period,
    NumberOfPeriodItemData? numberOfPeriod,
    PartnershipMethodItemData? partnershipMethod,
    //Map<String,String>? holdingMethod,
    HoldingMethodItemData? holdingMethodPerformance,
    Currency? currency,
    DenominationData? denomination,
    String? asOnDate,
  }) async {
    final Either<AppError, UserPreference> eitherUserPreference =
        await getUserPreference(NoParams());
    eitherUserPreference.fold((error) {}, (user) async {

      final favParams = FavoritesParams(
        isBlankWidget: isBlankWidget,
        context: context,
          id: itemId != null ? int.parse(itemId) : null,
          action:
              shouldUpdate ? FavoriteConstants.update : FavoriteConstants.add,
          userId: user.user?.id.toString(),
          systemName: user.systemName,
          reportId: reportId.toString(),
          reportName: reportName,
          isMarketValueSelecte: isMarketValueSelected,
          entity: Entity(
            id: entity?.id,
            name: entity?.name,
            type: entity?.type,
            currency: entity?.currency,
            accountingyear: entity?.accountingyear,
          ).toJson(),
          partnershipMethod: partnershipMethod !=null ?PartnershipMethodItem(
            id: partnershipMethod.id,
            name: partnershipMethod.name,
            value: partnershipMethod.value
          ).toJson()
              :null,
          holdingMethod: holdingMethodPerformance !=null ? HoldingMethodItem(
            id: holdingMethodPerformance.id,
            name: holdingMethodPerformance.name,
            value: holdingMethodPerformance.value
          ).toJson()
              :null,
          period: period != null
              ? PeriodItem(
                  id: period.id,
                  name: period.name,
                  gaps: period.gaps,
                ).toJson()
              : null,
          numberOfPeriod: numberOfPeriod != null
              ? NumberOfPeriodItem(
                  id: numberOfPeriod.id,
                  name: numberOfPeriod.name,
                  value: numberOfPeriod.value,
                ).toJson()
              : null,
          accounts: reportId==FavoriteConstants.cashBalanceId ? cashAccounts?.map((element) => cashSubPrimary.SubGroupingItemData(
              id: element?.id,
              name: element?.name
          ).toJson()
          ).toList() : reportId == FavoriteConstants.incomeId
              ? incomeAccounts
                  ?.map((element) => Account(
                        id: element?.id,
                        accountname: element?.accountname,
                        accounttype: element?.accounttype,
                      ).toJson())
                  .toList()
              : reportId == FavoriteConstants.expenseId
                  ? expenseAccounts
                      ?.map((element) => AccountEntity(
                            id: element?.id,
                            accountname: element?.accountname,
                            accounttype: element?.accounttype,
                          ).toJson())
                      .toList()
                  : null,
          primaryGrouping: reportId == FavoriteConstants.performanceId
              ? PrimaryGrouping(
                      id: performancePrimaryGrouping?.id,
                      name: performancePrimaryGrouping?.name)
                  .toJson()
              : reportId==FavoriteConstants.cashBalanceId ? cashPrimary.GroupingEntity(
              id: cashBalancePrimaryGrouping?.id,
              name: cashBalancePrimaryGrouping?.name
          ).toJson(): reportId==FavoriteConstants.netWorthId ? netWorthGroup.GroupingEntity(
              id: netWorthPrimaryGrouping?.id,
              name: netWorthPrimaryGrouping?.name
          ).toJson(): null,
          primarySubGrouping: reportId == FavoriteConstants.performanceId
              ? performancePrimarySubGrouping
                  ?.map((element) =>
                      subPrimaryM.SubGroupingItem(id: element?.id, name: element?.name)
                          .toJson())
                  .toList()
              : reportId==FavoriteConstants.cashBalanceId ? cashBalancePrimarySubGrouping?.map((element) => cashSubPrimary.SubGroupingItemData(
              id: element?.id,
              name: element?.name
          ).toJson()
          ).toList(): reportId==FavoriteConstants.netWorthId ? netWorthPrimarySubGrouping?.map((element) => netWorthSubGroup.SubGroupingItemData(
              id: element?.id,
              name: element?.name
          ).toJson()).toList() : null,
          secondaryGrouping: reportId == FavoriteConstants.performanceId
              ? SecondaryGrouping(
                  id: performanceSecondaryGrouping?.id,
                  name: performanceSecondaryGrouping?.name,
                ).toJson():null,
                secondarySubGrouping: reportId==FavoriteConstants.performanceId ? performanceSecondarySubGrouping?.map((element) => subSecondaryM.SubGroupingItem(
                    id: element?.id,
                    name: element?.name
                ).toJson()
                ).toList():null,
                returnPercent: reportId==FavoriteConstants.performanceId ? performanceReturnPercent?.map((element) => ReturnPercentItem(
                  id: element?.id,
                  value: element?.value ?? ReturnType.MTD,
                  key: element?.key,
                  name: element?.name,
                ).toJson()).toList():reportId==FavoriteConstants.netWorthId ? netWorthReturnPercent?.map((element) => returtPerNW.ReturnPercentItemData(
                  id: element?.id,
                  value: element?.value,
                  name: element?.name,
                ).toJson()).toList():null,
                currency: CurrencyData(
                    id: currency?.id,
                    code: currency?.code,
                    format: currency?.format
                ).toJson(),
                denomination: DenData(
                    id: denomination?.id,
                    key: denomination?.key,
                    title: denomination?.title,
                    suffix: denomination?.suffix,
                    denomination: denomination?.denomination
                ).toJson(),
                asOnDate: asOnDate,
                isPinned: isPinned,
        favSequence: state.sequence?.sequence ?? [],
              );
              final originalFavList = [...?(state.favorites)];
              final originalFavCubitList = [...?(state.reportCubits)];
      FavoritesSequenceEntity tempSeqEntity = FavoritesSequenceEntity(sequence: state.sequence?.sequence,id: state.sequence?.id);

              if(!shouldUpdate) {
                if(!shouldUpdate && (state.favorites?.length ?? 0)>=20){
                  emit(FavoritesInitial());
                  emit(FavoritesLoaded(
                      reportCubitList: originalFavCubitList,
                      favoritesList: originalFavList,
                      sequenceList: tempSeqEntity,error: const FavouriteError(limitReached: true)));
                  return;
                }
                List<Favorite>? tempFavorites = state.favorites;
                List? tempCubitList = state.reportCubits;

        Favorite favItemToAdd =
            FavoriteItem.fromJson(favParams.toJson()['data']);

        tempFavorites?.add(favItemToAdd);

        if (reportId == FavoriteConstants.performanceId) {
          final performanceReportCubit =
              getItInstance<PerformanceReportCubit>();
          performanceReportCubit.loadPerformanceReportForFavorites(
            context: context,
              favorite: favItemToAdd, tileName: "Performance");
          tempCubitList?.add(performanceReportCubit);
        } else if (reportId == FavoriteConstants.incomeId) {
          final incomeReportCubit = getItInstance<IncomeReportCubit>();
          incomeReportCubit.loadIncomeReportForFavorites(
            context: context,
              favorite: favItemToAdd);
          tempCubitList?.add(incomeReportCubit);
        } else if (reportId == FavoriteConstants.expenseId) {
          final expenseReportCubit = getItInstance<ExpenseReportCubit>();
          expenseReportCubit.loadExpenseReportForFavorites(
            context: context,
              favorite: favItemToAdd);
          tempCubitList?.add(expenseReportCubit);
        } else if(reportId==FavoriteConstants.cashBalanceId){
          final cashBalanceReportCubit = getItInstance<CashBalanceReportCubit>();
          cashBalanceReportCubit.loadCashBalanceReportForFavorites(context: context, tileName: "cash_balance", favorite: favItemToAdd);
          tempCubitList?.add(
              cashBalanceReportCubit
          );
        } else if(reportId==FavoriteConstants.netWorthId){
          final netWorthReportCubit = getItInstance<NetWorthReportCubit>();
          netWorthReportCubit.loadNetWorthReportForFavorites(context: context, tileName: "NetWorth", favorite: favItemToAdd);
          tempCubitList?.add(
              netWorthReportCubit
          );
        }

        emit(FavoritesInitial());
        emit(FavoritesLoaded(
          reportCubitList: tempCubitList,
            favoritesList: tempFavorites,
            sequenceList: tempSeqEntity));
      } else {
        List<Favorite>? tempFavorites = state.favorites;
        List? tempCubitList = state.reportCubits;

        Favorite updatedItem =
            FavoriteItem.fromJson(favParams.toJson()['data']);

        final indexOfUpdatableItem = tempFavorites?.indexWhere(
              (element) => element.id.toString() == itemId,
            ) ??
            0;

        tempFavorites?.removeAt(indexOfUpdatableItem);
        tempFavorites?.insert(indexOfUpdatableItem, updatedItem);

        emit(FavoritesInitial());
        emit(FavoritesLoaded(
            favoritesList: tempFavorites,
            reportCubitList: tempCubitList,
            sequenceList: tempSeqEntity,
           success: const FavouriteSuccess(update: true)
        ));
      }

      final Either<AppError, FavoritesEntity> eitherFavorites =
          await favoritesReport(favParams);

      eitherFavorites.fold(
        (error) {
          print("Error type ${error.appErrorType}");
          print("Error : ${error.message}");
          if(itemId!=null){
            print("if block...update error");
            const FavouriteError(update: true);
          }else{
            print("else block...Item Id is null ");
            emit(FavoritesInitial());
            emit(FavoritesLoaded(
                favoritesList: originalFavList,
                reportCubitList: originalFavCubitList,
                sequenceList: tempSeqEntity,
                error:
                FavouriteError(create: !shouldUpdate, update: shouldUpdate)));
          }

        },
        (favoritesEntity) async {
          if(!shouldUpdate){
                List<Favorite>? tempFavorites = state.favorites;
                List? tempCubitList = state.reportCubits;
                Favorite updatedItem = FavoriteItem.fromJson(FavoritesParams(
                  context: context,
                    id: favoritesEntity.id,
                    action: shouldUpdate
                        ? FavoriteConstants.update
                        : FavoriteConstants.add,
                    isBlankWidget: isBlankWidget,
                    userId: user.user?.id.toString(),
                    systemName: user.systemName,
                    reportId: reportId.toString(),
                    reportName: reportName,
                    isMarketValueSelecte: isMarketValueSelected,
                    entity: Entity(
                      id: entity?.id,
                      name: entity?.name,
                      type: entity?.type,
                      currency: entity?.currency,
                      accountingyear: entity?.accountingyear,
                    ).toJson(),
                    partnershipMethod: partnershipMethod != null ?PartnershipMethodItem(
                      id: partnershipMethod.id,
                      name: partnershipMethod.name,
                      value: partnershipMethod.value
                    ).toJson()
                        :null,
                    holdingMethod: holdingMethodPerformance !=null ? HoldingMethodItem(
                      id: holdingMethodPerformance.id,
                      name: holdingMethodPerformance.name,
                      value: holdingMethodPerformance.value
                    ).toJson()
                        :null,
                    period: period != null
                        ? PeriodItem(
                      id: period.id,
                      name: period.name,
                      gaps: period.gaps,
                    ).toJson()
                        : null,
                    numberOfPeriod: numberOfPeriod != null
                        ? NumberOfPeriodItem(
                      id: numberOfPeriod.id,
                      name: numberOfPeriod.name,
                      value: numberOfPeriod.value,
                    ).toJson()
                        : null,
                    accounts: reportId==FavoriteConstants.cashBalanceId ? cashAccounts?.map((element) => cashSubPrimary.SubGroupingItemData(
                        id: element?.id,
                        name: element?.name
                    ).toJson()
                    ).toList() : reportId == FavoriteConstants.incomeId
                        ? incomeAccounts
                        ?.map((element) => Account(
                      id: element?.id,
                      accountname: element?.accountname,
                      accounttype: element?.accounttype,
                    ).toJson())
                        .toList()
                        : reportId == FavoriteConstants.expenseId
                        ? expenseAccounts
                        ?.map((element) => AccountEntity(
                      id: element?.id,
                      accountname: element?.accountname,
                      accounttype: element?.accounttype,
                    ).toJson())
                        .toList()
                        : null,
                    primaryGrouping: reportId == FavoriteConstants.performanceId
                        ? PrimaryGrouping(
                        id: performancePrimaryGrouping?.id,
                        name: performancePrimaryGrouping?.name)
                        .toJson()
                        : reportId==FavoriteConstants.cashBalanceId ? cashPrimary.GroupingEntity(
                        id: cashBalancePrimaryGrouping?.id,
                        name: cashBalancePrimaryGrouping?.name
                    ).toJson(): reportId==FavoriteConstants.netWorthId ? netWorthGroup.GroupingEntity(
                        id: netWorthPrimaryGrouping?.id,
                        name: netWorthPrimaryGrouping?.name
                    ).toJson(): null,
                    primarySubGrouping: reportId == FavoriteConstants.performanceId
                        ? performancePrimarySubGrouping
                        ?.map((element) =>
                        subPrimaryM.SubGroupingItem(id: element?.id, name: element?.name)
                            .toJson())
                        .toList()
                        : reportId==FavoriteConstants.cashBalanceId ? cashBalancePrimarySubGrouping?.map((element) => cashSubPrimary.SubGroupingItemData(
                        id: element?.id,
                        name: element?.name
                    ).toJson()
                    ).toList(): reportId==FavoriteConstants.netWorthId ? netWorthPrimarySubGrouping?.map((element) => netWorthSubGroup.SubGroupingItemData(
                        id: element?.id,
                        name: element?.name
                    ).toJson()).toList() : null,
                    secondaryGrouping:
                    reportId == FavoriteConstants.performanceId
                        ? SecondaryGrouping(
                      id: performanceSecondaryGrouping?.id,
                      name: performanceSecondaryGrouping?.name,
                    ).toJson()
                        : null,
                    secondarySubGrouping: reportId == FavoriteConstants.performanceId
                        ? performanceSecondarySubGrouping
                        ?.map((element) => subSecondaryM.SubGroupingItem(
                        id: element?.id, name: element?.name)
                        .toJson())
                        .toList()
                        : null,
                    returnPercent: reportId==FavoriteConstants.performanceId ? performanceReturnPercent?.map((element) => ReturnPercentItem(
                      id: element?.id,
                      value: element?.value ?? ReturnType.MTD,
                      key: element?.key,
                      name: element?.name,
                    ).toJson()).toList():reportId==FavoriteConstants.netWorthId ? netWorthReturnPercent?.map((element) => returtPerNW.ReturnPercentItemData(
                      id: element?.id,
                      value: element?.value,
                      name: element?.name,
                    ).toJson()).toList():null,
                    currency: CurrencyData(id: currency?.id, code: currency?.code, format: currency?.format).toJson(),
                    denomination: DenData(id: denomination?.id, key: denomination?.key, title: denomination?.title, suffix: denomination?.suffix, denomination: denomination?.denomination).toJson(),
                    asOnDate: asOnDate,
                    isPinned: isPinned)
                    .toJson()['data']);
                final indexOfUpdatableItem = tempFavorites?.indexWhere(
                      (element) => element.id == null,
                ) ??
                    0;
                tempFavorites?.removeAt(indexOfUpdatableItem);
                tempFavorites?.insert(indexOfUpdatableItem, updatedItem);
                emit(FavoritesInitial());
                emit(FavoritesLoaded(
                    favoritesList: tempFavorites,
                    reportCubitList: tempCubitList,
                    sequenceList: favoritesEntity.sequenceData,
                    success: const FavouriteSuccess(create: true)));

          }
        },
      );
    });
  }

  Future<void> removeFavorites({required BuildContext context, required Favorite? favorite}) async {
    final Either<AppError, UserPreference> eitherUserPreference =
        await getUserPreference(NoParams());
    List<Favorite>? favoritesList = state.favorites;
    List? cubitList = state.reportCubits;
    List<int>? seqList = state.sequence?.sequence ?? favoritesList?.map((e) => e.id!).toList();

    List<Favorite>? originalFovouriteList = [...?state.favorites];
    List? originalCubitList = [...?state.reportCubits];
    List<int>? originalSeqList = [...?(state.sequence?.sequence ?? favoritesList?.map((e) => e.id!).toList())];
    FavoritesSequenceEntity originalSequenceEntity = FavoritesSequenceEntity(sequence: state.sequence?.sequence,id: state.sequence?.id);

    int? index = favoritesList?.indexWhere((item) => item.id == favorite?.id);

    if (index != null) {
      try {
        favoritesList?.removeAt(index);
        cubitList?.removeAt(index);
        seqList?.removeAt(index);
      }catch(e) {

      }
    }

    emit(FavoritesInitial());
    emit(FavoritesLoaded(
        favoritesList: favoritesList,
        reportCubitList: cubitList,
        sequenceList: FavoritesSequenceEntity(
            id: originalSequenceEntity.id, sequence: seqList)));

    eitherUserPreference.fold((error) {}, (user) async {
      final Either<AppError, FavoritesEntity> eitherFavorites =
          await favoritesReport(FavoritesParams(
            context: context,
        id: favorite?.id,
        action: FavoriteConstants.delete,
        userId: user.user?.id.toString(),
        systemName: user.systemName,
            favSequence: seqList,
      ));

      eitherFavorites.fold(
        (error) {
          emit(FavoritesInitial());
          emit(FavoritesLoaded(
              favoritesList: originalFovouriteList,
              reportCubitList: originalCubitList,
              sequenceList: FavoritesSequenceEntity(
                  id: originalSequenceEntity.id, sequence: originalSeqList),
              error: const FavouriteError(delete: true)));
        },
        (favoriteEntity) {

              FavoritesSequenceEntity favoritesSequenceEntity = FavoritesSequenceEntity(
                  id: originalSequenceEntity.id, sequence: seqList);
              emit(FavoritesInitial());
              emit(FavoritesLoaded(
                  favoritesList: favoritesList,
                  reportCubitList: cubitList,
                  sequenceList: favoritesSequenceEntity,
                  success: const FavouriteSuccess(delete: true)));
              print("Favorite: ${favoriteEntity.message}");
            },
          );

    });
  }

  Future<void> updateFavoriteReportName(
      {required BuildContext context, required Favorite? favorite, required String reportName}) async {
    List<Favorite>? favoritesList = state.favorites;
    List? cubitList = state.reportCubits;
    List<int>? seqList = state.sequence?.sequence;
    FavoritesSequenceEntity originalSequenceEntity = FavoritesSequenceEntity(sequence: state.sequence?.sequence,id: state.sequence?.id);

    emit(FavoritesInitial());
    emit(FavoritesLoaded(
        favoritesList: favoritesList,
        reportCubitList: cubitList,
        sequenceList:
            FavoritesSequenceEntity(id: originalSequenceEntity.id, sequence: seqList),
        nameLoading: FavoriteNameLoading(id: favorite?.id)));

    final originalFavList = [...?(state.favorites)];
    final originalFavCubitList = [...?(state.reportCubits)];
    List<int>? originalSeqList = [...?state.sequence?.sequence];

    int? index = favoritesList?.indexWhere((item) => item.id == favorite?.id);
    if (index != null) {
      Favorite? tempFavorite = favoritesList?[index];
      favoritesList?.removeAt(index);
      favoritesList?.insert(
          index,
          FavoriteItem(
            id: tempFavorite?.id,
            userId: tempFavorite?.userId,
            reportid: tempFavorite?.reportId,
            systemName: tempFavorite?.systemName,
            reportname: reportName,
            filter: tempFavorite?.filter,
            level: tempFavorite?.level,
            itemid: tempFavorite?.itemid,
            isPined: tempFavorite?.isPined,
            createdAt: tempFavorite?.createdAt,
            updatedAt: tempFavorite?.updatedAt,
          ));
    }

    final Either<AppError, UserPreference> eitherUserPreference =
        await getUserPreference(NoParams());

    eitherUserPreference.fold((error) {}, (user) async {
      final Either<AppError, FavoritesEntity> eitherFavorites =
          await favoritesReport(FavoritesParams(
            context: context,
        id: favorite?.id,
        action: FavoriteConstants.update,
        userId: user.user?.id.toString(),
        systemName: user.systemName,
        reportName: reportName.isNotEmpty
            ? reportName
            : FavoriteConstants.performanceName,
      ));

      eitherFavorites.fold(
        (error) {
          emit(FavoritesInitial());
          emit(FavoritesLoaded(
              favoritesList: originalFavList,
              reportCubitList: originalFavCubitList,
              sequenceList: FavoritesSequenceEntity(
                  id: originalSequenceEntity.id, sequence: originalSeqList),
              error: const FavouriteError(nameChange: true)));
        },
        (favoriteEntity) {
          emit(FavoritesInitial());
          emit(FavoritesLoaded(
              favoritesList: favoritesList,
              reportCubitList: cubitList,
              sequenceList: FavoritesSequenceEntity(
                  id: originalSequenceEntity.id, sequence: seqList),
              success: const FavouriteSuccess(nameChange: true)));
          print("Favorite: ${favoriteEntity.message}");
        },
      );
    });
  }

  Future<void> pinUnpinFavoriteReport({required BuildContext context, required Favorite? favorite}) async {
    List<Favorite>? favoritesList = state.favorites;
    List? cubitList = state.reportCubits;
    List<int>? seqList = state.sequence?.sequence;
    FavoritesSequenceEntity originalSequenceEntity = FavoritesSequenceEntity(sequence: state.sequence?.sequence,id: state.sequence?.id);


    final originalFavList = [...?(state.favorites)];
    final originalFavCubitList = [...?(state.reportCubits)];
    List<int>? originalSeqList = [...?state.sequence?.sequence];

    int? index = favoritesList?.indexWhere((item) => item.id == favorite?.id);
    Favorite? tempFavorite;
    var tempCubit;
    int tempSeq;
    if (index != null) {
      tempFavorite = favoritesList?[index];
      tempCubit = cubitList?[index];
      tempSeq = seqList?[index] ?? -1;
      favoritesList?.removeAt(index);
      cubitList?.removeAt(index);
      seqList?.removeAt(index);
      favoritesList?.insert(
          0,
          FavoriteItem(
            id: tempFavorite?.id,
            reportid: tempFavorite?.reportId,
            userId: tempFavorite?.userId,
            systemName: tempFavorite?.systemName,
            reportname: tempFavorite?.reportname,
            filter: tempFavorite?.filter,
            level: tempFavorite?.level,
            itemid: tempFavorite?.itemid,
            isPined: !(tempFavorite?.isPined ?? false),
            createdAt: tempFavorite?.createdAt,
            updatedAt: tempFavorite?.updatedAt,
          ));
      cubitList?.insert(0, tempCubit);
      seqList?.insert(0, tempSeq);
    }

    final Either<AppError, UserPreference> eitherUserPreference =
        await getUserPreference(NoParams());

    eitherUserPreference.fold((error) {}, (user) async {
      final Either<AppError, FavoritesEntity> eitherFavorites =
          await favoritesReport(FavoritesParams(
            context: context,
        id: favorite?.id,
        action: FavoriteConstants.update,
        userId: user.user?.id.toString(),
        systemName: user.systemName,
        isPinned: !(tempFavorite?.isPined ?? false),
      ));

      final Either<AppError, FavoritesSequenceEntity> eitherFavSequence =
          await favoritesSequence(
        FavoritesSequenceParams(
          context: context,
          action: originalSequenceEntity.id == null
              ? FavoriteConstants.add
              : FavoriteConstants.update,
          id: state.sequence?.id,
          sequence: seqList,
          systemName: user.systemName,
          userId: user.user?.id.toString(),
        ),
      );

      eitherFavorites.fold(
        (error) {
          emit(FavoritesInitial());
          emit(FavoritesLoaded(
              favoritesList: originalFavList,
              reportCubitList: originalFavCubitList,
              sequenceList: FavoritesSequenceEntity(
                  id: originalSequenceEntity.id, sequence: originalSeqList),
              error: const FavouriteError(pinUnpin: true)));
        },
        (favoriteEntity) {
          eitherFavSequence.fold(
            (seqError) {
              emit(FavoritesInitial());
              emit(FavoritesLoaded(
                  favoritesList: originalFavList,
                  reportCubitList: originalFavCubitList,
                  sequenceList: FavoritesSequenceEntity(
                      id: originalSequenceEntity.id, sequence: originalSeqList),
                  error: const FavouriteError(pinUnpin: true)));
            },
            (seq) {
              FavoritesSequenceEntity favoritesSequenceEntity = FavoritesSequenceEntity(
                  id: originalSequenceEntity.id, sequence: seqList);
              if(originalSequenceEntity.id == null && seq.id!=null){
                favoritesSequenceEntity = FavoritesSequenceEntity(sequence: seqList,id: seq.id,message: seq.message,);
              }
              emit(FavoritesInitial());
              emit(FavoritesLoaded(
                  favoritesList: favoritesList,
                  reportCubitList: cubitList,
                  sequenceList: favoritesSequenceEntity,
                  success: const FavouriteSuccess(pinUnpin: true)));
              print("Favorite: ${favoriteEntity.message}");
            },
          );
        },
      );
    });
  }

  Future<void> onReorder({required BuildContext context, required int oldIndex, required int newIndex}) async {
    if (oldIndex == newIndex) return;
    List<Favorite>? favoritesList = state.favorites;
    List? cubitList = state.reportCubits;
    List<int>? seqList = state.sequence?.sequence ??
        favoritesList?.map((e) => e.id!).toList();
    FavoritesSequenceEntity originalSequenceEntity = FavoritesSequenceEntity(
        sequence: state.sequence?.sequence, id: state.sequence?.id);
    final originalFavList = [...?(state.favorites)];
    final originalFavCubitList = [...?(state.reportCubits)];
    List<int>? originalSeqList = [
      ...?(state.sequence?.sequence ??
          favoritesList?.map((e) => e.id!).toList())
    ];
    int endIndex = newIndex;
    if (oldIndex != newIndex) {
      if (oldIndex < newIndex) {
        endIndex -= 1;
      }
    }
    Favorite? tempFavorite;
    var tempCubit;
    int tempSeq;
    tempFavorite = favoritesList?[oldIndex];
    tempCubit = cubitList?[oldIndex];
    tempSeq = seqList?[oldIndex] ?? -1;
    favoritesList?.removeAt(oldIndex);
    cubitList?.removeAt(oldIndex);
    seqList?.removeAt(oldIndex);
    favoritesList?.insert(endIndex, tempFavorite!);
    cubitList?.insert(endIndex, tempCubit);
    seqList?.insert(endIndex, tempSeq);
    emit(FavoritesInitial());
    emit(FavoritesLoaded(
        favoritesList: favoritesList,
        reportCubitList: cubitList,
        sequenceList: FavoritesSequenceEntity(
            id: originalSequenceEntity.id, sequence: seqList)));
    final Either<AppError, UserPreference> eitherUserPreference =
    await getUserPreference(NoParams());
    eitherUserPreference.fold((error) {}, (user) async {
      final Either<AppError, FavoritesSequenceEntity> eitherFavSequence =
      await favoritesSequence(
        FavoritesSequenceParams(
          context: context,
          action: originalSequenceEntity.id == null
              ? FavoriteConstants.add
              : FavoriteConstants.update,
          id: state.sequence?.id,
          sequence: seqList,
          systemName: user.systemName,
          userId: user.user?.id.toString(),
        ),
      );
      eitherFavSequence.fold(
            (seqError) {
          emit(FavoritesInitial());
          emit(FavoritesLoaded(
              favoritesList: originalFavList,
              reportCubitList: originalFavCubitList,
              sequenceList: FavoritesSequenceEntity(
                  id: originalSequenceEntity.id, sequence: originalSeqList),
              error: const FavouriteError(sequence: true)));
        },
            (seq) {
          FavoritesSequenceEntity favoritesSequenceEntity = FavoritesSequenceEntity(
              id: originalSequenceEntity.id, sequence: seqList);
          if (originalSequenceEntity.id == null && seq.id != null) {
            favoritesSequenceEntity = FavoritesSequenceEntity(
              sequence: seqList, id: seq.id, message: seq.message,);
          }
          emit(FavoritesInitial());
          emit(FavoritesLoaded(
              favoritesList: favoritesList,
              reportCubitList: cubitList,
              sequenceList: favoritesSequenceEntity,
              success: const FavouriteSuccess(sequence: true)));
        },
      );
    });
  }
}
