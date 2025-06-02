
import 'package:asset_vantage/src/domain/entities/cash_balance/cash_balance_chart_data.dart';
import 'package:equatable/equatable.dart';

class CashBalanceReportEntity extends Equatable {
  final List<CBPeriodEntity>? periodsList;
  final double? totalAmount;

  const CashBalanceReportEntity({
    this.periodsList,
    this.totalAmount,
  });

  @override
  List<Object?> get props => [periodsList, totalAmount];
}

class CBPeriodEntity {
  final int? year;
  final String? periodStart;
  final String? periodEnd;
  final double? total;
  final List<PrimarySubgroupEntity>? primarySubgroup;

  CBPeriodEntity({
    this.year,
    this.periodStart,
    this.periodEnd,
    this.total,
    this.primarySubgroup,
  });

  factory CBPeriodEntity.fromJson(Map<dynamic, dynamic> json) => CBPeriodEntity(
    year: json["year"],
    periodStart: json["period_start"],
    periodEnd: json["period_end"],
    total: json["total"]?.toDouble(),
    primarySubgroup: json["primary_subgroup"] == null ? [] : List<PrimarySubgroupEntity>.from(json["primary_subgroup"]!.map((x) => PrimarySubgroupEntity.fromJson(x))),
  );

}

class PrimarySubgroupEntity {
  final String? title;
  final String? entityName;
  final List<AccountEntity>? accounts;
  final double? total;

  PrimarySubgroupEntity({
    this.title,
    this.entityName,
    this.accounts,
    this.total,
  });

  factory PrimarySubgroupEntity.fromJson(Map<dynamic, dynamic> json) => PrimarySubgroupEntity(
    title: json["title"],
    entityName: json["entity_name"],
    accounts: json["accounts"] == null ? [] : List<AccountEntity>.from(json["accounts"]!.map((x) => AccountEntity.fromJson(x))),
    total: json["total"]?.toDouble(),
  );
}

class AccountEntity {
  final int? accountId;
  final String? accountName;
  final String? entityName;
  final double? amount;

  AccountEntity({
    this.accountId,
    this.accountName,
    this.entityName,
    this.amount,
  });

  factory AccountEntity.fromJson(Map<dynamic, dynamic> json) => AccountEntity(
    accountId: json["account_id"],
    accountName: json["account_name"],
    entityName: json["entity_name"],
    amount: json["amount"]?.toDouble(),
  );
}