part of 'net_worth_currency_cubit.dart';

abstract class NetWorthCurrencyState extends Equatable {
  final Currency? selectedNetWorthCurrency;
  final List<Currency?>? netWorthCurrencyList;
  const NetWorthCurrencyState({this.selectedNetWorthCurrency, this.netWorthCurrencyList});

  @override
  List<Object> get props => [];
}

class NetWorthCurrencyInitial extends NetWorthCurrencyState {}

class NetWorthCurrencyLoaded extends NetWorthCurrencyState {
  final Currency? selectedCurrency;
  final List<Currency?>? entityList;
  const NetWorthCurrencyLoaded({
    required this.entityList,
    required this.selectedCurrency,
  }) :super(selectedNetWorthCurrency: selectedCurrency, netWorthCurrencyList: entityList);

  @override
  List<Object> get props => [];
}

class NetWorthCurrencyError extends NetWorthCurrencyState {
  final AppErrorType errorType;

  const NetWorthCurrencyError({
    required this.errorType,
  });
}

class NetWorthCurrencyLoading extends NetWorthCurrencyState {
  const NetWorthCurrencyLoading();
}
