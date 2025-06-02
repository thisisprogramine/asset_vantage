part of 'expense_account_cubit.dart';

abstract class ExpenseAccountState extends Equatable {
  final List<AccountEntity?>? selectedAccountList;
  final List<AccountEntity?>? accountList;
  const ExpenseAccountState({
    this.selectedAccountList, this.accountList,
  });

  @override
  List<Object> get props => [];
}

class ExpenseAccountInitial extends ExpenseAccountState {}

class ExpenseAccountLoaded extends ExpenseAccountState {
  final List<AccountEntity?>? selectedExpenseAccountList;
  final List<AccountEntity?>? expenseAccountList;
  const ExpenseAccountLoaded({
    required this.selectedExpenseAccountList, required this.expenseAccountList,
  })
      : super(accountList: expenseAccountList, selectedAccountList: selectedExpenseAccountList);

  @override
  List<Object> get props => [];
}

class ExpenseAccountError extends ExpenseAccountState {
  final AppErrorType errorType;

  const ExpenseAccountError({
    required this.errorType,
  }) : super();
}

class ExpenseAccountLoading extends ExpenseAccountState {
  const ExpenseAccountLoading()
      : super();
}
