part of 'income_report_cubit.dart';

abstract class IncomeReportState extends Equatable {

  const IncomeReportState();

  @override
  List<Object> get props => [];
}

class IncomeReportInitial extends IncomeReportState {}

class IncomeReportLoaded extends IncomeReportState {
  final List<IncomeChartData> chartData;

  const IncomeReportLoaded({required this.chartData});

  @override
  List<Object> get props => [chartData];
}

class IncomeReportError extends IncomeReportState {
  final AppErrorType errorType;

  const IncomeReportError({
    required this.errorType,
  });
}

class IncomeReportLoading extends IncomeReportState {
  const IncomeReportLoading();
}
