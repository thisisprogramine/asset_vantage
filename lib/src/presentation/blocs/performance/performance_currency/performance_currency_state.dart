part of 'performance_currency_cubit.dart';

abstract class PerformanceCurrencyState extends Equatable {
  final Currency? selectedPerformanceCurrency;
  final List<Currency?>? performanceCurrencyList;
  const PerformanceCurrencyState({this.selectedPerformanceCurrency, this.performanceCurrencyList});

  @override
  List<Object> get props => [];
}

class PerformanceCurrencyInitial extends PerformanceCurrencyState {}

class PerformanceCurrencyLoaded extends PerformanceCurrencyState {
  final Currency? selectedCurrency;
  final List<Currency?>? entityList;
  const PerformanceCurrencyLoaded({
    required this.entityList,
    required this.selectedCurrency,
  }) :super(selectedPerformanceCurrency: selectedCurrency, performanceCurrencyList: entityList);

  @override
  List<Object> get props => [];
}

class PerformanceCurrencyError extends PerformanceCurrencyState {
  final AppErrorType errorType;

  const PerformanceCurrencyError({
    required this.errorType,
  });
}

class PerformanceCurrencyLoading extends PerformanceCurrencyState {
  const PerformanceCurrencyLoading();
}
