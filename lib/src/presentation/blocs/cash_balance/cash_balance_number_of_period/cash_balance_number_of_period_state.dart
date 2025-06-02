part of 'cash_balance_number_of_period_cubit.dart';

abstract class CashBalanceNumberOfPeriodState extends Equatable {
  final NumberOfPeriodItemData? selectedCashBalanceNumberOfPeriod;
  final List<NumberOfPeriodItemData>? cashBalanceNumberOfPeriodList;
  const CashBalanceNumberOfPeriodState({this.selectedCashBalanceNumberOfPeriod, this.cashBalanceNumberOfPeriodList});

  @override
  List<Object> get props => [];
}

class CashBalanceNumberOfPeriodInitial extends CashBalanceNumberOfPeriodState {}

class CashBalanceNumberOfPeriodLoaded extends CashBalanceNumberOfPeriodState {
  final NumberOfPeriodItemData? selectedNumberOfPeriod;
  final List<NumberOfPeriodItemData>? entityList;
  const CashBalanceNumberOfPeriodLoaded({
    required this.entityList,
    required this.selectedNumberOfPeriod,
  }) :super(selectedCashBalanceNumberOfPeriod: selectedNumberOfPeriod, cashBalanceNumberOfPeriodList: entityList);

  @override
  List<Object> get props => [];
}

class CashBalanceNumberOfPeriodError extends CashBalanceNumberOfPeriodState {
  final AppErrorType errorType;

  const CashBalanceNumberOfPeriodError({
    required this.errorType,
  });
}

class CashBalanceNumberOfPeriodLoading extends CashBalanceNumberOfPeriodState {
  const CashBalanceNumberOfPeriodLoading();
}
