// class IncomeReportEntity {


import 'package:equatable/equatable.dart';

import 'income_chart_data.dart';

class IncomeReportEntity extends Equatable{
  final List<ReportEntity> report;

  const IncomeReportEntity({
    required this.report,
  });

  @override
  List<Object?> get props => [report];
}

class ReportEntity extends IncomeChartData{
  final String date;
  final List<Child> children;
  final double total;

  const ReportEntity({
    required this.date,
    required this.children,
    required this.total,
  }) : super(
    date: date,
    children: children,
    total: total,
  );
}