

import 'package:flutter/material.dart';

import '../../../utilities/helper/app_helper.dart';

class InvestmentPolicyStatementReportParams {
  final BuildContext context;
  final String? primaryfilter;
  final String? filter5;
  final String? policyid;
  final String? date;
  final String? yearReturn;
  final String? reportingCurrency;
  final String? reportingCurrencyid;
  final String? accountingyear;
  final String? entityname;
  final String? entitytype;
  final String? id;
  final String? type;
  final String? currencycode;
  final String? currencyid;
  final String? primaryfilterid;
  final String? purpose;

  const InvestmentPolicyStatementReportParams({
    required this.context,
    required this.primaryfilter,
    required this.filter5,
    required this.policyid,
    required this.date,
    required this.yearReturn,
    required this.reportingCurrency,
    required this.reportingCurrencyid,
    required this.accountingyear,
    required this.entityname,
    required this.entitytype,
    required this.id,
    required this.type,
    required this.currencycode,
    required this.currencyid,
    required this.primaryfilterid,
    required this.purpose,
  });

  Future<Map<String, dynamic>> toJson() async{
    return {
      "primaryfilter": primaryfilter,
      "filter5": filter5,
      "policyid": policyid,
      "date": date,
      "yearReturn": yearReturn,
      "reportingCurrency": reportingCurrency,
      "currencycode": reportingCurrency,
      "currencyid": reportingCurrencyid,
      "accountingyear": accountingyear,
      "entityname": entityname,
      "entitytype": entitytype,
      "id": id,
      "type": type,
      "currencycode": currencycode,
      "currencyid": currencyid,
      "primaryfilterid": primaryfilterid,
      "purpose": "${AppHelpers.getLambdaPrefix(region: purpose ?? '')}get_ips_new"
    };
  }
}