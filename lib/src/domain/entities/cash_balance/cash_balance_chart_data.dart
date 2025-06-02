import 'package:equatable/equatable.dart';

class CashBalanceChartData extends Equatable {
  final String startDate;
  final String endDate;
  final double closingValue;
  final String title;
  final String? entity;
  final String? accountNumber;
  final List<CashBalanceChartData>? children;

  const CashBalanceChartData({
    this.children,
    required this.closingValue,
    required this.endDate,
    required this.startDate,
    required this.title,
    this.entity,
    this.accountNumber
  });

  @override
  List<Object?> get props => [startDate,endDate,closingValue,title,children,accountNumber];
}