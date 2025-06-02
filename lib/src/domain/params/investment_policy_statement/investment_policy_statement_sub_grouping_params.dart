import 'package:flutter/cupertino.dart';

class InvestmentPolicyStatementSubGroupingParams{
  final BuildContext context;
  final String? entity;
  final String? id;
  final String? entitytype;
  final String? subgrouping;

  const InvestmentPolicyStatementSubGroupingParams({
    required this.context,
    required this.entity,
    required this.id,
    required this.entitytype,
    required this.subgrouping
  });

  Map<String, dynamic> toJson() {
    return {
      'entity': entity,
      'id': id,
      'entitytype': entitytype,
      'subgrouping': subgrouping
    };
  }
}