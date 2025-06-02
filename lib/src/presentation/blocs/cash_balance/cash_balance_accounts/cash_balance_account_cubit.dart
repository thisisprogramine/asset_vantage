


import 'package:asset_vantage/src/domain/entities/cash_balance/cash_balance_sub_grouping_entity.dart';
import 'package:asset_vantage/src/domain/usecases/cash_balance/cash_balance_filters/accounts/get_cash_balance_accounts.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/cash_balance/cash_balance_sub_grouping_model.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/cash_balance/cash_balance_grouping_entity.dart';
import '../../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../../domain/params/cash_balance/cash_balance_account_params.dart';
import '../../../../domain/params/cash_balance/cash_balance_sub_grouping_params.dart';
import '../../../../domain/usecases/cash_balance/cash_balance_filters/accounts/get_cash_balance_selected_accounts.dart';
import '../../../../domain/usecases/cash_balance/cash_balance_filters/accounts/save_cb_selected_sub_groups.dart';
import '../../../../domain/usecases/cash_balance/cash_balance_filters/sub_grouping/get_cash_balance_sub_grouping.dart';
import '../../authentication/login_check/login_check_cubit.dart';

part 'cash_balance_account_state.dart';

class CashBalanceAccountCubit extends Cubit<CashBalanceAccountState> {
  final GetCashBalanceAccounts getCashBalanceAccounts;
  final GetCashBalanceSelectedAccounts getCashBalanceSelectedAccounts;
  final SaveCashBalanceSelectedAccounts saveCashBalanceSelectedAccounts;
  final LoginCheckCubit loginCheckCubit;

  CashBalanceAccountCubit({
    required this.getCashBalanceAccounts,
    required this.getCashBalanceSelectedAccounts,
    required this.saveCashBalanceSelectedAccounts,
    required this.loginCheckCubit,
  }): super(CashBalanceAccountInitial());


  Future<void> loadCashBalanceAccounts({
    required BuildContext? context,
    required String tileName,
    required EntityData? selectedEntity,
    required GroupingEntity? primaryGrouping,
    required List<SubGroupingItemData?>? primarySubGrouping,
    required String? asOnDate,
    List<SubGroupingItem?>? favoriteAccount
  }) async {
    emit(const CashBalanceAccountLoading());

    final Either<AppError, CashBalanceSubGroupingEntity>
    eitherCashBalanceAccounts =
    await getCashBalanceAccounts(CashBalanceAccountParams(
      context: context,
      entity: selectedEntity,
      primaryGrouping: primaryGrouping,
      primarySubGrouping: primarySubGrouping,
      asOnDate: asOnDate,
    ));
    final List<SubGroupingItem?>? savedAccounts = favoriteAccount ?? await getCashBalanceSelectedAccounts(tileName,{"entityid": selectedEntity?.id, "entitytype": selectedEntity?.type, "id": "${primaryGrouping?.id}"});

    eitherCashBalanceAccounts.fold((error) {
      if(error.appErrorType==AppErrorType.unauthorised){
        loginCheckCubit.loginCheck();
      }
      emit(CashBalanceAccountError(errorType: error.appErrorType));
    }, (accounts) async {

      List<SubGroupingItemData?>? accountsList = accounts.subGroupingList;
      List<SubGroupingItemData?>? selectedAccountsList = accounts.subGroupingList;

      if(savedAccounts != null && savedAccounts.isNotEmpty) {
        selectedAccountsList = accountsList.where((accountsItem)
        => savedAccounts.any((selectedAccountsItem) =>
        accountsItem?.id == selectedAccountsItem?.id)
        ).toList();

        accountsList.removeWhere((accountsItem)
        => (selectedAccountsList ?? []).any((selectedAccountsItem) =>
        selectedAccountsItem?.id == accountsItem?.id));

        accounts.subGroupingList = selectedAccountsList + accountsList;
      }

      emit(CashBalanceAccountLoaded(
        selectedSecondaryAccountList: selectedAccountsList,
          secondaryAccountList: accounts.subGroupingList.toSet().toList(),
      ));
    });
  }

  Future<void> changeSelectedCashBalanceAccounts({required List<SubGroupingItemData?> selectedAccounts}) async {
    List<SubGroupingItemData?> accountsList = state.selectedAccountsList ?? [];

    accountsList.removeWhere((item1) => selectedAccounts.any((item2) => item1?.id == item2?.id));
    accountsList.sort((a, b) => (a?.name ?? '').compareTo((b?.name ?? '')));

    emit(CashBalanceAccountInitial());
    emit(CashBalanceAccountLoaded(
      selectedSecondaryAccountList: selectedAccounts,
        secondaryAccountList: [...selectedAccounts.toSet().toList(), ...accountsList.toSet().toList()],
    ));
  }
}
