import 'package:asset_vantage/src/data/models/net_worth/net_worth_grouping_model.dart' as nwgp;
import 'package:asset_vantage/src/domain/entities/cash_balance/cash_balance_entity.dart';
import 'package:asset_vantage/src/domain/entities/dashboard/dashboard_list_entity.dart';
import 'package:asset_vantage/src/domain/entities/dashboard/dashboard_widget_entity.dart';
import 'package:asset_vantage/src/domain/entities/document/document_entity.dart';
import 'package:asset_vantage/src/domain/entities/expense/expense_report_entity.dart';
import 'package:asset_vantage/src/domain/entities/expense/expense_account_entity.dart';
import 'package:asset_vantage/src/domain/entities/favorites/favorites_entity.dart';
import 'package:asset_vantage/src/domain/entities/favorites/favorites_sequence_enitity.dart';
import 'package:asset_vantage/src/domain/entities/income/income_report_entity.dart';
import 'package:asset_vantage/src/domain/entities/income/income_account_entity.dart';
import 'package:asset_vantage/src/domain/entities/partnership_method/partnership_method.dart';
import 'package:asset_vantage/src/domain/entities/user_guide_assets/user_guide_assets_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:asset_vantage/src/data/models/net_worth/net_worth_return_percent_model.dart'
    as rpmodal;
import '../../data/models/expense/expense_account_model.dart';
import '../../data/models/cash_balance/cash_balance_sub_grouping_model.dart'
    as cb;
import '../../data/models/currency/currency_model.dart';
import '../../data/models/dashboard/dashboard_entity_model.dart';
import '../../data/models/denomination/denomination_model.dart';
import '../../data/models/income/income_account_model.dart';
import '../../data/models/insights/messages_model.dart';
import '../../data/models/net_worth/net_worth_sub_grouping_model.dart';
import '../../data/models/number_of_period/number_of_period_model.dart' as nop;
import '../../data/models/performance/performance_primary_grouping_model.dart';
import '../../data/models/performance/performance_secondary_grouping_model.dart';
import '../../data/models/period/period_model.dart' as period;
import '../../data/models/preferences/app_theme.dart';
import '../../data/repositories/chat_remote_datasource.dart';
import '../entities/app_error.dart';
import '../entities/authentication/user_entity.dart';
import '../entities/cash_balance/cash_balance_grouping_entity.dart';
import '../entities/cash_balance/cash_balance_sub_grouping_entity.dart';
import '../entities/currency/currency_entity.dart';
import '../entities/denomination/denomination_entity.dart';
import '../entities/document/download_entity.dart';
import '../entities/income_expense/income_expense_number_of_period_entity.dart'
    as ie;
import '../entities/income_expense/income_expense_number_of_period_entity.dart';
import '../entities/income_expense/income_expense_period_entity.dart';
import '../entities/investment_policy_statement/investment_policy_statement_grouping_entity.dart';
import '../entities/investment_policy_statement/investment_policy_statement_policies_entity.dart';
import '../entities/investment_policy_statement/investment_policy_statement_report_entity.dart';
import '../entities/investment_policy_statement/investment_policy_statement_sub_grouping_entity.dart'
    as ips;
import '../entities/investment_policy_statement/investment_policy_statement_sub_grouping_entity.dart';
import '../entities/investment_policy_statement/investment_policy_statement_time_period_entity.dart';
import '../entities/net_worth/net_worth_entity.dart';
import '../entities/net_worth/net_worth_grouping_entity.dart';
import '../entities/net_worth/net_worth_return_percent_entity.dart';
import '../entities/net_worth/net_worth_sub_grouping_enity.dart';
import '../entities/notification/notification_entity.dart';
import '../entities/number_of_period/number_of_period.dart';
import '../entities/partnership_method/holding_method_entities.dart';
import '../entities/performance/performance_primary_grouping_entity.dart';
import '../entities/performance/performance_primary_sub_grouping_enity.dart';
import '../entities/performance/performance_report_entity.dart';
import '../entities/performance/performance_secondary_grouping_entity.dart';
import '../entities/performance/performance_secondary_sub_grouping_enity.dart';
import '../entities/period/period_enitity.dart';
import '../entities/return_percentage/return_percentage_entity.dart';
import 'package:asset_vantage/src/data/models/performance/performance_secondary_grouping_model.dart'
    as secondaryGrouping;
import 'package:asset_vantage/src/data/models/performance/performance_secondary_sub_grouping_model.dart'
    as secondarySubGrouping;
import 'package:asset_vantage/src/data/models/performance/performance_primary_grouping_model.dart'
    as primaryGrouping;
import 'package:asset_vantage/src/data/models/performance/performance_primary_sub_grouping_model.dart'
    as primarySubGrouping;
import 'package:asset_vantage/src/data/models/return_percentage/return_percentage_model.dart'
    as rp;
import 'package:asset_vantage/src/data/models/cash_balance/cash_balance_grouping_model.dart'
    as cbpg;
import 'package:asset_vantage/src/domain/entities/number_of_period/number_of_period.dart'
    as cbnp;
import 'package:asset_vantage/src/domain/entities/period/period_enitity.dart'
    as cbp;

abstract class AVRepository {
  Future<Either<AppError, DashboardEntity>> getEntities({required BuildContext context});
  Future<Either<AppError, WidgetListEntity>> getDashboardWidget(
      {required BuildContext context, required Map<String, dynamic> requestBody});
  Future<Either<AppError, CurrencyModel>> getCurrencies({required BuildContext context});
  Future<Either<AppError, ReturnPercentEntity>> getReturnPercentage(
      {required BuildContext context, required Map<String, dynamic> requestBody});
  Future<Either<AppError, NumberOfPeriodEntity>> getNumberOfPeriod(
      {required BuildContext context, required Map<String, dynamic> requestBody});
  Future<Either<AppError,PartnershipMethodEntities>> getPartnershipMethod(
  { required BuildContext context, required Map<String,dynamic> requestBody});
  Future<Either<AppError,HoldingMethodEntities>> getHoldingMethod(
      { required BuildContext context, required Map<String,dynamic> requestBody});
  Future<Either<AppError, PeriodEntity>> getPeriods(
      {required BuildContext context, required Map<String, dynamic> requestBody});
  Future<Either<AppError, DenominationEntity>> getDenominationList(
      {required BuildContext context, required Map<String, dynamic> requestBody});
  Future<Either<AppError, UserEntity>> getUserData(
      {required BuildContext context, required Map<String, dynamic> requestBody});
  Future<Either<AppError, AppThemeModel>> getUserTheme(
      {required BuildContext context, required Map<String, dynamic> requestBody});
  Future<Either<AppError, FavoritesEntity>> favoriteReport(
      {required BuildContext context, required Map<String, dynamic> requestBody});
  Future<Either<AppError, FavoritesSequenceEntity>> favoriteSequence(
      {required BuildContext context, required Map<String, dynamic> requestBody});
  Future<Either<AppError, void>> saveDashSeq({required BuildContext context, required List<int> seq});

  Future<Either<AppError, InvestmentPolicyStatementReportEntity>>
      getInvestmentPolicyStatementReport(
          {required BuildContext context,
          required Map<String, dynamic> requestBody});
  Future<Either<AppError, InvestmentPolicyStatementGroupingEntity>>
      getInvestmentPolicyStatementGrouping({required BuildContext context});
  Future<Either<AppError, InvestmentPolicyStatementPoliciesEntity>>
      getInvestmentPolicyStatementPolicies({required BuildContext context});
  Future<Either<AppError, InvestmentPolicyStatementSubGroupingEntity>>
      getInvestmentPolicyStatementSubGrouping(
          {required BuildContext context, required Map<String, dynamic> requestBody});
  Future<Either<AppError, InvestmentPolicyStatementTimePeriodEntity>>
      getInvestmentPolicyStatementTimePeriod(
          {required BuildContext context, required Map<String, dynamic> requestBody});
  Future<Either<AppError, void>> clearInvestmentPolicyStatement();

  Future<Either<AppError, CashBalanceReportEntity>> getCashBalanceReport(
      {required BuildContext context, required Map<String, dynamic> requestBody});
  Future<Either<AppError, CashBalanceGroupingEntity>> getCashBalanceGrouping(
      {required BuildContext context, required Map<String, dynamic> requestBody});
  Future<Either<AppError, CashBalanceSubGroupingEntity>>
      getCashBalanceSubGrouping({required BuildContext? context, required Map<String, dynamic> requestBody});
  Future<Either<AppError, CashBalanceSubGroupingEntity>> getCashBalanceAccounts({required BuildContext? context, required Map<String, dynamic> requestBody});

  Future<List<cb.SubGroupingItem?>?>
  getCashBalanceSelectedAccounts(
      {required String tileName,required Map<dynamic, dynamic> requestBody});
  Future<void> saveCashBalanceSelectedAccounts(
      {required String tileName,required Map<dynamic, dynamic> requestBody,
        required Map<dynamic, dynamic> response});
  Future<Either<AppError, void>> clearCashBalance();

  Future<Entity?> getCashBalanceSelectedEntity({required String tileName});
  Future<void> saveCashBalanceSelectedEntity(
      {required String tileName, required Map<dynamic, dynamic> response});

  Future<cbpg.PrimaryGrouping?> getCashBalanceSelectedPrimaryGrouping({
    required String? tileName,
    required EntityData? entity,
  });
  Future<void> saveCashBalanceSelectedPrimaryGrouping(
      {required String tileName,
      required EntityData entity,
      required Map<dynamic, dynamic> response});

  Future<List<cb.SubGroupingItem?>?> getCashBalanceSelectedPrimarySubGrouping(
      {required String tileName, required Map<dynamic, dynamic> requestBody});
  Future<void> saveCashBalanceSelectedPrimarySubGrouping(
      {required String tileName,
      required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response});

  Future<cbp.PeriodItemData?> getCashBalanceSelectedPeriod(
      {required String tileName});
  Future<void> saveCashBalanceSelectedPeriod(
      {required String tileName, required Map<dynamic, dynamic> response});

  Future<cbnp.NumberOfPeriodItemData?> getCashBalanceSelectedNumberOfPeriod(
      {required String tileName});
  Future<void> saveCashBalanceSelectedNumberOfPeriod(
      {required String tileName, required Map<dynamic, dynamic> response});

  Future<CurrencyData?> getCashBalanceSelectedCurrency(
      {required String tileName});
  Future<void> saveCashBalanceSelectedCurrency(
      {required String tileName, required Map<dynamic, dynamic> response});

  Future<DenData?> getCashBalanceSelectedDenomination(
      {required String tileName});
  Future<void> saveCashBalanceSelectedDenomination(
      {required String tileName, required Map<dynamic, dynamic> response});

  Future<String?> getCashBalanceSelectedAsOnDate({required String tileName});
  Future<void> saveCashBalanceSelectedAsOnDate(
      {required String tileName, required String? response});

  Future<Either<AppError, NetWorthReportEntity>> getNetWorthReport(
      {required BuildContext? context, required Map<String, dynamic> requestBody});
  Future<Either<AppError, NetWorthGroupingEntity>> getNetWorthGrouping({required BuildContext context, required Map<String, dynamic> requestBody});
  Future<Either<AppError, NetWorthSubGroupingEntity>> getNetWorthSubGrouping(
      {required BuildContext? context, required Map<String, dynamic> requestBody});
  Future<Either<AppError, NetWorthReturnPercentEntity>>
      getNetWorthReturnPercent({required BuildContext context, required Map<String, dynamic> requestBody});
  Future<Either<AppError, void>> clearNetWorth();

  Future<String?> getNetWorthSelectedAsOnDate();
  Future<void> saveNetWorthSelectedAsOnDate({required String? response});

  Future<CurrencyData?> getNetWorthSelectedCurrency();
  Future<void> saveNetWorthSelectedCurrency(
      {required Map<dynamic, dynamic> response});

  Future<DenData?> getNetWorthSelectedDenomination();
  Future<void> saveNetWorthSelectedDenomination(
      {required Map<dynamic, dynamic> response});

  Future<Entity?> getNetWorthSelectedEntity();
  Future<void> saveNetWorthSelectedEntity(
      {required Map<dynamic, dynamic> response});

  Future<cbnp.NumberOfPeriodItemData?> getNetWorthSelectedNumberOfPeriod(
      {required String tileName});
  Future<void> saveNetWorthSelectedNumberOfPeriod(
      {required String tileName, required Map<dynamic, dynamic> response});

  Future<PartnershipMethodItemData?> getNetWorthSelectedPartnershipMethod(
  {required String tileName});
  Future<void> saveNetWorthSelectedPartnershipMethod({
    required String tileName,required Map<dynamic,dynamic> response});

  Future<HoldingMethodItemData?> getNetWorthSelectedHoldingMethod(
  {required String tileName});
  Future<void> saveNetWorthSelectedHoldingMethod({
    required String tileName,required Map<dynamic,dynamic>? response});

  Future<cbp.PeriodItemData?> getNetWorthSelectedPeriod(
      {required String tileName});
  Future<void> saveNetWorthSelectedPeriod(
      {required String tileName, required Map<dynamic, dynamic> response});

  Future<nwgp.PrimaryGrouping?> getNetWorthSelectedPrimaryGrouping();
  Future<void> saveNetWorthSelectedPrimaryGrouping(
      {required Map<dynamic, dynamic> response});

  Future<List<SubGroupingItem?>?>
  getNetWorthSelectedPrimarySubGrouping(
      {required Map<dynamic, dynamic> requestBody});
  Future<void> saveNetWorthSelectedPrimarySubGrouping(
      {required Map<dynamic, dynamic> requestBody,
        required Map<dynamic, dynamic> response});

  Future<rpmodal.ReturnPercentItem?> getNetWorthSelectedReturnPercent();
  Future<void> saveNetWorthSelectedReturnPercent(
      {required Map<dynamic, dynamic> response});

  Future<Either<AppError, PerformanceReportEntity>> getPerformanceReport(
      {required BuildContext context, required Map<String, dynamic> requestBody});
  Future<Either<AppError, PerformancePrimaryGroupingEntity>>
      getPerformancePrimaryGrouping(
          {required BuildContext context, required Map<String, dynamic> requestBody});
  Future<Either<AppError, PerformancePrimarySubGroupingEntity>>
      getPerformancePrimarySubGrouping(
          {required BuildContext? context, required Map<String, dynamic> requestBody});
  Future<Either<AppError, PerformanceSecondaryGroupingEntity>>
      getPerformanceSecondaryGrouping(
          {required BuildContext context, required Map<String, dynamic> requestBody});
  Future<Either<AppError, PerformanceSecondarySubGroupingEntity>>
      getPerformanceSecondarySubGrouping(
          {required BuildContext? context, required Map<String, dynamic> requestBody});

  Future<Entity?> getPerformanceSelectedEntity();
  Future<void> savePerformanceSelectedEntity(
      {required Map<dynamic, dynamic> response});

  Future<PartnershipMethodItemData?> getPerformanceSelectedPartnershipMethod(
      {required String tileName});
  Future<void> savePerformanceSelectedPartnershipMethod({
    required String tileName,required Map<dynamic,dynamic> response});

  Future<HoldingMethodItemData?> getPerformanceSelectedHoldingMethod(
      {required String tileName});
  Future<void> savePerformanceSelectedHoldingMethod({
    required String tileName,required Map<dynamic,dynamic> response});

  Future<primaryGrouping.PrimaryGrouping?> getPerformanceSelectedPrimaryGrouping();
  Future<void> savePerformanceSelectedPrimaryGrouping(
      {required Map<dynamic, dynamic> response});

  Future<List<primarySubGrouping.SubGroupingItem?>?>
      getPerformanceSelectedPrimarySubGrouping(
          {required Map<dynamic, dynamic> requestBody});
  Future<void> savePerformanceSelectedPrimarySubGrouping(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response});

  Future<SecondaryGrouping?> getPerformanceSelectedSecondaryGrouping();
  Future<void> savePerformanceSelectedSecondaryGrouping(
      {required Map<dynamic, dynamic> response});

  Future<List<secondarySubGrouping.SubGroupingItem?>?>
      getPerformanceSelectedSecondarySubGrouping(
          {required Map<dynamic, dynamic> requestBody});
  Future<void> savePerformanceSelectedSecondarySubGrouping(
      {required Map<dynamic, dynamic> requestBody,
      required Map<dynamic, dynamic> response});

  Future<List<rp.ReturnPercentItem?>?> getPerformanceSelectedReturnPercent();
  Future<void> savePerformanceSelectedReturnPercent(
      {required Map<dynamic, dynamic> response});

  Future<CurrencyData?> getPerformanceSelectedCurrency();
  Future<void> savePerformanceSelectedCurrency(
      {required Map<dynamic, dynamic> response});

  Future<DenData?> getPerformanceSelectedDenomination();
  Future<void> savePerformanceSelectedDenomination(
      {required Map<dynamic, dynamic> response});

  Future<String?> getPerformanceSelectedAsOnDate();
  Future<void> savePerformanceSelectedAsOnDate({required String? response});

  Future<Either<AppError, void>> clearPerformance();

  Future<Either<AppError, IncomeAccountEntity>> getIncomeReportPeriod(
      {required BuildContext context, required Map<String, dynamic> requestBody});
  Future<Either<AppError, IncomeReportEntity>> getIncomeReport(
      {required BuildContext context, required Map<String, dynamic> requestBody});

  Future<Either<AppError, ExpenseAccountEntity>> getExpenseReportPeriod(
      {required BuildContext context, required Map<String, dynamic> requestBody});
  Future<Either<AppError, ExpenseReportEntity>> getExpenseReport(
      {required BuildContext context, required Map<String, dynamic> requestBody});

  Future<Either<AppError, IncomeExpenseNumberOfPeriodEntity>>
      getIncomeExpenseNumberOfPeriod(
          {required BuildContext context, required Map<String, dynamic> requestBody});
  Future<Either<AppError, IncomeExpensePeriodEntity>> getIncomeExpensePeriod(
      {required BuildContext context, required Map<String, dynamic> requestBody});

  Future<Entity?> getIncomeSelectedEntity();

  Future<void> saveIncomeSelectedEntity(
      {required Map<dynamic, dynamic> response});

  Future<List<IncomeAccount>?> getIncomeSelectedAccounts({required Map<String, dynamic> requestBody});

  Future<void> saveIncomeSelectedAccounts({required Map<String, dynamic> requestBody, required Map<dynamic, dynamic> response});

  Future<period.PeriodItem?> getIncomeSelectedPeriod();

  Future<void> saveIncomeSelectedPeriod(
      {required Map<dynamic, dynamic> response});

  Future<nop.NumberOfPeriodItem?> getIncomeSelectedNumberOfPeriod();

  Future<void> saveIncomeSelectedNumberOfPeriod(
      {required Map<dynamic, dynamic> response});

  Future<CurrencyData?> getIncomeSelectedCurrency();

  Future<void> saveIncomeSelectedCurrency(
      {required Map<dynamic, dynamic> response});

  Future<DenData?> getIncomeSelectedDenomination();

  Future<void> saveIncomeSelectedDenomination(
      {required Map<dynamic, dynamic> response});

  Future<Entity?> getExpenseSelectedEntity();

  Future<void> saveExpenseSelectedEntity(
      {required Map<dynamic, dynamic> response});

  Future<List<ExpenseAccount>?> getExpenseSelectedAccounts({required Map<String, dynamic> requestBody});

  Future<void> saveExpenseSelectedAccounts({required Map<String, dynamic> requestBody, required Map<dynamic, dynamic> response});

  Future<period.PeriodItem?> getExpenseSelectedPeriod();

  Future<void> saveExpenseSelectedPeriod(
      {required Map<dynamic, dynamic> response});

  Future<nop.NumberOfPeriodItem?> getExpenseSelectedNumberOfPeriod();

  Future<void> saveExpenseSelectedNumberOfPeriod(
      {required Map<dynamic, dynamic> response});

  Future<CurrencyData?> getExpenseSelectedCurrency();

  Future<void> saveExpenseSelectedCurrency(
      {required Map<dynamic, dynamic> response});

  Future<DenData?> getExpenseSelectedDenomination();

  Future<void> saveExpenseSelectedDenomination({required Map<dynamic, dynamic> response});

  Future<Either<AppError, void>> clearIncomeExpense();

  Future<Either<AppError, DocumentEntity>> getDocuments(
      {required BuildContext context, required Map<String, dynamic> requestBody});
  Future<Either<AppError, DocumentEntity>> searchDocuments(
      {required BuildContext context, required Map<String, dynamic> requestBody});
  Future<Either<AppError, DownloadEntity>> downloadDocuments(
      {required BuildContext context, required Map<String, dynamic> requestBody});

  Future<Either<AppError, UserGuideAssetsEntity>> getUserGuideAssets(
      {required Map<String, dynamic> requestBody});

  Future<Either<AppError, NotificationsEntity>> getNotifications(
      {required Map<String, dynamic> requestBody});

  Future<Either<AppError, void>> saveSelectedDashboardEntity(
      {required EntityData? entity});
  Future<Either<AppError, EntityData?>> getSelectedDashboardEntity();

  Future<Either<AppError, void>> saveIpsPolicyFilter({
    required String? entityName,
    required String? grouping,
    required Policies? policy,
  });
  Future<Either<AppError, void>> saveIpsSubFilter({
    required String? entityName,
    required String? grouping,
    required List<ips.SubGroupingItemData>? subGroup,
  });
  Future<Either<AppError, void>> saveIpsReturnFilter({
    required String? entityName,
    required String? grouping,
    required TimePeriodItemData? period,
  });
  Future<Either<AppError, TimePeriodItemData?>> getIpsReturnFilter({
    required String? entityName,
    required String? grouping,
  });
  Future<Either<AppError, Policies?>> getIpsPolicyFilter({
    required String? entityName,
    required String? grouping,
  });
  Future<Either<AppError, List<ips.SubGroupingItemData>?>> getIpsSubFilter({
    required String? entityName,
    required String? grouping,
  });

  Future<Either<AppError, List<cb.SubGroupingItem>?>> getSelectedCBSubGroup({
    required String? entityName,
    required String? grouping,
  });
  Future<Either<AppError, void>> saveSelectedCBSubGroup(
      {required String? entityName,
      required String? grouping,
      required List<cb.SubGroupingItem>? subGroup});
  Future<Either<AppError, void>> saveCBSortFilter({required int sort});
  Future<Either<AppError, int?>> getCBSortFilter();

  Future<Either<AppError, List<Map>?>> getSavedIncomeOrExpenseAccount({
    required String? entityName,
    required String? grouping,
  });
  Future<Either<AppError, void>> saveSelectedIncomeOrExpenseAccount({
    required String? entityName,
    required String? grouping,
    required List<Object>? item,
  });

  Future<Either<AppError, ie.NumberOfPeriodItemData?>>
      getSavedIncomeOrExpensePeriod({
    required String? entityName,
    required String? grouping,
  });
  Future<Either<AppError, void>> saveSelectedIncomeOrExpensePeriod({
    required String? entityName,
    required String? grouping,
    required ie.NumberOfPeriodItemData? item,
  });

  Future<Either<AppError, void>> saveSelectedDocumentEntity(
      {required EntityData? entity});
  Future<Either<AppError, EntityData?>> getSelectedDocumentEntity();

  Future<Either<AppError, void>> saveCurrencyFilter({
    required Currency? currency,
    required String? tileName,
  });
  Future<Either<AppError, CurrencyData?>> getSavedCurrencyFilter({
    required String? tileName,
  });

  Future<Either<AppError, void>> saveSelectedDenomination({
    required DenominationData? denomination,
    required String? tileName,
  });
  Future<Either<AppError, DenominationData?>> getSelectedDenomination({
    required String? tileName,
  });

  Future<Either<AppError, void>> sendMessage(
      {required String? question,
      required ChatDataSource? chatDataSource,
      required String? entityId,
      required String? entityType});
  Future<Either<AppError, List<ChatMsg>?>> getChatList();
  Future<Either<AppError, void>> connectChatServer({
    required String? authToken,
    required String? subId,
  });
  Future<Either<AppError, void>> disconnectChatServer();
  Future<Either<AppError, void>> establishChatStream({
    required ChatDataSource chatDataSource,
    required String? authToken,
    required String? subId,
  });
  Future<void> clearAllTheFilters();
}
