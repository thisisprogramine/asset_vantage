import 'package:asset_vantage/src/domain/entities/currency/currency_entity.dart';
import 'package:asset_vantage/src/domain/entities/dashboard/dashboard_list_entity.dart';
import 'package:asset_vantage/src/domain/entities/performance/performance_primary_sub_grouping_enity.dart' as primarySub;
import 'package:asset_vantage/src/domain/entities/performance/performance_secondary_sub_grouping_enity.dart' as secondarySub;
import 'package:asset_vantage/src/domain/entities/return_percentage/return_percentage_entity.dart';
import 'package:flutter/material.dart';

import '../../../data/models/return_percentage/return_percentage_model.dart';
import '../../../utilities/helper/app_helper.dart';
import '../../entities/performance/performance_primary_grouping_entity.dart' as primary;
import '../../entities/performance/performance_secondary_grouping_entity.dart' as secondary;

class PerformanceReportParams {
  final BuildContext context;
  final EntityData? entity;
  final primary.GroupingEntity? primaryGrouping;
  final secondary.GroupingEntity? secondaryGrouping;
  final List<primarySub.SubGroupingItemData?>? primarySubGrouping;
  final List<secondarySub.SubGroupingItemData?>? secondarySubGrouping;
  final List<ReturnPercentItemData?>? returnPercentItemData;
  final Currency? currency;
  final String? asOnDate;
   String? partnershipMethod;
  final String? holdingMethod;

   PerformanceReportParams({
    required this.context,
    required this.entity,
    required this.primaryGrouping,
    required this.secondaryGrouping,
    required this.primarySubGrouping,
    required this.secondarySubGrouping,
    this.returnPercentItemData,
    required this.currency,
    required this.asOnDate,
      this.partnershipMethod,
     this.holdingMethod,
  });

  Map<String, dynamic> toJson() {
    if(partnershipMethod == "None"){
      partnershipMethod = "";
    }

    String? partnershipNameWithNoSpace;

    if (partnershipMethod?.trim().toLowerCase() == "none" || partnershipMethod?.isEmpty == true) {
      print("Inside if - partnershipMethod is None");
      partnershipNameWithNoSpace = null;
    } else {
      print("Inside else - partnershipMethod is not None");
      partnershipNameWithNoSpace = partnershipMethod?.replaceAll(' ', '');
    }

    print("Final value: $partnershipNameWithNoSpace");
    String filter4 = (primarySubGrouping ?? []).map((e) => e?.id).toList().join(',');

    String filter5 = (secondarySubGrouping ?? []).map((e) => e?.id).toList().join(',');

    String? multiPeriod = returnPercentItemData?.map((ReturnPercentItemData? item) {
      return setReturnType(type: item?.value ?? ReturnType.MTD) ?? '';
    }).toList().join(',');

    String? multiPeriodValue = (returnPercentItemData?.map((ReturnPercentItemData? item) {
      return setReturnType(type: item?.value ?? ReturnType.MTD) ?? '';
    }).toList()?..removeWhere((element) => element=="xirr"))?.join(',');

    String? multiPeriodId = returnPercentItemData?.map((ReturnPercentItemData? item) {
      return item?.id ?? '';
    }).toList().join(',');

    return {
      "0": "phase4_mppr",
      "1": {
        "isMPPRtoPAR": "1",
        "position_hide_irr": 0,
        "api": "phase4_mppr",
        "accountdetailsname": "undefined",
        "accounttypestext": "",
        "autoval": "1",
        "benchmark": "1",
        "displaycurrency": true,
        "decimals": "1",
        "denomination": 1,
        "entity": entity?.type?.toLowerCase() == 'group' ? "${entity?.id}_EntityGroup": entity?.id,
        "entityid": entity?.type?.toLowerCase() == 'group' ? "${entity?.id}_EntityGroup": entity?.id,
        "entityname": entity?.name,
        "entitytype": "${entity?.type?.toLowerCase() == 'group' ? 1 : 0}",
        "filter1": primaryGrouping?.id,
        "filter1name": primaryGrouping?.name,
        "filter3": secondaryGrouping?.id,
        "filter3name": secondaryGrouping?.name,
        "filter4": filter4,
        "filter5": filter5,
        "fromdate": null,
        "investment-vehicle": "",
        "isccg": "1",
        "isconsolidatecurrency": "1",
        "isentitygrp": "${entity?.type?.toLowerCase() == 'group' ? 1 : 0}",
        "issummary": 0,
        "page": 1,
        "partnershipmethod": partnershipNameWithNoSpace,
        "performancesummary": "1",
        "policyname": "1",
        "report-type": "cummlativeMultPeriod",
        "reportType": "wr",
        "reportname": "performanceReport",
        "search": "",
        "securityname": "",
        "showcol": "1benchmarktwrr,2benchmark,holdingIRR,accruedIncome,securityidentifier,allpositiontags${(multiPeriod?.contains("xirr") ?? false) ? ',showxirr' : ''}",
        "todate": asOnDate,
        "token-key": "enoyU2ZjM0pOQmdkV3NCTWtIUkI0UT09",
        "txnInceptiondate": "2006-01-01",
        "txnfromdate": "2006-01-01",
        "txntodate": asOnDate,
        "valuationWithAccrued": "true",
        "vehicles": "30,29,3,33,24,47,11,17,42,2,7,15,18,10,48,14,6,31,19,34,13,44,22,32,9,28,4,8,16,1,37,40,39,12,49,50,56",
        "withParthership": holdingMethod,   ///"Default",
        "wraccountid": "",
        "wrinstrumentname": "",
        "wrmodule": "",
        "activeChartValue": "value_on_date",
        "activeChartValue2": "none",
        "is_xirr_show": true,
        "multiPeriod": multiPeriodValue,
        "columnList": "value_on_date,$multiPeriodId",
        "partnershipmethodName": partnershipMethod == "With Partnership" ? "With Partnerships" : partnershipMethod,
        "currency": currency?.id,
        "currencyname": currency?.code,
        "acctDetails": "on",
        "isincludepartnershipposition": "1",
        "ispartnershipposition": "on"
      },
      "2": false
    };
  }
}
