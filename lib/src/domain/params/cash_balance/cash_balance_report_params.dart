// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class CashBalanceReportParams {
  final BuildContext context;
  final String? entityId;
  final String? entityName;
  final String? entityType;
  final String? filter1;
  final String? filter1name;
  final String? filter4;
  final String? filter5;
  final String? currencycode;
  final String? currencyid;
  final List<String>? transactionPeriods;
  final String? period;
  final String? numberOfPeriod;
  final String? asOnDate;

  const CashBalanceReportParams({
    required this.context,
    this.filter4,
    this.filter5,
    this.currencycode,
    this.currencyid,
    this.entityId,
    this.entityName,
    this.entityType,
    this.filter1,
    this.filter1name,
    this.transactionPeriods,
    this.period,
    this.numberOfPeriod,
    this.asOnDate,
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

  Map<String, dynamic> toJson() {
    return {
      "filter": {
        "entityid": "$entityId",
        "entityname": "$entityName",
        "entitytype": "$entityType",
        "primary_filter": "$filter1",
        "primary_filter_name": "$filter1name",
        "secondary_filter": "6",
        "secondary_filter_name": "Account",
        "primary_sub_filter": "$filter4",
        "accountnumbers": "$filter5",
        "asOnDate": "$asOnDate",
        "period": "$period".contains("Calendar Year") ? "Yearly" : "$period",
        "nop": "$numberOfPeriod",
        "currencyid": "$currencyid"
      }
    };
  }
}
