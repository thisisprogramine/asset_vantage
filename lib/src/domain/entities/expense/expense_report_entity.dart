// class ExpenseReportEntity {


import 'package:equatable/equatable.dart';

import 'expense_chart_data.dart';

class ExpenseReportEntity extends Equatable{
  final List<ReportEntity> report;

  const ExpenseReportEntity({
    required this.report,
  });

  @override
  List<Object?> get props => [report];
}

class ReportEntity extends ExpenseChartData{
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