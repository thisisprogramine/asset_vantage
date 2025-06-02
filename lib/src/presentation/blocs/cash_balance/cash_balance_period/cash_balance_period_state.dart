part of 'cash_balance_period_cubit.dart';

abstract class CashBalancePeriodState extends Equatable {
  final PeriodItemData? selectedCashBalancePeriod;
  final List<PeriodItemData>? cashBalancePeriodList;
  const CashBalancePeriodState({this.selectedCashBalancePeriod, this.cashBalancePeriodList});

  @override
  List<Object> get props => [];
}

class CashBalancePeriodInitial extends CashBalancePeriodState {}

class CashBalancePeriodLoaded extends CashBalancePeriodState {
  final PeriodItemData? selectedPeriod;
  final List<PeriodItemData>? entityList;
  const CashBalancePeriodLoaded({
    required this.entityList,
    required this.selectedPeriod,
  }) :super(selectedCashBalancePeriod: selectedPeriod, cashBalancePeriodList: entityList);

  @override
  List<Object> get props => [];
}

class CashBalancePeriodError extends CashBalancePeriodState {
  final AppErrorType errorType;

  const CashBalancePeriodError({
    required this.errorType,
  });
}

class CashBalancePeriodLoading extends CashBalancePeriodState {
  const CashBalancePeriodLoading();
}
