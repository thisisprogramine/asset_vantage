import 'package:equatable/equatable.dart';

class NetWorthChartData extends Equatable{
  final String startDate;
  final String endDate;
  final double closingValue;
  final double? periodIrrPercent;
  final double? inceptionIrrPercent;
  final double? periodTWRPercent;
  final double? inceptionTWRPercent;
  final String title;
  final List<NetWorthChartData>? children;

  const NetWorthChartData({
    this.children,
    required this.closingValue,
    required this.endDate,
    this.inceptionIrrPercent,
    this.inceptionTWRPercent,
    this.periodIrrPercent,
    this.periodTWRPercent,
    required this.startDate,
    required this.title,
  });

  @override
  List<Object?> get props => [startDate,endDate,closingValue,periodIrrPercent,periodTWRPercent,inceptionTWRPercent,inceptionIrrPercent,title,children,];
}