
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:asset_vantage/main.dart';
import 'package:asset_vantage/src/config/app_config.dart';
import 'package:asset_vantage/src/config/constants/denomination_constants.dart';
import 'package:asset_vantage/src/config/constants/favorite_constants.dart';
import 'package:asset_vantage/src/config/constants/holding_method_constants.dart';
import 'package:asset_vantage/src/config/constants/partnership_method_constant.dart';
import 'package:asset_vantage/src/core/unathorised_exception.dart';
import 'package:asset_vantage/src/data/models/authentication/user_model.dart';
import 'package:asset_vantage/src/data/models/cash_balance/cash_balance_sub_grouping_model.dart';
import 'package:asset_vantage/src/data/models/currency/currency_model.dart';
import 'package:asset_vantage/src/data/models/denomination/denomination_model.dart';
import 'package:asset_vantage/src/data/models/document/document_model.dart';
import 'package:asset_vantage/src/data/models/expense/expense_report_model.dart';
import 'package:asset_vantage/src/data/models/expense/expense_account_model.dart';
import 'package:asset_vantage/src/data/models/favorites/favorites_model.dart';
import 'package:asset_vantage/src/data/models/favorites/favorites_sequence_model.dart';
import 'package:asset_vantage/src/data/models/income/income_report_model.dart';
import 'package:asset_vantage/src/data/models/income/income_account_model.dart';
import 'package:asset_vantage/src/data/models/investment_policy_statement/investment_policy_statement_policies_model.dart';
import 'package:asset_vantage/src/data/models/net_worth/networth_report_model.dart';
import 'package:asset_vantage/src/data/models/partnership_method/holding_method_model.dart';
import 'package:asset_vantage/src/data/models/partnership_method/partnership_method_model.dart';
import 'package:asset_vantage/src/data/models/period/period_model.dart';
import 'package:asset_vantage/src/data/models/preferences/app_theme.dart';
import 'package:asset_vantage/src/presentation/av_app.dart';
import 'package:asset_vantage/src/presentation/blocs/authentication/token/token_cubit.dart';
import 'package:asset_vantage/src/utilities/helper/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_string/random_string.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../config/constants/dashboard.dart';
import '../../../config/constants/number_of_period_constants.dart';
import '../../../config/constants/period_constants.dart';
import '../../../config/constants/return_percentage_constants.dart';
import '../../../core/api_client.dart';
import '../../../core/api_constants.dart';
import '../../../injector.dart';
import '../../models/cash_balance/cash_balance_grouping_model.dart';
import '../../models/cash_balance/cash_balance_report_model.dart';
import '../../models/dashboard/dashboard_entity_model.dart';
import '../../models/dashboard/dashboard_widget_model.dart';
import '../../models/document/download_data.dart';
import '../../models/insights/messages_model.dart';
import '../../models/income_expense/income_expense_number_of_period_model.dart';
import '../../models/income_expense/income_expense_period_model.dart';
import '../../models/investment_policy_statement/investment_policy_statement_grouping_model.dart';
import '../../models/investment_policy_statement/investment_policy_statement_report_model.dart';
import '../../models/investment_policy_statement/investment_policy_statement_sub_grouping_model.dart';
import '../../models/investment_policy_statement/investment_policy_statement_time_period_model.dart';
import '../../models/net_worth/net_worth_grouping_model.dart';
import '../../models/net_worth/net_worth_number_of_period_model.dart';
import '../../models/net_worth/net_worth_period_model.dart';
import '../../models/net_worth/net_worth_return_percent_model.dart';
import '../../models/net_worth/net_worth_sub_grouping_model.dart';
import '../../models/notifications/notifications_model.dart';
import '../../models/number_of_period/number_of_period_model.dart';
import '../../models/performance/performance_primary_grouping_model.dart';
import '../../models/performance/performance_primary_sub_grouping_model.dart';
import '../../models/performance/performance_report_model.dart';
import '../../models/performance/performance_secondary_grouping_model.dart';
import '../../models/performance/performance_secondary_sub_grouping_model.dart';
import '../../models/preferences/user_preference.dart';
import '../../models/return_percentage/return_percentage_model.dart';
import '../../models/user_guide/user_guid_assets_model.dart';
import '../local/app_local_datasource.dart';

abstract class AVRemoteDataSource {
  Future<DashboardEntityModel> getEntities({required BuildContext context});
  Future<CurrencyModel> getCurrencies({required BuildContext context});
  Future<WidgetListModel> getDashboardWidget({required BuildContext context, required Map<String, dynamic> requestBody});
  Future<DenominationModel> getDenominationList({required BuildContext context, required Map<String, dynamic> requestBody});
  Future<ReturnPercentModel> getReturnPercentage({required BuildContext context, required Map<String, dynamic> requestBody});
  Future<NumberOfPeriodModel> getNumberOfPeriod({required BuildContext context, required Map<String, dynamic> requestBody});
  Future<PartnershipMethodModel> getPartnershipMethod({required BuildContext context,required Map<String,dynamic> requestBody});
  Future<HoldingMethodModel> getHoldingMethod({required BuildContext context,required Map<String,dynamic> requestBody});
  Future<PeriodModel> getPeriods({required BuildContext context, required Map<String, dynamic> requestBody});
  Future<UserModel> getUserData({required BuildContext context, required Map<String, dynamic> requestBody});
  Future<AppThemeModel> getUserTheme({required BuildContext context, required Map<String, dynamic> requestBody});
  Future<FavoritesModel> favoriteReport({required BuildContext context, required Map<String, dynamic> requestBody});
  Future<FavoritesSequenceModel> favoriteSequence({required BuildContext context, required Map<String, dynamic> requestBody});

  Future<InvestmentPolicyStatementReportModel> getInvestmentPolicyStatementReport({required BuildContext context, required Map<String, dynamic> requestBody});
  Future<InvestmentPolicyStatementGroupingModel> getInvestmentPolicyStatementGroupings({required BuildContext context});
  Future<InvestmentPolicyStatementPoliciesModel> getInvestmentPolicyStatementPolicies({required BuildContext context});
  Future<InvestmentPolicyStatementSubGroupingModel> getInvestmentPolicyStatementSubGroupings({required BuildContext context, required Map<String, dynamic> requestBody});
  Future<InvestmentPolicyStatementTimePeriodModel> getInvestmentPolicyStatementTimePeriod({required BuildContext context});

  Future<CashBalanceReportModel> getCashBalanceReport({required BuildContext context, required Map<String, dynamic> requestBody});
  Future<CashBalanceGroupingModel> getCashBalanceGrouping({required BuildContext context, required Map<String, dynamic> requestBody});
  Future<CashBalanceSubGroupingModel> getCashBalanceSubGrouping({required BuildContext? context, required Map<String, dynamic> requestBody});
  Future<CashBalanceSubGroupingModel> getCashBalanceAccounts({required BuildContext? context, required Map<String, dynamic> requestBody});

  Future<NetWorthReportModel> getNetWorthReport({required BuildContext? context, required Map<String, dynamic> requestBody});
  Future<NetWorthGroupingModel> getNetWorthGrouping({required BuildContext context, required Map<String, dynamic> requestBody});
  Future<NetWorthSubGroupingModel> getNetWorthSubGrouping({required BuildContext? context, required Map<String, dynamic> requestBody});
  Future<NetWorthNumberOfPeriodModel> getNetWorthNumberOfPeriod({required BuildContext context, required Map<String, dynamic> requestBody});
  Future<NetWorthPeriodModel> getNetWorthPeriod({required BuildContext context, required Map<String, dynamic> requestBody});
  Future<NetWorthReturnPercentModel> getNetWorthReturnPercent({required BuildContext context, required Map<String, dynamic> requestBody});

  Future<PerformanceReportModel> getPerformanceReport({required BuildContext context, required Map<String, dynamic> requestBody});
  Future<PerformancePrimaryGroupingModel> getPerformancePrimaryGrouping({required BuildContext context, required Map<String, dynamic> requestBody});
  Future<PerformancePrimarySubGroupingModel> getPerformancePrimarySubGrouping({required BuildContext? context, required Map<String, dynamic> requestBody});
  Future<PerformanceSecondaryGroupingModel> getPerformanceSecondaryGrouping({required BuildContext context, required Map<String, dynamic> requestBody});
  Future<PerformanceSecondarySubGroupingModel> getPerformanceSecondarySubGrouping({required BuildContext? context, required Map<String, dynamic> requestBody});

  Future<IncomeAccountModel> getIncomeAccounts({required BuildContext context, required Map<String, dynamic> requestBody});
  Future<IncomeReportModel> getIncomeReport({required BuildContext context, required Map<String, dynamic> requestBody});

  Future<ExpenseAccountModel> getExpenseAccounts({required BuildContext context, required Map<String, dynamic> requestBody});
  Future<ExpenseReportModel> getExpenseReport({required BuildContext context, required Map<String, dynamic> requestBody});

  Future<IncomeExpenseNumberOfPeriodModel> getIncomeExpenseNumberOfPeriod({required BuildContext context, required Map<String, dynamic> requestBody});
  Future<IncomeExpensePeriodModel> getIncomeExpensePeriod({required BuildContext context, required Map<String, dynamic> requestBody});

  Future<DocumentModel> getDocuments({required BuildContext context, required Map<String, dynamic> requestBody});
  Future<DocumentModel> searchDocuments({required BuildContext context, required Map<String, dynamic> requestBody});
  Future<DownloadData> downloadDocuments({required BuildContext context, required String? username, required String? password,required String? token, required String? systemName, required Map<String, dynamic> requestBody});

  Future<UserGuidAssetsModel> getUserGuideAssets({required Map<String, dynamic> requestBody});

  Future<NotificationsModel> getNotifications({required Map<String, dynamic> requestBody});

  Future<String> fetchFileAndStore({required String url, required String fileName});

  Future<ChatMsg> sendMessage({
    required String? question,
    required WebSocketChannel channel,
    required String? entityId,
    required String? entityType,
  });
  Stream<ChatMsg?> getChatResponse({
    required WebSocketChannel channel,
  });
  Future<WebSocketChannel> connectChatServer({
    required String? authToken,
    required String? subId,
  });
  Future<void> disconnectChatServer({required WebSocketChannel channel});
}

class AVRemoteDataSourceImpl extends AVRemoteDataSource {
  final ApiClient _client;

  AVRemoteDataSourceImpl(this._client);

  @override
  Future<DashboardEntityModel> getEntities({required BuildContext context}) async {
    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    final response = await _client.get('filters/entities');
    return DashboardEntityModel.fromJson({"EntityList": response});
  }

  @override
  Future<CurrencyModel> getCurrencies({required BuildContext context}) async {
    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    final response = await _client.get('filters/get_currencyList');
    return CurrencyModel.fromJson(response);
  }

  @override
  Future<WidgetListModel> getDashboardWidget({required BuildContext context, required Map<String, dynamic> requestBody}) async {
    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    return WidgetListModel.fromJson(DashboardReports.data);
  }

  @override
  Future<ReturnPercentModel> getReturnPercentage({required BuildContext context, required Map<String, dynamic> requestBody}) async {
    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }

    return ReturnPercentModel.fromJson(ReturnPercentageConstants.data);
  }

  @override
  Future<NumberOfPeriodModel> getNumberOfPeriod({required BuildContext context, required Map<String, dynamic> requestBody}) async {
    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }

    return NumberOfPeriodModel.fromJson(NumberOfPeriodConstants.data);
  }

  @override
  Future<PartnershipMethodModel> getPartnershipMethod(
      {required BuildContext context, required Map<String, dynamic> requestBody})async {
    if(context.mounted){
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    return PartnershipMethodModel.fromJson(PartnershipMethodConstants.data);
  }

  @override
  Future<HoldingMethodModel> getHoldingMethod(
      {required BuildContext context, required Map<String, dynamic> requestBody})async {
    if(context.mounted){
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    return HoldingMethodModel.fromJson(HoldingMethodConstants.data);
  }

  @override
  Future<PeriodModel> getPeriods({required BuildContext context, required Map<String, dynamic> requestBody}) async {
    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }

    return PeriodModel.fromJson(PeriodConstants.data);
  }

  @override
  Future<DenominationModel> getDenominationList({required BuildContext context, required Map<String, dynamic> requestBody}) async {
    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    return DenominationModel.fromJson(Denomination.data);
  }

  @override
  Future<UserModel> getUserData({required BuildContext context, required Map<String, dynamic> requestBody}) async {
    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    final Map<String, dynamic> response = await _client.get('get_userpreference',
        params: requestBody
    );

    final dataSource = getItInstance<AppLocalDataSource>();
    final UserPreference preference = await dataSource.getUserPreference();

    final tokenData = JwtDecoder.decode(preference.idToken ?? '');
    if(response.containsKey('cobranding')) {
      response["cobrandingLight"] = {
        "brandLogo": "https://www.assetvantage.com/wp-content/uploads/2023/07/AV-LOGO-without-tagline.png",
        "brandName": response["cobranding"]["brandName"],
        "textColor": "#000000",
        "backgroundColor": "#EFFCFF",
        "primaryColor": "#1B3E5A",
        "secondaryColor": "",
        "accentColor": "",
        "iconColor": "#000000",
        "cardColor": "0xFFFFFFFF",
        "id": "1"
      };

      final logoPath = await fetchFileAndStore(
          url: response["cobranding"]["brandLogo"], fileName: "darkLogo");
      final logoPathLight = await fetchFileAndStore(
          url: response["cobrandingLight"]["brandLogo"], fileName: "lightLogo");
      response["cobranding"]["brandLogo"] = logoPath;
      response["cobrandingLight"]["brandLogo"] = logoPathLight;
    }
    log("Token Data: $tokenData");
    return UserModel.fromJson(response, tokenData: tokenData);
  }

  @override
  Future<AppThemeModel> getUserTheme({required BuildContext context, required Map<String, dynamic> requestBody}) async {
    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    return AppThemeModel.fromJson({}[requestBody['index']]);

  }

  @override
  Future<FavoritesModel> favoriteReport({required BuildContext context, required Map<String, dynamic> requestBody}) async {

    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    final response = await _client.postWithDio("favourite",
      body: requestBody,
    );
    return FavoritesModel.fromJson(response);
  }

  @override
  Future<FavoritesSequenceModel> favoriteSequence({required BuildContext context, required Map<String, dynamic> requestBody}) async {
    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    final response = await _client.post("sequence",
      body: requestBody,
    );
    return FavoritesSequenceModel.fromJson(response);
  }

  @override
  Future<InvestmentPolicyStatementReportModel> getInvestmentPolicyStatementReport({required BuildContext context,
    required Map<String, dynamic> requestBody}) async {
    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    final response = await _client.get('reports/get_ips',
        params: requestBody,
        isReport: true
    );
    return InvestmentPolicyStatementReportModel.fromJson({'result': response});
  }

  @override
  Future<InvestmentPolicyStatementGroupingModel> getInvestmentPolicyStatementGroupings({required BuildContext context}) async {
    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    final response = await _client.get('filters/groupings');
    return InvestmentPolicyStatementGroupingModel.fromJson({'result': response});
  }

  @override
  Future<InvestmentPolicyStatementSubGroupingModel> getInvestmentPolicyStatementSubGroupings({required BuildContext context, required Map<String, dynamic> requestBody}) async {
    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    final response = await _client.get('filters/secsubgrouping',
        params: requestBody
    );
    return InvestmentPolicyStatementSubGroupingModel.fromJson({"result": response});
  }

  @override
  Future<InvestmentPolicyStatementPoliciesModel> getInvestmentPolicyStatementPolicies({required BuildContext context}) async {
    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    final response = await _client.get('filters/get_policies');
    return InvestmentPolicyStatementPoliciesModel.fromJson({"result": response});
  }

  @override
  Future<InvestmentPolicyStatementTimePeriodModel> getInvestmentPolicyStatementTimePeriod({required BuildContext context}) async {
    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    return InvestmentPolicyStatementTimePeriodModel.fromJson(const {
      "result": [
        {
          "id": "year_1",
          "name": "1 year %"
        },
        {
          "id": "year_2",
          "name": "2 years %"
        },
        {
          "id": "year_3",
          "name": "3 years %"
        },
        {
          "id": "year_5",
          "name": "5 years %"
        },
        {
          "id": "year_7",
          "name": "7 years %"
        },
        {
          "id": "year_10",
          "name": "10 years %"
        }
      ]
    });
  }


  @override
  Future<CashBalanceReportModel> getCashBalanceReport({required BuildContext context, required Map<String, dynamic> requestBody}) async {
    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    final dataSource = getItInstance<AppLocalDataSource>();
    final UserPreference preference = await dataSource.getUserPreference();
    log("CASH_BALANCE_REQUEST_API::::::URL:::${"${ApiConstants.isProd ? ApiConstants.BASE_URL_PROD[preference.regionUrl ?? 'base_uat'] : ApiConstants.BASE_URL_DEV }"}reports/get_cash_balance:::::${jsonEncode(requestBody)}");
    final response = await Client().post(
      Uri.parse("${ApiConstants.isProd ? ApiConstants.BASE_URL_PROD[preference.regionUrl ?? 'base_uat'] : ApiConstants.BASE_URL_DEV }reports/get_cash_balance"),
      headers: {
        'Content-Type': 'application/json',
        if (preference.idToken != null) 'Authorization': '${preference.idToken}',
      },
      body: jsonEncode(requestBody),
    );

    log("CASH_BALANCE_API_RESPONSE:: ${response.body}");

    try{
      return CashBalanceReportModel.fromJson(json: jsonDecode(response.body)["body"] ?? {});
    }catch(e) {
      return CashBalanceReportModel.fromJson(json: {});
    }
  }

  @override
  Future<CashBalanceGroupingModel> getCashBalanceGrouping({required BuildContext context, required Map<String, dynamic> requestBody}) async {
    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    final dataSource = getItInstance<AppLocalDataSource>();
    final UserPreference preference = await dataSource.getUserPreference();
    log("PerformancePrimaryGrouping::::::URL:::${"https://m${preference.systemName}.assetvantage.com/user/index/read"}:::::::${jsonEncode(requestBody['1'])}");
    final response = await Client().post(
      Uri.parse(
          "https://m${preference.systemName}.assetvantage.com/user/index/read"),
      headers: {
        'Content-Type': 'application/json',
        if (preference.idToken != null) 'Auth': '${preference.idToken}',
      },
      body: jsonEncode(requestBody['1']),
    );

    Map<dynamic, dynamic> refinedResponse = {};

    if(jsonDecode(response.body) != null) {
      if(jsonDecode(response.body)['Filter'] != null) {
        if(jsonDecode(response.body)['Filter']['primarygrouping'] != null) {
          refinedResponse = {"result": jsonDecode(response.body)['Filter']['primarygrouping']};
        }
      }
    }
    return CashBalanceGroupingModel.fromJson(refinedResponse);
  }

  @override
  Future<CashBalanceSubGroupingModel> getCashBalanceSubGrouping({required BuildContext? context, required Map<String, dynamic> requestBody}) async {
    if(context?.mounted ?? false) {
      context?.read<TokenCubit>().checkIfTokenExpired();
    }
    final dataSource = getItInstance<AppLocalDataSource>();
    final UserPreference preference = await dataSource.getUserPreference();
    log("CashBalancePrimarySubGrouping::::::URL:::${"https://m${preference.systemName}.assetvantage.com/user/index/read"}:::::::${jsonEncode(requestBody)}");
    final response = await Client().post(
      Uri.parse(
          "https://m${preference.systemName}.assetvantage.com/user/index/read"),
      headers: {
        'Content-Type': 'application/json',
        if (preference.idToken != null) 'Auth': '${preference.idToken}',
      },
      body: jsonEncode(requestBody),
    );

    return CashBalanceSubGroupingModel.fromJson({"result": jsonDecode(response.body)});
  }

  @override
  Future<CashBalanceSubGroupingModel> getCashBalanceAccounts({required BuildContext? context, required Map<String, dynamic> requestBody}) async {
    if(context?.mounted ?? false) {
      context?.read<TokenCubit>().checkIfTokenExpired();
    }
    final dataSource = getItInstance<AppLocalDataSource>();
    final UserPreference preference = await dataSource.getUserPreference();
    log("Cash Balance Acounts::::::URL:::${"https://${preference.systemName}.assetvantage.com/user/index/read"}:::::::${jsonEncode(requestBody)}");
    final response = await Client().post(
      Uri.parse(
          "https://m${preference.systemName}.assetvantage.com/user/index/read"),
      headers: {
        'Content-Type': 'application/json',
        if (preference.idToken != null) 'Auth': '${preference.idToken}',
      },
      body: jsonEncode(requestBody),
    );



    return CashBalanceSubGroupingModel.fromJson({"result": jsonDecode(response.body)});
  }


  @override
  Future<NetWorthReportModel> getNetWorthReport({required BuildContext? context, required Map<String, dynamic> requestBody}) async {
    if(context?.mounted ?? false) {
      context?.read<TokenCubit>().checkIfTokenExpired();
    }
    final dataSource = getItInstance<AppLocalDataSource>();
    final UserPreference preference = await dataSource.getUserPreference();
    log("NETWORTH_API_REQUEST::::::URL:::${"https://m${preference.systemName}.assetvantage.com/user/index/read"}:::::::${jsonEncode(requestBody)}");
    final response = await Client().post(
      Uri.parse(
          "https://m${preference.systemName}.assetvantage.com/user/index/read"),
      headers: {
        'Content-Type': 'application/json',
        if (preference.idToken != null) 'Auth': '${preference.idToken}',
      },
      body: jsonEncode(requestBody),
    );
    log("NETWORTH_API_RESPONSE::::::${response.body}");
    return NetWorthReportModel.fromJson(json: jsonDecode(response.body));

  }

  @override
  Future<NetWorthGroupingModel> getNetWorthGrouping({required BuildContext context, required Map<String, dynamic> requestBody}) async {
    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    final dataSource = getItInstance<AppLocalDataSource>();
    final UserPreference preference = await dataSource.getUserPreference();
    log("NetWorthPrimaryGrouping::::::URL:::${"https://m${preference.systemName}.assetvantage.com/user/index/read"}:::::::${jsonEncode(requestBody['1'])}");
    final response = await Client().post(
      Uri.parse(
          "https://m${preference.systemName}.assetvantage.com/user/index/read"),
      headers: {
        'Content-Type': 'application/json',
        if (preference.idToken != null) 'Auth': '${preference.idToken}',
      },
      body: jsonEncode(requestBody['1']),
    );

    Map<dynamic, dynamic> refinedResponse = {};

    if(jsonDecode(response.body) != null) {
      if(jsonDecode(response.body)['Filter'] != null) {
        if(jsonDecode(response.body)['Filter']['primarygrouping'] != null) {
          refinedResponse = {"result": jsonDecode(response.body)['Filter']['primarygrouping']};
        }
      }
    }
    return NetWorthGroupingModel.fromJson(refinedResponse);
  }

  @override
  Future<NetWorthSubGroupingModel> getNetWorthSubGrouping({required BuildContext? context, required Map<String, dynamic> requestBody}) async {
    if(context?.mounted ?? false) {
      context?.read<TokenCubit>().checkIfTokenExpired();
    }
    final dataSource = getItInstance<AppLocalDataSource>();
    final UserPreference preference = await dataSource.getUserPreference();
    log("NetWorthPrimarySubGrouping::::::URL:::${"https://m${preference.systemName}.assetvantage.com/user/index/read"}:::::::${jsonEncode(requestBody)}");
    final response = await Client().post(
      Uri.parse(
          "https://m${preference.systemName}.assetvantage.com/user/index/read"),
          //"https://m${preference.systemName}.assetvantage.com/user/index/read"),
      headers: {
        'Content-Type': 'application/json',
        if (preference.idToken != null) 'Auth': '${preference.idToken}',
      },
      body: jsonEncode(requestBody),
    );

    return NetWorthSubGroupingModel.fromJson({"result": jsonDecode(response.body)});
  }

  @override
  Future<NetWorthReturnPercentModel> getNetWorthReturnPercent({required BuildContext context, required Map<String, dynamic> requestBody}) async {
    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    return NetWorthReturnPercentModel.fromJson(const {
      "result": [
        {"id": "", "value": 0, "name": "None"},
        {"id": "per_twr", "value": 3, "name": "Period TWR"},
      ]
    });
  }

  @override
  Future<NetWorthNumberOfPeriodModel> getNetWorthNumberOfPeriod({required BuildContext context, required Map<String, dynamic> requestBody}) async {
    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }return NetWorthNumberOfPeriodModel.fromJson(const {
      "result": [
        {
          "id": "0",
          "value": 1,
          "name": "1"
        },
        {
          "id": "1",
          "value": 2,
          "name": "2"
        },
        {
          "id": "2",
          "value": 3,
          "name": "3"
        },
        {
          "id": "3",
          "value": 4,
          "name": "4"
        },
        {
          "id": "4",
          "value": 5,
          "name": "5"
        },
        {
          "id": "5",
          "value": 6,
          "name": "6"
        },
        {
          "id": "6",
          "value": 7,
          "name": "7"
        },
        {
          "id": "7",
          "value": 8,
          "name": "8"
        },
        {
          "id": "8",
          "value": 9,
          "name": "9"
        },
        {
          "id": "9",
          "value": 10,
          "name": "10"
        },
        {
          "id": "10",
          "value": 11,
          "name": "11"
        },
        {
          "id": "11",
          "value": 12,
          "name": "12"
        }
      ]
    });
  }

  @override
  Future<NetWorthPeriodModel> getNetWorthPeriod({required BuildContext context, required Map<String, dynamic> requestBody}) async {
    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    return NetWorthPeriodModel.fromJson(const {
      "result": [
        {
          "id": "0",
          "gaps": 1,
          "name": "Monthly"
        },
        {
          "id": "1",
          "gaps": 3,
          "name": "Quarterly"
        },
        {
          "id": "2",
          "gaps": 12,
          "name": "Yearly"
        },
        {
          "id": "3",
          "gaps": -1,
          "name": "Fiscal Year"
        }
      ]
    });
  }


  @override
  Future<PerformanceReportModel> getPerformanceReport({required BuildContext context, required Map<String, dynamic> requestBody}) async {
    final dataSource = getItInstance<AppLocalDataSource>();
    final UserPreference preference = await dataSource.getUserPreference();
    log("PERFORMANCE_API_REQUEST::::::URL:::${"https://m${preference.systemName}.assetvantage.com/user/index/read"}:::::::${jsonEncode(requestBody)}");
    final response = await Client().post(
      Uri.parse(
          "https://m${preference.systemName}.assetvantage.com/user/index/read"),
      headers: {
        'Content-Type': 'application/json',
        if (preference.idToken != null) 'Auth': '${preference.idToken}',
      },
      body: jsonEncode(requestBody),
    );
    log("PERFORMANCE_API_STATUS_CODE::::: ${response.statusCode}");


    try{
      return PerformanceReportModel.fromJson(jsonDecode(response.body)['result'] != null ? jsonDecode(response.body)['result']['All'] : null, /*true*/);
    }catch(e) {
      return PerformanceReportModel.fromJson({}, /*true*/);
    }
  }

  @override
  Future<PerformancePrimaryGroupingModel> getPerformancePrimaryGrouping({required BuildContext context, required Map<String, dynamic> requestBody}) async {
    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    final dataSource = getItInstance<AppLocalDataSource>();
    final UserPreference preference = await dataSource.getUserPreference();
    log("PerformancePrimaryGrouping::::::URL:::${"https://m${preference.systemName}.assetvantage.com/user/index/read"}:::::::${jsonEncode(requestBody['1'])}");
    final response = await Client().post(
      Uri.parse(
          "https://m${preference.systemName}.assetvantage.com/user/index/read"),
      headers: {
        'Content-Type': 'application/json',
        if (preference.idToken != null) 'Auth': '${preference.idToken}',
      },
      body: jsonEncode(requestBody['1']),
    );

    Map<dynamic, dynamic> refinedResponse = {};

    if(jsonDecode(response.body) != null) {
      if(jsonDecode(response.body)['Filter'] != null) {
        if(jsonDecode(response.body)['Filter']['primarygrouping'] != null) {
          refinedResponse = {"result": jsonDecode(response.body)['Filter']['primarygrouping']};
        }
      }
    }

    return PerformancePrimaryGroupingModel.fromJson(refinedResponse);
  }
  @override
  Future<PerformancePrimarySubGroupingModel> getPerformancePrimarySubGrouping({required BuildContext? context, required Map<String, dynamic> requestBody}) async {
    if(context?.mounted ?? false) {
      context?.read<TokenCubit>().checkIfTokenExpired();
    }
    final dataSource = getItInstance<AppLocalDataSource>();
    final UserPreference preference = await dataSource.getUserPreference();
    log("PerformancePrimarySubGrouping::::::URL:::${"https://m${preference.systemName}.assetvantage.com/user/index/read"}:::::::${jsonEncode(requestBody)}");
    final response = await Client().post(
      Uri.parse(
          "https://m${preference.systemName}.assetvantage.com/user/index/read"),
      headers: {
        'Content-Type': 'application/json',
        if (preference.idToken != null) 'Auth': '${preference.idToken}',
      },
      body: jsonEncode(requestBody),
    );

    return PerformancePrimarySubGroupingModel.fromJson({"result": jsonDecode(response.body)});
  }

  @override
  Future<PerformanceSecondaryGroupingModel> getPerformanceSecondaryGrouping({required BuildContext context, required Map<String, dynamic> requestBody}) async {
    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    final dataSource = getItInstance<AppLocalDataSource>();
    final UserPreference preference = await dataSource.getUserPreference();
    log("PerformanceSecondaryGrouping::::::URL:::${"https://m${preference.systemName}.assetvantage.com/user/index/read"}:::::::${jsonEncode(requestBody['1'])}");
    final response = await Client().post(
      Uri.parse(
          "https://m${preference.systemName}.assetvantage.com/user/index/read"),
      headers: {
        'Content-Type': 'application/json',
        if (preference.idToken != null) 'Auth': '${preference.idToken}',
      },
      body: jsonEncode(requestBody['1']),
    );

    Map<dynamic, dynamic> refinedResponse = {};

    if(jsonDecode(response.body) != null) {
      if(jsonDecode(response.body)['Filter'] != null) {
        if(jsonDecode(response.body)['Filter']['secondarygrouping'] != null) {
          refinedResponse = {"result": jsonDecode(response.body)['Filter']['secondarygrouping']};
        }
      }
    }

    return PerformanceSecondaryGroupingModel.fromJson(refinedResponse);
  }

  @override
  Future<PerformanceSecondarySubGroupingModel> getPerformanceSecondarySubGrouping({required BuildContext? context, required Map<String, dynamic> requestBody}) async {
    if(context?.mounted ?? false) {
      context?.read<TokenCubit>().checkIfTokenExpired();
    }
    final dataSource = getItInstance<AppLocalDataSource>();
    final UserPreference preference = await dataSource.getUserPreference();
    log("PerformanceSecondarySubGrouping::::::URL:::${"https://m${preference.systemName}.assetvantage.com/user/index/read"}:::::::${jsonEncode(requestBody)}");
    final response = await Client().post(
      Uri.parse(
          "https://m${preference.systemName}.assetvantage.com/user/index/read"),
      headers: {
        'Content-Type': 'application/json',
        if (preference.idToken != null) 'Auth': '${preference.idToken}',
      },
      body: jsonEncode(requestBody),
    );

    return PerformanceSecondarySubGroupingModel.fromJson({"result": jsonDecode(response.body)});
  }



  @override
  Future<IncomeAccountModel> getIncomeAccounts({required BuildContext context, required Map<String, dynamic> requestBody}) async {
    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    final response = await _client.get('filters/get_incomeaccounts',
        params: requestBody
    );
    return IncomeAccountModel.fromJson({"incomeAccount": response});
  }

  @override
  Future<IncomeReportModel> getIncomeReport({required BuildContext context, required Map<String, dynamic> requestBody}) async {
    if(context.mounted ?? false) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    final dataSource = getItInstance<AppLocalDataSource>();
    final UserPreference preference = await dataSource.getUserPreference();
    log("INCOME_REQUEST_API::::::URL:::${"${ApiConstants.isProd ? ApiConstants.BASE_URL_PROD[preference.regionUrl ?? 'base_uat'] : ApiConstants.BASE_URL_DEV }"}reports/get_income_expense:::::${jsonEncode(requestBody)}");
    final response = await Client().post(
      Uri.parse("${ApiConstants.isProd ? ApiConstants.BASE_URL_PROD[preference.regionUrl ?? 'base_uat'] : ApiConstants.BASE_URL_DEV }reports/get_income_expense"),
      headers: {
        'Content-Type': 'application/json',
        if (preference.idToken != null) 'Authorization': '${preference.idToken}',
      },
      body: jsonEncode(requestBody),
    );

    log("INCOME_API_RESPONSE:: ${response.body}");

    try{
      return IncomeReportModel.fromJson({"incomeReport": jsonDecode(response.body)["body"] != null ? jsonDecode(response.body)["body"]["RESPONSE"] : {}});
    }catch(e) {
      return IncomeReportModel.fromJson({});
    }
  }


  @override
  Future<ExpenseAccountModel> getExpenseAccounts({required BuildContext context, required Map<String, dynamic> requestBody}) async {
    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    final response = await _client.get('filters/get_expenseaccounts',
        params: requestBody
    );

    return ExpenseAccountModel.fromJson({"expenseAccount": response});
  }

  @override
  Future<ExpenseReportModel> getExpenseReport({required BuildContext context, required Map<String, dynamic> requestBody}) async {

    if(context.mounted ?? false) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    final dataSource = getItInstance<AppLocalDataSource>();
    final UserPreference preference = await dataSource.getUserPreference();
    log("EXPENSE_REQUEST_API::::::URL:::${ApiConstants.isProd ? ApiConstants.BASE_URL_PROD[preference.regionUrl ?? 'base_uat'] : ApiConstants.BASE_URL_DEV }reports/get_income_expense:::::${jsonEncode(requestBody)}");
    final response = await Client().post(
      Uri.parse("${ApiConstants.isProd ? ApiConstants.BASE_URL_PROD[preference.regionUrl ?? 'base_uat'] : ApiConstants.BASE_URL_DEV }reports/get_income_expense"),
      headers: {
        'Content-Type': 'application/json',
        if (preference.idToken != null) 'Authorization': '${preference.idToken}',
      },
      body: jsonEncode(requestBody),
    );

    log("EXPENSE_API_RESPONSE:: ${response.body}");

    try{
      return ExpenseReportModel.fromJson({"expenseReport": jsonDecode(response.body)["body"] != null ? jsonDecode(response.body)["body"]["RESPONSE"] : {}});
    }catch(e) {
      return ExpenseReportModel.fromJson({});
    }

  }

  @override
  Future<IncomeExpenseNumberOfPeriodModel> getIncomeExpenseNumberOfPeriod({required BuildContext context, required Map<String, dynamic> requestBody}) async {
    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    return IncomeExpenseNumberOfPeriodModel.fromJson(const {
      "result": [
        {
          "id": "0",
          "value": 1,
          "name": "1"
        },
        {
          "id": "1",
          "value": 2,
          "name": "2"
        },
        {
          "id": "2",
          "value": 3,
          "name": "3"
        },
        {
          "id": "3",
          "value": 4,
          "name": "4"
        },
        {
          "id": "4",
          "value": 5,
          "name": "5"
        },
        {
          "id": "5",
          "value": 6,
          "name": "6"
        },
        {
          "id": "6",
          "value": 7,
          "name": "7"
        },
        {
          "id": "7",
          "value": 8,
          "name": "8"
        },
        {
          "id": "8",
          "value": 9,
          "name": "9"
        },
        {
          "id": "9",
          "value": 10,
          "name": "10"
        },
        {
          "id": "10",
          "value": 11,
          "name": "11"
        },
        {
          "id": "11",
          "value": 12,
          "name": "12"
        }
      ]
    });
  }

  @override
  Future<IncomeExpensePeriodModel> getIncomeExpensePeriod({required BuildContext context, required Map<String, dynamic> requestBody}) async {
    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    return IncomeExpensePeriodModel.fromJson(const {
      "result": [
        {
          "id": "0",
          "gaps": 1,
          "name": "Monthly"
        },
        {
          "id": "1",
          "gaps": 3,
          "name": "Quarterly"
        },
        {
          "id": "2",
          "gaps": 12,
          "name": "Yearly"
        },
        {
          "id": "3",
          "gaps": -1,
          "name": "Fiscal Year"
        }
      ]
    });
  }



  @override
  Future<DocumentModel> getDocuments({required BuildContext context, required Map<String, dynamic> requestBody}) async {
    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    final response = await _client.get('reports/get_documents',
        params: requestBody
    );
    return DocumentModel.fromJson({"result": response});
  }

  @override
  Future<DocumentModel> searchDocuments({required BuildContext context, required Map<String, dynamic> requestBody}) async {
    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    final response = await _client.get('reports/search_document',
        params: requestBody
    );
    return DocumentModel.fromJson({"result": response});
  }

  @override
  Future<DownloadData> downloadDocuments({required BuildContext context, required String? username, required String? password,required String? token, required String? systemName, required Map<String, dynamic> requestBody}) async {
    if(context.mounted) {
      context.read<TokenCubit>().checkIfTokenExpired();
    }
    final bodyByte = await _client.download('https://$systemName.assetvantage.com/documents/file/download',
        documentId: requestBody['documentId'],
        token: token,
        systemName: systemName,
        username: username,
        password: password
    );

    return DownloadData(
        file: bodyByte,
        name: requestBody['name'],
        extension: requestBody['extension'],
        type: requestBody['type']
    );
  }

  @override
  Future<UserGuidAssetsModel> getUserGuideAssets({required Map<String, dynamic> requestBody}) async {

    final response = {
      "assets": [
        "assets/pngs/user_guide_1.png",
        "assets/pngs/user_guide_2.png",
        "assets/pngs/user_guide_3.png"
      ]
    };

    return UserGuidAssetsModel.fromJson(response);
  }

  @override
  Future<NotificationsModel> getNotifications({required Map<String, dynamic> requestBody}) async {
    final response = await _client.get('get_notification',
        params: requestBody
    );
    return NotificationsModel.fromJson(response);
  }

  @override
  Future<String> fetchFileAndStore(
      {required String url, required String fileName}) async {
    final docPath = await getApplicationDocumentsDirectory();
    final filePath = '${docPath.path}/$fileName.png';
    log(filePath);
    final response = await get(Uri.parse(url));
    await File(filePath).writeAsBytes(response.bodyBytes);
    return filePath;
  }

  @override
  Future<ChatMsg> sendMessage({
    required String? question,
    required WebSocketChannel channel,
    required String? entityId,
    required String? entityType,
  }) async {
    String generatedString =
        '${randomAlphaNumeric(8).toUpperCase()}-${randomAlphaNumeric(4).toUpperCase()}-${randomAlphaNumeric(4).toUpperCase()}-${randomAlphaNumeric(4).toUpperCase()}-${randomAlphaNumeric(12).toUpperCase()}';
    final chat = ChatMsg.fromJson(res: {
      "type": "message",
      "payload": {
        "name": "send",
        "data": {
          "messageId": generatedString,
          "entityId": int.parse(entityId ?? ''),
          "entityType": entityType,
          "content": question,
        }
      }
    });
    channel.sink.add(jsonEncode(chat.toJson()));
    return chat;
  }

  @override
  Stream<ChatMsg?> getChatResponse({
    required WebSocketChannel channel,
  }) {
    return channel.stream.map<ChatMsg>((message) {
      final msg = jsonDecode(message);
      log('chatResponse: $msg');
      ChatMsg? chat = ChatMsg.fromJson(res: msg);
      return chat;
    });

  }

  @override
  Future<WebSocketChannel> connectChatServer({
    required String? authToken,
    required String? subId,
  }) async {
    final dataSource = getItInstance<AppLocalDataSource>();
    final UserPreference preference = await dataSource.getUserPreference();

    String connectionUrl = "${preference.user?.avInsightsUrl}/$subId/";

    log(connectionUrl);

    final channel = IOWebSocketChannel.connect(
      Uri.parse(connectionUrl),
      headers: {
        "Authorization": "$authToken",
      },
    );

    await channel.ready;
    return channel;
  }

  @override
  Future<void> disconnectChatServer({required WebSocketChannel channel}) async {
    await channel.sink.close(WebSocketStatus.normalClosure);
  }



}

ReportTile getReportTile({required String filter, required String report}) {
  if(report == 'ips') {
    if(filter.toLowerCase() == 'Asset-Class'.toLowerCase()) {
      return ReportTile.ipsAssetClass;
    }else if(filter.toLowerCase() == 'Advisor'.toLowerCase()) {
      return ReportTile.ipsAdvisor;
    }else if(filter.toLowerCase() == 'Currency'.toLowerCase()) {
      return ReportTile.ipsCurrency;
    }else if(filter.toLowerCase() == 'Liquidity'.toLowerCase()) {
      return ReportTile.ipsLiquidity;
    }else if(filter.toLowerCase() == 'Strategy'.toLowerCase()) {
      return ReportTile.ipsStrategy;
    }
  }else if(report == 'cb') {
    if(filter.toLowerCase() == 'Account'.toLowerCase()) {
      return ReportTile.cbAccount;
    }else if(filter.toLowerCase() == 'Geography'.toLowerCase()) {
      return ReportTile.cbGeography;
    }
  }else if(report == 'nw') {
    if(filter.toLowerCase() == 'Asset-Class'.toLowerCase()) {
      return ReportTile.nwAssetClass;
    }else if(filter.toLowerCase() == 'Advisor'.toLowerCase()) {
      return ReportTile.nwAdvisor;
    }else if(filter.toLowerCase() == 'Currency'.toLowerCase()) {
      return ReportTile.nwCurrency;
    }else if(filter.toLowerCase() == 'Liquidity'.toLowerCase()) {
      return ReportTile.nwLiquidity;
    }else if(filter.toLowerCase() == 'Strategy'.toLowerCase()) {
      return ReportTile.nwStrategy;
    }
  }else if(report == 'per') {
    if(filter.toLowerCase() == 'Asset-Class'.toLowerCase()) {
      return ReportTile.perAssetClass;
    }else if(filter.toLowerCase() == 'Advisor'.toLowerCase()) {
      return ReportTile.perAdvisor;
    }else if(filter.toLowerCase() == 'Currency'.toLowerCase()) {
      return ReportTile.perCurrency;
    }else if(filter.toLowerCase() == 'Liquidity'.toLowerCase()) {
      return ReportTile.perLiquidity;
    }else if(filter.toLowerCase() == 'Strategy'.toLowerCase()) {
      return ReportTile.perStrategy;
    }
  }else if(report.toLowerCase() == 'inc'.toLowerCase()) {
    return ReportTile.inc;
  }else if(report.toLowerCase() == 'exp'.toLowerCase()) {
    return ReportTile.exp;
  }
  return ReportTile.none;
}