import 'package:asset_vantage/src/domain/entities/partnership_method/holding_method_entities.dart';
import 'package:flutter/cupertino.dart';

import '../../entities/dashboard/dashboard_list_entity.dart';
import '../../entities/partnership_method/partnership_method.dart';
import '../../entities/performance/performance_primary_grouping_entity.dart';

class PerformancePrimarySubGroupingParam{
  final BuildContext? context;
  final EntityData? entity;
  final GroupingEntity? primaryGrouping;
  final String? asOnDate;
  final PartnershipMethodItemData? partnershipMethod;
  final HoldingMethodItemData? holdingMethod;

  const PerformancePrimarySubGroupingParam( {
    required this.context,
    this.entity,
    this.primaryGrouping,
    this.asOnDate,
    this.partnershipMethod,
    this.holdingMethod,
  });

  Map<String, dynamic> toJson() {
    // if(partnershipMethod?.value == "None"){
    //
    // }
    return {
      "0": "filter-subgroups",
      "1": {
        "curFilter": primaryGrouping?.id,
        "entitytype": "${entity?.type?.toLowerCase() == 'group' ? 1 : 0}",
        "entiyid": entity?.type?.toLowerCase() == 'group' ? "${entity?.id}_EntityGroup": entity?.id,
        "filter1val": "13",
        "filter4val": [],
        "fromdate": "2011-12-31",
        "partnershipmethod": partnershipMethod?.value == "None" ? "" : partnershipMethod?.value,   //"",
        "reportname": "wealthregister",
        "todate": asOnDate,
        "vehicles": "30,29,3,33,24,47,11,17,42,2,7,15,18,10,48,14,6,31,19,34,13,44,22,32,9,28,4,8,16,1,37,40,39,12,49,50,56",
        "withParthership":  holdingMethod?.value,   //"Default",
        "reportType": "cummlativeMultPeriodPhase4",
        "IsFilterFlag": 2
      }
    };
  }
}