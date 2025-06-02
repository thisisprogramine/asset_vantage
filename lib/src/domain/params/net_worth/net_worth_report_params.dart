// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import '../../../utilities/helper/app_helper.dart';

class NetWorthReportParams {
  final BuildContext? context;
  final String? entityId;
  final String? entityName;
  final String? entityType;
  final String? filter1;
  final String? filter1name;
  final String? filter4;
  final String? columnList;
  final String? currencycode;
  final String? currencyid;
  final List<String>? transactionPeriods;
  final String? period;
  final String? numberOfPeriod;
  String? partnershipMethod;
  final String? holdingMethod;

   NetWorthReportParams(  {
    required this.context,
    this.filter4,
    this.currencycode,
    this.currencyid,
    this.columnList,
    this.entityId,
    this.entityName,
    this.entityType,
    this.filter1,
    this.filter1name,
    this.transactionPeriods,
    this.period,
    this.numberOfPeriod,
    this.partnershipMethod,
    this.holdingMethod,
  });

  Map<String, String> returnTransDates() {
    Map<String, String> mapToBeReturned = {};
    transactionPeriods?.forEach((ele) {
      final subStrss = ele.split("_");
      final indexOfEle = transactionPeriods?.indexOf(ele);
      mapToBeReturned.addAll({
        "txnfromdate${indexOfEle == 0 ? "" : indexOfEle}": subStrss[0],
        "txntodate${indexOfEle == 0 ? "" : indexOfEle}": subStrss[1],
      });
    });
    return mapToBeReturned;
  }
  //String? input = partnershipMethod;


  Map<String, dynamic> toJson() {
    if(partnershipMethod == "None"){
      partnershipMethod = "";
    }

    String? partnershipNameWithNoSpace;
    print("Before if - partnershipMethod: '$partnershipMethod'");
    print("Before if - partnershipMethod length: ${partnershipMethod?.length}");

    if (partnershipMethod?.trim().toLowerCase() == "none" || partnershipMethod?.isEmpty == true) {
      print("Inside if - partnershipMethod is None");
      partnershipNameWithNoSpace = null;
    } else {
      print("Inside else - partnershipMethod is not None");
      partnershipNameWithNoSpace = partnershipMethod?.replaceAll(' ', '');
    }

    print("Final value: $partnershipNameWithNoSpace");
    final jsonData = {
      "0": "seq_multi_period",
      "1": {
        "api": "seq_multi_period",
        "accountdetailsname": "undefined",
        "accounttypestext": "",
        "autoval": "1",
        "displaycurrency": true,
        "decimals": "1",
        "denomination": 1,
        "entity": "$entityId",
        "entityid": "$entityId",
        "entityname": entityName,
        "entitytype": entityType,
        "filter1": filter1,
        "filter1name": filter1name,
        "filter3": "1",
        "filter3name": "None",
        "filter4": filter4,
        "filter5": "",
        "fromdate": "2007-06-27",
        "investment-vehicle": "",
        "isccg": "1",
        "isconsolidatecurrency": "1",
        "isentitygrp": entityType,
        "issummary": 0,
        "page": 1,
        "partnershipmethod": partnershipNameWithNoSpace, //null
        "performancesummary": "1",
        "policyname": "1",
        "report-type": "capitalInvest",
        "reportType": "capitalflowbyinvest",
        "reportname": "capitalflowbyinvest",
        "search": "",
        "securityname": "",
        "showcol": "",
        "todate": "2020-08-11",
        "token-key": "enoyU2ZjM0pOQmdkV3NCTWtIUkI0UT09",
        "txnInceptiondate": "2011-03-11",
        "txnfromdate": "2024-06-01",
        "txntodate": "2024-06-11",
        "vehicles":
            "30,29,3,33,24,47,11,17,42,2,7,15,18,10,48,14,6,31,19,34,13,44,22,32,9,28,4,8,16,1,37,40,39,12,49,50,56,20",
        "withParthership":  holdingMethod,  //"Default",
        "wraccountid": "",
        "wrinstrumentname": "",
        "wrmodule": "",
        "activeChartValue": "",
        "activeChartValue2": "",
        "reportPeriod": ["custom"],
        "dateTypeWR": "transaction",
        "datetype": "fromto",
        "is_debug": false,
        "multipleaccount1": "",
        "rp-txtcachedfilter": "0",
        "rp-txtsavedfilter": "0",
        "savereport": "0",
        "searchdata": "",
        "txtcachereportquickaccess": "",
        "txtsaveasfilter": "",
        "txttags": "",
        "version": 2.1,
        "columnList": "closing,$columnList",
        "partnershipmethodName": partnershipMethod == "With Partnership" ? partnershipMethod ="With Partnerships" : partnershipMethod,  //"",
        "investmentUniverseFilter": filter1,
        "investmentUniverseFilterName": filter1name,
        "investmentSubFilter": filter4,
        "balanceperiod": "Monthly",
        "periodsnumber": transactionPeriods?.length,
        "orderBy": "recentLast",
        "currency": currencyid,
        "currencyname": currencycode,
        "acctDetails": "on",
        "isincludepartnershipposition": "1",
        "periodDates":
            transactionPeriods?.reversed.join("_"),
        "2period": "on",
        "RBsummGrid": "on",
        "ispartnershipposition": "on",
        "valuationWithAccrued": "true",
      },
      "2": false
    };
    final tDates = returnTransDates();
    (jsonData["1"] as Map).addAll(tDates);
    return jsonData;
  }
}
