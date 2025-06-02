
import 'package:flutter/material.dart';

import '../../../data/models/cash_balance/cash_balance_sub_grouping_model.dart';
import '../../entities/cash_balance/cash_balance_grouping_entity.dart';
import '../../entities/cash_balance/cash_balance_sub_grouping_entity.dart';
import '../../entities/dashboard/dashboard_list_entity.dart';

class CashBalanceAccountParams{
  final BuildContext? context;
  final EntityData? entity;
  final GroupingEntity? primaryGrouping;
  final List<SubGroupingItemData?>? primarySubGrouping;
  final String? asOnDate;

  const CashBalanceAccountParams({
    required this.context,
    this.entity,
    this.primaryGrouping,
    this.primarySubGrouping,
    this.asOnDate,
  });

  Map<String, dynamic> toJson() {

    List<String> subGroups = [];
    primarySubGrouping
        ?.forEach((grp) {
          print("primarySubGrouping: ${grp?.id}");
          if(grp?.id != null) {
            subGroups.add(grp?.id ?? '');
          }
    });

    return {
      "0": "filter-subgroups",
      "1": {
        "curFilter": "6",
        "entitytype": "${entity?.type?.toLowerCase() == 'group' ? 1 : 0}",
        "entiyid": entity?.type?.toLowerCase() == 'group' ? "${entity?.id}_EntityGroup": entity?.id,
        "filter1val": primaryGrouping?.id,
        "filter4val": subGroups,
        "fromdate": "2011-12-31",
        "partnershipmethod": "",
        "reportname": "wealthregister",
        "todate": asOnDate,
        "vehicles": "30,29,3,33,24,47,11,17,42,2,7,15,18,10,48,14,6,31,19,34,13,44,22,32,9,28,4,8,16,1,37,40,39,12,49,50,56",
        "withParthership": "Default",
        "reportType": "cummlativeMultPeriodPhase4",
        "IsFilterFlag": 2,
        "investmentSubFilter": ["29"],
        "investmentUniverseFilter": "4"
      }
    };
  }
}