part of 'investment_policy_statement_report_cubit.dart';

abstract class InvestmentPolicyStatementReportState extends Equatable {

  const InvestmentPolicyStatementReportState();

  @override
  List<Object> get props => [];
}

class InvestmentPolicyStatementReportInitial extends InvestmentPolicyStatementReportState {}

class InvestmentPolicyStatementReportLoaded extends InvestmentPolicyStatementReportState {
  final List<InvestmentPolicyStatementChartData> chartData;

  const InvestmentPolicyStatementReportLoaded({required this.chartData});

  @override
  List<Object> get props => [chartData];
}

class InvestmentPolicyStatementReportError extends InvestmentPolicyStatementReportState {
  final AppErrorType errorType;

  const InvestmentPolicyStatementReportError({
    required this.errorType,
  });
}

class InvestmentPolicyStatementReportLoading extends InvestmentPolicyStatementReportState {
  const InvestmentPolicyStatementReportLoading();
}
