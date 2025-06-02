
import 'package:asset_vantage/src/domain/entities/investment_policy_statement/chart_data.dart';
import 'package:equatable/equatable.dart';

class InvestmentPolicyStatementReportEntity extends Equatable{
  final List<InvestmentPolicyStatementReportData> report;

  const InvestmentPolicyStatementReportEntity({
    required this.report,
  });

  @override
  List<Object?> get props => [report];
}

class InvestmentPolicyStatementReportData extends InvestmentPolicyStatementChartData{
  final String reportTitle;
  final double allocation;
  final double expectedAllocation;
  final double returnPercent;
  final double benchmark;

  const InvestmentPolicyStatementReportData({
    required this.reportTitle,
    required this.allocation,
    required this.expectedAllocation,
    required this.returnPercent,
    required this.benchmark,
  }) : super(
      title: reportTitle,
      actualAlloc: allocation,
      expectedAlloc: expectedAllocation,
      returnPercent: returnPercent,
      benchmark: benchmark,
  );

  @override
  List<Object?> get props => [];
}