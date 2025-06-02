
import 'dart:developer';

import 'package:asset_vantage/src/domain/usecases/cash_balance/cash_balance_filters/primary_grouping/get_cash_balance_selected_grouping.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/cash_balance/cash_balance_grouping_model.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/cash_balance/cash_balance_grouping_entity.dart';
import '../../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../../domain/params/cash_balance/cash_balance_primary_grouping_params.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/usecases/cash_balance/cash_balance_filters/primary_grouping/save_cash_balance_selected_grouping.dart';
import '../../../../domain/usecases/cash_balance/clear_cash_balance.dart';
import '../../../../domain/usecases/cash_balance/cash_balance_filters/primary_grouping/get_cash_balance_grouping.dart';
import '../../authentication/login_check/login_check_cubit.dart';

part 'cash_balance_grouping_state.dart';

class CashBalancePrimaryGroupingCubit extends Cubit<CashBalancePrimaryGroupingState> {
  final GetCashBalanceGrouping getCashBalanceGrouping;
  final GetCashBalanceSelectedPrimaryGrouping getCashBalanceSelectedPrimaryGrouping;
  final SaveCashBalanceSelectedPrimaryGrouping saveCashBalanceSelectedPrimaryGrouping;
  final ClearCashBalance clearCashBalance;
  final LoginCheckCubit loginCheckCubit;


  CashBalancePrimaryGroupingCubit({
    required this.getCashBalanceGrouping,
    required this.getCashBalanceSelectedPrimaryGrouping,
    required this.saveCashBalanceSelectedPrimaryGrouping,
    required this.clearCashBalance,
    required this.loginCheckCubit,
  })
      : super(CashBalancePrimaryGroupingInitial());

  Future<void> loadCashBalancePrimaryGrouping({required BuildContext context, bool shouldClearData = false, required EntityData? selectedEntity, required String? asOnDate, required String? tileName, PrimaryGrouping? favoritePrimaryGrouping}) async {
    emit(const CashBalancePrimaryGroupingLoading());

    if(shouldClearData) {
      await clearCashBalance(NoParams());
    }

    final Either<AppError, CashBalanceGroupingEntity>
    eitherPerformancePrimaryGrouping =
    await getCashBalanceGrouping(CashBalancePrimaryGroupingParam(
      context: context,
        entity: selectedEntity
    ));
    final PrimaryGrouping? savedPrimaryGrouping = favoritePrimaryGrouping ?? await getCashBalanceSelectedPrimaryGrouping(tileName,selectedEntity);

    eitherPerformancePrimaryGrouping.fold(
          (error) {
        if(error.appErrorType==AppErrorType.unauthorised){
          loginCheckCubit.loginCheck();
        }
        return emit(CashBalancePrimaryGroupingError(
            errorType: error.appErrorType));
      },
          (cashBalanceGrouping) async{

        List<GroupingEntity?>? primaryGroupingList = cashBalanceGrouping.grouping;
        GroupingEntity? selectedPrimaryGrouping = cashBalanceGrouping.grouping.isNotEmpty ? cashBalanceGrouping.grouping.first : null;

        if(savedPrimaryGrouping != null) {
          selectedPrimaryGrouping = primaryGroupingList.firstWhere((primaryGrouping) => primaryGrouping?.id == savedPrimaryGrouping.id);
          primaryGroupingList.removeWhere((primaryGrouping) => primaryGrouping?.id == selectedPrimaryGrouping?.id);
          primaryGroupingList.insert(0, selectedPrimaryGrouping);
        }
        emit(CashBalancePrimaryGroupingLoaded(
            selectedPrimaryGrouping: selectedPrimaryGrouping,
            primaryGroupingList: primaryGroupingList.toSet().toList()
        ));
      },
    );
  }

  Future<void> changeSelectedCashBalancePrimaryGrouping({GroupingEntity? selectedGrouping}) async {
    List<GroupingEntity?> primaryGroupingList = state.groupingList ?? [];

    primaryGroupingList.remove(selectedGrouping);
    primaryGroupingList.sort((a, b) => (a?.name ?? '').compareTo((b?.name ?? '')));
    primaryGroupingList.insert(0, selectedGrouping);

    emit(CashBalancePrimaryGroupingInitial());
    emit(CashBalancePrimaryGroupingLoaded(
        selectedPrimaryGrouping: selectedGrouping,
        primaryGroupingList: primaryGroupingList.toSet().toList()
    ));
  }
}
