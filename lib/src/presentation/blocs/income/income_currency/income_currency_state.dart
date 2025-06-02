part of 'income_currency_cubit.dart';

abstract class IncomeCurrencyState extends Equatable {
  final Currency? selectedIncomeCurrency;
  final List<Currency?>? incomeCurrencyList;
  const IncomeCurrencyState({this.selectedIncomeCurrency, this.incomeCurrencyList});

  @override
  List<Object> get props => [];
}

class IncomeCurrencyInitial extends IncomeCurrencyState {}

class IncomeCurrencyLoaded extends IncomeCurrencyState {
  final Currency? selectedCurrency;
  final List<Currency?>? entityList;
  const IncomeCurrencyLoaded({
    required this.entityList,
    required this.selectedCurrency,
  }) :super(selectedIncomeCurrency: selectedCurrency, incomeCurrencyList: entityList);

  @override
  List<Object> get props => [];
}

class IncomeCurrencyError extends IncomeCurrencyState {
  final AppErrorType errorType;

  const IncomeCurrencyError({
    required this.errorType,
  });
}

class IncomeCurrencyLoading extends IncomeCurrencyState {
  const IncomeCurrencyLoading();
}
