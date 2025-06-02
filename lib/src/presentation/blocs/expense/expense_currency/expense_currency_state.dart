part of 'expense_currency_cubit.dart';

abstract class ExpenseCurrencyState extends Equatable {
  final Currency? selectedExpenseCurrency;
  final List<Currency?>? expenseCurrencyList;
  const ExpenseCurrencyState({this.selectedExpenseCurrency, this.expenseCurrencyList});

  @override
  List<Object> get props => [];
}

class ExpenseCurrencyInitial extends ExpenseCurrencyState {}

class ExpenseCurrencyLoaded extends ExpenseCurrencyState {
  final Currency? selectedCurrency;
  final List<Currency?>? entityList;
  const ExpenseCurrencyLoaded({
    required this.entityList,
    required this.selectedCurrency,
  }) :super(selectedExpenseCurrency: selectedCurrency, expenseCurrencyList: entityList);

  @override
  List<Object> get props => [];
}

class ExpenseCurrencyError extends ExpenseCurrencyState {
  final AppErrorType errorType;

  const ExpenseCurrencyError({
    required this.errorType,
  });
}

class ExpenseCurrencyLoading extends ExpenseCurrencyState {
  const ExpenseCurrencyLoading();
}
