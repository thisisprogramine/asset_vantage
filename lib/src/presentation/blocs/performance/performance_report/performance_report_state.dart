part of 'performance_report_cubit.dart';

abstract class PerformanceReportState extends Equatable {
  const PerformanceReportState();

  @override
  List<Object> get props => [];
}

class PerformanceReportInitial extends PerformanceReportState {}

class PerformanceReportLoaded extends PerformanceReportState {
  final PerformanceReportEntity chartData;

  const PerformanceReportLoaded({required this.chartData});

  @override
  List<Object> get props => [chartData];
}

class PerformanceReportError extends PerformanceReportState {
  final AppErrorType errorType;

  const PerformanceReportError({
    required this.errorType,
  });
}

class PerformanceReportLoading extends PerformanceReportState {
  const PerformanceReportLoading();
}
