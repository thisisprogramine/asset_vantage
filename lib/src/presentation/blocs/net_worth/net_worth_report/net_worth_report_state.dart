part of 'net_worth_report_cubit.dart';

abstract class NetWorthReportState extends Equatable {
  const NetWorthReportState();

  @override
  List<Object> get props => [];
}

class NetWorthReportInitial extends NetWorthReportState {}

class NetWorthReportLoaded extends NetWorthReportState {
  final List<NetWorthChartData> chartData;
  const NetWorthReportLoaded({
    required this.chartData
  });

  @override
  List<Object> get props => [chartData];
}

class NetWorthReportError extends NetWorthReportState {
  final AppErrorType errorType;

  const NetWorthReportError({
    required this.errorType,
  });
}

class NetWorthReportLoading extends NetWorthReportState {
  const NetWorthReportLoading();
}

