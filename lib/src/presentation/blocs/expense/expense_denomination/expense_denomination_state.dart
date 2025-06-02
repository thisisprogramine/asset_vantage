part of 'expense_denomination_cubit.dart';

abstract class ExpenseDenominationState extends Equatable {
  final DenominationData? selectedExpenseDenomination;
  final List<DenominationData?>? expenseDenominationList;
  const ExpenseDenominationState({this.selectedExpenseDenomination, this.expenseDenominationList});

  @override
  List<Object> get props => [];
}

class ExpenseDenominationInitial extends ExpenseDenominationState {}

class ExpenseDenominationLoaded extends ExpenseDenominationState {
  final DenominationData? selectedDenomination;
  final List<DenominationData?>? denominationList;
  const ExpenseDenominationLoaded({
    required this.denominationList,
    required this.selectedDenomination,
  }) :super(selectedExpenseDenomination: selectedDenomination, expenseDenominationList: denominationList);

  @override
  List<Object> get props => [];
}

class ExpenseDenominationError extends ExpenseDenominationState {
  final AppErrorType errorType;

  const ExpenseDenominationError({
    required this.errorType,
  });
}

class ExpenseDenominationLoading extends ExpenseDenominationState {
  const ExpenseDenominationLoading();
}
