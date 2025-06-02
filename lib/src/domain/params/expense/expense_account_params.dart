import 'package:flutter/material.dart';

import '../../entities/dashboard/dashboard_list_entity.dart';

class ExpenseAccountParams {
  final BuildContext context;
  final EntityData? entity;
  final String? fromDate;
  final String? asOnDate;
  const ExpenseAccountParams({
    required this.context,
    this.entity,
    this.fromDate,
    this.asOnDate,
  });

  Map<String, dynamic> toJson() => {
    "entity": entity?.name,
    "id": entity?.id,
    "entitytype": entity?.type,
    "fromDate": "2020-01-01",
    "toDate": asOnDate,
  };
}