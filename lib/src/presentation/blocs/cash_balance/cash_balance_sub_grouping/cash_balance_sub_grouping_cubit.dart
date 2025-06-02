


import 'dart:developer';

import 'package:asset_vantage/src/domain/entities/cash_balance/cash_balance_sub_grouping_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/cash_balance/cash_balance_sub_grouping_model.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/cash_balance/cash_balance_grouping_entity.dart';
import '../../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../../domain/params/cash_balance/cash_balance_sub_grouping_params.dart';
import '../../../../domain/usecases/cash_balance/cash_balance_filters/sub_grouping/get_cash_balance_selected_sub_grouping.dart';
import '../../../../domain/usecases/cash_balance/cash_balance_filters/sub_grouping/get_cash_balance_sub_grouping.dart';
import '../../../../domain/usecases/cash_balance/cash_balance_filters/sub_grouping/save_cash_balance_selected_sub_grouping.dart';
import '../../authentication/login_check/login_check_cubit.dart';

part 'cash_balance_sub_grouping_state.dart';

class CashBalancePrimarySubGroupingCubit extends Cubit<CashBalancePrimarySubGroupingState> {
  final GetCashBalanceSubGrouping getCashBalanceSubGrouping;
  final GetCashBalanceSelectedPrimarySubGrouping getCashBalanceSelectedPrimarySubGrouping;
  final SaveCashBalanceSelectedPrimarySubGrouping saveCashBalanceSelectedPrimarySubGrouping;
  final LoginCheckCubit loginCheckCubit;

  CashBalancePrimarySubGroupingCubit({
    required this.getCashBalanceSubGrouping,
    required this.getCashBalanceSelectedPrimarySubGrouping,
    required this.saveCashBalanceSelectedPrimarySubGrouping,
    required this.loginCheckCubit,
  }): super(CashBalancePrimarySubGroupingInitial());

  Future<void> loadCashBalancePrimarySubGrouping({
    required BuildContext? context,
    required String tileName,
    required EntityData? selectedEntity,
    required GroupingEntity? selectedGrouping,
    required String? asOnDate,
    List<SubGroupingItem?>? favoriteSubGroupingItemList
  }) async {
    emit(const CashBalancePrimarySubGroupingLoading());
    final Either<AppError, CashBalanceSubGroupingEntity>
    eitherCashBalancePrimarySubGrouping =
    await getCashBalanceSubGrouping(CashBalanceSubGroupingParam(
      context: context,
      entity: selectedEntity,
      primaryGrouping: selectedGrouping,
      asOnDate: asOnDate,
    ));
    final List<SubGroupingItem?>? savedSubGroupingItem = favoriteSubGroupingItemList ?? await getCashBalanceSelectedPrimarySubGrouping(tileName,{"entityid": selectedEntity?.id, "entitytype": selectedEntity?.type, "id": selectedGrouping?.id});
    log("savedSubgrpItems:${savedSubGroupingItem?.length}");

    eitherCashBalancePrimarySubGrouping.fold((error) {
      if(error.appErrorType==AppErrorType.unauthorised){
        loginCheckCubit.loginCheck();
      }
      emit(CashBalancePrimarySubGroupingError(errorType: error.appErrorType));
    }, (primarySubGrouping) async {

      List<SubGroupingItemData?>? primarySubGroupingList = primarySubGrouping.subGroupingList;
      List<SubGroupingItemData?>? selectedPrimarySubGroupingList = primarySubGrouping.subGroupingList;

      if(savedSubGroupingItem != null && savedSubGroupingItem.isNotEmpty) {
        selectedPrimarySubGroupingList = primarySubGroupingList.where((primarySubGroupingItem)
        => savedSubGroupingItem.any((selectedPrimarySubGroupingItem) =>
        primarySubGroupingItem?.id == selectedPrimarySubGroupingItem?.id)
        ).toList();

        primarySubGroupingList.removeWhere((primarySubGroupingItem)
        => (selectedPrimarySubGroupingList ?? []).any((selectedPrimarySubGroupingItem) =>
        selectedPrimarySubGroupingItem?.id == primarySubGroupingItem?.id));

        primarySubGrouping.subGroupingList = selectedPrimarySubGroupingList + primarySubGroupingList;
      }

      emit(CashBalancePrimarySubGroupingLoaded(
          selectedSecondarySubGroupingList: selectedPrimarySubGroupingList,
          secondarySubGroupingList: primarySubGrouping.subGroupingList.toSet().toList()
      ));
    });
  }

  Future<void> changeSelectedCashBalancePrimarySubGrouping({required List<SubGroupingItemData?> selectedSubGroupingList}) async {
    List<SubGroupingItemData?> primarySubGroupingList = state.subGroupingList ?? [];

    primarySubGroupingList.removeWhere((item1) => selectedSubGroupingList.any((item2) => item1?.id == item2?.id));
    primarySubGroupingList.sort((a, b) => (a?.name ?? '').compareTo((b?.name ?? '')));

    emit(CashBalancePrimarySubGroupingInitial());
    emit(CashBalancePrimarySubGroupingLoaded(
        selectedSecondarySubGroupingList: selectedSubGroupingList,
        secondarySubGroupingList: [...selectedSubGroupingList.toSet().toList(), ...primarySubGroupingList.toSet().toList()]
    ));
  }
}
