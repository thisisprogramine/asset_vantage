part of 'cash_balance_account_cubit.dart';

abstract class CashBalanceAccountState extends Equatable {
  final List<SubGroupingItemData?>? selectedAccountsList;
  final List<SubGroupingItemData?>? accountList;
  const CashBalanceAccountState({
    this.selectedAccountsList, this.accountList,
  });

  @override
  List<Object> get props => [];
}

class CashBalanceAccountInitial extends CashBalanceAccountState {}

class CashBalanceAccountLoaded extends CashBalanceAccountState {
  final List<SubGroupingItemData?>? selectedSecondaryAccountList;
  final List<SubGroupingItemData?>? secondaryAccountList;
  const CashBalanceAccountLoaded({
    required this.selectedSecondaryAccountList, required this.secondaryAccountList,
  })
      : super(selectedAccountsList: selectedSecondaryAccountList, accountList: secondaryAccountList);

  @override
  List<Object> get props => [];
}

class CashBalanceAccountError extends CashBalanceAccountState {
  final AppErrorType errorType;

  const CashBalanceAccountError({
    required this.errorType,
  }) : super();
}

class CashBalanceAccountLoading extends CashBalanceAccountState {
  const CashBalanceAccountLoading()
      : super();
}
