import 'package:flutter/material.dart';

import '../../../utilities/helper/app_helper.dart';
import '../../entities/currency/currency_entity.dart';
import '../../entities/dashboard/dashboard_list_entity.dart';
import '../../entities/income/income_account_entity.dart';
import '../../entities/number_of_period/number_of_period.dart';
import '../../entities/period/period_enitity.dart';

class IncomeReportParams {
  final BuildContext context;
  final EntityData? entity;
  final List<Account?>? accountnumbers;
  final String? asOnDate;
  final String? dates;
  final PeriodItemData? period;
  final NumberOfPeriodItemData? numberOfPeriod;
  final Currency? reportingCurrency;
  final String? purpose;
  const IncomeReportParams({
    required this.context,
    this.entity,
    this.accountnumbers,
    this.asOnDate,
    this.dates,
    this.period,
    this.numberOfPeriod,
    this.reportingCurrency,
    this.purpose,
  });

  Map<String, dynamic> toJson() {
    String formattedAccounts = '';

    accountnumbers?.forEach((grp) {
      formattedAccounts = formattedAccounts + ('${grp?.id},' ?? '');
    });
    return {
      "filter": {
        "entity": entity?.name,
        "entitytype": entity?.type,
        "id": entity?.id,
        "accountnumbers": formattedAccounts.isNotEmpty ?  formattedAccounts.substring(0, formattedAccounts.length-1) : formattedAccounts,
        "asOnDate": asOnDate,
        "period": "${period?.name}".contains("Calendar Year") ? "Yearly" : "${period?.name}",
        "nop": "12",
        "currencyid": reportingCurrency?.id,
        "report_type": "income"
      }
    };
  }
}