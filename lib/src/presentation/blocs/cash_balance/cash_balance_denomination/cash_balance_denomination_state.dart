part of 'cash_balance_denomination_cubit.dart';

abstract class CashBalanceDenominationState extends Equatable {
  final DenominationData? selectedCashBalanceDenomination;
  final List<DenominationData?>? cashBalanceDenominationList;
  const CashBalanceDenominationState({this.selectedCashBalanceDenomination, this.cashBalanceDenominationList});

  @override
  List<Object> get props => [];
}

class CashBalanceDenominationInitial extends CashBalanceDenominationState {}

class CashBalanceDenominationLoaded extends CashBalanceDenominationState {
  final DenominationData? selectedDenomination;
  final List<DenominationData?>? entityList;
  const CashBalanceDenominationLoaded({
    required this.entityList,
    required this.selectedDenomination,
  }) :super(selectedCashBalanceDenomination: selectedDenomination, cashBalanceDenominationList: entityList);

  @override
  List<Object> get props => [];
}

class CashBalanceDenominationError extends CashBalanceDenominationState {
  final AppErrorType errorType;

  const CashBalanceDenominationError({
    required this.errorType,
  });
}

class CashBalanceDenominationLoading extends CashBalanceDenominationState {
  const CashBalanceDenominationLoading();
}
