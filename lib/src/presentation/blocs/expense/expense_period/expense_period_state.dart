part of 'expense_period_cubit.dart';

abstract class ExpensePeriodState extends Equatable {
  final PeriodItemData? selectedExpensePeriod;
  final List<PeriodItemData?>? expensePeriodList;
  const ExpensePeriodState({this.selectedExpensePeriod, this.expensePeriodList});

  @override
  List<Object> get props => [];
}

class ExpensePeriodInitial extends ExpensePeriodState {}

class ExpensePeriodLoaded extends ExpensePeriodState {
  final PeriodItemData? selectedPeriod;
  final List<PeriodItemData?>? entityList;
  const ExpensePeriodLoaded({
    required this.entityList,
    required this.selectedPeriod,
  }) :super(selectedExpensePeriod: selectedPeriod, expensePeriodList: entityList);

  @override
  List<Object> get props => [];
}

class ExpensePeriodError extends ExpensePeriodState {
  final AppErrorType errorType;

  const ExpensePeriodError({
    required this.errorType,
  });
}

class ExpensePeriodLoading extends ExpensePeriodState {
  const ExpensePeriodLoading();
}
