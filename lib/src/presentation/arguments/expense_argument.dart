
import '../../domain/entities/dashboard/dashboard_list_entity.dart';

class ExpenseArgument {
  final int index;
  final EntityData? entityData;
  final String? asOnDate;
  ExpenseArgument({
    this.index = 0,
    required this.entityData,
    required this.asOnDate,
  });
}