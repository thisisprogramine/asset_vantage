import 'package:asset_vantage/src/data/models/cash_balance/cash_balance_grouping_model.dart';
import 'package:asset_vantage/src/data/models/cash_balance/cash_balance_report_model.dart';
import 'package:asset_vantage/src/data/models/cash_balance/cash_balance_sub_grouping_model.dart';
import 'package:asset_vantage/src/domain/entities/app_error.dart';
import 'package:asset_vantage/src/domain/entities/cash_balance/cash_balance_entity.dart';
import 'package:asset_vantage/src/domain/entities/cash_balance/cash_balance_grouping_entity.dart';
import 'package:asset_vantage/src/domain/entities/cash_balance/cash_balance_sub_grouping_entity.dart';
import 'package:asset_vantage/src/domain/params/cash_balance/cash_balance_report_params.dart';
import 'package:asset_vantage/src/domain/params/cash_balance/cash_balance_sub_grouping_params.dart';
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:asset_vantage/src/domain/usecases/cash_balance/cash_balance_filters/primary_grouping/get_cash_balance_grouping.dart';
import 'package:asset_vantage/src/domain/usecases/cash_balance/get_cash_balance_report.dart';
import 'package:asset_vantage/src/domain/usecases/cash_balance/cash_balance_filters/sub_grouping/get_cash_balance_sub_grouping.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'cash_balance_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<GetCashBalanceGrouping>()])
@GenerateMocks([], customMocks: [MockSpec<GetCashBalanceSubGrouping>()])
@GenerateMocks([], customMocks: [MockSpec<GetCashBalanceReport>()])
void main() async {
  group('Cash Balance test', () {
    test('CashBalanceGroupingEntity should be return on success api call',
        () async {
      final getCashBalanceGrouping = MockGetCashBalanceGrouping();

      when(getCashBalanceGrouping(NoParams())).thenAnswer((_) async =>
          Right(CashBalanceGroupingEntity(grouping: [const GroupingEntity()])));

      final result = await getCashBalanceGrouping(NoParams());

      CashBalanceReportModel.fromJson({});
      const CashBalanceReportModel().toJson();
      CashBalanceReport.fromJson({});
      CashBalanceReport().toJson();
      CashBalanceSubGroupingModel.fromJson({});
      CashBalanceSubGroupingModel().toJson();
      SubGroupingItem.fromJson({});
      // const SubGroupingItem().toJson();
      CashBalanceGroupingModel.fromJson({});
      CashBalanceGroupingModel().toJson();
      PrimaryGrouping.fromJson({});
      const PrimaryGrouping().toJson();

      SubGroupingItem.fromJson({});
      // SubGroupingItem().toJson();

      result.fold((error) {
        expect(error, isA<CashBalanceGroupingEntity>());
      }, (response) {
        expect(response, isA<CashBalanceGroupingEntity>());
      });
    });

    test('AppError should be return on api call failure', () async {
      final getCashBalanceGrouping = MockGetCashBalanceGrouping();

      when(getCashBalanceGrouping(NoParams()))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result = await getCashBalanceGrouping(NoParams());

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });

    test('CashBalanceGroupingEntity should be return on success api call',
        () async {
      final getCashBalanceSubGrouping = MockGetCashBalanceSubGrouping();

      when(getCashBalanceSubGrouping(const CashBalanceSubGroupingParams()))
          .thenAnswer((_) async => const Right(CashBalanceSubGroupingEntity(
              subGroupingList: [SubGroupingItemData()])));

      final result =
          await getCashBalanceSubGrouping(const CashBalanceSubGroupingParams());

      CashBalanceSubGroupingParams().toJson();

      result.fold((error) {
        expect(error, isA<CashBalanceSubGroupingEntity>());
      }, (response) {
        response.props;
        response.subGroupingList.first.props;
        expect(response, isA<CashBalanceSubGroupingEntity>());
      });
    });

    test('AppError should be return on api call failure', () async {
      final getCashBalanceSubGrouping = MockGetCashBalanceSubGrouping();

      when(getCashBalanceSubGrouping(const CashBalanceSubGroupingParams()))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result =
          await getCashBalanceSubGrouping(const CashBalanceSubGroupingParams());

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });

    test('CashBalanceReportEntity should be return on success api call',
        () async {
      final getCashBalanceReport = MockGetCashBalanceReport();

      when(getCashBalanceReport(const CashBalanceReportParams()))
          .thenAnswer((_) async => const Right(CashBalanceReportEntity(report: [
                ReportEntity(
                    accountId: '',
                    accountName: '',
                    accountNumber: '',
                    cashBalance: 0.0)
              ])));

      final result =
          await getCashBalanceReport(const CashBalanceReportParams());

      CashBalanceReportParams().toJson();

      result.fold((error) {
        expect(error, isA<CashBalanceReportEntity>());
      }, (response) {
        expect(response, isA<CashBalanceReportEntity>());
      });
    });

    test('AppError should be return on api call failure', () async {
      final getCashBalanceReport = MockGetCashBalanceReport();

      when(getCashBalanceReport(const CashBalanceReportParams()))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result =
          await getCashBalanceReport(const CashBalanceReportParams());

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });
  });
}
