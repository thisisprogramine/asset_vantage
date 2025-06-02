
import 'package:asset_vantage/src/domain/entities/expense/expense_account_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../../domain/params/expense/expense_account_params.dart';
import '../../../../domain/usecases/expense/expense_filter/selected_accounts/get_expense_selected_accounts.dart';
import '../../../../domain/usecases/expense/expense_filter/selected_accounts/save_expense_selected_accounts.dart';
import '../../../../domain/usecases/expense/get_expense_account.dart';
import '../../authentication/login_check/login_check_cubit.dart';

part 'expense_account_state.dart';

class ExpenseAccountCubit extends Cubit<ExpenseAccountState> {
  final GetExpenseAccount getExpenseAccount;
  final GetExpenseSelectedAccounts getExpenseSelectedAccounts;
  final SaveExpenseSelectedAccounts saveExpenseSelectedAccounts;
  final LoginCheckCubit loginCheckCubit;

  ExpenseAccountCubit({
    required this.getExpenseAccount,
    required this.getExpenseSelectedAccounts,
    required this.saveExpenseSelectedAccounts,
    required this.loginCheckCubit,
  }): super(ExpenseAccountInitial());

  Future<void> loadExpenseAccount({
    required BuildContext context,
    List<AccountEntity?>? favoriteAccounts,
    required EntityData? selectedEntity,
    required String? asOnDate,
  }) async {
    emit(ExpenseAccountInitial());

    final Either<AppError, ExpenseAccountEntity>
    eitherExpenseAccount =
    await getExpenseAccount(ExpenseAccountParams(
      context: context,
      entity: selectedEntity,
      asOnDate: asOnDate,
    ));
    final List<AccountEntity?>? savedExpenseAccountItem = favoriteAccounts ?? await getExpenseSelectedAccounts({"entityid": selectedEntity?.id, "entitytype": selectedEntity?.type});


    eitherExpenseAccount.fold((error) {
      if(error.appErrorType==AppErrorType.unauthorised){
        loginCheckCubit.loginCheck();
      }
      emit(ExpenseAccountError(errorType: error.appErrorType));
    }, (expenseAccount) async {

      List<AccountEntity?>? expenseAccountList = expenseAccount.expenseAccounts;
      List<AccountEntity?>? selectedExpenseAccountList = expenseAccount.expenseAccounts;

      if(savedExpenseAccountItem != null && savedExpenseAccountItem.isNotEmpty) {
        selectedExpenseAccountList = expenseAccountList.where((primarySubGroupingItem)
        => savedExpenseAccountItem.any((selectedPrimarySubGroupingItem) =>
        primarySubGroupingItem?.id == selectedPrimarySubGroupingItem?.id)
        ).toList();

        expenseAccountList.removeWhere((primarySubGroupingItem)
        => (selectedExpenseAccountList ?? []).any((selectedPrimarySubGroupingItem) =>
        selectedPrimarySubGroupingItem?.id == primarySubGroupingItem?.id));

        expenseAccount.expenseAccounts = selectedExpenseAccountList + expenseAccountList;
      }

      emit(ExpenseAccountLoaded(
          selectedExpenseAccountList: selectedExpenseAccountList.toSet().toList(),
          expenseAccountList: expenseAccountList.toSet().toList()
      ));
    });
  }

  Future<void> changeSelectedExpenseAccount({required List<AccountEntity?> selectedExpenseAccountList}) async {
    List<AccountEntity?> expenseAccountList = state.accountList ?? [];

    expenseAccountList.removeWhere((item1) => selectedExpenseAccountList.any((item2) => item1?.id == item2?.id));
    expenseAccountList.sort((a, b) => (a?.accountname ?? '').compareTo((b?.accountname ?? '')));

    emit(ExpenseAccountInitial());
    emit(ExpenseAccountLoaded(
        selectedExpenseAccountList: selectedExpenseAccountList,
        expenseAccountList: [...selectedExpenseAccountList.toSet().toList(), ...expenseAccountList.toSet().toList()]
    ));
  }
}
