part of 'expense_number_of_period_cubit.dart';

abstract class ExpenseNumberOfPeriodState extends Equatable {
  final NumberOfPeriodItemData? selectedExpenseNumberOfPeriod;
  final List<NumberOfPeriodItemData?>? expenseNumberOfPeriodList;
  const ExpenseNumberOfPeriodState({this.selectedExpenseNumberOfPeriod, this.expenseNumberOfPeriodList});

  @override
  List<Object> get props => [];
}

class ExpenseNumberOfPeriodInitial extends ExpenseNumberOfPeriodState {}

class ExpenseNumberOfPeriodLoaded extends ExpenseNumberOfPeriodState {
  final NumberOfPeriodItemData? selectedNumberOfPeriod;
  final List<NumberOfPeriodItemData?>? entityList;
  const ExpenseNumberOfPeriodLoaded({
    required this.entityList,
    required this.selectedNumberOfPeriod,
  }) :super(selectedExpenseNumberOfPeriod: selectedNumberOfPeriod, expenseNumberOfPeriodList: entityList);

  @override
  List<Object> get props => [];
}

class ExpenseNumberOfPeriodError extends ExpenseNumberOfPeriodState {
  final AppErrorType errorType;

  const ExpenseNumberOfPeriodError({
    required this.errorType,
  });
}

class ExpenseNumberOfPeriodLoading extends ExpenseNumberOfPeriodState {
  const ExpenseNumberOfPeriodLoading();
}
