import 'package:flutter/cupertino.dart';

import '../../entities/dashboard/dashboard_list_entity.dart';

class NetWorthPrimaryGroupingParam{
  final BuildContext context;
  final EntityData? entity;

  const NetWorthPrimaryGroupingParam({
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