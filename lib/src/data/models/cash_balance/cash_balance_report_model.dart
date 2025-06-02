// import 'dart:convert';

import '../../../domain/entities/cash_balance/cash_balance_entity.dart';

class CashBalanceReportModel extends CashBalanceReportEntity{
  final List<Period>? periods;
  final double? totalAmount;

  CashBalanceReportModel({
    this.periods,
    this.totalAmount,
  }) : super(
    periodsList: periods,
    totalAmount: totalAmount
  );

  factory CashBalanceReportModel.fromJson({required Map<dynamic, dynamic> json}) => CashBalanceReportModel(
    periods: json["periods"] == null ? [] : List<Period>.from(json["periods"]!.map((x) => Period.fromJson(x))),
    totalAmount: json["total_amount"]?.toDouble(),
  );

  Map<dynamic, dynamic> toJson() => {
    "periods": periods == null ? [] : List<dynamic>.from(periods!.map((x) => x.toJson())),
    "total_amount": totalAmount,
  };
}

class Period extends CBPeriodEntity {
  final int? year;
  final String? periodStart;
  final String? periodEnd;
  final double? total;
  final List<PrimarySubgroup>? primarySubgroup;

  Period({
    this.year,
    this.periodStart,
    this.periodEnd,
    this.total,
    this.primarySubgroup,
  }) : super(
    year: year,
    periodStart: periodStart,
    periodEnd: periodEnd,
    total: total,
    primarySubgroup: primarySubgroup,
  );

  factory Period.fromJson(Map<dynamic, dynamic> json) => Period(
    year: json["year"],
    periodStart: json["period_start"],
    periodEnd: json["period_end"],
    total: json["total"]?.toDouble(),
    primarySubgroup: json["primary_subgroup"] == null ? [] : List<PrimarySubgroup>.from(json["primary_subgroup"]!.map((x) => PrimarySubgroup.fromJson(x))),
  );

  Map<dynamic, dynamic> toJson() => {
    "year": year,
    "period_start": periodStart,
    "period_end": periodEnd,
    "total": total,
    "primary_subgroup": primarySubgroup == null ? [] : List<dynamic>.from(primarySubgroup!.map((x) => x.toJson())),
  };
}

class PrimarySubgroup extends PrimarySubgroupEntity {
  final String? title;
  final String? entityName;
  final List<Account>? accounts;
  final double? total;

  PrimarySubgroup({
    this.title,
    this.entityName,
    this.accounts,
    this.total,
  }) : super(
    title: title,
    entityName: entityName,
    accounts: accounts,
    total: total,
  );

  factory PrimarySubgroup.fromJson(Map<dynamic, dynamic> json) => PrimarySubgroup(
    title: json["title"],
    entityName: json["entity_name"],
    accounts: json["accounts"] == null ? [] : List<Account>.from(json["accounts"]!.map((x) => Account.fromJson(x))),
    total: json["total"]?.toDouble(),
  );

  Map<dynamic, dynamic> toJson() => {
    "title": title,
    "entity_name": entityName,
    "accounts": accounts == null ? [] : List<dynamic>.from(accounts!.map((x) => x.toJson())),
    "total": total,
  };
}

class Account extends AccountEntity {
  final int? accountId;
  final String? accountName;
  final String? entityName;
  final double? amount;

  Account({
    this.accountId,
    this.accountName,
    this.entityName,
    this.amount,
  }) : super(
    accountId: accountId,
    accountName: accountName,
    entityName: entityName,
    amount: amount,
  );

  factory Account.fromJson(Map<dynamic, dynamic> json) => Account(
    accountId: json["account_id"],
    accountName: json["account_name"],
    entityName: json["entity_name"],
    amount: json["amount"]?.toDouble(),
  );

  Map<dynamic, dynamic> toJson() => {
    "account_id": accountId,
    "account_name": accountName,
    "entity_name": entityName,
    "amount": amount,
  };
}

