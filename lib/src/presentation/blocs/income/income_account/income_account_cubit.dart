
import 'package:asset_vantage/src/domain/usecases/income/income_filter/selected_accounts/get_income_selected_accounts.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../../domain/entities/income/income_account_entity.dart';
import '../../../../domain/params/income/income_account_params.dart';
import '../../../../domain/usecases/income/get_income_account.dart';
import '../../../../domain/usecases/income/income_filter/selected_accounts/save_income_selected_accounts.dart';
import '../../authentication/login_check/login_check_cubit.dart';

part 'income_account_state.dart';

class IncomeAccountCubit extends Cubit<IncomeAccountState> {
  final GetIncomeAccount getIncomeAccount;
  final GetIncomeSelectedAccounts getIncomeSelectedAccounts;
  final SaveIncomeSelectedAccounts saveIncomeSelectedAccounts;
  final LoginCheckCubit loginCheckCubit;

  IncomeAccountCubit({
    required this.getIncomeAccount,
    required this.getIncomeSelectedAccounts,
    required this.saveIncomeSelectedAccounts,
    required this.loginCheckCubit,
  }): super(IncomeAccountInitial());

  Future<void> loadIncomeAccount({
    required BuildContext context,
    List<Account?>? favoriteAccounts,
    required EntityData? selectedEntity,
    required String? asOnDate,
  }) async {
    emit(IncomeAccountInitial());

    final Either<AppError, IncomeAccountEntity>
    eitherIncomeAccount =
    await getIncomeAccount(IncomeAccountParams(
      context: context,
      entity: selectedEntity,
      asOnDate: asOnDate,
    ));
    final List<Account?>? savedIncomeAccountItem = favoriteAccounts ?? await getIncomeSelectedAccounts({"entityid": selectedEntity?.id, "entitytype": selectedEntity?.type});


    eitherIncomeAccount.fold((error) {
      if(error.appErrorType==AppErrorType.unauthorised){
        loginCheckCubit.loginCheck();
      }
      emit(IncomeAccountError(errorType: error.appErrorType));
    }, (incomeAccount) async {

      List<Account?>? incomeAccountList = incomeAccount.incomeAccounts;
      List<Account?>? selectedIncomeAccountList = incomeAccount.incomeAccounts;

      if(savedIncomeAccountItem != null && savedIncomeAccountItem.isNotEmpty) {
        selectedIncomeAccountList = incomeAccountList.where((primarySubGroupingItem)
        => savedIncomeAccountItem.any((selectedPrimarySubGroupingItem) =>
        primarySubGroupingItem?.id == selectedPrimarySubGroupingItem?.id)
        ).toList();

        incomeAccountList.removeWhere((primarySubGroupingItem)
        => (selectedIncomeAccountList ?? []).any((selectedPrimarySubGroupingItem) =>
        selectedPrimarySubGroupingItem?.id == primarySubGroupingItem?.id));

        incomeAccount.incomeAccounts = selectedIncomeAccountList + incomeAccountList;
      }

      emit(IncomeAccountLoaded(
          selectedIncomeAccountList: selectedIncomeAccountList.toSet().toList(),
          incomeAccountList: incomeAccountList.toSet().toList()
      ));
    });
  }

  Future<void> changeSelectedIncomeAccount({required List<Account?> selectedIncomeAccountList}) async {
    List<Account?> incomeAccountList = state.accountList ?? [];

    incomeAccountList.removeWhere((item1) => selectedIncomeAccountList.any((item2) => item1?.id == item2?.id));
    incomeAccountList.sort((a, b) => (a?.accountname ?? '').compareTo((b?.accountname ?? '')));

    emit(IncomeAccountInitial());
    emit(IncomeAccountLoaded(
        selectedIncomeAccountList: selectedIncomeAccountList,
        incomeAccountList: [...selectedIncomeAccountList.toSet().toList(), ...incomeAccountList.toSet().toList()]
    ));
  }
}
