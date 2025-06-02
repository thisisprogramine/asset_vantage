part of 'cash_balance_report_cubit.dart';

abstract class CashBalanceReportState extends Equatable {

  const CashBalanceReportState();

  @override
  List<Object> get props => [];
}

class CashBalanceReportInitial extends CashBalanceReportState {}

class CashBalanceReportLoaded extends CashBalanceReportState {
  final CashBalanceReportEntity chartData;

  const CashBalanceReportLoaded({required this.chartData});

  @override
  List<Object> get props => [chartData];
}

class CashBalanceReportError extends CashBalanceReportState {
  final AppErrorType errorType;

  const CashBalanceReportError({
    required this.errorType,
  });
}

class CashBalanceReportLoading extends CashBalanceReportState {
  const CashBalanceReportLoading();
}
