import 'package:flutter/material.dart';

import '../../entities/dashboard/dashboard_list_entity.dart';

class CashBalancePrimaryGroupingParam{
  final BuildContext context;
  final EntityData? entity;

  const CashBalancePrimaryGroupingParam({
    required this.context,
    this.entity,
  });

  Map<String, dynamic> toJson() {
    return {
      "0": {
        "entiyid": entity?.id,
        "entitytype": "${entity?.type?.toLowerCase() == 'group' ? 1 : 0}",
      },
      "1": {"0":"filters"}
    };
  }
}