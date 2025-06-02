import 'package:equatable/equatable.dart';

class IncomeChartData extends Equatable{
  final String date;
  final List<Child> children;
  final double total;

  const IncomeChartData({
    this.date = '--',
    this.children = const [],
    required this.total
  });

  @override
  List<Object?> get props => [date, children, total];
}

class Child extends Equatable{
  final String accountName;
  final int accountId;
  final double total;
  final double percentage;
  final String accNumber;
  final String currencyData;
  final List<Child> accounts;
  final String date;

  const Child({
    required this.accountName,
    required this.accountId,
    required this.total,
    required this.percentage,
    required this.accounts,
    required this.accNumber,
    required this.currencyData,
    required this.date,
  });

  @override
  List<Object?> get props => [accountName, accountId, total, percentage,accNumber,currencyData,accounts,date];

}