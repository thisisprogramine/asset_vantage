
import 'package:equatable/equatable.dart';

import 'net_worth_chart_data.dart';

class NetWorthReportEntity extends Equatable{
  final List<ReportEntity> report;

  const NetWorthReportEntity({
    required this.report,
  });

  @override
  List<Object?> get props => [report];
}

class ReportEntity extends NetWorthChartData{
  final String startDate;
  final String endDate;
  final double closingValue;
  final double? periodIrrPercent;
  final double? inceptionIrrPercent;
  final double? periodTWRPercent;
  final double? inceptionTWRPercent;
  final String title;
  final List<ReportEntity>? children;

  const ReportEntity({
    this.children,
    required this.closingValue,
    required this.endDate,
    this.inceptionIrrPercent,
    this.inceptionTWRPercent,
    this.periodIrrPercent,
    this.periodTWRPercent,
    required this.startDate,
    required this.title,
  }) : super(
    title: title,
    startDate: startDate,
    periodTWRPercent: periodTWRPercent,
    periodIrrPercent: periodIrrPercent,
    inceptionTWRPercent: inceptionTWRPercent,
    inceptionIrrPercent: inceptionIrrPercent,
    endDate: endDate,
    closingValue: closingValue,
    children: children,
  );
}