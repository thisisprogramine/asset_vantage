part of 'expense_report_cubit.dart';

abstract class ExpenseReportState extends Equatable {

  const ExpenseReportState();

  @override
  List<Object> get props => [];
}

class ExpenseReportInitial extends ExpenseReportState {}

class ExpenseReportLoaded extends ExpenseReportState {
  final List<ExpenseChartData> chartData;

  const ExpenseReportLoaded({required this.chartData});

  @override
  List<Object> get props => [chartData];
}

class ExpenseReportError extends ExpenseReportState {
  final AppErrorType errorType;

  const ExpenseReportError({
    required this.errorType,
  });
}

class ExpenseReportLoading extends ExpenseReportState {
  const ExpenseReportLoading();
}
