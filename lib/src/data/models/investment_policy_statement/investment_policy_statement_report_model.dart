
import '../../../domain/entities/investment_policy_statement/investment_policy_statement_report_entity.dart';

class InvestmentPolicyStatementReportModel extends InvestmentPolicyStatementReportEntity{
  InvestmentPolicyStatementReportModel({
    this.result,
  }) : super(
    report: result ?? []
  );

  final List<InvestmentPolicyModel>? result;

  factory InvestmentPolicyStatementReportModel.fromJson(Map<dynamic, dynamic> json) => InvestmentPolicyStatementReportModel(
    result: json["result"] == null ? [] : List<InvestmentPolicyModel>.from(json["result"]!.map((x) => InvestmentPolicyModel.fromJson(x))),
  );

  Map<dynamic, dynamic> toJson() => {
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}

class InvestmentPolicyModel extends InvestmentPolicyStatementReportData{
  InvestmentPolicyModel({
    required this.title,
    required this.expectedAllocation,
    required this.actualAllocation,
    required this.returnPercent,
    required this.benchmarkReturn,
  }) : super(
    reportTitle: title ?? '--',
    expectedAllocation: expectedAllocation,
    allocation: actualAllocation,
    returnPercent: returnPercent,
    benchmark: benchmarkReturn

  );

  final String title;
  final double expectedAllocation;
  final double actualAllocation;
  final double returnPercent;
  final double benchmarkReturn;

  factory InvestmentPolicyModel.fromJson(Map<dynamic, dynamic> json) => InvestmentPolicyModel(
    title: json["title"] != null && json["title"] != '-' ? json["title"]! : '--',
    expectedAllocation: json["expectedAllocation"] != null && json["expectedAllocation"] != '-' ? (json["expectedAllocation"] is double ? json["expectedAllocation"] : double.parse('${json["expectedAllocation"]}')) : 0.0,
    actualAllocation: json["actualAllocation"] != null && json["actualAllocation"] != '-' ? (json["actualAllocation"] is double ? json["actualAllocation"] : double.parse('${json["actualAllocation"]}')) : 0.0,
    returnPercent: json["returnPercent"] != null && json["returnPercent"] != '-' ? (json["returnPercent"] is double ? json["returnPercent"] : double.parse('${json["returnPercent"]}')) : 0.0,
    benchmarkReturn: json["benchmarkReturn"] != null && json["benchmarkReturn"] != '-' ? (json["benchmarkReturn"] is double ? json["benchmarkReturn"] : double.parse('${json["benchmarkReturn"]}')) : 0.0,
  );

  Map<dynamic, dynamic> toJson() => {
    "title": title,
    "expectedAllocation": expectedAllocation,
    "actualAllocation": actualAllocation,
    "returnPercent": returnPercent,
    "benchmarkReturn": benchmarkReturn,
  };
}
