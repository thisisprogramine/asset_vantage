part of 'income_account_cubit.dart';

abstract class IncomeAccountState extends Equatable {
  final List<Account?>? selectedAccountList;
  final List<Account?>? accountList;
  const IncomeAccountState({
    this.selectedAccountList, this.accountList,
  });

  @override
  List<Object> get props => [];
}

class IncomeAccountInitial extends IncomeAccountState {}

class IncomeAccountLoaded extends IncomeAccountState {
  final List<Account?>? selectedIncomeAccountList;
  final List<Account?>? incomeAccountList;
  const IncomeAccountLoaded({
    required this.selectedIncomeAccountList, required this.incomeAccountList,
  })
      : super(accountList: incomeAccountList, selectedAccountList: selectedIncomeAccountList);

  @override
  List<Object> get props => [];
}

class IncomeAccountError extends IncomeAccountState {
  final AppErrorType errorType;

  const IncomeAccountError({
    required this.errorType,
  }) : super();
}

class IncomeAccountLoading extends IncomeAccountState {
  const IncomeAccountLoading()
      : super();
}
