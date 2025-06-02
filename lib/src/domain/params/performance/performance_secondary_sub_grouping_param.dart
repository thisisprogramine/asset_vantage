import 'package:asset_vantage/src/domain/entities/dashboard/dashboard_list_entity.dart';
import 'package:asset_vantage/src/domain/entities/partnership_method/holding_method_entities.dart';
import 'package:flutter/cupertino.dart';
import 'package:asset_vantage/src/domain/entities/performance/performance_primary_sub_grouping_enity.dart';

import '../../entities/partnership_method/partnership_method.dart';
import '../../entities/performance/performance_secondary_grouping_entity.dart';

class PerformanceSecondarySubGroupingParam{
  final BuildContext? context;
  final EntityData? entity;
  final GroupingEntity? primaryGrouping;
  final List<SubGroupingItemData?>? primarySubGroupingItem;
  final String? asOnDate;
  final PartnershipMethodItemData? partnershipMethod;
  final HoldingMethodItemData? holdingMethod;

  const PerformanceSecondarySubGroupingParam(  {
    required this.context,
    this.entity,
    this.primaryGrouping,
    this.primarySubGroupingItem,
    this.asOnDate,
    this.partnershipMethod,
    this.holdingMethod,
  });

  Map<String, dynamic> toJson() {

    List<String> filter4val = [];

    for(int i = 0; i < (primarySubGroupingItem?.length ?? 0); i ++) {

      if(primarySubGroupingItem?[i]?.id != null) {
        filter4val.add(primarySubGroupingItem?[i]?.id ?? '');
      }
    }


    return {
      "0": "filter-subgroups",
      "1": {
        "curFilter": primaryGrouping?.id,
        "entitytype": "${entity?.type?.toLowerCase() == 'group' ? 1 : 0}",
        "entiyid": entity?.type?.toLowerCase() == 'group' ? "${entity?.id}_EntityGroup": entity?.id,
        "filter1val": "13",
        "filter4val": filter4val,
        "fromdate": "2011-12-31",
        "partnershipmethod": partnershipMethod?.value == "None" ? "" : partnershipMethod?.value,
        "reportname": "wealthregister",
        "todate": asOnDate,
        "vehicles": "30,29,3,33,24,47,11,17,42,2,7,15,18,10,48,14,6,31,19,34,13,44,22,32,9,28,4,8,16,1,37,40,39,12,49,50,56",
        "withParthership": holdingMethod?.value  ,  //"Default",
        "reportType": "cummlativeMultPeriodPhase4",
        "IsFilterFlag": 2
      }
    };
  }
}