part of 'cash_balance_currency_cubit.dart';

abstract class CashBalanceCurrencyState extends Equatable {
  final Currency? selectedCashBalanceCurrency;
  final List<Currency?>? cashBalanceCurrencyList;
  const CashBalanceCurrencyState({this.selectedCashBalanceCurrency, this.cashBalanceCurrencyList});

  @override
  List<Object> get props => [];
}

class CashBalanceCurrencyInitial extends CashBalanceCurrencyState {}

class CashBalanceCurrencyLoaded extends CashBalanceCurrencyState {
  final Currency? selectedCurrency;
  final List<Currency?>? entityList;
  const CashBalanceCurrencyLoaded({
    required this.entityList,
    required this.selectedCurrency,
  }) :super(selectedCashBalanceCurrency: selectedCurrency, cashBalanceCurrencyList: entityList);

  @override
  List<Object> get props => [];
}

class CashBalanceCurrencyError extends CashBalanceCurrencyState {
  final AppErrorType errorType;

  const CashBalanceCurrencyError({
    required this.errorType,
  });
}

class CashBalanceCurrencyLoading extends CashBalanceCurrencyState {
  const CashBalanceCurrencyLoading();
}
