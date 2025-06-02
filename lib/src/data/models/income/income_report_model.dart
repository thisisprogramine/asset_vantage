

import 'package:asset_vantage/src/domain/entities/income/income_chart_data.dart';

import '../../../domain/entities/income/income_report_entity.dart';

class IncomeReportModel extends IncomeReportEntity{
  IncomeReportModel({
    this.result,
    this.jsonData
  }) : super(
      report: result ?? []
  );

  final List<Date>? result;
  final Map<dynamic, dynamic>? jsonData;

  factory IncomeReportModel.fromJson(Map<dynamic, dynamic> json) {
    Map<dynamic, dynamic>? response = json['incomeReport'];

    if(response == null) {
      return IncomeReportModel(
          result: [],
          jsonData: {}
      );
    }

    List<Date> dateList = [];

    List<dynamic> keys = [];

    keys.addAll(response?.keys ?? []);

    keys.forEach((element) {

      for(int i = 0; i < (response?[element]['accounts']?.length ?? 0); i++) {
        if(response?[element]['accounts'][i]['entityname'] != null) {
          response?[element]['accounts'][i]['accountname'] = response[element]['accounts'][i]['entityname'];
        }
      }

      dateList.add(Date(
        totalAmount: response?[element]['total'] is int ? double.parse('${response?[element]['total']}') : response?[element]['total'],
        filterList: response?[element]['accounts'] != null && (response?[element]['total'] is int
            ? double.parse('${response?[element]['total']}')
            : (response?[element]['total'] ?? 0))!=0 ? List<Filter>.from(response?[element]['accounts']!.map((x) => Filter.fromJson(x,element)))
            : [],
        reportDate: element
      ));
    });

    return IncomeReportModel(
      result: dateList,
      jsonData: response
    );
  }

  Map<dynamic, dynamic> toJson() => {
    "incomeReport": jsonData
  };
}

class Date extends ReportEntity {
  Date({
    this.reportDate,
    this.filterList,
    this.totalAmount,
  }) : super(
      date: reportDate ?? '--',
      children: filterList  ?? [],
      total: totalAmount ?? 0.0
  );

  final String? reportDate;
  final List<Filter>? filterList;
  final double? totalAmount;

  factory Date.fromJson(Map<dynamic, dynamic> json) => Date(
    reportDate: json["date"] != null ? json["date"]!.substring(json["date"]!.indexOf('_') + 1) : null,
    filterList: json["children"] != null ? List<Filter>.from(json["children"]!.map((x) => Filter.fromJson(x,json["date"] != null ? json["date"]!.substring(json["date"]!.indexOf('_') + 1) : null))) : [],
    totalAmount: json["total"] != null ? (json["total"] is String ? double.parse(json["total"]) : json["total"] is int ? double.parse("${json["total"]}"): json["total"])! : null,
  );

  Map<dynamic, dynamic> toJson() => {
    "date": reportDate != null ? reportDate!.substring(reportDate!.indexOf('_') + 1) : null,
    "children": filterList != null ? List<dynamic>.from(filterList!.map((x) => x.toJson())) : [],
    "total": totalAmount != null ? totalAmount! : null,
  };
}

class Filter extends Child{
  Filter({
    this.accountname,
    this.accountid,
    this.amount,
    this.valuePercentage,
    this.currency,
    this.accountNumber,
    this.filterList,
    this.reportDate,
  }) : super(
      accountName: accountname ?? '--',
      accountId: accountid ?? 0,
      total: amount ?? 0.0,
      percentage: valuePercentage ?? 0.0,
    accNumber: accountNumber ?? '--',
    accounts: filterList ?? [],
    currencyData: currency ?? '--',
    date: reportDate ?? '--',
  );

  final String? accountname;
  final int? accountid;
  final double? amount;
  final double? valuePercentage;
  final String? accountNumber;
  final String? currency;
  final List<Filter>? filterList;
  final String? reportDate;

  factory Filter.fromJson(Map<dynamic, dynamic> json,String reportDate) => Filter(
    accountname: json["accountname"] != null ? json["accountname"]! : null,
    accountid: json["accountid"] != null ? json["accountid"]! is int ? json["accountid"]! : int.parse('${json["accountid"]!}') : null,
    amount: json["amount"] != null ? (json["amount"] is int) ? double.parse("${json["amount"]}") : json["amount"] : null,
    valuePercentage: json["percentage"] != null ? (json["percentage"] is int) ? double.parse("${json["percentage"]}") : json["percentage"] : null,
    accountNumber: json["accountnumber"] != null ? json["accountnumber"]! : null,
    currency: json["currency"] != null ? json["currency"]! : null,
    filterList: json["accounts"] != null ?json["accounts"][0] != null ? List<Filter>.from(json["accounts"][0]!.map((x) => Filter.fromJson(x,reportDate))):[] : [],
    reportDate: reportDate,
  );

  Map<dynamic, dynamic> toJson() => {
    "accountname": accountname,
    "accountid": accountid,
    "value": amount,
    "percentage": valuePercentage,
    "currency": currency,
    "accountnumber": accountNumber,
    "accounts": filterList?.map((e) => e.toJson()).toList(),
  };
}
