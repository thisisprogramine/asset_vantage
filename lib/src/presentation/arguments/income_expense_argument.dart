

import '../../domain/entities/dashboard/dashboard_list_entity.dart';

class IncomeExpenseArgument {
  final int index;
  final EntityData? entityData;
  final String? asOnDate;
  IncomeExpenseArgument({
    this.index = 5,
    required this.entityData,
    required this.asOnDate,
  });
}