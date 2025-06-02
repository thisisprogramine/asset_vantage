

import '../../domain/entities/dashboard/dashboard_list_entity.dart';

class InvestmentPolicyStatementArgument {
  final int index;
  final EntityData? entityData;
  final String? asOnDate;
  InvestmentPolicyStatementArgument({
    this.index = 0,
    required this.entityData,
    required this.asOnDate,
  });
}