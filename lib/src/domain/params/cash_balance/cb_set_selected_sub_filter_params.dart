import 'package:asset_vantage/src/data/models/cash_balance/cash_balance_sub_grouping_model.dart';

class SaveCBSubFilterParams{
  final String? entityName;
  final String? grouping;
  final List<SubGroupingItem>? filter;

  const SaveCBSubFilterParams({
    required this.entityName,
    required this.grouping,
    required this.filter,
  });
}