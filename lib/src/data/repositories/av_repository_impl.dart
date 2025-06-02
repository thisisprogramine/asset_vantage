import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:asset_vantage/src/core/unathorised_exception.dart';
import 'package:asset_vantage/src/data/datasource/local/app_local_datasource.dart';
import 'package:asset_vantage/src/data/datasource/local/av_local_datasource.dart';
import 'package:asset_vantage/src/data/datasource/remote/av_remote_datasource.dart';
import 'package:asset_vantage/src/data/models/expense/expense_account_model.dart';
import 'package:asset_vantage/src/data/models/authentication/user_model.dart';
import 'package:asset_vantage/src/data/models/document/document_model.dart';
import 'package:asset_vantage/src/data/models/favorites/favorites_model.dart';
import 'package:asset_vantage/src/data/models/investment_policy_statement/investment_policy_statement_policies_model.dart';
import 'package:asset_vantage/src/data/models/investment_policy_statement/investment_policy_statement_report_model.dart';
import 'package:asset_vantage/src/data/models/net_worth/net_worth_sub_grouping_model.dart' as nw;
import 'package:asset_vantage/src/domain/entities/investment_policy_statement/investment_policy_statement_sub_grouping_entity.dart'as ips;
import 'package:asset_vantage/src/domain/entities/app_error.dart';
import 'package:asset_vantage/src/domain/entities/currency/currency_entity.dart';
import 'package:asset_vantage/src/domain/entities/income_expense/income_expense_number_of_period_entity.dart' as ienp;
import 'package:asset_vantage/src/domain/entities/investment_policy_statement/investment_policy_statement_policies_entity.dart';
import 'package:asset_vantage/src/domain/entities/investment_policy_statement/investment_policy_statement_time_period_entity.dart';
import 'package:asset_vantage/src/domain/entities/net_worth/net_worth_return_percent_entity.dart' as nwrp;
import 'package:asset_vantage/src/domain/entities/net_worth/net_worth_sub_grouping_enity.dart';
import 'package:asset_vantage/src/domain/entities/partnership_method/holding_method_entities.dart';
import 'package:asset_vantage/src/domain/entities/partnership_method/partnership_method.dart';
import 'package:asset_vantage/src/domain/entities/performance/performance_report_entity.dart';
import 'package:asset_vantage/src/domain/entities/user_guide_assets/user_guide_assets_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newrelic_mobile/newrelic_mobile.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../config/constants/favorite_constants.dart';
import '../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../domain/entities/denomination/denomination_entity.dart';
import '../../domain/entities/expense/expense_report_entity.dart';
import '../../domain/entities/expense/expense_account_entity.dart';
import '../../domain/entities/insights/chat_message_entity.dart';
import '../../domain/entities/income/income_report_entity.dart';
import '../../domain/entities/income/income_account_entity.dart';
import '../../domain/entities/net_worth/net_worth_grouping_entity.dart';
import '../../domain/entities/performance/performance_primary_grouping_entity.dart';
import '../../domain/entities/performance/performance_primary_sub_grouping_enity.dart';
import '../../domain/entities/performance/performance_secondary_grouping_entity.dart';
import '../../domain/entities/performance/performance_secondary_sub_grouping_enity.dart';
import '../../domain/repositories/av_repository.dart';
import '../models/cash_balance/cash_balance_grouping_model.dart' as cbpg;
import '../models/cash_balance/cash_balance_report_model.dart';
import '../models/cash_balance/cash_balance_sub_grouping_model.dart' as cb;
import '../models/cash_balance/cash_balance_sub_grouping_model.dart';
import '../models/currency/currency_model.dart';
import '../models/dashboard/dashboard_entity_model.dart';
import '../models/dashboard/dashboard_widget_model.dart';
import '../models/denomination/denomination_model.dart';
import '../models/document/download_data.dart';
import '../models/favorites/favorites_sequence_model.dart';
import '../models/income/income_account_model.dart';
import '../models/insights/messages_model.dart';
import '../models/income_expense/income_expense_number_of_period_model.dart' as nopie;
import '../models/income_expense/income_expense_period_model.dart';
import '../models/investment_policy_statement/investment_policy_statement_sub_grouping_model.dart';
import '../models/investment_policy_statement/investment_policy_statement_time_period_model.dart';
import '../models/investment_policy_statement/investment_policy_statement_grouping_model.dart';
import '../models/net_worth/net_worth_grouping_model.dart' as nwgp;
import '../models/net_worth/net_worth_number_of_period_model.dart' as nwp;
import '../models/net_worth/net_worth_period_model.dart' as nwpm;
import '../models/net_worth/net_worth_return_percent_model.dart' as rpmodal;
import '../models/net_worth/networth_report_model.dart';
import '../models/notifications/notifications_model.dart';
import '../models/number_of_period/number_of_period_model.dart' as nop;
import '../models/number_of_period/number_of_period_model.dart';
import '../models/partnership_method/partnership_method_model.dart';
import '../models/performance/performance_secondary_grouping_model.dart';
import 'package:asset_vantage/src/data/models/performance/performance_secondary_grouping_model.dart' as secondaryGrouping;
import 'package:asset_vantage/src/data/models/performance/performance_secondary_sub_grouping_model.dart' as secondarySubGrouping;
import 'package:asset_vantage/src/data/models/performance/performance_primary_grouping_model.dart' as primaryGrouping;
import 'package:asset_vantage/src/data/models/performance/performance_primary_sub_grouping_model.dart' as primarySubGrouping;
import '../models/return_percentage/return_percentage_model.dart' as rp;
import '../models/period/period_model.dart' as period;
import '../models/preferences/app_theme.dart';
import '../models/preferences/user_preference.dart';
import 'chat_remote_datasource.dart';
import 'package:asset_vantage/src/domain/entities/number_of_period/number_of_period.dart' as cbnp;
import 'package:asset_vantage/src/domain/entities/period/period_enitity.dart' as cbp;

class AVRepositoryImpl extends AVRepository {
  final AppLocalDataSource _appLocalDataSource;
  final AVLocalDataSource _avLocalDataSource;
  final AVRemoteDataSource _avRemoteDataSource;
  WebSocketChannel? webSocketChannel;

  AVRepositoryImpl(this._appLocalDataSource, this._avLocalDataSource,
      this._avRemoteDataSource);

  @override
  Future<Either<AppError, WidgetListModel>> getDashboardWidget(
      {required BuildContext context, required Map<String,
          dynamic> requestBody}) async {
    try {
      List<Data> dash = [];
      WidgetListModel response = await _avRemoteDataSource.getDashboardWidget(
          context: context, requestBody: requestBody);
      final dashSeq = await _avLocalDataSource.getDashboardSequence();
      dashSeq.forEach((element) {
        response.data?.forEach((ele) {
          if (element == ele.index) {
            dash.add(ele);
          }
        });
      });
      response = WidgetListModel(data: dash);
      return Right(response);
    } on SocketException {
      return const Left(AppError(AppErrorType.database));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, void>> saveDashSeq(
      {required BuildContext context, required List<int> seq}) async {
    try {
      final response = _avLocalDataSource.saveDashboardSequence(seq: seq);
      return Right(response);
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, DenominationModel>> getDenominationList(
      {required BuildContext context, required Map<String,
          dynamic> requestBody}) async {
    try {
      final response = await _avRemoteDataSource.getDenominationList(
          context: context, requestBody: requestBody);
      return Right(response);
    } on SocketException {
      return const Left(AppError(AppErrorType.database));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, rp.ReturnPercentModel>> getReturnPercentage(
      {required BuildContext context, required Map<String,
          dynamic> requestBody}) async {
    try {
      final response = await _avRemoteDataSource.getReturnPercentage(
          context: context, requestBody: requestBody);
      return Right(response);
    } on SocketException {
      return const Left(AppError(AppErrorType.database));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, NumberOfPeriodModel>> getNumberOfPeriod(
      {required BuildContext context, required Map<String,
          dynamic> requestBody}) async {
    try {
      final response = await _avRemoteDataSource.getNumberOfPeriod(
          context: context, requestBody: requestBody);
      return Right(response);
    } on SocketException {
      return const Left(AppError(AppErrorType.database));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError,PartnershipMethodModel>> getPartnershipMethod({
    required BuildContext context,required Map<String,dynamic> requestBody}) async{
    try{
      final response =await _avRemoteDataSource.getPartnershipMethod(context: context, requestBody: requestBody);
      return Right(response);
    }on SocketException{
      return const Left(AppError(AppErrorType.database));
    }on UnauthorisedException{
      return const Left(AppError(AppErrorType.unauthorised));
    }on Exception{
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, HoldingMethodEntities>> getHoldingMethod(
      {required BuildContext context, required Map<String, dynamic> requestBody})async {
    try{
      final response = await _avRemoteDataSource.getHoldingMethod(
          context: context, requestBody: requestBody);
      return Right(response);
    }on SocketException{
      return const Left(AppError(AppErrorType.database));
    }on UnauthorisedException{
      return const Left(AppError(AppErrorType.unauthorised));
    }on Exception{
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, period.PeriodModel>> getPeriods(
      {required BuildContext context, required Map<String,
          dynamic> requestBody}) async {
    try {
      final response = await _avRemoteDataSource.getPeriods(
          context: context, requestBody: requestBody);
      return Right(response);
    } on SocketException {
      return const Left(AppError(AppErrorType.database));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, DashboardEntityModel>> getEntities(
      {required BuildContext context}) async {
    try {
      final response = await _avLocalDataSource.getEntities(requestBody: {});
      if (response != null) {
        return Right(response);
      } else {
        final response = await _avRemoteDataSource.getEntities(
          context: context,);
        await _avLocalDataSource.saveEntities(
            response: response.toJson(), requestBody: {});
        return Right(response);
      }
    } on SocketException {
      return const Left(AppError(AppErrorType.network));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, CurrencyModel>> getCurrencies(
      {required BuildContext context}) async {
    try {
      final response = await _avLocalDataSource.getCurrencies(requestBody: {});
      if (response != null) {
        return Right(response);
      } else {
        final response = await _avRemoteDataSource.getCurrencies(
          context: context,);
        await _avLocalDataSource.saveCurrencies(
            response: response.toJson(), requestBody: {});
        return Right(response);
      }
    } on SocketException {
      return Right(CurrencyModel.fromJson(
          const {
            "currencylist": [
              {"id": "225", "code": "AED", "format": "###,###,##0.00"},
              {"id": "13", "code": "AUD", "format": "###,###,##0.00"},
              {"id": "19", "code": "BBD", "format": "###,###,##0.00"},
              {"id": "17", "code": "BHD", "format": "###,###,##0.00"},
              {"id": "30", "code": "BRL", "format": "###,###,##0.00"},
              {"id": "249", "code": "BTC", "format": "###,###,##0.00"},
              {"id": "39", "code": "CAD", "format": "###,###,##0.00"},
              {"id": "207", "code": "CHF", "format": "###,###,##0.00"},
              {"id": "44", "code": "CLP", "format": "###,###,##0.00"},
              {"id": "45", "code": "CNY", "format": "###,###,##0.00"},
              {"id": "57", "code": "DKK", "format": "###,###,##0.00"},
              {"id": "251", "code": "ETH", "format": "###,###,##0.00"},
              {"id": "80", "code": "EUR", "format": "###,###,##0.00"},
              {"id": "226", "code": "GBP", "format": "###,###,##0.00"},
              {"id": "95", "code": "HKD", "format": "###,###,##0.00"},
              {"id": "96", "code": "HUF", "format": "###,###,##0.00"},
              {"id": "99", "code": "IDR", "format": "###,###,##0.00"},
              {"id": "103", "code": "ILS", "format": "###,###,##0.00"},
              {"id": "98", "code": "INR", "format": "##,##,##0.00"},
              {"id": "107", "code": "JPY", "format": "###,###,##0.00"},
              {"id": "110", "code": "KES", "format": "###,###,##0.00"},
              {"id": "199", "code": "KRW", "format": "###,###,##0.00"},
              {"id": "201", "code": "LKR", "format": "###,###,##0.00"},
              {"id": "134", "code": "MUR", "format": "###,###,##0.00"},
              {"id": "136", "code": "MXN", "format": "###,###,##0.00"},
              {"id": "127", "code": "MYR", "format": "###,###,##0.00"},
              {"id": "154", "code": "NGN", "format": "###,###,##0.00"},
              {"id": "159", "code": "NOK", "format": "###,###,##0.00"},
              {"id": "151", "code": "NZD", "format": "###,###,##0.00"},
              {"id": "160", "code": "OMR", "format": "###,###,##0.00"},
              {"id": "168", "code": "PHP", "format": "###,###,##0.00"},
              {"id": "250", "code": "QAR", "format": "###,###,##0.00"},
              {"id": "177", "code": "RUB", "format": "###,###,##0.00"},
              {"id": "187", "code": "SAR", "format": "###,###,##0.00"},
              {"id": "206", "code": "SEK", "format": "###,###,##0.00"},
              {"id": "192", "code": "SGD", "format": "###,###,##0.00"},
              {"id": "212", "code": "THB", "format": "###,###,##0.00"},
              {"id": "218", "code": "TRY", "format": "###,###,##0.00"},
              {"id": "209", "code": "TWD", "format": "###,###,##0.00"},
              {"id": "223", "code": "UGX", "format": "###,###,##0.00"},
              {"id": "227", "code": "USD", "format": "###,###,##0.00"},
              {"id": "181", "code": "XCD", "format": "###,###,##0.00"},
              {"id": "197", "code": "ZAR", "format": "###,###,##0.00"},
              {"id": "238", "code": "ZMK", "format": "###,###,##0.00"}
            ]
          }
      ));
    } on UnauthorisedException {
      return Right(CurrencyModel.fromJson(
          const {
            "currencylist": [
              {"id": "225", "code": "AED", "format": "###,###,##0.00"},
              {"id": "13", "code": "AUD", "format": "###,###,##0.00"},
              {"id": "19", "code": "BBD", "format": "###,###,##0.00"},
              {"id": "17", "code": "BHD", "format": "###,###,##0.00"},
              {"id": "30", "code": "BRL", "format": "###,###,##0.00"},
              {"id": "249", "code": "BTC", "format": "###,###,##0.00"},
              {"id": "39", "code": "CAD", "format": "###,###,##0.00"},
              {"id": "207", "code": "CHF", "format": "###,###,##0.00"},
              {"id": "44", "code": "CLP", "format": "###,###,##0.00"},
              {"id": "45", "code": "CNY", "format": "###,###,##0.00"},
              {"id": "57", "code": "DKK", "format": "###,###,##0.00"},
              {"id": "251", "code": "ETH", "format": "###,###,##0.00"},
              {"id": "80", "code": "EUR", "format": "###,###,##0.00"},
              {"id": "226", "code": "GBP", "format": "###,###,##0.00"},
              {"id": "95", "code": "HKD", "format": "###,###,##0.00"},
              {"id": "96", "code": "HUF", "format": "###,###,##0.00"},
              {"id": "99", "code": "IDR", "format": "###,###,##0.00"},
              {"id": "103", "code": "ILS", "format": "###,###,##0.00"},
              {"id": "98", "code": "INR", "format": "##,##,##0.00"},
              {"id": "107", "code": "JPY", "format": "###,###,##0.00"},
              {"id": "110", "code": "KES", "format": "###,###,##0.00"},
              {"id": "199", "code": "KRW", "format": "###,###,##0.00"},
              {"id": "201", "code": "LKR", "format": "###,###,##0.00"},
              {"id": "134", "code": "MUR", "format": "###,###,##0.00"},
              {"id": "136", "code": "MXN", "format": "###,###,##0.00"},
              {"id": "127", "code": "MYR", "format": "###,###,##0.00"},
              {"id": "154", "code": "NGN", "format": "###,###,##0.00"},
              {"id": "159", "code": "NOK", "format": "###,###,##0.00"},
              {"id": "151", "code": "NZD", "format": "###,###,##0.00"},
              {"id": "160", "code": "OMR", "format": "###,###,##0.00"},
              {"id": "168", "code": "PHP", "format": "###,###,##0.00"},
              {"id": "250", "code": "QAR", "format": "###,###,##0.00"},
              {"id": "177", "code": "RUB", "format": "###,###,##0.00"},
              {"id": "187", "code": "SAR", "format": "###,###,##0.00"},
              {"id": "206", "code": "SEK", "format": "###,###,##0.00"},
              {"id": "192", "code": "SGD", "format": "###,###,##0.00"},
              {"id": "212", "code": "THB", "format": "###,###,##0.00"},
              {"id": "218", "code": "TRY", "format": "###,###,##0.00"},
              {"id": "209", "code": "TWD", "format": "###,###,##0.00"},
              {"id": "223", "code": "UGX", "format": "###,###,##0.00"},
              {"id": "227", "code": "USD", "format": "###,###,##0.00"},
              {"id": "181", "code": "XCD", "format": "###,###,##0.00"},
              {"id": "197", "code": "ZAR", "format": "###,###,##0.00"},
              {"id": "238", "code": "ZMK", "format": "###,###,##0.00"}
            ]
          }
      ));
    } on Exception {
      return Right(CurrencyModel.fromJson(
          const {
            "currencylist": [
              {"id": "225", "code": "AED", "format": "###,###,##0.00"},
              {"id": "13", "code": "AUD", "format": "###,###,##0.00"},
              {"id": "19", "code": "BBD", "format": "###,###,##0.00"},
              {"id": "17", "code": "BHD", "format": "###,###,##0.00"},
              {"id": "30", "code": "BRL", "format": "###,###,##0.00"},
              {"id": "249", "code": "BTC", "format": "###,###,##0.00"},
              {"id": "39", "code": "CAD", "format": "###,###,##0.00"},
              {"id": "207", "code": "CHF", "format": "###,###,##0.00"},
              {"id": "44", "code": "CLP", "format": "###,###,##0.00"},
              {"id": "45", "code": "CNY", "format": "###,###,##0.00"},
              {"id": "57", "code": "DKK", "format": "###,###,##0.00"},
              {"id": "251", "code": "ETH", "format": "###,###,##0.00"},
              {"id": "80", "code": "EUR", "format": "###,###,##0.00"},
              {"id": "226", "code": "GBP", "format": "###,###,##0.00"},
              {"id": "95", "code": "HKD", "format": "###,###,##0.00"},
              {"id": "96", "code": "HUF", "format": "###,###,##0.00"},
              {"id": "99", "code": "IDR", "format": "###,###,##0.00"},
              {"id": "103", "code": "ILS", "format": "###,###,##0.00"},
              {"id": "98", "code": "INR", "format": "##,##,##0.00"},
              {"id": "107", "code": "JPY", "format": "###,###,##0.00"},
              {"id": "110", "code": "KES", "format": "###,###,##0.00"},
              {"id": "199", "code": "KRW", "format": "###,###,##0.00"},
              {"id": "201", "code": "LKR", "format": "###,###,##0.00"},
              {"id": "134", "code": "MUR", "format": "###,###,##0.00"},
              {"id": "136", "code": "MXN", "format": "###,###,##0.00"},
              {"id": "127", "code": "MYR", "format": "###,###,##0.00"},
              {"id": "154", "code": "NGN", "format": "###,###,##0.00"},
              {"id": "159", "code": "NOK", "format": "###,###,##0.00"},
              {"id": "151", "code": "NZD", "format": "###,###,##0.00"},
              {"id": "160", "code": "OMR", "format": "###,###,##0.00"},
              {"id": "168", "code": "PHP", "format": "###,###,##0.00"},
              {"id": "250", "code": "QAR", "format": "###,###,##0.00"},
              {"id": "177", "code": "RUB", "format": "###,###,##0.00"},
              {"id": "187", "code": "SAR", "format": "###,###,##0.00"},
              {"id": "206", "code": "SEK", "format": "###,###,##0.00"},
              {"id": "192", "code": "SGD", "format": "###,###,##0.00"},
              {"id": "212", "code": "THB", "format": "###,###,##0.00"},
              {"id": "218", "code": "TRY", "format": "###,###,##0.00"},
              {"id": "209", "code": "TWD", "format": "###,###,##0.00"},
              {"id": "223", "code": "UGX", "format": "###,###,##0.00"},
              {"id": "227", "code": "USD", "format": "###,###,##0.00"},
              {"id": "181", "code": "XCD", "format": "###,###,##0.00"},
              {"id": "197", "code": "ZAR", "format": "###,###,##0.00"},
              {"id": "238", "code": "ZMK", "format": "###,###,##0.00"}
            ]
          }
      ));
    }
  }

  @override
  Future<Either<AppError, UserModel>> getUserData(
      {required BuildContext context, required Map<String,
          dynamic> requestBody}) async {
    try {
      final lastUpdate = await _appLocalDataSource.getUserPreference();
      if (DateTime.now().isAfter((DateTime.tryParse(
          lastUpdate.lastUserUpdate ?? DateTime.now().toString()) ??
          DateTime.now()).add(const Duration(hours: 24)))) {
        final response = await _avRemoteDataSource.getUserData(
            context: context, requestBody: requestBody);
        await _avLocalDataSource.saveUserData(
            requestBody: requestBody, response: response.toJson());
        await _appLocalDataSource.saveUserPreference(
            preference: UserPreference(
              lastUserUpdate: DateTime.now().toString(),
            )
        );
        return Right(response);
      } else {
        final response = await _avLocalDataSource.getUserData(
            requestBody: requestBody);
        if (response != null) {
          return Right(response);
        } else {
          final response = await _avRemoteDataSource.getUserData(
              context: context, requestBody: requestBody);
          await _avLocalDataSource.saveUserData(
              requestBody: requestBody, response: response.toJson());
          await _appLocalDataSource.saveUserPreference(
              preference: UserPreference(
                lastUserUpdate: DateTime.now().toString(),
              )
          );
          return Right(response);
        }
      }
    } on SocketException {
      return const Left(AppError(AppErrorType.database));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, AppThemeModel>> getUserTheme(
      {required BuildContext context, required Map<String,
          dynamic> requestBody}) async {
    try {
      final response = await _avRemoteDataSource.getUserTheme(
          context: context, requestBody: requestBody);
      return Right(response);
    } on SocketException {
      return const Left(AppError(AppErrorType.database));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, FavoritesModel>> favoriteReport(
      {required BuildContext context, required Map<String,
          dynamic> requestBody}) async {
    try {
      final response = await _avRemoteDataSource.favoriteReport(
          context: context, requestBody: requestBody);
      return Right(response);
    } on SocketException {
      return const Left(AppError(AppErrorType.database));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, FavoritesSequenceModel>> favoriteSequence(
      {required BuildContext context, required Map<String,
          dynamic> requestBody}) async {
    try {
      final response = await _avRemoteDataSource.favoriteSequence(
          context: context, requestBody: requestBody);
      return Right(response);
    } on SocketException {
      return const Left(AppError(AppErrorType.database));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError,
      InvestmentPolicyStatementReportModel>> getInvestmentPolicyStatementReport(
      {required BuildContext context, required Map<String,
          dynamic> requestBody}) async {
    var id = await NewrelicMobile.instance.startInteraction(
        "Investment Policy Statement Report");
    try {
      final response = await _avLocalDataSource
          .getInvestmentPolicyStatementReport(requestBody: requestBody);
      if (response != null) {
        NewrelicMobile.instance.endInteraction(id);
        return Right(response);
      } else {
        final response = await _avRemoteDataSource
            .getInvestmentPolicyStatementReport(
            context: context, requestBody: requestBody);
        await _avLocalDataSource.saveInvestmentPolicyStatementReport(
            requestBody: requestBody, response: response.toJson());
        await _appLocalDataSource.saveUserPreference(preference: UserPreference(
            ipsTimeStamp: DateFormat('hh:mm a')
                .format(DateTime.now())
                .toString()));
        NewrelicMobile.instance.endInteraction(id);
        return Right(response);
      }
    } on SocketException {
      return const Left(AppError(AppErrorType.network));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError,
      InvestmentPolicyStatementGroupingModel>> getInvestmentPolicyStatementGrouping(
      {required BuildContext context}) async {
    try {
      final response = await _avLocalDataSource
          .getInvestmentPolicyStatementGrouping();
      if (response != null) {
        return Right(response);
      } else {
        final response = await _avRemoteDataSource
            .getInvestmentPolicyStatementGroupings(context: context,);
        await _avLocalDataSource.saveInvestmentPolicyStatementGrouping(
            response: response.toJson());
        return Right(response);
      }
    } on SocketException {
      return const Left(AppError(AppErrorType.network));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError,
      InvestmentPolicyStatementSubGroupingModel>> getInvestmentPolicyStatementSubGrouping(
      {required BuildContext context, required Map<String,
          dynamic> requestBody}) async {
    try {
      final response = await _avLocalDataSource
          .getInvestmentPolicyStatementSubGrouping(requestBody: requestBody);
      if (response != null) {
        return Right(response);
      } else {
        final response = await _avRemoteDataSource
            .getInvestmentPolicyStatementSubGroupings(
            context: context, requestBody: requestBody);
        await _avLocalDataSource.saveInvestmentPolicyStatementSubGrouping(
            requestBody: requestBody, response: response.toJson());
        return Right(response);
      }
    } on SocketException {
      return const Left(AppError(AppErrorType.network));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError,
      InvestmentPolicyStatementPoliciesModel>> getInvestmentPolicyStatementPolicies(
      {required BuildContext context}) async {
    try {
      final response = await _avLocalDataSource
          .getInvestmentPolicyStatementPolicies();
      if (response != null) {
        return Right(response);
      } else {
        final response = await _avRemoteDataSource
            .getInvestmentPolicyStatementPolicies(context: context,);
        await _avLocalDataSource.saveInvestmentPolicyStatementPolicies(
            response: response.toJson());
        return Right(response);
      }
    } on SocketException {
      return const Left(AppError(AppErrorType.network));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError,
      InvestmentPolicyStatementTimePeriodModel>> getInvestmentPolicyStatementTimePeriod(
      {required BuildContext context, required Map<String,
          dynamic> requestBody}) async {
    try {
      final response = await _avRemoteDataSource
          .getInvestmentPolicyStatementTimePeriod(context: context,);
      return Right(response);
    } on SocketException {
      return const Left(AppError(AppErrorType.network));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, void>> clearInvestmentPolicyStatement() async {
    try {
      final response = await _avLocalDataSource
          .clearInvestmentPolicyStatement();
      return Right(response);
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, CashBalanceReportModel>> getCashBalanceReport(
      {required BuildContext context, required Map<String,
          dynamic> requestBody}) async {
    var id = await NewrelicMobile.instance.startInteraction(
        "Cash Balance Report");
    try {
      final response = await _avLocalDataSource.getCashBalanceReport(
          requestBody: requestBody["filter"] ?? {});
      if (response != null) {
        NewrelicMobile.instance.endInteraction(id);
        return Right(response);
      } else {
        final response = await _avRemoteDataSource.getCashBalanceReport(
            context: context, requestBody: requestBody);
        await _avLocalDataSource.saveCashBalanceReport(
            requestBody: requestBody["filter"], response: response.toJson());
        await _appLocalDataSource.saveUserPreference(preference: UserPreference(cashBalanceTimeStamp: DateFormat('hh:mm a').format(DateTime.now()).toString()));
        NewrelicMobile.instance.endInteraction(id);
        return Right(response);
      }
    } on SocketException {
      return const Left(AppError(AppErrorType.network));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Entity?> getCashBalanceSelectedEntity(
      {required String tileName}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource.getCashBalanceSelectedEntity(
        tileName: tileName,
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> saveCashBalanceSelectedEntity(
      {required String tileName, required Map<dynamic,
          dynamic> response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.saveCashBalanceSelectedEntity(tileName: tileName,
        response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<
      Either<AppError, cbpg.CashBalanceGroupingModel>> getCashBalanceGrouping(
      {required BuildContext context, required Map<String,
          dynamic> requestBody}) async {
    try {
      final response = await _avLocalDataSource.getCashBalanceGrouping(
          requestBody: requestBody['0']);
      if (response != null) {
        return Right(response);
      } else {
        final response = await _avRemoteDataSource.getCashBalanceGrouping(
            context: context, requestBody: requestBody);
        await _avLocalDataSource.saveCashBalanceGrouping(
            requestBody: requestBody['0'], response: response.toJson());
        return Right(response);
      }
    } on SocketException {
      return const Left(AppError(AppErrorType.api));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<
      Either<AppError, CashBalanceSubGroupingModel>> getCashBalanceSubGrouping(
      {required BuildContext? context, required Map<String,
          dynamic> requestBody}) async {
    try {
      final response = await _avLocalDataSource.getCashBalanceSubGrouping(
          requestBody: requestBody['1']);
      if (response != null) {
        return Right(response);
      } else {
        final response = await _avRemoteDataSource.getCashBalanceSubGrouping(
            context: context != null ? context : null,
            requestBody: requestBody);
        await _avLocalDataSource.saveCashBalanceSubGrouping(
            response: response.toJson(), requestBody: requestBody['1']);
        return Right(response);
      }
    } on SocketException {
      return const Left(AppError(AppErrorType.api));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, CashBalanceSubGroupingModel>> getCashBalanceAccounts(
      {required BuildContext? context, required Map<String,
          dynamic> requestBody}) async {
    try {
      final response = await _avLocalDataSource.getCashBalanceAccounts(
          requestBody: requestBody['1']);
      if (false /*response != null*/) {
      } else {
        final response = await _avRemoteDataSource.getCashBalanceAccounts(
            context: context != null ? context : null,
            requestBody: requestBody);
        await _avLocalDataSource.saveCashBalanceAccounts(
            response: response.toJson(), requestBody: requestBody['1']);
        return Right(response);
      }
    } on SocketException {
      return const Left(AppError(AppErrorType.api));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<List<cb.SubGroupingItem?>?> getCashBalanceSelectedAccounts(
      {required String tileName, required Map<dynamic,
          dynamic> requestBody}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource.getCashBalanceSelectedAccounts(
        requestBody: requestBody,
        tileName: tileName,
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> saveCashBalanceSelectedAccounts(
      {required String tileName, required Map<dynamic,
          dynamic> requestBody, required Map<dynamic,
          dynamic> response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.saveCashBalanceSelectedAccounts(tileName: tileName,
        requestBody: requestBody,
        response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<cbpg.PrimaryGrouping?> getCashBalanceSelectedPrimaryGrouping(
      {required String? tileName, required EntityData? entity}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource
        .getCashBalanceSelectedPrimaryGrouping(tileName: tileName,
        entity: entity,
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> saveCashBalanceSelectedPrimaryGrouping(
      {required String tileName, required EntityData entity, required Map response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.savePerformanceSelectedPrimaryGrouping(
        response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<List<cb.SubGroupingItem?>?> getCashBalanceSelectedPrimarySubGrouping(
      {required String tileName, required Map<dynamic,
          dynamic> requestBody}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource
        .getCashBalanceSelectedPrimarySubGrouping(tileName: tileName,
        requestBody: requestBody,
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> saveCashBalanceSelectedPrimarySubGrouping(
      {required String tileName, required Map<dynamic,
          dynamic> requestBody, required Map<dynamic,
          dynamic> response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.saveCashBalanceSelectedPrimarySubGrouping(
        tileName: tileName,
        requestBody: requestBody,
        response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<cbnp.NumberOfPeriodItemData?> getCashBalanceSelectedNumberOfPeriod(
      {required String tileName}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource
        .getCashBalanceSelectedNumberOfPeriod(tileName: tileName,
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<cbp.PeriodItemData?> getCashBalanceSelectedPeriod(
      {required String tileName}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource.getCashBalanceSelectedPeriod(
        tileName: tileName,
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> saveCashBalanceSelectedNumberOfPeriod(
      {required String tileName, required Map response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.saveCashBalanceSelectedNumberOfPeriod(
        tileName: tileName,
        response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<void> saveCashBalanceSelectedPeriod(
      {required String tileName, required Map response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.saveCashBalanceSelectedPeriod(tileName: tileName,
        response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<CurrencyData?> getCashBalanceSelectedCurrency(
      {required String tileName}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource.getCashBalanceSelectedCurrency(
        tileName: tileName,
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> saveCashBalanceSelectedCurrency(
      {required String tileName, required Map<dynamic,
          dynamic> response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.saveCashBalanceSelectedCurrency(tileName: tileName,
        response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<DenData?> getCashBalanceSelectedDenomination(
      {required String tileName}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource
        .getCashBalanceSelectedDenomination(tileName: tileName,
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> saveCashBalanceSelectedDenomination(
      {required String tileName, required Map response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.saveCashBalanceSelectedDenomination(
        tileName: tileName,
        response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<String?> getCashBalanceSelectedAsOnDate(
      {required String tileName}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource.getCashBalanceSelectedAsOnDate(
        tileName: tileName,
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> saveCashBalanceSelectedAsOnDate(
      {required String tileName, required String? response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.saveCashBalanceSelectedAsOnDate(tileName: tileName,
        response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<Either<AppError, void>> clearCashBalance() async {
    try {
      final response = await _avLocalDataSource.clearCashBalance();
      return Right(response);
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, NetWorthReportModel>> getNetWorthReport(
      {required BuildContext? context, required Map<String,
          dynamic> requestBody}) async {
    var id = await NewrelicMobile.instance.startInteraction("NetWorth Report");
    try {
      final response = await _avLocalDataSource.getNetWorthReport(
          requestBody: requestBody['1']);
      if (response != null) {
        NewrelicMobile.instance.endInteraction(id);
        return Right(response);
      } else {
        final response = await _avRemoteDataSource.getNetWorthReport(
            context: context != null ? context : null,
            requestBody: requestBody);
        await _avLocalDataSource.saveNetWorthReport(
            requestBody: requestBody['1'], response: response.toJson());
        await _appLocalDataSource.saveUserPreference(preference: UserPreference(
            netWorthTimeStamp: DateFormat('hh:mm a')
                .format(DateTime.now())
                .toString()));
        NewrelicMobile.instance.endInteraction(id);
        return Right(response);
      }
    } on SocketException {
      return const Left(AppError(AppErrorType.network));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, NetWorthGroupingEntity>> getNetWorthGrouping(
      {required BuildContext context, required Map<String,
          dynamic> requestBody}) async {
    try {
      final response = await _avLocalDataSource.getNetWorthGrouping(
          requestBody: requestBody['0']);
      if (response != null) {
        return Right(response);
      } else {
        final response = await _avRemoteDataSource.getNetWorthGrouping(
            context: context, requestBody: requestBody);
        await _avLocalDataSource.saveNetWorthGrouping(
            requestBody: requestBody['0'], response: response.toJson());
        return Right(response);
      }
    } on SocketException {
      return const Left(AppError(AppErrorType.api));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, NetWorthSubGroupingEntity>> getNetWorthSubGrouping(
      {required BuildContext? context, required Map<String,
          dynamic> requestBody}) async {
    try {
      final response = await _avLocalDataSource.getNetWorthSubGrouping(
          requestBody: requestBody['1']);
      if (response != null) {
        return Right(response);
      } else {
        final response = await _avRemoteDataSource.getNetWorthSubGrouping(
            context: context != null ? context : null,
            requestBody: requestBody);
        await _avLocalDataSource.saveNetWorthSubGrouping(
            response: response.toJson(), requestBody: requestBody['1']);
        return Right(response);
      }
    } on SocketException {
      return const Left(AppError(AppErrorType.api));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError,
      nwrp.NetWorthReturnPercentEntity>> getNetWorthReturnPercent(
      {required BuildContext context, required Map<String,
          dynamic> requestBody}) async {
    try {
      final response = await _avRemoteDataSource.getNetWorthReturnPercent(
          context: context, requestBody: requestBody);
      return Right(response);
    } on SocketException {
      return const Left(AppError(AppErrorType.api));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, void>> clearNetWorth() async {
    try {
      final response = await _avLocalDataSource.clearNetWorth();
      return Right(response);
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<String?> getNetWorthSelectedAsOnDate() async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource.getNetWorthSelectedAsOnDate(
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> saveNetWorthSelectedAsOnDate({required String? response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.saveNetWorthSelectedAsOnDate(response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<CurrencyData?> getNetWorthSelectedCurrency() async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource.getNetWorthSelectedCurrency(
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> saveNetWorthSelectedCurrency(
      {required Map<dynamic, dynamic> response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.saveNetWorthSelectedCurrency(response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<DenData?> getNetWorthSelectedDenomination() async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource.getNetWorthSelectedDenomination(
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> saveNetWorthSelectedDenomination(
      {required Map<dynamic, dynamic> response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.saveNetWorthSelectedDenomination(
        response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<Entity?> getNetWorthSelectedEntity() async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource.getNetWorthSelectedEntity(
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> saveNetWorthSelectedEntity(
      {required Map<dynamic, dynamic> response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.saveNetWorthSelectedEntity(response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<cbnp.NumberOfPeriodItemData?> getNetWorthSelectedNumberOfPeriod(
      {required String tileName}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource.getNetWorthSelectedNumberOfPeriod(
        tileName: tileName,
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> saveNetWorthSelectedNumberOfPeriod(
      {required String tileName, required Map response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.saveNetWorthSelectedNumberOfPeriod(
        tileName: tileName,
        response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<PartnershipMethodItemData?> getNetWorthSelectedPartnershipMethod({required String tileName}) async{
   final preference = await _appLocalDataSource.getUserPreference();
   final response = await _avLocalDataSource.getNetWorthSelectedPartnershipMethod(
       tileName: tileName,
       postFix: "${preference.systemName}_${preference.username}");
   return response;
  }


  @override
  Future<void> saveNetWorthSelectedPartnershipMethod(
      {required String tileName, required Map response}) async{
   final preference = await _appLocalDataSource.getUserPreference();
   await _avLocalDataSource.saveNetWorthSelectedPartnershipMethod(
       tileName: tileName,
       response: response,
       postFix: "${preference.systemName}_${preference.username}");
  }


  @override
  Future<void> saveNetWorthSelectedHoldingMethod(
      {required String tileName, required Map<dynamic, dynamic>? response})async {
   final preference = await _appLocalDataSource.getUserPreference();
   await _avLocalDataSource.saveNetWorthSelectedHoldingMethod(
       tileName: tileName,
       response: response,
       postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<cbp.PeriodItemData?> getNetWorthSelectedPeriod(
      {required String tileName}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource.getNetWorthSelectedPeriod(
        tileName: tileName,
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> saveNetWorthSelectedPeriod(
      {required String tileName, required Map response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.saveNetWorthSelectedPeriod(tileName: tileName,
        response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<nwgp.PrimaryGrouping?> getNetWorthSelectedPrimaryGrouping() async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource
        .getNetWorthSelectedPrimaryGrouping(
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> saveNetWorthSelectedPrimaryGrouping(
      {required Map<dynamic, dynamic> response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.saveNetWorthSelectedPrimaryGrouping(
        response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<List<nw.SubGroupingItem?>?> getNetWorthSelectedPrimarySubGrouping(
      {required Map<dynamic, dynamic> requestBody}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource
        .getNetWorthSelectedPrimarySubGrouping(requestBody: requestBody,
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> saveNetWorthSelectedPrimarySubGrouping(
      {required Map<dynamic, dynamic> requestBody, required Map<dynamic,
          dynamic> response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.saveNetWorthSelectedPrimarySubGrouping(
        requestBody: requestBody,
        response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<rpmodal.ReturnPercentItem?> getNetWorthSelectedReturnPercent() async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource.getNetWorthSelectedReturnPercent(
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> saveNetWorthSelectedReturnPercent(
      {required Map<dynamic, dynamic> response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.saveNetWorthSelectedReturnPercent(
        response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<Either<AppError,
      PerformancePrimaryGroupingEntity>> getPerformancePrimaryGrouping(
      {required BuildContext context, required Map<String,
          dynamic> requestBody}) async {
    try {
      final response = await _avLocalDataSource.getPerformancePrimaryGrouping(
          requestBody: requestBody['0']);
      if (response != null) {
        return Right(response);
      } else {
        final response = await _avRemoteDataSource
            .getPerformancePrimaryGrouping(
            context: context, requestBody: requestBody);
        await _avLocalDataSource.savePerformancePrimaryGrouping(
            requestBody: requestBody['0'], response: response.toJson());
        return Right(response);
      }
    } on SocketException {
      return const Left(AppError(AppErrorType.api));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError,
      PerformancePrimarySubGroupingEntity>> getPerformancePrimarySubGrouping(
      {required BuildContext? context, required Map<String,
          dynamic> requestBody}) async {
    try {
      final response = await _avLocalDataSource
          .getPerformancePrimarySubGrouping(requestBody: requestBody['1']);
      if (response != null) {
        return Right(response);
      } else {
        final response = await _avRemoteDataSource
            .getPerformancePrimarySubGrouping(
            context: context != null ? context : null,
            requestBody: requestBody);
        await _avLocalDataSource.savePerformancePrimarySubGrouping(
            response: response.toJson(), requestBody: requestBody['1']);
        return Right(response);
      }
    } on SocketException {
      return const Left(AppError(AppErrorType.api));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError,
      PerformanceSecondaryGroupingEntity>> getPerformanceSecondaryGrouping(
      {required BuildContext context, required Map<String,
          dynamic> requestBody}) async {
    try {
      final response = await _avLocalDataSource.getPerformanceSecondaryGrouping(
          requestBody: requestBody['0']);
      if (response != null) {
        return Right(response);
      } else {
        final response = await _avRemoteDataSource
            .getPerformanceSecondaryGrouping(
            context: context, requestBody: requestBody);
        await _avLocalDataSource.savePerformanceSecondaryGrouping(
            requestBody: requestBody['0'], response: response.toJson());
        return Right(response);
      }
    } on SocketException {
      return const Left(AppError(AppErrorType.api));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError,
      PerformanceSecondarySubGroupingEntity>> getPerformanceSecondarySubGrouping(
      {required BuildContext? context, required Map<String,
          dynamic> requestBody}) async {
    try {
      final response = await _avLocalDataSource
          .getPerformanceSecondarySubGrouping(requestBody: requestBody['1']);
      if (false) {
      } else {
        final response = await _avRemoteDataSource
            .getPerformanceSecondarySubGrouping(
            context: context != null ? context : null,
            requestBody: requestBody);
        await _avLocalDataSource.savePerformanceSecondarySubGrouping(
            response: response.toJson(), requestBody: requestBody['1']);
        return Right(response);
      }
    } on SocketException {
      return const Left(AppError(AppErrorType.api));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, PerformanceReportEntity>> getPerformanceReport(
      {required BuildContext context, required Map<String,
          dynamic> requestBody}) async {
    var id = await NewrelicMobile.instance.startInteraction(
        "Performance Report");
    try {

        final response = await _avRemoteDataSource.getPerformanceReport(
            context: context, requestBody: requestBody);
        return Right(response);
    } on SocketException {
      return const Left(AppError(AppErrorType.api));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }


  @override
  Future<Entity?> getPerformanceSelectedEntity() async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource.getPerformanceSelectedEntity(
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> savePerformanceSelectedEntity(
      {required Map<dynamic, dynamic> response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.savePerformanceSelectedEntity(response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<primaryGrouping
      .PrimaryGrouping?> getPerformanceSelectedPrimaryGrouping() async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource
        .getPerformanceSelectedPrimaryGrouping(
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> savePerformanceSelectedPrimaryGrouping(
      {required Map<dynamic, dynamic> response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.savePerformanceSelectedPrimaryGrouping(
        response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<List<primarySubGrouping
      .SubGroupingItem?>?> getPerformanceSelectedPrimarySubGrouping(
      {required Map<dynamic, dynamic> requestBody}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource
        .getPerformanceSelectedPrimarySubGrouping(requestBody: requestBody,
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> savePerformanceSelectedPrimarySubGrouping(
      {required Map<dynamic, dynamic> requestBody, required Map<dynamic,
          dynamic> response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.savePerformanceSelectedPrimarySubGrouping(
        requestBody: requestBody,
        response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<SecondaryGrouping?> getPerformanceSelectedSecondaryGrouping() async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource
        .getPerformanceSelectedSecondaryGrouping(
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> savePerformanceSelectedSecondaryGrouping(
      {required Map<dynamic, dynamic> response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.savePerformanceSelectedSecondaryGrouping(
        response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<List<secondarySubGrouping
      .SubGroupingItem?>?> getPerformanceSelectedSecondarySubGrouping(
      {required Map<dynamic, dynamic> requestBody}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource
        .getPerformanceSelectedSecondarySubGrouping(requestBody: requestBody,
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> savePerformanceSelectedSecondarySubGrouping(
      {required Map<dynamic, dynamic> requestBody, required Map<dynamic,
          dynamic> response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.savePerformanceSelectedSecondarySubGrouping(
        requestBody: requestBody,
        response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<List<
      rp.ReturnPercentItem?>?> getPerformanceSelectedReturnPercent() async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource
        .getPerformanceSelectedReturnPercent(
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> savePerformanceSelectedReturnPercent(
      {required Map<dynamic, dynamic> response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.savePerformanceSelectedReturnPercent(
        response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<CurrencyData?> getPerformanceSelectedCurrency() async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource.getPerformanceSelectedCurrency(
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> savePerformanceSelectedCurrency(
      {required Map<dynamic, dynamic> response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.savePerformanceSelectedCurrency(response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<DenData?> getPerformanceSelectedDenomination() async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource
        .getPerformanceSelectedDenomination(
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> savePerformanceSelectedDenomination(
      {required Map<dynamic, dynamic> response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.savePerformanceSelectedDenomination(
        response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<String?> getPerformanceSelectedAsOnDate() async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource.getPerformanceSelectedAsOnDate(
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> savePerformanceSelectedAsOnDate(
      {required String? response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.savePerformanceSelectedAsOnDate(response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }


  @override
  Future<Either<AppError, void>> clearPerformance() async {
    try {
      final response = await _avLocalDataSource.clearPerformance();
      return Right(response);
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }


  @override
  Future<Either<AppError, IncomeAccountEntity>> getIncomeReportPeriod(
      {required BuildContext context, required Map<String,
          dynamic> requestBody}) async {
    try {
      final response = await _avLocalDataSource.getIncomeAccounts(
          requestBody: requestBody);
      if (response != null) {
        return Right(response);
      } else {
        final response = await _avRemoteDataSource.getIncomeAccounts(
            context: context, requestBody: requestBody);
        await _avLocalDataSource.saveIncomeAccounts(
            requestBody: requestBody, response: response.toJson());
        return Right(response);
      }
    } on SocketException {
      return const Left(AppError(AppErrorType.api));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, IncomeReportEntity>> getIncomeReport({required BuildContext context, required Map<String, dynamic> requestBody}) async {
    var id = await NewrelicMobile.instance.startInteraction("Income Report");
    try {
      final response = await _avLocalDataSource.getIncomeReport(requestBody: requestBody['filter']);
      if (response != null) {
        NewrelicMobile.instance.endInteraction(id);
        return Right(response);
      } else {
        final response = await _avRemoteDataSource.getIncomeReport(context: context, requestBody: requestBody);
        await _avLocalDataSource.saveIncomeReport(requestBody: requestBody['filter'], response: response.toJson());
        await _appLocalDataSource.saveUserPreference(preference: UserPreference(
            incomeTimeStamp: DateFormat('hh:mm a')
                .format(DateTime.now())
                .toString()));
        NewrelicMobile.instance.endInteraction(id);
        return Right(response);
      }
    } on SocketException {
      return const Left(AppError(AppErrorType.api));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Entity?> getIncomeSelectedEntity() async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource.getIncomeSelectedEntity(
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> saveIncomeSelectedEntity(
      {required Map<dynamic, dynamic> response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.saveIncomeSelectedEntity(response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<List<IncomeAccount>?> getIncomeSelectedAccounts(
      {required Map<String, dynamic> requestBody}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource.getIncomeSelectedAccounts(
        requestBody: requestBody,
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> saveIncomeSelectedAccounts(
      {required Map<String, dynamic> requestBody, required Map<dynamic,
          dynamic> response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.saveIncomeSelectedAccounts(
        requestBody: requestBody,
        response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<period.PeriodItem?> getIncomeSelectedPeriod() async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource.getIncomeSelectedPeriod(
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> saveIncomeSelectedPeriod(
      {required Map<dynamic, dynamic> response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.saveIncomeSelectedPeriod(response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<nop.NumberOfPeriodItem?> getIncomeSelectedNumberOfPeriod() async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource.getIncomeSelectedNumberOfPeriod(
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> saveIncomeSelectedNumberOfPeriod(
      {required Map<dynamic, dynamic> response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.saveIncomeSelectedNumberOfPeriod(
        response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<CurrencyData?> getIncomeSelectedCurrency() async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource.getIncomeSelectedCurrency(
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> saveIncomeSelectedCurrency(
      {required Map<dynamic, dynamic> response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.saveIncomeSelectedCurrency(response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<DenData?> getIncomeSelectedDenomination() async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource.getIncomeSelectedDenomination(
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> saveIncomeSelectedDenomination(
      {required Map<dynamic, dynamic> response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.saveIncomeSelectedDenomination(response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }


  @override
  Future<Either<AppError, ExpenseAccountEntity>> getExpenseReportPeriod(
      {required BuildContext context, required Map<String,
          dynamic> requestBody}) async {
    try {
      final response = await _avLocalDataSource.getExpenseAccounts(
          requestBody: requestBody);
      if (response != null) {
        return Right(response);
      } else {
        final response = await _avRemoteDataSource.getExpenseAccounts(
            context: context, requestBody: requestBody);
        await _avLocalDataSource.saveExpenseAccounts(
            requestBody: requestBody, response: response.toJson());
        return Right(response);
      }
    } on SocketException {
      return const Left(AppError(AppErrorType.api));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, ExpenseReportEntity>> getExpenseReport(
      {required BuildContext context, required Map<String,
          dynamic> requestBody}) async {
    var id = await NewrelicMobile.instance.startInteraction("Expense Report");
    try {
      final response = await _avLocalDataSource.getExpenseReport(
          requestBody: requestBody['filter']);
      if (response != null) {
        NewrelicMobile.instance.endInteraction(id);
        return Right(response);
      } else {
        final response = await _avRemoteDataSource.getExpenseReport(
            context: context, requestBody: requestBody);
        await _avLocalDataSource.saveExpenseReport(
            requestBody: requestBody['filter'], response: response.toJson());
        await _appLocalDataSource.saveUserPreference(preference: UserPreference(
            expenseTimeStamp: DateFormat('hh:mm a')
                .format(DateTime.now())
                .toString()));
        NewrelicMobile.instance.endInteraction(id);
        return Right(response);
      }
    } on SocketException {
      return const Left(AppError(AppErrorType.api));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError,
      nopie.IncomeExpenseNumberOfPeriodModel>> getIncomeExpenseNumberOfPeriod(
      {required BuildContext context, required Map<String,
          dynamic> requestBody}) async {
    try {
      final response = await _avRemoteDataSource.getIncomeExpenseNumberOfPeriod(
          context: context, requestBody: requestBody);
      return Right(response);
    } on SocketException {
      return const Left(AppError(AppErrorType.api));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, IncomeExpensePeriodModel>> getIncomeExpensePeriod(
      {required BuildContext context, required Map<String,
          dynamic> requestBody}) async {
    try {
      final response = await _avRemoteDataSource.getIncomeExpensePeriod(
          context: context, requestBody: requestBody);
      return Right(response);
    } on SocketException {
      return const Left(AppError(AppErrorType.api));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, void>> clearIncomeExpense() async {
    try {
      final response = await _avLocalDataSource.clearIncomeExpense();
      return Right(response);
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }


  @override
  Future<Either<AppError, DocumentModel>> getDocuments(
      {required BuildContext context, required Map<String,
          dynamic> requestBody}) async {
    try {
      final response = await _avRemoteDataSource.getDocuments(
          context: context, requestBody: requestBody);
      return Right(response);
    } on SocketException {
      return const Left(AppError(AppErrorType.api));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, DownloadData>> downloadDocuments(
      {required BuildContext context, required Map<String,
          dynamic> requestBody}) async {
    try {
      final preference = await _appLocalDataSource.getUserPreference();
      final response = await _avRemoteDataSource.downloadDocuments(
          context: context,
          username: preference.username,
          password: preference.password,
          token: preference.idToken,
          systemName: preference.systemName,
          requestBody: requestBody);
      return Right(response);
    } on SocketException {
      return const Left(AppError(AppErrorType.api));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, DocumentModel>> searchDocuments(
      {required BuildContext context, required Map<String,
          dynamic> requestBody}) async {
    try {
      final response = await _avRemoteDataSource.searchDocuments(
          context: context, requestBody: requestBody);
      return Right(response);
    } on SocketException {
      return const Left(AppError(AppErrorType.api));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, UserGuideAssetsEntity>> getUserGuideAssets(
      {required Map<String, dynamic> requestBody}) async {
    try {
      final response = await _avRemoteDataSource.getUserGuideAssets(requestBody: requestBody);
      return Right(response);
    } on SocketException {
      return const Left(AppError(AppErrorType.api));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, NotificationsModel>> getNotifications(
      {required Map<String, dynamic> requestBody}) async {
    try {
      final response = await _avRemoteDataSource.getNotifications(
          requestBody: requestBody);
      return Right(response);
    } on SocketException {
      return const Left(AppError(AppErrorType.api));
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, void>> saveSelectedDashboardEntity(
      {required EntityData? entity}) async {
    try {
      final user = await _appLocalDataSource.getUserPreference();
      final response = await _avLocalDataSource.saveSelectedEntity(
          entity: entity, credential: "${user.username}_${user.systemName}");
      return Right(response);
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, EntityData?>> getSelectedDashboardEntity() async {
    try {
      final user = await _appLocalDataSource.getUserPreference();
      final entity = await _avLocalDataSource.getSelectedEntity(
          credential: "${user.username}_${user.systemName}");
      return Right(entity);
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, TimePeriodItemData?>> getIpsReturnFilter(
      {required String? entityName, required String? grouping}) async {
    try {
      final user = await _appLocalDataSource.getUserPreference();
      final entity = await _avLocalDataSource.getIpsReturnFilter(
          entityName: entityName,
          grouping: grouping,
          credential: "${user.username}_${user.systemName}");
      return Right(entity);
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, Policies?>> getIpsPolicyFilter(
      {required String? entityName, required String? grouping}) async {
    try {
      final user = await _appLocalDataSource.getUserPreference();
      final entity = await _avLocalDataSource.getIpsPolicyFilter(
          entityName: entityName,
          grouping: grouping,
          credential: "${user.username}_${user.systemName}");
      return Right(entity);
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, List<ips.SubGroupingItemData>?>> getIpsSubFilter(
      {required String? entityName, required String? grouping}) async {
    try {
      final user = await _appLocalDataSource.getUserPreference();
      final entity = await _avLocalDataSource.getIpsSubFilter(
          entityName: entityName,
          grouping: grouping,
          credential: "${user.username}_${user.systemName}");
      return Right(entity);
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, void>> saveIpsPolicyFilter(
      {required String? entityName, required String? grouping, required Policies? policy}) async {
    try {
      final user = await _appLocalDataSource.getUserPreference();
      final response = await _avLocalDataSource.saveIpsPolicyFilter(
          entityName: entityName,
          grouping: grouping,
          policy: policy,
          credential: "${user.username}_${user.systemName}");
      return Right(response);
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, void>> saveIpsReturnFilter(
      {required String? entityName, required String? grouping, required TimePeriodItemData? period}) async {
    try {
      final user = await _appLocalDataSource.getUserPreference();
      final response = await _avLocalDataSource.saveIpsReturnFilter(
          entityName: entityName,
          grouping: grouping,
          period: period,
          credential: "${user.username}_${user.systemName}");
      return Right(response);
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, void>> saveIpsSubFilter(
      {required String? entityName, required String? grouping, required List<
          ips.SubGroupingItemData>? subGroup}) async {
    try {
      final user = await _appLocalDataSource.getUserPreference();
      final response = await _avLocalDataSource.saveIpsSubFilter(
          entityName: entityName,
          grouping: grouping,
          subGroup: subGroup,
          credential: "${user.username}_${user.systemName}");
      return Right(response);
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, List<cb.SubGroupingItem>?>> getSelectedCBSubGroup(
      {required String? entityName, required String? grouping}) async {
    try {
      final user = await _appLocalDataSource.getUserPreference();
      final entity = await _avLocalDataSource.getSelectedCBSubGroup(
          entityName: entityName,
          grouping: grouping,
          credential: "${user.username}_${user.systemName}");
      return Right(entity);
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, void>> saveSelectedCBSubGroup(
      {required String? entityName, required String? grouping, required List<
          cb.SubGroupingItem>? subGroup}) async {
    try {
      final user = await _appLocalDataSource.getUserPreference();
      final response = await _avLocalDataSource.saveSelectedCBSubGroup(
          entityName: entityName,
          grouping: grouping,
          subGroup: subGroup,
          credential: "${user.username}_${user.systemName}");
      return Right(response);
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, EntityData?>> getSelectedDocumentEntity() async {
    try {
      final user = await _appLocalDataSource.getUserPreference();
      final entity = await _avLocalDataSource.getSelectedDocEntity(
          credential: "${user.username}_${user.systemName}");
      return Right(entity);
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, void>> saveSelectedDocumentEntity(
      {required EntityData? entity}) async {
    try {
      final user = await _appLocalDataSource.getUserPreference();
      final response = await _avLocalDataSource.saveSelectedDocEntity(
          entity: entity, credential: "${user.username}_${user.systemName}");
      return Right(response);
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, List<Map>?>> getSavedIncomeOrExpenseAccount(
      {required String? entityName, required String? grouping}) async {
    try {
      final user = await _appLocalDataSource.getUserPreference();
      final response = await _avLocalDataSource.getSavedIncomeOrExpenseAccount(
          entityName: entityName,
          grouping: grouping,
          credential: "${user.username}_${user.systemName}");
      return Right(response);
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError,
      ienp.NumberOfPeriodItemData?>> getSavedIncomeOrExpensePeriod(
      {required String? entityName, required String? grouping}) async {
    try {
      final user = await _appLocalDataSource.getUserPreference();
      final response = await _avLocalDataSource.getSavedIncomeOrExpensePeriod(
          entityName: entityName,
          grouping: grouping,
          credential: "${user.username}_${user.systemName}");
      return Right(response);
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, void>> saveSelectedIncomeOrExpenseAccount(
      {required String? entityName, required String? grouping, required List<
          Object>? item}) async {
    try {
      final user = await _appLocalDataSource.getUserPreference();
      final response = await _avLocalDataSource
          .saveSelectedIncomeOrExpenseAccount(entityName: entityName,
          grouping: grouping,
          item: item,
          credential: "${user.username}_${user.systemName}");
      return Right(response);
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, void>> saveSelectedIncomeOrExpensePeriod(
      {required String? entityName, required String? grouping, required ienp
          .NumberOfPeriodItemData? item}) async {
    try {
      final user = await _appLocalDataSource.getUserPreference();
      final response = await _avLocalDataSource
          .saveSelectedIncomeOrExpensePeriod(entityName: entityName,
          grouping: grouping,
          item: nopie.NumberOfPeriodItem.fromJson(item?.toJson() ?? {}),
          credential: "${user.username}_${user.systemName}");
      return Right(response);
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, int?>> getCBSortFilter() async {
    try {
      final user = await _appLocalDataSource.getUserPreference();
      final response = await _avLocalDataSource.getCBSortFilter(
          credential: "${user.username}_${user.systemName}");
      return Right(response);
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, void>> saveCBSortFilter({required int sort}) async {
    try {
      final user = await _appLocalDataSource.getUserPreference();
      final response = await _avLocalDataSource.saveCBSortFilter(
          sort: sort, credential: "${user.username}_${user.systemName}");
      return Right(response);
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, CurrencyData?>> getSavedCurrencyFilter(
      {required String? tileName}) async {
    try {
      final user = await _appLocalDataSource.getUserPreference();
      final response = await _avLocalDataSource.getSavedCurrencyFilter(
          tileName: tileName,
          credential: "${user.username}_${user.systemName}");
      return Right(response);
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, void>> saveCurrencyFilter(
      {required Currency? currency, required String? tileName}) async {
    try {
      final user = await _appLocalDataSource.getUserPreference();
      final response = await _avLocalDataSource.saveCurrencyFilter(
          currency: currency,
          tileName: tileName,
          credential: "${user.username}_${user.systemName}");
      return Right(response);
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, DenominationData?>> getSelectedDenomination(
      {required String? tileName}) async {
    try {
      final user = await _appLocalDataSource.getUserPreference();
      final response = await _avLocalDataSource.getSelectedDenomination(
          tileName: tileName,
          credential: "${user.username}_${user.systemName}");
      return Right(response);
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, void>> saveSelectedDenomination(
      {required DenominationData? denomination, required String? tileName}) async {
    try {
      final user = await _appLocalDataSource.getUserPreference();
      final response = await _avLocalDataSource.saveSelectedDenomination(
          denomination: denomination,
          tileName: tileName,
          credential: "${user.username}_${user.systemName}");
      return Right(response);
    } on UnauthorisedException {
      return const Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, void>> connectChatServer({
    required String? authToken,
    required String? subId,
  }) async {
    try {
      final response = await _avRemoteDataSource.connectChatServer(
        subId: subId,
        authToken: authToken,
      );
      webSocketChannel = response;
      return Right(response);
    } on Exception catch (e) {
      log('errorMessage: $e');
      return const Left(AppError(AppErrorType.api));
    }
  }

  @override
  Future<Either<AppError, void>> disconnectChatServer() async {
    try {
      final response = await _avRemoteDataSource.disconnectChatServer(
          channel: webSocketChannel!);
      return Right(response);
    } on Exception {
      return const Left(AppError(AppErrorType.api));
    }
  }

  @override
  Future<Either<AppError, void>> sendMessage({
    required String? question,
    required ChatDataSource? chatDataSource,
    required String? entityId,
    required String? entityType,
  }) async {
    try {
      final response = await _avRemoteDataSource.sendMessage(
          question: question,
          channel: webSocketChannel!,
          entityId: entityId,
          entityType: entityType
      );
      chatDataSource?.addChat([response]);
      return Right(response);
    } on Exception {
      return const Left(AppError(AppErrorType.api));
    }
  }

  @override
  Future<Either<AppError, List<ChatMsg>?>> getChatList() async {
    try {
      final chats = await _avLocalDataSource.getChatMsgList();
      return Right(chats);
    } on Exception {
      return const Left(AppError(AppErrorType.api));
    }
  }

  @override
  Future<Either<AppError, void>> establishChatStream({
    required ChatDataSource chatDataSource,
    required String? authToken,
    required String? subId,
  }) async {
    try {
      final data = _avRemoteDataSource
          .getChatResponse(channel: webSocketChannel!)
          .listen((message) {
        if (message?.typ == MsgVariant.notification) {
          chatDataSource.changeNotification(message);
        } else if (message?.typ == MsgVariant.message) {
          chatDataSource.addChat([message ?? const ChatMsg()]);
        }
      }).onError((error) {
        connectChatServer(
          authToken: authToken,
          subId: subId,
        );
        establishChatStream(
            chatDataSource: chatDataSource, authToken: authToken, subId: subId);
      });
      return Right(data);
    } on Exception {
      return const Left(AppError(AppErrorType.api));
    }
  }

  @override
  Future<List<ExpenseAccount>?> getExpenseSelectedAccounts(
      {required Map<String, dynamic> requestBody}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource.getExpenseSelectedAccounts(
        requestBody: requestBody,
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<CurrencyData?> getExpenseSelectedCurrency() async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource.getExpenseSelectedCurrency(
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<DenData?> getExpenseSelectedDenomination() async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource.getExpenseSelectedDenomination(
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<Entity?> getExpenseSelectedEntity() async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource.getExpenseSelectedEntity(
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<nop.NumberOfPeriodItem?> getExpenseSelectedNumberOfPeriod() async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource.getExpenseSelectedNumberOfPeriod(
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<period.PeriodItem?> getExpenseSelectedPeriod() async {
    final preference = await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource.getExpenseSelectedPeriod(
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> saveExpenseSelectedAccounts({required Map<String,
      dynamic> requestBody, required Map response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.saveExpenseSelectedAccounts(
        requestBody: requestBody,
        response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<void> saveExpenseSelectedCurrency({required Map response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.saveExpenseSelectedCurrency(response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<void> saveExpenseSelectedDenomination({required Map response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.saveExpenseSelectedDenomination(response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<void> saveExpenseSelectedEntity({required Map response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.saveExpenseSelectedEntity(response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<void> saveExpenseSelectedNumberOfPeriod(
      {required Map response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.saveExpenseSelectedNumberOfPeriod(
        response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<void> saveExpenseSelectedPeriod({required Map response}) async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.saveExpenseSelectedPeriod(response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<void> clearAllTheFilters() async{
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.clearAllTheFilters(postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<PartnershipMethodItemData?> getPerformanceSelectedPartnershipMethod({required String tileName}) async{
    final preference= await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource.getPerformanceSelectedPartnershipMethod(
        tileName: tileName,
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> savePerformanceSelectedPartnershipMethod(
      {required String tileName, required Map<dynamic, dynamic> response})async {
    final preference = await _appLocalDataSource.getUserPreference();
    await _avLocalDataSource.savePerformanceSelectedPartnershipMethod(
        tileName: tileName,
        response: response,
        postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<HoldingMethodItemData?> getPerformanceSelectedHoldingMethod({required String tileName})async {
    final preference =await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource.getPerformanceSelectedHoldingMethod(
        tileName: tileName,
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }

  @override
  Future<void> savePerformanceSelectedHoldingMethod(
      {required String tileName, required Map<dynamic, dynamic> response}) async{
  final preference = await _appLocalDataSource.getUserPreference();
  await _avLocalDataSource.savePerformanceSelectedHoldingMethod(
      tileName: tileName,
      response: response,
      postFix: "${preference.systemName}_${preference.username}");
  }

  @override
  Future<HoldingMethodItemData?> getNetWorthSelectedHoldingMethod(
      {required String tileName})async {
    final preference =await _appLocalDataSource.getUserPreference();
    final response = await _avLocalDataSource.getNetWorthSelectedHoldingMethod(
        tileName: tileName,
        postFix: "${preference.systemName}_${preference.username}");
    return response;
  }






}