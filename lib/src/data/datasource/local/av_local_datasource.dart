import 'dart:convert';
import 'dart:developer';

import 'package:asset_vantage/src/config/extensions/string_extensions.dart';
import 'package:asset_vantage/src/data/models/currency/currency_model.dart';
import 'package:asset_vantage/src/data/models/net_worth/net_worth_grouping_model.dart'
    as nwgp;
import 'package:asset_vantage/src/data/models/net_worth/net_worth_number_of_period_model.dart';
import 'package:asset_vantage/src/data/models/net_worth/net_worth_sub_grouping_model.dart'
    as nw;
import 'package:asset_vantage/src/data/models/net_worth/networth_report_model.dart';
import 'package:asset_vantage/src/data/models/partnership_method/holding_method_model.dart';
import 'package:asset_vantage/src/data/models/partnership_method/partnership_method_model.dart';
import 'package:asset_vantage/src/data/models/period/period_model.dart'
    as period;
import 'package:asset_vantage/src/data/models/number_of_period/number_of_period_model.dart'
    as nop;
import 'package:asset_vantage/src/data/models/return_percentage/return_percentage_model.dart'
    as rp;
import 'package:asset_vantage/src/domain/entities/currency/currency_entity.dart';
import 'package:asset_vantage/src/domain/entities/investment_policy_statement/investment_policy_statement_time_period_entity.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'package:asset_vantage/src/data/models/net_worth/net_worth_return_percent_model.dart'
    as rpmodal;
import 'package:uuid/uuid.dart';

import '../../../config/constants/hive_constants.dart';
import '../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../domain/entities/denomination/denomination_entity.dart';
import '../../../domain/entities/investment_policy_statement/investment_policy_statement_policies_entity.dart';
import '../../../domain/entities/investment_policy_statement/investment_policy_statement_sub_grouping_entity.dart';
import '../../../injector.dart';
import '../../models/authentication/user_model.dart';
import '../../models/cash_balance/cash_balance_grouping_model.dart' as cbpg;
import '../../models/cash_balance/cash_balance_report_model.dart';
import '../../models/cash_balance/cash_balance_sub_grouping_model.dart' as cb;
import '../../models/cash_balance/cash_balance_sub_grouping_model.dart';
import '../../models/dashboard/dashboard_entity_model.dart';
import '../../models/denomination/denomination_model.dart';
import '../../models/expense/expense_account_model.dart';
import '../../models/expense/expense_report_model.dart';
import '../../models/insights/messages_model.dart';
import '../../models/income/income_account_model.dart';
import '../../models/income/income_report_model.dart';
import '../../models/income_expense/income_expense_number_of_period_model.dart'
    as ie;
import '../../models/investment_policy_statement/investment_policy_statement_policies_model.dart';
import '../../models/investment_policy_statement/investment_policy_statement_sub_grouping_model.dart'
    as ips;
import '../../models/investment_policy_statement/investment_policy_statement_sub_grouping_model.dart';
import '../../models/investment_policy_statement/investment_policy_statement_time_period_model.dart';
import '../../models/investment_policy_statement/investment_policy_statement_grouping_model.dart';
import '../../models/investment_policy_statement/investment_policy_statement_report_model.dart';
import '../../models/net_worth/net_worth_period_model.dart';
import '../../models/net_worth/net_worth_return_percent_model.dart';
import '../../models/performance/performance_primary_grouping_model.dart';
import '../../models/performance/performance_primary_sub_grouping_model.dart';
import '../../models/performance/performance_report_model.dart';
import '../../models/performance/performance_secondary_grouping_model.dart';
import '../../models/performance/performance_secondary_grouping_model.dart'
    as secondaryGrouping;
import '../../models/performance/performance_secondary_sub_grouping_model.dart'
    as secondarySubGrouping;
import '../../models/performance/performance_primary_grouping_model.dart'
    as primaryGrouping;
import '../../models/performance/performance_primary_sub_grouping_model.dart'
    as primarySubGrouping;
import '../../models/performance/performance_secondary_sub_grouping_model.dart';
import '../../models/preferences/user_preference.dart';
import 'app_local_datasource.dart';
import 'package:asset_vantage/src/data/models/number_of_period/number_of_period_model.dart'
    as cbnp;
import 'package:asset_vantage/src/data/models/period/period_model.dart' as cbp;

abstract class AVLocalDataSource {
  Future<UserModel?> getUserData({required Map<String, dynamic> requestBody});

  Future<void> saveUserData(
      {required Map<String, dynamic> requestBody,
      required Map<dynamic, dynamic> response});

  Future<List<int>> getDashboardSequence();

  Future<void> saveDashboardSequence({required List<int> seq});

  Future<DashboardEntityModel?> getEntities(
      {required Map<String, dynamic> requestBody});

  Future<void> saveEntities(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response});

  Future<CurrencyModel?> getCurrencies(
      {required Map<String, dynamic> requestBody});

  Future<void> saveCurrencies(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response});

  Future<InvestmentPolicyStatementGroupingModel?>
      getInvestmentPolicyStatementGrouping();

  Future<void> saveInvestmentPolicyStatementGrouping(
      {required Map<dynamic, dynamic> response});

  Future<InvestmentPolicyStatementSubGroupingModel?>
      getInvestmentPolicyStatementSubGrouping(
          {required Map<String, dynamic> requestBody});

  Future<void> saveInvestmentPolicyStatementSubGrouping(
      {required Map<String, dynamic> requestBody,
      required Map<dynamic, dynamic> response});

  Future<InvestmentPolicyStatementPoliciesModel?>
      getInvestmentPolicyStatementPolicies();

  Future<void> saveInvestmentPolicyStatementPolicies(
      {required Map<dynamic, dynamic> response});

  Future<InvestmentPolicyStatementTimePeriodModel?>
      getInvestmentPolicyStatementTimePeriod(
          {required Map<String, dynamic> requestBody});

  Future<void> saveInvestmentPolicyStatementTimePeriod(
      {required Map<String, dynamic> requestBody,
      required Map<dynamic, dynamic> response});

  Future<InvestmentPolicyStatementReportModel?>
      getInvestmentPolicyStatementReport(
          {required Map<String, dynamic> requestBody});

  Future<void> saveInvestmentPolicyStatementReport(
      {required Map<String, dynamic> requestBody,
      required Map<dynamic, dynamic> response});

  Future<void> clearInvestmentPolicyStatement();

  Future<CashBalanceReportModel?> getCashBalanceReport(
      {required Map<String, dynamic> requestBody});

  Future<void> saveCashBalanceReport(
      {required Map<String, dynamic> requestBody,
      required Map<dynamic, dynamic> response});

  Future<CashBalanceSubGroupingModel?> getCashBalanceAccounts(
      {required Map<String, dynamic> requestBody});

  Future<void> saveCashBalanceAccounts(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response});

  Future<cbpg.PrimaryGrouping?> getCashBalanceSelectedPrimaryGrouping(
      {required String? tileName,
      required EntityData? entity,
      required String postFix});

  Future<void> saveCashBalanceSelectedPrimaryGrouping(
      {required String tileName,
      required EntityData entity,
      required Map<dynamic, dynamic> response,
      required String postFix});

  Future<Entity?> getCashBalanceSelectedEntity(
      {required String tileName, required String postFix});

  Future<void> saveCashBalanceSelectedEntity(
      {required String tileName,
      required Map<dynamic, dynamic> response,
      required String postFix});

  Future<List<cb.SubGroupingItem?>?> getCashBalanceSelectedPrimarySubGrouping(
      {required String tileName,
      required Map<dynamic, dynamic> requestBody,
      required String postFix});

  Future<void> saveCashBalanceSelectedPrimarySubGrouping(
      {required String tileName,
      required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response,
      required String postFix});

  Future<cbpg.CashBalanceGroupingModel?> getCashBalanceGrouping(
      {required Map<dynamic, dynamic> requestBody});

  Future<void> saveCashBalanceGrouping(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response});

  Future<CashBalanceSubGroupingModel?> getCashBalanceSubGrouping(
      {required Map<String, dynamic> requestBody});

  Future<void> saveCashBalanceSubGrouping(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response});

  Future<CurrencyData?> getCashBalanceSelectedCurrency(
      {required String tileName, required String postFix});

  Future<void> saveCashBalanceSelectedCurrency(
      {required String tileName,
      required Map<dynamic, dynamic> response,
      required String postFix});

  Future<DenData?> getCashBalanceSelectedDenomination(
      {required String tileName, required String postFix});

  Future<void> saveCashBalanceSelectedDenomination(
      {required String tileName,
      required Map<dynamic, dynamic> response,
      required String postFix});

  Future<String?> getCashBalanceSelectedAsOnDate(
      {required String tileName, required String postFix});

  Future<void> saveCashBalanceSelectedAsOnDate(
      {required String tileName,
      required String? response,
      required String postFix});

  Future<cbp.PeriodItem?> getCashBalanceSelectedPeriod(
      {required String tileName, required String postFix});

  Future<void> saveCashBalanceSelectedPeriod(
      {required String tileName,
      required Map<dynamic, dynamic> response,
      required String postFix});

  Future<cbnp.NumberOfPeriodItem?> getCashBalanceSelectedNumberOfPeriod(
      {required String tileName, required String postFix});

  Future<void> saveCashBalanceSelectedNumberOfPeriod(
      {required String tileName,
      required Map<dynamic, dynamic> response,
      required String postFix});

  Future<List<cb.SubGroupingItem?>?> getCashBalanceSelectedAccounts(
      {required String tileName,
      required Map<dynamic, dynamic> requestBody,
      required String postFix});

  Future<void> saveCashBalanceSelectedAccounts(
      {required String tileName,
      required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response,
      required String postFix});

  Future<void> clearCashBalance();

  Future<nwgp.NetWorthGroupingModel?> getNetWorthGrouping(
      {required Map<String, dynamic> requestBody});

  Future<void> saveNetWorthGrouping(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response});

  Future<nw.NetWorthSubGroupingModel?> getNetWorthSubGrouping(
      {required Map<String, dynamic> requestBody});

  Future<void> saveNetWorthSubGrouping(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response});

  Future<NetWorthReportModel?> getNetWorthReport(
      {required Map<String, dynamic> requestBody});

  Future<void> saveNetWorthReport(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response});

  Future<void> clearNetWorth();

  Future<String?> getNetWorthSelectedAsOnDate({required String postFix});

  Future<void> saveNetWorthSelectedAsOnDate(
      {required String? response, required String postFix});

  Future<CurrencyData?> getNetWorthSelectedCurrency({required String postFix});

  Future<void> saveNetWorthSelectedCurrency(
      {required Map<dynamic, dynamic> response, required String postFix});

  Future<DenData?> getNetWorthSelectedDenomination({required String postFix});

  Future<void> saveNetWorthSelectedDenomination(
      {required Map<dynamic, dynamic> response, required String postFix});

  Future<Entity?> getNetWorthSelectedEntity({required String postFix});

  Future<void> saveNetWorthSelectedEntity(
      {required Map<dynamic, dynamic> response, required String postFix});

  Future<cbnp.NumberOfPeriodItem?> getNetWorthSelectedNumberOfPeriod(
      {required String tileName, required String postFix});

  Future<void> saveNetWorthSelectedNumberOfPeriod(
      {required String tileName,
      required Map<dynamic, dynamic> response,
      required String postFix});

  Future<PartnershipMethodItem?> getNetWorthSelectedPartnershipMethod({
    required String tileName,required String postFix});

  Future<void> saveNetWorthSelectedPartnershipMethod(
  { required String tileName,
    required Map<dynamic,dynamic> response,
    required String postFix });

  Future<HoldingMethodItem?> getNetWorthSelectedHoldingMethod({
    required String tileName,required String postFix});
  Future<void> saveNetWorthSelectedHoldingMethod(
      { required String tileName,
        required Map<dynamic,dynamic>? response,
        required String postFix });

  Future<cbp.PeriodItem?> getNetWorthSelectedPeriod(
      {required String tileName, required String postFix});

  Future<void> saveNetWorthSelectedPeriod(
      {required String tileName,
      required Map<dynamic, dynamic> response,
      required String postFix});

  Future<nwgp.PrimaryGrouping?> getNetWorthSelectedPrimaryGrouping(
      {required String postFix});

  Future<void> saveNetWorthSelectedPrimaryGrouping(
      {required Map<dynamic, dynamic> response, required String postFix});

  Future<List<nw.SubGroupingItem?>?> getNetWorthSelectedPrimarySubGrouping(
      {required Map<dynamic, dynamic> requestBody, required String postFix});

  Future<void> saveNetWorthSelectedPrimarySubGrouping(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response,
      required String postFix});

  Future<rpmodal.ReturnPercentItem?> getNetWorthSelectedReturnPercent(
      {required String postFix});

  Future<void> saveNetWorthSelectedReturnPercent(
      {required Map<dynamic, dynamic> response, required String postFix});

  Future<PerformanceReportModel?> getPerformanceReport(
      {required Map<String, dynamic> requestBody});

  Future<void> savePerformanceReport(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response});

  Future<PerformancePrimaryGroupingModel?> getPerformancePrimaryGrouping(
      {required Map<dynamic, dynamic> requestBody});

  Future<void> savePerformancePrimaryGrouping(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response});

  Future<PerformancePrimarySubGroupingModel?> getPerformancePrimarySubGrouping(
      {required Map<dynamic, dynamic> requestBody});

  Future<void> savePerformancePrimarySubGrouping(
      {required Map<dynamic, dynamic> response,
      required Map<dynamic, dynamic> requestBody});

  Future<PerformanceSecondaryGroupingModel?> getPerformanceSecondaryGrouping(
      {required Map<dynamic, dynamic> requestBody});

  Future<void> savePerformanceSecondaryGrouping(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response});

  Future<PerformanceSecondarySubGroupingModel?>
      getPerformanceSecondarySubGrouping(
          {required Map<dynamic, dynamic> requestBody});

  Future<void> savePerformanceSecondarySubGrouping(
      {required Map<dynamic, dynamic> response,
      required Map<dynamic, dynamic> requestBody});

  Future<Entity?> getPerformanceSelectedEntity({required String postFix});

  Future<void> savePerformanceSelectedEntity(
      {required Map<dynamic, dynamic> response, required String postFix});

  Future<PartnershipMethodItem?> getPerformanceSelectedPartnershipMethod({
    required String tileName,required String postFix});
  Future<void> savePerformanceSelectedPartnershipMethod(
      { required String tileName,
        required Map<dynamic,dynamic> response,
        required String postFix });

  Future<HoldingMethodItem?> getPerformanceSelectedHoldingMethod({
    required String tileName,required String postFix});
  Future<void> savePerformanceSelectedHoldingMethod(
      { required String tileName,
        required Map<dynamic,dynamic> response,
        required String postFix });

  Future<primaryGrouping.PrimaryGrouping?>
      getPerformanceSelectedPrimaryGrouping({required String postFix});

  Future<void> savePerformanceSelectedPrimaryGrouping(
      {required Map<dynamic, dynamic> response, required String postFix});

  Future<List<primarySubGrouping.SubGroupingItem?>?>
      getPerformanceSelectedPrimarySubGrouping(
          {required Map<dynamic, dynamic> requestBody,
          required String postFix});

  Future<void> savePerformanceSelectedPrimarySubGrouping(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response,
      required String postFix});

  Future<secondaryGrouping.SecondaryGrouping?>
      getPerformanceSelectedSecondaryGrouping({required String postFix});

  Future<void> savePerformanceSelectedSecondaryGrouping(
      {required Map<dynamic, dynamic> response, required String postFix});

  Future<List<secondarySubGrouping.SubGroupingItem?>?>
      getPerformanceSelectedSecondarySubGrouping(
          {required Map<dynamic, dynamic> requestBody,
          required String postFix});

  Future<void> savePerformanceSelectedSecondarySubGrouping(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response,
      required String postFix});

  Future<List<rp.ReturnPercentItem?>?> getPerformanceSelectedReturnPercent(
      {required String postFix});

  Future<void> savePerformanceSelectedReturnPercent(
      {required Map<dynamic, dynamic> response, required String postFix});

  Future<CurrencyData?> getPerformanceSelectedCurrency(
      {required String postFix});

  Future<void> savePerformanceSelectedCurrency(
      {required Map<dynamic, dynamic> response, required String postFix});

  Future<DenData?> getPerformanceSelectedDenomination(
      {required String postFix});

  Future<void> savePerformanceSelectedDenomination(
      {required Map<dynamic, dynamic> response, required String postFix});

  Future<String?> getPerformanceSelectedAsOnDate({required String postFix});

  Future<void> savePerformanceSelectedAsOnDate(
      {required String? response, required String postFix});

  Future<void> clearPerformance();

  Future<IncomeAccountModel?> getIncomeAccounts(
      {required Map<String, dynamic> requestBody});

  Future<void> saveIncomeAccounts(
      {required Map<String, dynamic> requestBody,
      required Map<dynamic, dynamic> response});

  Future<IncomeReportModel?> getIncomeReport(
      {required Map<String, dynamic> requestBody});

  Future<void> saveIncomeReport(
      {required Map<String, dynamic> requestBody,
      required Map<dynamic, dynamic> response});

  Future<Entity?> getIncomeSelectedEntity({required String postFix});

  Future<void> saveIncomeSelectedEntity(
      {required Map<dynamic, dynamic> response, required String postFix});

  Future<List<IncomeAccount>?> getIncomeSelectedAccounts(
      {required Map<String, dynamic> requestBody, required String postFix});

  Future<void> saveIncomeSelectedAccounts(
      {required Map<String, dynamic> requestBody,
      required Map<dynamic, dynamic> response,
      required String postFix});

  Future<period.PeriodItem?> getIncomeSelectedPeriod({required String postFix});

  Future<void> saveIncomeSelectedPeriod(
      {required Map<dynamic, dynamic> response, required String postFix});

  Future<nop.NumberOfPeriodItem?> getIncomeSelectedNumberOfPeriod(
      {required String postFix});

  Future<void> saveIncomeSelectedNumberOfPeriod(
      {required Map<dynamic, dynamic> response, required String postFix});

  Future<CurrencyData?> getIncomeSelectedCurrency({required String postFix});

  Future<void> saveIncomeSelectedCurrency(
      {required Map<dynamic, dynamic> response, required String postFix});

  Future<DenData?> getIncomeSelectedDenomination({required String postFix});

  Future<void> saveIncomeSelectedDenomination(
      {required Map<dynamic, dynamic> response, required String postFix});

  Future<ExpenseAccountModel?> getExpenseAccounts(
      {required Map<String, dynamic> requestBody});

  Future<void> saveExpenseAccounts(
      {required Map<String, dynamic> requestBody,
      required Map<dynamic, dynamic> response});

  Future<ExpenseReportModel?> getExpenseReport(
      {required Map<String, dynamic> requestBody});

  Future<void> saveExpenseReport(
      {required Map<String, dynamic> requestBody,
      required Map<dynamic, dynamic> response});

  Future<Entity?> getExpenseSelectedEntity({required String postFix});

  Future<void> saveExpenseSelectedEntity(
      {required Map<dynamic, dynamic> response, required String postFix});

  Future<List<ExpenseAccount>?> getExpenseSelectedAccounts(
      {required Map<String, dynamic> requestBody, required String postFix});

  Future<void> saveExpenseSelectedAccounts(
      {required Map<String, dynamic> requestBody,
      required Map<dynamic, dynamic> response,
      required String postFix});

  Future<period.PeriodItem?> getExpenseSelectedPeriod(
      {required String postFix});

  Future<void> saveExpenseSelectedPeriod(
      {required Map<dynamic, dynamic> response, required String postFix});

  Future<nop.NumberOfPeriodItem?> getExpenseSelectedNumberOfPeriod(
      {required String postFix});

  Future<void> saveExpenseSelectedNumberOfPeriod(
      {required Map<dynamic, dynamic> response, required String postFix});

  Future<CurrencyData?> getExpenseSelectedCurrency({required String postFix});

  Future<void> saveExpenseSelectedCurrency(
      {required Map<dynamic, dynamic> response, required String postFix});

  Future<DenData?> getExpenseSelectedDenomination({required String postFix});

  Future<void> saveExpenseSelectedDenomination(
      {required Map<dynamic, dynamic> response, required String postFix});

  Future<void> clearIncomeExpense();

  Future<void> saveIpsPolicyFilter(
      {required String? entityName,
      required String? grouping,
      required Policies? policy,
      required String credential});

  Future<void> saveIpsSubFilter(
      {required String? entityName,
      required String? grouping,
      required List<SubGroupingItemData>? subGroup,
      required String credential});

  Future<void> saveIpsReturnFilter(
      {required String? entityName,
      required String? grouping,
      required TimePeriodItemData? period,
      required String credential});

  Future<TimePeriodItemData?> getIpsReturnFilter(
      {required String? entityName,
      required String? grouping,
      required String credential});

  Future<Policies?> getIpsPolicyFilter(
      {required String? entityName,
      required String? grouping,
      required String credential});

  Future<List<SubGroupingItemData>?> getIpsSubFilter(
      {required String? entityName,
      required String? grouping,
      required String credential});

  Future<List<cb.SubGroupingItem>?> getSelectedCBSubGroup(
      {required String? entityName,
      required String? grouping,
      required String credential});

  Future<void> saveSelectedCBSubGroup(
      {required String? entityName,
      required String? grouping,
      required List<cb.SubGroupingItem>? subGroup,
      required String credential});

  Future<List<Map>?> getSavedIncomeOrExpenseAccount(
      {required String? entityName,
      required String? grouping,
      required String credential});

  Future<void> saveSelectedIncomeOrExpenseAccount(
      {required String? entityName,
      required String? grouping,
      required List<Object>? item,
      required String credential});

  Future<ie.NumberOfPeriodItem?> getSavedIncomeOrExpensePeriod(
      {required String? entityName,
      required String? grouping,
      required String credential});

  Future<void> saveSelectedIncomeOrExpensePeriod(
      {required String? entityName,
      required String? grouping,
      required ie.NumberOfPeriodItem? item,
      required String credential});

  Future<EntityData?> getSelectedEntity({required String credential});

  Future<void> saveSelectedEntity(
      {required EntityData? entity, required String credential});

  Future<Entity?> getSelectedDocEntity({required String credential});

  Future<void> saveSelectedDocEntity(
      {required EntityData? entity, required String credential});

  Future<void> saveCBSortFilter(
      {required int sort, required String credential});

  Future<int?> getCBSortFilter({required String credential});

  Future<void> saveCurrencyFilter(
      {required Currency? currency,
      required String? tileName,
      required String credential});

  Future<CurrencyData?> getSavedCurrencyFilter(
      {required String? tileName, required String credential});

  Future<void> saveSelectedDenomination(
      {required DenominationData? denomination,
      required String? tileName,
      required String credential});

  Future<DenominationData?> getSelectedDenomination(
      {required String? tileName, required String credential});

  Future<void> saveChatMsg({required ChatMsg chat});

  Future<List<ChatMsg>?> getChatMsgList();

  Future<void> clearAllTheFilters({required String postFix});
}

class AVLocalDataSourceImpl extends AVLocalDataSource {
  @override
  Future<UserModel?> getUserData(
      {required Map<dynamic, dynamic> requestBody}) async {
    final getUserBox = await Hive.openBox(HiveBox.getUserBox);
    final data = await getUserBox.get(HiveFields.userData, defaultValue: null);
    return data != null ? UserModel.fromJson(data) : data;
  }

  @override
  Future<List<int>> getDashboardSequence() async {
    final dataSource = getItInstance<AppLocalDataSource>();
    final UserPreference preference = await dataSource.getUserPreference();
    final dashBox = await Hive.openBox(HiveBox.dashboardData);
    log("fds${"${preference.systemName}-${preference.username}-${HiveFields.dashboardListSequence}"}");
    final seq = await dashBox.get(
        "${preference.systemName}-${preference.username}-${HiveFields.dashboardListSequence}",
        defaultValue: [0, 1, 2, 3]);
    return seq;
  }

  @override
  Future<void> saveDashboardSequence({required List<int> seq}) async {
    final dataSource = getItInstance<AppLocalDataSource>();
    final UserPreference preference = await dataSource.getUserPreference();
    final dashBox = await Hive.openBox(HiveBox.dashboardData);
    await dashBox.put(
        "${preference.systemName}-${preference.username}-${HiveFields.dashboardListSequence}",
        seq);
  }

  @override
  Future<void> saveUserData(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response}) async {
    final entityBox = await Hive.openBox(HiveBox.getUserBox);
    await entityBox.put(HiveFields.userData, response);
  }

  @override
  Future<DashboardEntityModel?> getEntities(
      {required Map<dynamic, dynamic> requestBody}) async {
    final entityBox = await Hive.openBox(HiveBox.entityBox);
    final data = await entityBox.get(HiveFields.entityData, defaultValue: null);
    return data != null ? DashboardEntityModel.fromJson(data) : data;
  }

  @override
  Future<void> saveEntities(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response}) async {
    final entityBox = await Hive.openBox(HiveBox.entityBox);

    await entityBox.put(HiveFields.entityData, response);
  }

  @override
  Future<CurrencyModel?> getCurrencies(
      {required Map<dynamic, dynamic> requestBody}) async {
    final entityBox = await Hive.openBox(HiveBox.currencyBox);
    final data =
        await entityBox.get(HiveFields.currencyData, defaultValue: null);
    return data != null ? CurrencyModel.fromJson(data) : data;
  }

  @override
  Future<void> saveCurrencies(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response}) async {
    final entityBox = await Hive.openBox(HiveBox.currencyBox);
    await entityBox.put(HiveFields.currencyData, response);
  }

  @override
  Future<InvestmentPolicyStatementGroupingModel?>
      getInvestmentPolicyStatementGrouping() async {
    final ipsBox = await Hive.openBox(HiveBox.ipsBox);
    final data = await ipsBox.get(HiveFields.ipsGrouping, defaultValue: null);
    return data != null
        ? InvestmentPolicyStatementGroupingModel.fromJson(data)
        : null;
  }

  @override
  Future<void> saveInvestmentPolicyStatementGrouping(
      {required Map<dynamic, dynamic> response}) async {
    final ipsBox = await Hive.openBox(HiveBox.ipsBox);
    await ipsBox.put(HiveFields.ipsGrouping, response);
  }

  @override
  Future<InvestmentPolicyStatementSubGroupingModel?>
      getInvestmentPolicyStatementSubGrouping(
          {required Map<String, dynamic> requestBody}) async {
    final ipsBox = await Hive.openBox(HiveBox.ipsBox);
    final key =
        '${HiveFields.ipsSubGrouping}_${requestBody['id']}_${requestBody['subgrouping']}'
            .trim();
    final data = await ipsBox.get(
        key.substring(0, key.length > 255 ? 254 : key.length),
        defaultValue: null);
    return data != null
        ? InvestmentPolicyStatementSubGroupingModel.fromJson(data)
        : null;
  }

  @override
  Future<void> saveInvestmentPolicyStatementSubGrouping(
      {required Map<String, dynamic> requestBody,
      required Map<dynamic, dynamic> response}) async {
    final ipsBox = await Hive.openBox(HiveBox.ipsBox);
    final key =
        '${HiveFields.ipsSubGrouping}_${requestBody['id']}_${requestBody['subgrouping']}'
            .trim();
    await ipsBox.put(
        key.substring(0, key.length > 255 ? 254 : key.length), response);
  }

  @override
  Future<InvestmentPolicyStatementPoliciesModel?>
      getInvestmentPolicyStatementPolicies() async {
    final ipsBox = await Hive.openBox(HiveBox.ipsBox);
    final data = await ipsBox.get(HiveFields.ipsPolicies, defaultValue: null);
    return data != null
        ? InvestmentPolicyStatementPoliciesModel.fromJson(data)
        : null;
  }

  @override
  Future<void> saveInvestmentPolicyStatementPolicies(
      {required Map<dynamic, dynamic> response}) async {
    final ipsBox = await Hive.openBox(HiveBox.ipsBox);
    await ipsBox.put(HiveFields.ipsPolicies, response);
  }

  @override
  Future<InvestmentPolicyStatementTimePeriodModel?>
      getInvestmentPolicyStatementTimePeriod(
          {required Map<String, dynamic> requestBody}) async {
    final ipsBox = await Hive.openBox(HiveBox.ipsBox);
    final data = await ipsBox.get(HiveFields.ipsYears, defaultValue: null);
    return data != null
        ? InvestmentPolicyStatementTimePeriodModel.fromJson(data)
        : null;
  }

  @override
  Future<void> saveInvestmentPolicyStatementTimePeriod(
      {required Map<String, dynamic> requestBody,
      required Map<dynamic, dynamic> response}) async {
    final ipsBox = await Hive.openBox(HiveBox.ipsBox);
    await ipsBox.put(HiveFields.ipsYears, response);
  }

  @override
  Future<InvestmentPolicyStatementReportModel?>
      getInvestmentPolicyStatementReport(
          {required Map<String, dynamic> requestBody}) async {
    final ipsBox = await Hive.openBox(HiveBox.ipsBox);
    final key =
        (('${HiveFields.ipsReport}_${requestBody['date']}_${requestBody['id']}_${requestBody['currencyid']}_${requestBody['primaryfilter']}_${requestBody['filter5']}_${requestBody['policyid']}_${requestBody['yearReturn']}')
                .replaceAll('-', '_')
                .replaceAll(',', '_'))
            .trim();
    final data = await ipsBox.get(
        key.substring(0, key.length > 255 ? 254 : key.length),
        defaultValue: null);
    return data != null
        ? InvestmentPolicyStatementReportModel.fromJson(data)
        : null;
  }

  @override
  Future<void> saveInvestmentPolicyStatementReport(
      {required Map<String, dynamic> requestBody,
      required Map<dynamic, dynamic> response}) async {
    final ipsBox = await Hive.openBox(HiveBox.ipsBox);
    final key =
        (('${HiveFields.ipsReport}_${requestBody['date']}_${requestBody['id']}_${requestBody['currencyid']}_${requestBody['primaryfilter']}_${requestBody['filter5']}_${requestBody['policyid']}_${requestBody['yearReturn']}')
                .replaceAll('-', '_')
                .replaceAll(',', '_'))
            .trim();
    await ipsBox.put(
        key.substring(0, key.length > 255 ? 254 : key.length), response);
  }

  @override
  Future<void> clearInvestmentPolicyStatement() async {
    final ipsBox = await Hive.openBox(HiveBox.ipsBox);
    await ipsBox.clear();
  }

  @override
  Future<cbpg.CashBalanceGroupingModel?> getCashBalanceGrouping(
      {required Map<dynamic, dynamic> requestBody}) async {
    final cashBalanceBox = await Hive.openBox(HiveBox.cashBalanceBox);
    final key =
        "${HiveFields.cashBalanceGrouping}_${requestBody['entitytype']}_${requestBody['entiyid']}";
    final data = await cashBalanceBox.get(key, defaultValue: null);
    return data != null ? cbpg.CashBalanceGroupingModel.fromJson(data) : null;
  }

  @override
  Future<void> saveCashBalanceGrouping(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response}) async {
    final cashBalanceBox = await Hive.openBox(HiveBox.cashBalanceBox);
    final key =
        "${HiveFields.cashBalanceGrouping}_${requestBody['entitytype']}_${requestBody['entiyid']}";
    await cashBalanceBox.put(key, response);
  }

  @override
  Future<CashBalanceSubGroupingModel?> getCashBalanceSubGrouping(
      {required Map<String, dynamic> requestBody}) async {
    final cashBalanceBox = await Hive.openBox(HiveBox.cashBalanceBox);
    final key =
        "${HiveFields.cashBalanceSubGrouping}_${requestBody['curFilter']}_${requestBody['entitytype']}_${requestBody['entiyid']}";
    final data = await cashBalanceBox.get(key, defaultValue: null);
    return data != null ? CashBalanceSubGroupingModel.fromJson(data) : null;
  }

  @override
  Future<void> saveCashBalanceSubGrouping(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response}) async {
    final cashBalanceBox = await Hive.openBox(HiveBox.cashBalanceBox);
    final key =
        "${HiveFields.cashBalanceSubGrouping}_${requestBody['curFilter']}_${requestBody['entitytype']}_${requestBody['entiyid']}";
    await cashBalanceBox.put(key, response);
  }

  @override
  Future<CashBalanceReportModel?> getCashBalanceReport(
      {required Map<String, dynamic> requestBody}) async {
    final cashBalanceBox = await Hive.openBox(HiveBox.cashBalanceBox);
    final key =
    (('${HiveFields.cashBalanceReport}-${requestBody['entityname']}_${requestBody['entityid']}_${requestBody['entitytype']}-${requestBody['primary_filter']}_${requestBody['primary_filter_name']}_${requestBody['primary_sub_filter']}_${requestBody['accountnumbers']}_${requestBody['period']}_${requestBody['nop']}_${requestBody['currencyid']}_${requestBody['asOnDate']}')
        .replaceAll('-', '_')
        .replaceAll(',', '_'))
        .trim();
    final data = await cashBalanceBox.get(
        const Uuid().v5("b4b3c96d-a646-507e-970e-64614478c8a6", key),
        defaultValue: null);
    return data != null
        ? CashBalanceReportModel.fromJson(json: data)
        : data;
  }

  @override
  Future<CashBalanceSubGroupingModel?> getCashBalanceAccounts(
      {required Map<String, dynamic> requestBody}) async {
    final cashBalanceBox = await Hive.openBox(HiveBox.cashBalanceBox);
    final key =
        "${HiveFields.cashBalanceSelectedAccounts}_${requestBody['curFilter']}_${requestBody['entitytype']}_${requestBody['entiyid']}_${requestBody['filter1val']}_${requestBody['filter4val']}_${requestBody['todate']}";
    final data = await cashBalanceBox.get(key, defaultValue: null);
    return data != null ? CashBalanceSubGroupingModel.fromJson(data) : null;
  }

  @override
  Future<void> saveCashBalanceAccounts(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response}) async {
    final cashBalanceBox = await Hive.openBox(HiveBox.cashBalanceBox);
    final key =
        "${HiveFields.cashBalanceSelectedAccounts}_${requestBody['curFilter']}_${requestBody['entitytype']}_${requestBody['entiyid']}_${requestBody['filter1val']}_${requestBody['filter4val']}_${requestBody['todate']}";
    await cashBalanceBox.put(key, response);
  }

  @override
  Future<Entity?> getCashBalanceSelectedEntity(
      {required String tileName, required String postFix}) async {
    final cashBalanceBox =
        await Hive.openBox(HiveBox.cashBalanceFilterBox(postFix: postFix));
    final data = await cashBalanceBox.get(
        "${HiveFields.cashBalanceSelectedEntity}_$tileName",
        defaultValue: null);
    return data != null ? Entity.fromJson(data) : null;
  }

  @override
  Future<void> saveCashBalanceSelectedEntity(
      {required String tileName,
      required Map<dynamic, dynamic> response,
      required String postFix}) async {
    final cashBalanceBox =
        await Hive.openBox(HiveBox.cashBalanceFilterBox(postFix: postFix));
    await cashBalanceBox.put(
        "${HiveFields.cashBalanceSelectedEntity}_$tileName", response);
  }

  @override
  Future<cbpg.PrimaryGrouping?> getCashBalanceSelectedPrimaryGrouping(
      {required String? tileName,
      required EntityData? entity,
      required String postFix}) async {
    final cashBalanceBox =
        await Hive.openBox(HiveBox.cashBalanceFilterBox(postFix: postFix));
    final data = await cashBalanceBox.get(
        "${HiveFields.cashBalanceSelectedPrimaryGrouping}_$tileName",
        defaultValue: null);
    return data != null ? cbpg.PrimaryGrouping.fromJson(data) : null;
  }

  @override
  Future<void> saveCashBalanceSelectedPrimaryGrouping(
      {required String tileName,
      required EntityData entity,
      required Map<dynamic, dynamic> response,
      required String postFix}) async {
    final cashBalanceBox =
        await Hive.openBox(HiveBox.cashBalanceFilterBox(postFix: postFix));
    await cashBalanceBox.put(
        "${HiveFields.cashBalanceSelectedPrimaryGrouping}_$tileName", response);
  }

  @override
  Future<List<cb.SubGroupingItem?>?> getCashBalanceSelectedPrimarySubGrouping(
      {required String tileName,
      required Map<dynamic, dynamic> requestBody,
      required String postFix}) async {
    final cashBalanceBox =
        await Hive.openBox(HiveBox.cashBalanceFilterBox(postFix: postFix));
    final key =
        "${HiveFields.cashBalanceSelectedPrimarySubGrouping}_${tileName}_${requestBody['entityid']}_${requestBody['entitytype']}_${requestBody['id']}";
    final data = await cashBalanceBox.get(key, defaultValue: null);
    return data != null
        ? cb.CashBalanceSubGroupingModel.fromJson(data).subGrouping
        : null;
  }

  @override
  Future<void> saveCashBalanceSelectedPrimarySubGrouping(
      {required String tileName,
      required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response,
      required String postFix}) async {
    final cashBalanceBox =
        await Hive.openBox(HiveBox.cashBalanceFilterBox(postFix: postFix));
    final key =
        "${HiveFields.cashBalanceSelectedPrimarySubGrouping}_${tileName}_${requestBody['entityid']}_${requestBody['entitytype']}_${requestBody['id']}";
    await cashBalanceBox.put(key, response);
  }

  @override
  Future<void> saveCashBalanceReport(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response}) async {
    final cashBalanceBox = await Hive.openBox(HiveBox.cashBalanceBox);
    final key =
        (('${HiveFields.cashBalanceReport}-${requestBody['entityname']}_${requestBody['entityid']}_${requestBody['entitytype']}-${requestBody['primary_filter']}_${requestBody['primary_filter_name']}_${requestBody['primary_sub_filter']}_${requestBody['accountnumbers']}_${requestBody['period']}_${requestBody['nop']}_${requestBody['currencyid']}_${requestBody['asOnDate']}')
                .replaceAll('-', '_')
                .replaceAll(',', '_'))
            .trim();
    await cashBalanceBox.put(
        const Uuid().v5("b4b3c96d-a646-507e-970e-64614478c8a6", key), response);
  }

  @override
  Future<CurrencyData?> getCashBalanceSelectedCurrency(
      {required String tileName, required String postFix}) async {
    final cashBalanceBox =
        await Hive.openBox(HiveBox.cashBalanceFilterBox(postFix: postFix));
    final data = await cashBalanceBox.get(
        "${HiveFields.cashBalanceSelectedCurrency}_$tileName",
        defaultValue: null);
    return data != null ? CurrencyData.fromJson(data) : null;
  }

  @override
  Future<void> saveCashBalanceSelectedCurrency(
      {required String tileName,
      required Map response,
      required String postFix}) async {
    final cashBalanceBox =
        await Hive.openBox(HiveBox.cashBalanceFilterBox(postFix: postFix));
    await cashBalanceBox.put(
        "${HiveFields.cashBalanceSelectedCurrency}_$tileName", response);
  }

  @override
  Future<DenData?> getCashBalanceSelectedDenomination(
      {required String tileName, required String postFix}) async {
    final cashBalanceBox =
        await Hive.openBox(HiveBox.cashBalanceFilterBox(postFix: postFix));
    final data = await cashBalanceBox.get(
        "${HiveFields.cashBalanceSelectedDenomination}_$tileName",
        defaultValue: null);
    return data != null ? DenData.fromJson(data) : null;
  }

  @override
  Future<void> saveCashBalanceSelectedDenomination(
      {required String tileName,
      required Map response,
      required String postFix}) async {
    final cashBalanceBox =
        await Hive.openBox(HiveBox.cashBalanceFilterBox(postFix: postFix));
    await cashBalanceBox.put(
        "${HiveFields.cashBalanceSelectedDenomination}_$tileName", response);
  }

  @override
  Future<String?> getCashBalanceSelectedAsOnDate(
      {required String tileName, required String postFix}) async {
    final cashBalanceBox =
        await Hive.openBox(HiveBox.cashBalanceFilterBox(postFix: postFix));
    final data = await cashBalanceBox.get(
        "${HiveFields.cashBalanceSelectedAsOnDate}_$tileName",
        defaultValue: null);
    return data != null ? data : null;
  }

  @override
  Future<void> saveCashBalanceSelectedAsOnDate(
      {required String tileName,
      required String? response,
      required String postFix}) async {
    final cashBalanceBox =
        await Hive.openBox(HiveBox.cashBalanceFilterBox(postFix: postFix));
    await cashBalanceBox.put(
        "${HiveFields.cashBalanceSelectedAsOnDate}_$tileName", response);
  }

  @override
  Future<cbnp.NumberOfPeriodItem?> getCashBalanceSelectedNumberOfPeriod(
      {required String tileName, required String postFix}) async {
    final cashBalanceBox =
        await Hive.openBox(HiveBox.cashBalanceFilterBox(postFix: postFix));
    final data = await cashBalanceBox.get(
        "${HiveFields.cashBalanceSelectedNumberOfPeriod}_$tileName",
        defaultValue: null);
    return data != null ? cbnp.NumberOfPeriodItem.fromJson(data) : null;
  }

  @override
  Future<cbp.PeriodItem?> getCashBalanceSelectedPeriod(
      {required String tileName, required String postFix}) async {
    final cashBalanceBox =
        await Hive.openBox(HiveBox.cashBalanceFilterBox(postFix: postFix));
    final data = await cashBalanceBox.get(
        "${HiveFields.cashBalanceSelectedPeriod}_$tileName",
        defaultValue: null);
    return data != null ? cbp.PeriodItem.fromJson(data) : null;
  }

  @override
  Future<void> saveCashBalanceSelectedNumberOfPeriod(
      {required String tileName,
      required Map response,
      required String postFix}) async {
    final cashBalanceBox =
        await Hive.openBox(HiveBox.cashBalanceFilterBox(postFix: postFix));
    await cashBalanceBox.put(
        "${HiveFields.cashBalanceSelectedNumberOfPeriod}_$tileName", response);
  }

  @override
  Future<void> saveCashBalanceSelectedPeriod(
      {required String tileName,
      required Map response,
      required String postFix}) async {
    final cashBalanceBox =
        await Hive.openBox(HiveBox.cashBalanceFilterBox(postFix: postFix));
    await cashBalanceBox.put(
        "${HiveFields.cashBalanceSelectedPeriod}_$tileName", response);
  }

  @override
  Future<List<cb.SubGroupingItem?>?> getCashBalanceSelectedAccounts(
      {required String tileName,
      required Map<dynamic, dynamic> requestBody,
      required String postFix}) async {
    final cashBalanceBox =
        await Hive.openBox(HiveBox.cashBalanceFilterBox(postFix: postFix));
    final key =
        "${HiveFields.cashBalanceSelectedAccounts}_${tileName}_${requestBody['entityid']}_${requestBody['entitytype']}_${requestBody['id']}";
    final data = await cashBalanceBox.get(key, defaultValue: null);
    return data != null
        ? cb.CashBalanceSubGroupingModel.fromJson(data).subGrouping
        : null;
  }

  @override
  Future<void> saveCashBalanceSelectedAccounts(
      {required String tileName,
      required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response,
      required String postFix}) async {
    final cashBalanceBox =
        await Hive.openBox(HiveBox.cashBalanceFilterBox(postFix: postFix));
    final key =
        "${HiveFields.cashBalanceSelectedAccounts}_${tileName}_${requestBody['entityid']}_${requestBody['entitytype']}_${requestBody['id']}";
    await cashBalanceBox.put(key, response);
  }

  @override
  Future<void> clearCashBalance() async {
    final cashBalanceBox = await Hive.openBox(HiveBox.cashBalanceBox);
    await cashBalanceBox.clear();
  }

  @override
  Future<nwgp.NetWorthGroupingModel?> getNetWorthGrouping(
      {required Map<dynamic, dynamic> requestBody}) async {
    final netWorthBox = await Hive.openBox(HiveBox.netWorthBox);
    final key =
        "${HiveFields.netWorthGrouping}_${requestBody['entitytype']}_${requestBody['entiyid']}";
    final data = await netWorthBox.get(key, defaultValue: null);
    return data != null ? nwgp.NetWorthGroupingModel.fromJson(data) : null;
  }

  @override
  Future<void> saveNetWorthGrouping(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response}) async {
    final netWorthBox = await Hive.openBox(HiveBox.netWorthBox);
    final key =
        "${HiveFields.netWorthGrouping}_${requestBody['entitytype']}_${requestBody['entiyid']}";
    await netWorthBox.put(key, response);
  }

  @override
  Future<nw.NetWorthSubGroupingModel?> getNetWorthSubGrouping(
      {required Map<dynamic, dynamic> requestBody}) async {
    final netWorthBox = await Hive.openBox(HiveBox.netWorthBox);
    final key =
        "${HiveFields.netWorthSubGrouping}_${requestBody['curFilter']}_${requestBody['entitytype']}_${requestBody['entiyid']}";
    final data = await netWorthBox.get(key, defaultValue: null);
    return data != null ? nw.NetWorthSubGroupingModel.fromJson(data) : null;
  }

  @override
  Future<void> saveNetWorthSubGrouping(
      {required Map<dynamic, dynamic> response,
      required Map<dynamic, dynamic> requestBody}) async {
    final netWorthBox = await Hive.openBox(HiveBox.netWorthBox);
    final key =
        "${HiveFields.netWorthSubGrouping}_${requestBody['curFilter']}_${requestBody['entitytype']}_${requestBody['entiyid']}_${requestBody["partnershipmethod"]}";
    await netWorthBox.put(key, response);
  }

  @override
  Future<NetWorthReportModel?> getNetWorthReport(
      {required Map<String, dynamic> requestBody}) async {
    final netWorthBox = await Hive.openBox(HiveBox.netWorthBox);
    final key =
        (('${HiveFields.netWorthReport}_${requestBody['entity']}_${requestBody['entitytype']}_${requestBody['filter1']}_${requestBody['filter4']}_${requestBody['columnList']}_${requestBody['partnershipmethod']}_${requestBody['partnershipmethodName']}_${requestBody['withParthership']}_${requestBody['currency']}_${requestBody['periodDates']}')
                .replaceAll('-', '_')
                .replaceAll(',', '_'))
            .trim();
    final data = await netWorthBox.get(
        const Uuid().v5("b4b3c96d-a646-507e-970e-64614478c8a6", key),
        defaultValue: null);
    return data != null
        ? NetWorthReportModel.fromJson(json: data, fromCache: true)
        : null;
  }

  @override
  Future<void> saveNetWorthReport(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response}) async {
    final netWorthBox = await Hive.openBox(HiveBox.netWorthBox);
    final key =
        (('${HiveFields.netWorthReport}_${requestBody['entity']}_${requestBody['entitytype']}_${requestBody['filter1']}_${requestBody['filter4']}_${requestBody['columnList']}_${requestBody['partnershipmethod']}_${requestBody['partnershipmethodName']}_${requestBody['withParthership']}_${requestBody['currency']}_${requestBody['periodDates']}')
                .replaceAll('-', '_')
                .replaceAll(',', '_'))
            .trim();
    await netWorthBox.put(
        const Uuid().v5("b4b3c96d-a646-507e-970e-64614478c8a6", key), response);
  }

  @override
  Future<void> clearNetWorth() async {
    final netWorthBox = await Hive.openBox(HiveBox.netWorthBox);
    await netWorthBox.clear();
  }

  @override
  Future<String?> getNetWorthSelectedAsOnDate({required String postFix}) async {
    final netWorthBox =
        await Hive.openBox(HiveBox.netWorthFilterBox(postFix: postFix));
    final data = await netWorthBox.get(HiveFields.netWorthSelectedAsOnDate,
        defaultValue: null);
    return data;
  }

  @override
  Future<void> saveNetWorthSelectedAsOnDate(
      {required String? response, required String postFix}) async {
    final netWorthBox =
        await Hive.openBox(HiveBox.netWorthFilterBox(postFix: postFix));
    await netWorthBox.put(HiveFields.netWorthSelectedAsOnDate, response);
  }

  @override
  Future<CurrencyData?> getNetWorthSelectedCurrency(
      {required String postFix}) async {
    final netWorthBox =
        await Hive.openBox(HiveBox.netWorthFilterBox(postFix: postFix));
    final data = await netWorthBox.get(HiveFields.netWorthSelectedCurrency,
        defaultValue: null);
    return data != null ? CurrencyData.fromJson(data) : null;
  }

  @override
  Future<void> saveNetWorthSelectedCurrency(
      {required Map<dynamic, dynamic> response,
      required String postFix}) async {
    final netWorthBox =
        await Hive.openBox(HiveBox.netWorthFilterBox(postFix: postFix));
    await netWorthBox.put(HiveFields.netWorthSelectedCurrency, response);
  }

  @override
  Future<DenData?> getNetWorthSelectedDenomination(
      {required String postFix}) async {
    final netWorthBox =
        await Hive.openBox(HiveBox.netWorthFilterBox(postFix: postFix));
    final data = await netWorthBox.get(HiveFields.netWorthSelectedDenomination,
        defaultValue: null);
    return data != null ? DenData.fromJson(data) : null;
  }

  @override
  Future<void> saveNetWorthSelectedDenomination(
      {required Map<dynamic, dynamic> response,
      required String postFix}) async {
    final netWorthBox =
        await Hive.openBox(HiveBox.netWorthFilterBox(postFix: postFix));
    await netWorthBox.put(HiveFields.netWorthSelectedDenomination, response);
  }

  @override
  Future<Entity?> getNetWorthSelectedEntity({required String postFix}) async {
    final netWorthBox =
        await Hive.openBox(HiveBox.netWorthFilterBox(postFix: postFix));
    final data = await netWorthBox.get(HiveFields.netWorthSelectedEntity,
        defaultValue: null);
    return data != null ? Entity.fromJson(data) : null;
  }

  @override
  Future<void> saveNetWorthSelectedEntity(
      {required Map<dynamic, dynamic> response,
      required String postFix}) async {
    final netWorthBox =
        await Hive.openBox(HiveBox.netWorthFilterBox(postFix: postFix));
    await netWorthBox.put(HiveFields.netWorthSelectedEntity, response);
  }

  @override
  Future<cbnp.NumberOfPeriodItem?> getNetWorthSelectedNumberOfPeriod(
      {required String tileName, required String postFix}) async {
    final netWorthBox =
        await Hive.openBox(HiveBox.netWorthFilterBox(postFix: postFix));
    final data = await netWorthBox.get(
        "${HiveFields.netWorthSelectedNumberOfPeriod}_$tileName",
        defaultValue: null);
    return data != null ? cbnp.NumberOfPeriodItem.fromJson(data) : null;
  }

  @override
  Future<void> saveNetWorthSelectedNumberOfPeriod(
      {required String tileName,
      required Map response,
      required String postFix}) async {
    final netWorthBox =
        await Hive.openBox(HiveBox.netWorthFilterBox(postFix: postFix));
    await netWorthBox.put(
        "${HiveFields.netWorthSelectedNumberOfPeriod}_$tileName", response);
  }

  @override
  Future<PartnershipMethodItem?> getNetWorthSelectedPartnershipMethod(
      {required String tileName, required String postFix}) async{
    final netWorthBox = await Hive.openBox(HiveBox.netWorthFilterBox(postFix: postFix));
    final data = await netWorthBox.get("${HiveFields.netWorthSelectedPartnershipMethod}_$tileName",
    defaultValue: null);
    return data != null ? PartnershipMethodItem.fromJson(data): null;
  }

  @override
  Future<void> saveNetWorthSelectedPartnershipMethod(
      {required String tileName,
        required Map<dynamic, dynamic> response, required String postFix})async {
   final netWorthBox= await Hive.openBox(HiveBox.netWorthFilterBox(postFix: postFix));
   await netWorthBox.put("${HiveFields.netWorthSelectedPartnershipMethod}_$tileName", response);
  }


  @override
  Future<void> saveNetWorthSelectedHoldingMethod(
      {required String tileName,
        required Map<dynamic, dynamic>? response, required String postFix}) async{
    final netWorthBox = await Hive.openBox(HiveBox.netWorthFilterBox(postFix: postFix));
    await netWorthBox.put("${HiveFields.netWorthSelectedHoldingMethod}_$tileName", response);
  }

  @override
  Future<cbp.PeriodItem?> getNetWorthSelectedPeriod(
      {required String tileName, required String postFix}) async {
    final netWorthBox =
        await Hive.openBox(HiveBox.netWorthFilterBox(postFix: postFix));
    final data = await netWorthBox.get(
        "${HiveFields.netWorthSelectedPeriod}_$tileName",
        defaultValue: null);
    return data != null ? cbp.PeriodItem.fromJson(data) : null;
  }

  @override
  Future<void> saveNetWorthSelectedPeriod(
      {required String tileName,
      required Map response,
      required String postFix}) async {
    final netWorthBox =
        await Hive.openBox(HiveBox.netWorthFilterBox(postFix: postFix));
    await netWorthBox.put(
        "${HiveFields.netWorthSelectedPeriod}_$tileName", response);
  }

  @override
  Future<nwgp.PrimaryGrouping?> getNetWorthSelectedPrimaryGrouping(
      {required String postFix}) async {
    final netWorthBox =
        await Hive.openBox(HiveBox.netWorthFilterBox(postFix: postFix));
    final data = await netWorthBox
        .get(HiveFields.netWorthSelectedPrimaryGrouping, defaultValue: null);
    return data != null ? nwgp.PrimaryGrouping.fromJson(data) : null;
  }

  @override
  Future<void> saveNetWorthSelectedPrimaryGrouping(
      {required Map<dynamic, dynamic> response,
      required String postFix}) async {
    final netWorthBox =
        await Hive.openBox(HiveBox.netWorthFilterBox(postFix: postFix));
    await netWorthBox.put(HiveFields.netWorthSelectedPrimaryGrouping, response);
  }

  @override
  Future<List<nw.SubGroupingItem?>?> getNetWorthSelectedPrimarySubGrouping(
      {required Map<dynamic, dynamic> requestBody,
      required String postFix}) async {
    final netWorthBox =
        await Hive.openBox(HiveBox.netWorthFilterBox(postFix: postFix));
    final key =
        "${HiveFields.netWorthSelectedPrimarySubGrouping}_${requestBody['entityid']}_${requestBody['entitytype']}_${requestBody['id']}";
    final data = await netWorthBox.get(key, defaultValue: null);
    return data != null
        ? nw.NetWorthSubGroupingModel.fromJson(data).subGrouping
        : null;
  }

  @override
  Future<void> saveNetWorthSelectedPrimarySubGrouping(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response,
      required String postFix}) async {
    final netWorthBox =
        await Hive.openBox(HiveBox.netWorthFilterBox(postFix: postFix));
    final key =
        "${HiveFields.netWorthSelectedPrimarySubGrouping}_${requestBody['entityid']}_${requestBody['entitytype']}_${requestBody['id']}";
    await netWorthBox.put(key, response);
  }

  @override
  Future<rpmodal.ReturnPercentItem?> getNetWorthSelectedReturnPercent(
      {required String postFix}) async {
    final netWorthBox =
        await Hive.openBox(HiveBox.netWorthFilterBox(postFix: postFix));
    final data = await netWorthBox.get(HiveFields.netWorthSelectedReturnPercent,
        defaultValue: null);
    return data != null ? rpmodal.ReturnPercentItem.fromJson(data) : null;
  }

  @override
  Future<void> saveNetWorthSelectedReturnPercent(
      {required Map<dynamic, dynamic> response,
      required String postFix}) async {
    final netWorthBox =
        await Hive.openBox(HiveBox.netWorthFilterBox(postFix: postFix));
    await netWorthBox.put(HiveFields.netWorthSelectedReturnPercent, response);
  }

  @override
  Future<PerformancePrimaryGroupingModel?> getPerformancePrimaryGrouping(
      {required Map<dynamic, dynamic> requestBody}) async {
    final performanceBox = await Hive.openBox(HiveBox.performanceBox);
    final key =
        "${HiveFields.performancePrimaryGrouping}_${requestBody['entitytype']}_${requestBody['entiyid']}";
    final data = await performanceBox.get(key, defaultValue: null);
    return data != null ? PerformancePrimaryGroupingModel.fromJson(data) : null;
  }

  @override
  Future<void> savePerformancePrimaryGrouping(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response}) async {
    final performanceBox = await Hive.openBox(HiveBox.performanceBox);
    final key =
        "${HiveFields.performancePrimaryGrouping}_${requestBody['entitytype']}_${requestBody['entiyid']}";
    await performanceBox.put(key, response);
  }

  @override
  Future<PerformancePrimarySubGroupingModel?> getPerformancePrimarySubGrouping(
      {required Map<dynamic, dynamic> requestBody}) async {
    final performanceBox = await Hive.openBox(HiveBox.performanceBox);
    final key =
        "${HiveFields.performancePrimarySubGrouping}_${requestBody['curFilter']}_${requestBody['entitytype']}_${requestBody['entiyid']}_${requestBody['partnershipmethod']}_${requestBody['partnershipmethodName']}_${requestBody['withParthership']}";
    //_${requestBody['partnershipmethod']}_${requestBody['partnershipmethodName']}_${requestBody['withParthership']}

    final data = await performanceBox.get(key, defaultValue: null);
    return data != null
        ? PerformancePrimarySubGroupingModel.fromJson(data)
        : null;
  }

  @override
  Future<void> savePerformancePrimarySubGrouping(
      {required Map<dynamic, dynamic> response,
      required Map<dynamic, dynamic> requestBody}) async {
    final performanceBox = await Hive.openBox(HiveBox.performanceBox);
    final key =
        "${HiveFields.performancePrimarySubGrouping}_${requestBody['curFilter']}_${requestBody['entitytype']}_${requestBody['entiyid']}";
    await performanceBox.put(key, response);
  }

  @override
  Future<PerformanceSecondaryGroupingModel?> getPerformanceSecondaryGrouping(
      {required Map<dynamic, dynamic> requestBody}) async {
    final performanceBox = await Hive.openBox(HiveBox.performanceBox);
    final key =
        "${HiveFields.performanceSecondaryGrouping}_${requestBody['entitytype']}_${requestBody['entiyid']}";
    //_${requestBody['partnershipmethod']}_${requestBody['partnershipmethodName']}_${requestBody['withParthership']}
    final data = await performanceBox.get(key, defaultValue: null);
    return data != null
        ? PerformanceSecondaryGroupingModel.fromJson(data)
        : null;
  }

  @override
  Future<void> savePerformanceSecondaryGrouping(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response}) async {
    final performanceBox = await Hive.openBox(HiveBox.performanceBox);
    final key =
        "${HiveFields.performanceSecondaryGrouping}_${requestBody['entitytype']}_${requestBody['entiyid']}";
    await performanceBox.put(key, response);
  }

  @override
  Future<PerformanceSecondarySubGroupingModel?>
      getPerformanceSecondarySubGrouping(
          {required Map<dynamic, dynamic> requestBody}) async {
    final performanceBox = await Hive.openBox(HiveBox.performanceBox);
    final key =
        "${HiveFields.performanceSecondarySubGrouping}_${requestBody['curFilter']}_${requestBody['entitytype']}_${requestBody['entiyid']}";
    final data = await performanceBox.get(key, defaultValue: null);
    return data != null
        ? PerformanceSecondarySubGroupingModel.fromJson(data)
        : null;
  }

  @override
  Future<void> savePerformanceSecondarySubGrouping(
      {required Map<dynamic, dynamic> response,
      required Map<dynamic, dynamic> requestBody}) async {
    final performanceBox = await Hive.openBox(HiveBox.performanceBox);
    final key =
        "${HiveFields.performanceSecondarySubGrouping}_${requestBody['curFilter']}_${requestBody['entitytype']}_${requestBody['entiyid']}";
    await performanceBox.put(key, response);
  }

  @override
  Future<PerformanceReportModel?> getPerformanceReport(
      {required Map<String, dynamic> requestBody}) async {
    final performanceBox = await Hive.openBox(HiveBox.performanceBox);
    final key =
        (('${HiveFields.performanceReport}_${requestBody['entityid']}_${requestBody['entitytype']}_${requestBody['filter1']}_${requestBody['filter1name']}_${requestBody['filter3']}_${requestBody['filter3name']}_${requestBody['currency']}_${requestBody['currencyname']}_${requestBody['txntodate']}_${requestBody['multiPeriod']}')
                .replaceAll('-', '_')
                .replaceAll(',', '_'))
            .trim();
    final data = await performanceBox.get(
        const Uuid().v5("b4b3c96d-a646-507e-970e-64614478c8a6",
            key) /*key.substring(0, key.length > 255 ? 254 : key.length)*/,
        defaultValue: null);
    return data != null ? PerformanceReportModel.fromJson(data, /*true*/) : null;
    //_${requestBody['filter4']}_${requestBody['filter5']}

    //_${requestBody['partnershipmethod']}_${requestBody['partnershipmethodName']}_${requestBody['withParthership']}
  }

  @override
  Future<void> savePerformanceReport(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response}) async {
    final performanceBox = await Hive.openBox(HiveBox.performanceBox);
    final key =
        (('${HiveFields.performanceReport}_${requestBody['entityid']}_${requestBody['entitytype']}_${requestBody['filter1']}_${requestBody['filter1name']}_${requestBody['filter3']}_${requestBody['filter3name']}_${requestBody['currency']}_${requestBody['currencyname']}_${requestBody['txntodate']}_${requestBody['multiPeriod']}')
                .replaceAll('-', '_')
                .replaceAll(',', '_'))
            .trim();
    await performanceBox.put(
        const Uuid().v5("b4b3c96d-a646-507e-970e-64614478c8a6",
            key) /*key.substring(0, key.length > 255 ? 254 : key.length)*/,
        response);
  //_${requestBody['filter4']}_${requestBody['filter5']}
    //_${requestBody['partnershipmethod']}_${requestBody['partnershipmethodName']}_${requestBody['withParthership']}
  }

  @override
  Future<Entity?> getPerformanceSelectedEntity(
      {required String postFix}) async {
    final performanceBox =
        await Hive.openBox(HiveBox.performanceFilterBox(postFix: postFix));
    final data = await performanceBox.get(HiveFields.performanceSelectedEntity,
        defaultValue: null);
    return data != null ? Entity.fromJson(data) : null;
  }

  @override
  Future<void> savePerformanceSelectedEntity(
      {required Map<dynamic, dynamic> response,
      required String postFix}) async {
    final performanceBox =
        await Hive.openBox(HiveBox.performanceFilterBox(postFix: postFix));
    await performanceBox.put(HiveFields.performanceSelectedEntity, response);
  }

  @override
  Future<primaryGrouping.PrimaryGrouping?>
      getPerformanceSelectedPrimaryGrouping({required String postFix}) async {
    final performanceBox =
        await Hive.openBox(HiveBox.performanceFilterBox(postFix: postFix));
    final data = await performanceBox
        .get(HiveFields.performanceSelectedPrimaryGrouping, defaultValue: null);
    return data != null ? primaryGrouping.PrimaryGrouping.fromJson(data) : null;
  }

  @override
  Future<void> savePerformanceSelectedPrimaryGrouping(
      {required Map<dynamic, dynamic> response,
      required String postFix}) async {
    final performanceBox =
        await Hive.openBox(HiveBox.performanceFilterBox(postFix: postFix));
    await performanceBox.put(
        HiveFields.performanceSelectedPrimaryGrouping, response);
  }

  @override
  Future<List<primarySubGrouping.SubGroupingItem?>?>
      getPerformanceSelectedPrimarySubGrouping(
          {required Map<dynamic, dynamic> requestBody,
          required String postFix}) async {
    final performanceBox =
        await Hive.openBox(HiveBox.performanceFilterBox(postFix: postFix));
    final key =
        "${HiveFields.performanceSelectedPrimarySubGrouping}_${requestBody['entityid']}_${requestBody['entitytype']}_${requestBody['id']}";
    final data = await performanceBox.get(key, defaultValue: null);
    return data != null
        ? primarySubGrouping.PerformancePrimarySubGroupingModel.fromJson(data)
            .subGrouping
        : null;
  }

  @override
  Future<void> savePerformanceSelectedPrimarySubGrouping(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response,
      required String postFix}) async {
    final performanceBox =
        await Hive.openBox(HiveBox.performanceFilterBox(postFix: postFix));
    final key =
        "${HiveFields.performanceSelectedPrimarySubGrouping}_${requestBody['entityid']}_${requestBody['entitytype']}_${requestBody['id']}";
    await performanceBox.put(key, response);
  }

  @override
  Future<SecondaryGrouping?> getPerformanceSelectedSecondaryGrouping(
      {required String postFix}) async {
    final performanceBox =
        await Hive.openBox(HiveBox.performanceFilterBox(postFix: postFix));
    final data = await performanceBox.get(
        HiveFields.performanceSelectedSecondaryGrouping,
        defaultValue: null);
    return data != null ? SecondaryGrouping.fromJson(data) : null;
  }

  @override
  Future<void> savePerformanceSelectedSecondaryGrouping(
      {required Map<dynamic, dynamic> response,
      required String postFix}) async {
    final performanceBox =
        await Hive.openBox(HiveBox.performanceFilterBox(postFix: postFix));
    await performanceBox.put(
        HiveFields.performanceSelectedSecondaryGrouping, response);
  }

  @override
  Future<List<secondarySubGrouping.SubGroupingItem?>?>
      getPerformanceSelectedSecondarySubGrouping(
          {required Map<dynamic, dynamic> requestBody,
          required String postFix}) async {
    final performanceBox =
        await Hive.openBox(HiveBox.performanceFilterBox(postFix: postFix));
    final key =
        "${HiveFields.performanceSelectedSecondarySubGrouping}_${requestBody['entityid']}_${requestBody['entitytype']}_${requestBody['id']}";
    final data = await performanceBox.get(key, defaultValue: null);
    return data != null
        ? secondarySubGrouping.PerformanceSecondarySubGroupingModel.fromJson(
                data)
            .subGrouping
        : null;
  }

  @override
  Future<void> savePerformanceSelectedSecondarySubGrouping(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response,
      required String postFix}) async {
    final performanceBox =
        await Hive.openBox(HiveBox.performanceFilterBox(postFix: postFix));
    final key =
        "${HiveFields.performanceSelectedSecondarySubGrouping}_${requestBody['entityid']}_${requestBody['entitytype']}_${requestBody['id']}";
    await performanceBox.put(key, response);
  }

  @override
  Future<List<rp.ReturnPercentItem?>?> getPerformanceSelectedReturnPercent(
      {required String postFix}) async {
    final performanceBox =
        await Hive.openBox(HiveBox.performanceFilterBox(postFix: postFix));
    final data = await performanceBox
        .get(HiveFields.performanceSelectedReturnPercent, defaultValue: null);
    return data != null
        ? rp.ReturnPercentModel.fromJson(data).allReturnPercentList
        : null;
  }

  @override
  Future<void> savePerformanceSelectedReturnPercent(
      {required Map<dynamic, dynamic> response,
      required String postFix}) async {
    final performanceBox =
        await Hive.openBox(HiveBox.performanceFilterBox(postFix: postFix));
    await performanceBox.put(
        HiveFields.performanceSelectedReturnPercent, response);
  }

  @override
  Future<CurrencyData?> getPerformanceSelectedCurrency(
      {required String postFix}) async {
    final performanceBox =
        await Hive.openBox(HiveBox.performanceFilterBox(postFix: postFix));
    final data = await performanceBox
        .get(HiveFields.performanceSelectedCurrency, defaultValue: null);
    return data != null ? CurrencyData.fromJson(data) : null;
  }

  @override
  Future<void> savePerformanceSelectedCurrency(
      {required Map<dynamic, dynamic> response,
      required String postFix}) async {
    final performanceBox =
        await Hive.openBox(HiveBox.performanceFilterBox(postFix: postFix));
    await performanceBox.put(HiveFields.performanceSelectedCurrency, response);
  }

  @override
  Future<DenData?> getPerformanceSelectedDenomination(
      {required String postFix}) async {
    final performanceBox =
        await Hive.openBox(HiveBox.performanceFilterBox(postFix: postFix));
    final data = await performanceBox
        .get(HiveFields.performanceSelectedDenomination, defaultValue: null);
    return data != null ? DenData.fromJson(data) : null;
  }

  @override
  Future<void> savePerformanceSelectedDenomination(
      {required Map<dynamic, dynamic> response,
      required String postFix}) async {
    final performanceBox =
        await Hive.openBox(HiveBox.performanceFilterBox(postFix: postFix));
    await performanceBox.put(
        HiveFields.performanceSelectedDenomination, response);
  }

  @override
  Future<String?> getPerformanceSelectedAsOnDate(
      {required String postFix}) async {
    final performanceBox =
        await Hive.openBox(HiveBox.performanceFilterBox(postFix: postFix));
    final data = await performanceBox
        .get(HiveFields.performanceSelectedAsOnDate, defaultValue: null);
    return data != null ? data : null;
  }

  @override
  Future<void> savePerformanceSelectedAsOnDate(
      {required String? response, required String postFix}) async {
    final performanceBox =
        await Hive.openBox(HiveBox.performanceFilterBox(postFix: postFix));
    await performanceBox.put(HiveFields.performanceSelectedAsOnDate, response);
  }

  @override
  Future<void> clearPerformance() async {
    final performanceBox = await Hive.openBox(HiveBox.performanceBox);
    await performanceBox.clear();
  }

  @override
  Future<IncomeAccountModel?> getIncomeAccounts(
      {required Map<String, dynamic> requestBody}) async {
    final incomeBox = await Hive.openBox(HiveBox.incomeBox);
    final key =
        '${HiveFields.incomeAccount}_${requestBody['toDate']}_${requestBody['id']}'
            .trim();
    final data = await incomeBox.get(key, defaultValue: null);
    return data != null ? IncomeAccountModel.fromJson(data) : null;
  }

  @override
  Future<void> saveIncomeAccounts(
      {required Map<String, dynamic> requestBody,
      required Map response}) async {
    final incomeBox = await Hive.openBox(HiveBox.incomeBox);
    final key =
        '${HiveFields.incomeAccount}_${requestBody['toDate']}_${requestBody['id']}'
            .trim();
    await incomeBox.put(key, response);
  }

  @override
  Future<IncomeReportModel?> getIncomeReport(
      {required Map<String, dynamic> requestBody}) async {
    final incomeBox = await Hive.openBox(HiveBox.incomeBox);
    final key =
        (('${HiveFields.incomeReport}_${requestBody['asOnDate']}_${requestBody['id']}_${requestBody['currencyid']}_${requestBody['period']}_${requestBody['accountnumbers'] != null ? '${requestBody['accountnumbers']}'.total() : ''}')
                .replaceAll('-', '_')
                .replaceAll(',', '_'))
            .trim();
    final data = await incomeBox.get(key, defaultValue: null);
    return data != null ? IncomeReportModel.fromJson(data) : null;
  }

  @override
  Future<void> saveIncomeReport(
      {required Map<String, dynamic> requestBody,
      required Map<dynamic, dynamic> response}) async {
    final incomeBox = await Hive.openBox(HiveBox.incomeBox);
    final key =
        (('${HiveFields.incomeReport}_${requestBody['asOnDate']}_${requestBody['id']}_${requestBody['currencyid']}_${requestBody['period']}_${requestBody['accountnumbers'] != null ? '${requestBody['accountnumbers']}'.total() : ''}')
                .replaceAll('-', '_')
                .replaceAll(',', '_'))
            .trim();
    await incomeBox.put(key, response);
  }

  @override
  Future<Entity?> getIncomeSelectedEntity({required String postFix}) async {
    final performanceBox =
        await Hive.openBox(HiveBox.incomeFilterBox(postFix: postFix));
    final data = await performanceBox.get(HiveFields.incomeSelectedEntity,
        defaultValue: null);
    return data != null ? Entity.fromJson(data) : null;
  }

  @override
  Future<void> saveIncomeSelectedEntity(
      {required Map<dynamic, dynamic> response,
      required String postFix}) async {
    final performanceBox =
        await Hive.openBox(HiveBox.incomeFilterBox(postFix: postFix));
    await performanceBox.put(HiveFields.incomeSelectedEntity, response);
  }

  @override
  Future<List<IncomeAccount>?> getIncomeSelectedAccounts(
      {required Map<String, dynamic> requestBody,
      required String postFix}) async {
    final performanceBox =
        await Hive.openBox(HiveBox.incomeFilterBox(postFix: postFix));
    final key =
        "${HiveFields.incomeSelectedAccounts}_${requestBody['entityid']}_${requestBody['entitytype']}";
    final data = await performanceBox.get(key, defaultValue: null);
    return data != null
        ? IncomeAccountModel.fromJson(data).incomeAccount
        : null;
  }

  @override
  Future<void> saveIncomeSelectedAccounts(
      {required Map<String, dynamic> requestBody,
      required Map<dynamic, dynamic> response,
      required String postFix}) async {
    final performanceBox =
        await Hive.openBox(HiveBox.incomeFilterBox(postFix: postFix));
    final key =
        "${HiveFields.incomeSelectedAccounts}_${requestBody['entityid']}_${requestBody['entitytype']}";
    await performanceBox.put(key, response);
  }

  @override
  Future<period.PeriodItem?> getIncomeSelectedPeriod(
      {required String postFix}) async {
    final performanceBox =
        await Hive.openBox(HiveBox.incomeFilterBox(postFix: postFix));
    final data = await performanceBox.get(HiveFields.incomeSelectedPeriod,
        defaultValue: null);
    return data != null ? period.PeriodItem.fromJson(data) : null;
  }

  @override
  Future<void> saveIncomeSelectedPeriod(
      {required Map<dynamic, dynamic> response,
      required String postFix}) async {
    final performanceBox =
        await Hive.openBox(HiveBox.incomeFilterBox(postFix: postFix));
    await performanceBox.put(HiveFields.incomeSelectedPeriod, response);
  }

  @override
  Future<nop.NumberOfPeriodItem?> getIncomeSelectedNumberOfPeriod(
      {required String postFix}) async {
    final performanceBox =
        await Hive.openBox(HiveBox.incomeFilterBox(postFix: postFix));
    final data = await performanceBox
        .get(HiveFields.incomeSelectedNumberOfPeriod, defaultValue: null);
    return data != null ? nop.NumberOfPeriodItem.fromJson(data) : null;
  }

  @override
  Future<void> saveIncomeSelectedNumberOfPeriod(
      {required Map<dynamic, dynamic> response,
      required String postFix}) async {
    final performanceBox =
        await Hive.openBox(HiveBox.incomeFilterBox(postFix: postFix));
    await performanceBox.put(HiveFields.incomeSelectedNumberOfPeriod, response);
  }

  @override
  Future<CurrencyData?> getIncomeSelectedCurrency(
      {required String postFix}) async {
    final performanceBox =
        await Hive.openBox(HiveBox.incomeFilterBox(postFix: postFix));
    final data = await performanceBox.get(HiveFields.incomeSelectedCurrency,
        defaultValue: null);
    return data != null ? CurrencyData.fromJson(data) : null;
  }

  @override
  Future<void> saveIncomeSelectedCurrency(
      {required Map<dynamic, dynamic> response,
      required String postFix}) async {
    final performanceBox =
        await Hive.openBox(HiveBox.incomeFilterBox(postFix: postFix));
    await performanceBox.put(HiveFields.incomeSelectedCurrency, response);
  }

  @override
  Future<DenData?> getIncomeSelectedDenomination(
      {required String postFix}) async {
    final performanceBox =
        await Hive.openBox(HiveBox.incomeFilterBox(postFix: postFix));
    final data = await performanceBox.get(HiveFields.incomeSelectedDenomination,
        defaultValue: null);
    return data != null ? DenData.fromJson(data) : null;
  }

  @override
  Future<void> saveIncomeSelectedDenomination(
      {required Map<dynamic, dynamic> response,
      required String postFix}) async {
    final performanceBox =
        await Hive.openBox(HiveBox.incomeFilterBox(postFix: postFix));
    await performanceBox.put(HiveFields.incomeSelectedDenomination, response);
  }

  @override
  Future<ExpenseAccountModel?> getExpenseAccounts(
      {required Map<String, dynamic> requestBody}) async {
    final expenseBox = await Hive.openBox(HiveBox.expenseBox);
    final key =
        '${HiveFields.expenseAccount}_${requestBody['toDate']}_${requestBody['id']}'
            .trim();
    final data = await expenseBox.get(key, defaultValue: null);
    return data != null ? ExpenseAccountModel.fromJson(data) : null;
  }

  @override
  Future<void> saveExpenseAccounts(
      {required Map<String, dynamic> requestBody,
      required Map response}) async {
    final expenseBox = await Hive.openBox(HiveBox.expenseBox);
    final key =
        '${HiveFields.expenseAccount}_${requestBody['toDate']}_${requestBody['id']}'
            .trim();
    await expenseBox.put(key, response);
  }

  @override
  Future<ExpenseReportModel?> getExpenseReport(
      {required Map<String, dynamic> requestBody}) async {
    final expenseBox = await Hive.openBox(HiveBox.expenseBox);
    final key =
        (('${HiveFields.expenseReport}_${requestBody['asOnDate']}_${requestBody['id']}_${requestBody['reportingCurrency']}_${requestBody['period']}_${requestBody['accountnumbers'] != null ? '${requestBody['accountnumbers']}'.total() : ''}')
                .replaceAll('-', '_')
                .replaceAll(',', '_'))
            .trim();
    final data = await expenseBox.get(key, defaultValue: null);
    return data != null ? ExpenseReportModel.fromJson(data) : null;
  }

  @override
  Future<void> saveExpenseReport(
      {required Map<String, dynamic> requestBody,
      required Map<dynamic, dynamic> response}) async {
    final expenseBox = await Hive.openBox(HiveBox.expenseBox);
    final key =
        (('${HiveFields.expenseReport}_${requestBody['asOnDate']}_${requestBody['id']}_${requestBody['reportingCurrency']}_${requestBody['period']}_${requestBody['accountnumbers'] != null ? '${requestBody['accountnumbers']}'.total() : ''}')
                .replaceAll('-', '_')
                .replaceAll(',', '_'))
            .trim();
    await expenseBox.put(key, response);
  }

  @override
  Future<Entity?> getExpenseSelectedEntity({required String postFix}) async {
    final expenseBox =
        await Hive.openBox(HiveBox.expenseFilterBox(postFix: postFix));
    final data = await expenseBox.get(HiveFields.expenseSelectedEntity,
        defaultValue: null);
    return data != null ? Entity.fromJson(data) : null;
  }

  @override
  Future<void> saveExpenseSelectedEntity(
      {required Map<dynamic, dynamic> response,
      required String postFix}) async {
    final expenseBox =
        await Hive.openBox(HiveBox.expenseFilterBox(postFix: postFix));
    await expenseBox.put(HiveFields.expenseSelectedEntity, response);
  }

  @override
  Future<List<ExpenseAccount>?> getExpenseSelectedAccounts(
      {required Map<String, dynamic> requestBody,
      required String postFix}) async {
    final expenseBox =
        await Hive.openBox(HiveBox.expenseFilterBox(postFix: postFix));
    final key =
        "${HiveFields.expenseSelectedAccounts}_${requestBody['entityid']}_${requestBody['entitytype']}";
    final data = await expenseBox.get(key, defaultValue: null);
    return data != null
        ? ExpenseAccountModel.fromJson(data).expenseAccount
        : null;
  }

  @override
  Future<void> saveExpenseSelectedAccounts(
      {required Map<String, dynamic> requestBody,
      required Map<dynamic, dynamic> response,
      required String postFix}) async {
    final expenseBox =
        await Hive.openBox(HiveBox.expenseFilterBox(postFix: postFix));
    final key =
        "${HiveFields.expenseSelectedAccounts}_${requestBody['entityid']}_${requestBody['entitytype']}";
    await expenseBox.put(key, response);
  }

  @override
  Future<period.PeriodItem?> getExpenseSelectedPeriod(
      {required String postFix}) async {
    final expenseBox =
        await Hive.openBox(HiveBox.expenseFilterBox(postFix: postFix));
    final data = await expenseBox.get(HiveFields.expenseSelectedPeriod,
        defaultValue: null);
    return data != null ? period.PeriodItem.fromJson(data) : null;
  }

  @override
  Future<void> saveExpenseSelectedPeriod(
      {required Map<dynamic, dynamic> response,
      required String postFix}) async {
    final expenseBox =
        await Hive.openBox(HiveBox.expenseFilterBox(postFix: postFix));
    await expenseBox.put(HiveFields.expenseSelectedPeriod, response);
  }

  @override
  Future<nop.NumberOfPeriodItem?> getExpenseSelectedNumberOfPeriod(
      {required String postFix}) async {
    final expenseBox =
        await Hive.openBox(HiveBox.expenseFilterBox(postFix: postFix));
    final data = await expenseBox.get(HiveFields.expenseSelectedNumberOfPeriod,
        defaultValue: null);
    return data != null ? nop.NumberOfPeriodItem.fromJson(data) : null;
  }

  @override
  Future<void> saveExpenseSelectedNumberOfPeriod(
      {required Map<dynamic, dynamic> response,
      required String postFix}) async {
    final expenseBox =
        await Hive.openBox(HiveBox.expenseFilterBox(postFix: postFix));
    await expenseBox.put(HiveFields.expenseSelectedNumberOfPeriod, response);
  }

  @override
  Future<CurrencyData?> getExpenseSelectedCurrency(
      {required String postFix}) async {
    final expenseBox =
        await Hive.openBox(HiveBox.expenseFilterBox(postFix: postFix));
    final data = await expenseBox.get(HiveFields.expenseSelectedCurrency,
        defaultValue: null);
    return data != null ? CurrencyData.fromJson(data) : null;
  }

  @override
  Future<void> saveExpenseSelectedCurrency(
      {required Map<dynamic, dynamic> response,
      required String postFix}) async {
    final expenseBox =
        await Hive.openBox(HiveBox.expenseFilterBox(postFix: postFix));
    await expenseBox.put(HiveFields.expenseSelectedCurrency, response);
  }

  @override
  Future<DenData?> getExpenseSelectedDenomination(
      {required String postFix}) async {
    final expenseBox =
        await Hive.openBox(HiveBox.expenseFilterBox(postFix: postFix));
    final data = await expenseBox.get(HiveFields.expenseSelectedDenomination,
        defaultValue: null);
    return data != null ? DenData.fromJson(data) : null;
  }

  @override
  Future<void> saveExpenseSelectedDenomination(
      {required Map<dynamic, dynamic> response,
      required String postFix}) async {
    final expenseBox =
        await Hive.openBox(HiveBox.expenseFilterBox(postFix: postFix));
    await expenseBox.put(HiveFields.expenseSelectedDenomination, response);
  }

  @override
  Future<void> clearIncomeExpense() async {
    final incomeBox = await Hive.openBox(HiveBox.incomeBox);
    final expenseBox = await Hive.openBox(HiveBox.expenseBox);
    await incomeBox.clear();
    await expenseBox.clear();
  }

  @override
  Future<Entity?> getSelectedEntity({required String credential}) async {
    final filterBox = await Hive.openBox("${HiveBox.filterBox}_$credential");
    final entity =
        await filterBox.get(HiveFields.selectedEntity, defaultValue: null);
    return entity != null ? Entity.fromJson(entity) : null;
  }

  @override
  Future<void> saveSelectedEntity(
      {required EntityData? entity, required String credential}) async {
    final filterBox = await Hive.openBox("${HiveBox.filterBox}_$credential");
    await filterBox.put(HiveFields.selectedEntity, entity?.toJson());
  }

  @override
  Future<TimePeriodItemData?> getIpsReturnFilter(
      {required String? entityName,
      required String? grouping,
      required String credential}) async {
    final filterBox = await Hive.openBox("${HiveBox.filterBox}_$credential");
    final response = await filterBox.get(
        '$entityName-$grouping-${HiveFields.selectedIpsReturnFilter}',
        defaultValue: null);
    return response != null ? TimePeriodItem.fromJson(response) : null;
  }

  @override
  Future<Policies?> getIpsPolicyFilter(
      {required String? entityName,
      required String? grouping,
      required String credential}) async {
    final filterBox = await Hive.openBox("${HiveBox.filterBox}_$credential");
    final response = await filterBox.get(
        '$entityName-$grouping-${HiveFields.selectedIpsPolicyFilter}',
        defaultValue: null);
    return response != null ? PolicyModel.fromJson(response) : null;
  }

  @override
  Future<List<SubGroupingItemData>?> getIpsSubFilter(
      {required String? entityName,
      required String? grouping,
      required String credential}) async {
    final filterBox = await Hive.openBox("${HiveBox.filterBox}_$credential");
    final response = await filterBox.get(
        '$entityName-$grouping-${HiveFields.selectedIpsSubFilter}',
        defaultValue: null);
    return response != null
        ? (response as List)
            .map((e) => ips.SubGroupingItem.fromJson(e))
            .toList()
        : null;
  }

  @override
  Future<void> saveIpsPolicyFilter(
      {required String? entityName,
      required String? grouping,
      required Policies? policy,
      required String credential}) async {
    final filterBox = await Hive.openBox("${HiveBox.filterBox}_$credential");
    await filterBox.put(
        '$entityName-$grouping-${HiveFields.selectedIpsPolicyFilter}',
        policy?.toJson());
  }

  @override
  Future<void> saveIpsReturnFilter(
      {required String? entityName,
      required String? grouping,
      required TimePeriodItemData? period,
      required String credential}) async {
    final filterBox = await Hive.openBox("${HiveBox.filterBox}_$credential");
    await filterBox.put(
        '$entityName-$grouping-${HiveFields.selectedIpsReturnFilter}',
        period?.toJson());
  }

  @override
  Future<void> saveIpsSubFilter(
      {required String? entityName,
      required String? grouping,
      required List<SubGroupingItemData>? subGroup,
      required String credential}) async {
    final filterBox = await Hive.openBox("${HiveBox.filterBox}_$credential");
    await filterBox.put(
        '$entityName-$grouping-${HiveFields.selectedIpsSubFilter}',
        subGroup?.map((e) => e.toJson()).toList());
  }

  @override
  Future<List<cb.SubGroupingItem>?> getSelectedCBSubGroup(
      {required String? entityName,
      required String? grouping,
      required String credential}) async {
    final filterBox = await Hive.openBox("${HiveBox.filterBox}_$credential");
    final response = await filterBox.get(
        '$entityName-$grouping-${HiveFields.selectedCBSubFilter}',
        defaultValue: null);
    return response != null
        ? (response as List).map((e) => cb.SubGroupingItem.fromJson(e)).toList()
        : null;
  }

  @override
  Future<void> saveSelectedCBSubGroup(
      {required String? entityName,
      required String? grouping,
      required List<cb.SubGroupingItem>? subGroup,
      required String credential}) async {
    final filterBox = await Hive.openBox("${HiveBox.filterBox}_$credential");
    await filterBox.put(
        '$entityName-$grouping-${HiveFields.selectedCBSubFilter}',
        subGroup?.map((e) => e.toJson()).toList());
  }

  @override
  Future<List<Map>?> getSavedIncomeOrExpenseAccount(
      {required String? entityName,
      required String? grouping,
      required String credential}) async {
    final filterBox = await Hive.openBox("${HiveBox.filterBox}_$credential");
    final response = await filterBox.get(
        '$entityName-$grouping-${HiveFields.selectedIncExpFilter}',
        defaultValue: null);
    return response != null
        ? (response as List).map((e) => e as Map).toList()
        : null;
  }

  @override
  Future<ie.NumberOfPeriodItem?> getSavedIncomeOrExpensePeriod(
      {required String? entityName,
      required String? grouping,
      required String credential}) async {
    final filterBox = await Hive.openBox("${HiveBox.filterBox}_$credential");
    final response = await filterBox.get(
        '$entityName-$grouping-${HiveFields.selectedIncExpNoOfPeriods}',
        defaultValue: null);
    return response != null ? ie.NumberOfPeriodItem.fromJson(response) : null;
  }

  @override
  Future<void> saveSelectedIncomeOrExpenseAccount(
      {required String? entityName,
      required String? grouping,
      required List<Object>? item,
      required String credential}) async {
    final filterBox = await Hive.openBox("${HiveBox.filterBox}_$credential");
    await filterBox.put(
        '$entityName-$grouping-${HiveFields.selectedIncExpFilter}',
        item
            ?.map((e) => e is IncomeAccount
                ? e.toJson()
                : e is ExpenseAccount
                    ? e.toJson()
                    : {})
            .toList());
  }

  @override
  Future<void> saveSelectedIncomeOrExpensePeriod(
      {required String? entityName,
      required String? grouping,
      required ie.NumberOfPeriodItem? item,
      required String credential}) async {
    final filterBox = await Hive.openBox("${HiveBox.filterBox}_$credential");
    await filterBox.put(
        '$entityName-$grouping-${HiveFields.selectedIncExpNoOfPeriods}',
        item?.toJson());
  }

  @override
  Future<Entity?> getSelectedDocEntity({required String credential}) async {
    final filterBox = await Hive.openBox("${HiveBox.filterBox}_$credential");
    final entity = await filterBox.get(HiveFields.selectedDocumentEntity,
        defaultValue: null);
    return entity != null ? Entity.fromJson(entity) : null;
  }

  @override
  Future<void> saveSelectedDocEntity(
      {required EntityData? entity, required String credential}) async {
    final filterBox = await Hive.openBox("${HiveBox.filterBox}_$credential");
    await filterBox.put(HiveFields.selectedDocumentEntity, entity?.toJson());
  }

  @override
  Future<int?> getCBSortFilter({required String credential}) async {
    final filterBox = await Hive.openBox("${HiveBox.filterBox}_$credential");
    final index = await filterBox.get(HiveFields.selectedCBSortFilter,
        defaultValue: null);
    return index;
  }

  @override
  Future<void> saveCBSortFilter(
      {required int sort, required String credential}) async {
    final filterBox = await Hive.openBox("${HiveBox.filterBox}_$credential");
    await filterBox.put(HiveFields.selectedCBSortFilter, sort);
  }

  @override
  Future<CurrencyData?> getSavedCurrencyFilter(
      {required String? tileName, required String credential}) async {
    final filterBox = await Hive.openBox("${HiveBox.filterBox}_$credential");
    final currency = await filterBox.get(
        '$tileName-${HiveFields.selectedCurrencyFilter}',
        defaultValue: null);
    return currency != null ? CurrencyData.fromJson(currency) : null;
  }

  @override
  Future<void> saveCurrencyFilter(
      {required Currency? currency,
      required String? tileName,
      required String credential}) async {
    final filterBox = await Hive.openBox("${HiveBox.filterBox}_$credential");
    await filterBox.put(
        '$tileName-${HiveFields.selectedCurrencyFilter}', currency?.toJson());
  }

  @override
  Future<DenominationData?> getSelectedDenomination(
      {required String? tileName, required String credential}) async {
    final filterBox = await Hive.openBox("${HiveBox.filterBox}_$credential");
    final index = await filterBox.get(
        '$tileName-${HiveFields.selectedDenominationFilter}',
        defaultValue: null);
    return index != null ? DenData.fromJson(index) : null;
  }

  @override
  Future<void> saveSelectedDenomination(
      {required DenominationData? denomination,
      required String? tileName,
      required String credential}) async {
    final filterBox = await Hive.openBox("${HiveBox.filterBox}_$credential");
    await filterBox.put('$tileName-${HiveFields.selectedDenominationFilter}',
        denomination?.toJson());
  }

  @override
  Future<List<ChatMsg>?> getChatMsgList() async {
    final chatBox = await Hive.openBox(HiveBox.chatBox);
    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final chat = chatBox.get(date, defaultValue: null);
    return chat != null
        ? (chat as List).map((e) => ChatMsg.fromJson(res: e)).toList()
        : null;
  }

  @override
  Future<void> saveChatMsg({required ChatMsg chat}) async {
    final chatBox = await Hive.openBox(HiveBox.chatBox);
    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    List<ChatMsg>? savedChats = await getChatMsgList();
    savedChats ??= [];
    savedChats.add(chat);
    await chatBox.put(date, savedChats.map((e) => e.toJson()).toList());
  }

  @override
  Future<void> clearAllTheFilters({required String postFix}) async{
    final cashBalanceFilterBox = await Hive.openBox(HiveBox.cashBalanceFilterBox(postFix: postFix));
    final cashBalanceBox = await Hive.openBox(HiveBox.cashBalanceBox);
    final netWorthFilterBox = await Hive.openBox(HiveBox.netWorthFilterBox(postFix: postFix));
    final netWorthBox = await Hive.openBox(HiveBox.netWorthBox);
    final incomeFilterBox = await Hive.openBox(HiveBox.incomeFilterBox(postFix: postFix));
    final incomeBox = await Hive.openBox(HiveBox.incomeBox);
    final expenseFilterBox = await Hive.openBox(HiveBox.expenseFilterBox(postFix: postFix));
    final expenseBox = await Hive.openBox(HiveBox.expenseBox);
    final performanceFilterBox = await Hive.openBox(HiveBox.performanceFilterBox(postFix: postFix));
    final performanceBox = await Hive.openBox(HiveBox.performanceBox);

    await cashBalanceFilterBox.clear();
    await netWorthFilterBox.clear();
    await incomeFilterBox.clear();
    await expenseFilterBox.clear();
    await performanceFilterBox.clear();

    await cashBalanceBox.clear();
    await netWorthBox.clear();
    await incomeBox.clear();
    await expenseBox.clear();
    await performanceBox.clear();
  }

  @override
  Future<PartnershipMethodItem?> getPerformanceSelectedPartnershipMethod(
      {required String tileName, required String postFix}) async {
  final performanceBox = await Hive.openBox(HiveBox.performanceFilterBox(postFix: postFix));
  final data = await performanceBox.get("${HiveFields.performanceSelectedPartnershipMethod}_$tileName",
  defaultValue:  null);
  return data != null ? PartnershipMethodItem.fromJson(data): null;
  }

  @override
  Future<void> savePerformanceSelectedPartnershipMethod(
      {required String tileName,
        required Map<dynamic, dynamic> response, required String postFix})async {
    final performanceBox = await Hive.openBox(HiveBox.performanceFilterBox(postFix: postFix));
    await performanceBox.put("${HiveFields.performanceSelectedPartnershipMethod}_$tileName", response);
  }

  @override
  Future<HoldingMethodItem?> getPerformanceSelectedHoldingMethod(
      {required String tileName, required String postFix}) async{
    final performanceBox = await Hive.openBox(HiveBox.performanceFilterBox(postFix: postFix));
    final data = await performanceBox.get("${HiveFields.performanceSelectedHoldingMethod}_$tileName",
        defaultValue: null);
    return data != null ? HoldingMethodItem.fromJson(data): null;
  }

  @override
  Future<void> savePerformanceSelectedHoldingMethod(
      {required String tileName, required Map<dynamic, dynamic> response,
        required String postFix}) async {
   final performanceBox = await Hive.openBox(HiveBox.performanceFilterBox(postFix: postFix));
   await performanceBox.put("${HiveFields.performanceSelectedHoldingMethod}_$tileName", response);
  }

  @override
  Future<HoldingMethodItem?> getNetWorthSelectedHoldingMethod(
      {required String tileName, required String postFix}) async{
    final performanceBox = await Hive.openBox(HiveBox.performanceFilterBox(postFix: postFix));
    final data = await performanceBox.get("${HiveFields.netWorthSelectedHoldingMethod}_$tileName",
      defaultValue: null);
    return data != null ? HoldingMethodItem.fromJson(data):null;
  }



}
