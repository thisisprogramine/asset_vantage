import 'package:flutter/cupertino.dart';

import '../../entities/dashboard/dashboard_list_entity.dart';
import '../../entities/performance/performance_primary_grouping_entity.dart';

class PerformanceSecondaryGroupingParam{
  final BuildContext context;
  final EntityData? entity;

  const PerformanceSecondaryGroupingParam({
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