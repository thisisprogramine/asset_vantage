import 'package:asset_vantage/src/data/models/net_worth/net_worth_grouping_model.dart';
import 'package:asset_vantage/src/data/models/net_worth/net_worth_number_of_period_model.dart';
import 'package:asset_vantage/src/data/models/net_worth/net_worth_period_model.dart';
import 'package:asset_vantage/src/data/models/net_worth/net_worth_sub_grouping_model.dart';
import 'package:asset_vantage/src/data/models/net_worth/networth_report_model.dart';
import 'package:asset_vantage/src/domain/entities/app_error.dart';
import 'package:asset_vantage/src/domain/entities/net_worth/net_worth_chart_data.dart';
import 'package:asset_vantage/src/domain/entities/net_worth/net_worth_entity.dart';
import 'package:asset_vantage/src/domain/entities/net_worth/net_worth_grouping_entity.dart';
import 'package:asset_vantage/src/domain/entities/net_worth/net_worth_number_of_period_entity.dart';
import 'package:asset_vantage/src/domain/entities/net_worth/net_worth_period_entity.dart';
import 'package:asset_vantage/src/domain/entities/net_worth/net_worth_sub_grouping_enity.dart';
import 'package:asset_vantage/src/domain/params/net_worth/net_worth_number_or_period_params.dart';
import 'package:asset_vantage/src/domain/params/net_worth/net_worth_period_params.dart';
import 'package:asset_vantage/src/domain/params/net_worth/net_worth_report_params.dart';
import 'package:asset_vantage/src/domain/params/net_worth/net_worth_sub_grouping_param.dart';
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:asset_vantage/src/domain/usecases/net_worth/get_net_worth_grouping.dart';
import 'package:asset_vantage/src/domain/usecases/net_worth/get_net_worth_number_of%20_period.dart';
import 'package:asset_vantage/src/domain/usecases/net_worth/get_net_worth_period.dart';
import 'package:asset_vantage/src/domain/usecases/net_worth/get_net_worth_report.dart';
import 'package:asset_vantage/src/domain/usecases/net_worth/get_net_worth_sub_grouping.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'net_worth_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<GetNetWorthGrouping>()])
@GenerateMocks([], customMocks: [MockSpec<GetNetWorthNumberOfPeriod>()])
@GenerateMocks([], customMocks: [MockSpec<GetNetWorthPeriod>()])
@GenerateMocks([], customMocks: [MockSpec<GetNetWorthSubGrouping>()])
@GenerateMocks([], customMocks: [MockSpec<GetNetWorthReport>()])
void main() async {
  group('Net Worth test', () {
    test('NetWorthGroupingEntity should be return on success api call',
        () async {
      final getNetWorthGrouping = MockGetNetWorthGrouping();

      when(getNetWorthGrouping(NoParams())).thenAnswer((_) async =>
          Right(NetWorthGroupingEntity(grouping: [GroupingEntity()])));

      final result = await getNetWorthGrouping(NoParams());

      NetWorthReportModel.fromJson({});
      // NetWorthReportModel().toJson();
      NetWorthGroupingModel.fromJson({});
      NetWorthGroupingModel().toJson();
      PrimaryGrouping.fromJson({});
      const PrimaryGrouping().toJson();
      Date.fromJson({});
      Date().toJson();
      Filter.fromJson({});
      Filter().toJson();
      NetWorthChartData(total: 0.0).props;
      Child(name: '', value: 0.0).props;
      result.fold((error) {
        expect(error, isA<NetWorthGroupingEntity>());
      }, (response) {
        expect(response, isA<NetWorthGroupingEntity>());
      });
    });

    test('AppError should be return on api call failure', () async {
      final getNetWorthGrouping = MockGetNetWorthGrouping();

      when(getNetWorthGrouping(NoParams()))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result = await getNetWorthGrouping(NoParams());

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });

    test('NetWorthNumberOfPeriodEntity should be return on success api call',
        () async {
      final getNetWorthNumberOfPeriod = MockGetNetWorthNumberOfPeriod();

      when(getNetWorthNumberOfPeriod(const NetWorthNumberOfPeriodParams()))
          .thenAnswer((_) async => const Right(NetWorthNumberOfPeriodEntity(
              periodList: [NumberOfPeriodItemData()])));

      final result =
          await getNetWorthNumberOfPeriod(const NetWorthNumberOfPeriodParams());

      const NetWorthNumberOfPeriodParams().toJson();
      NetWorthNumberOfPeriodModel.fromJson({});
      NetWorthNumberOfPeriodModel().toJson();
      NumberOfPeriodItem.fromJson(const {});
      const NumberOfPeriodItem().toJson();
      result.fold((error) {
        expect(error, isA<NetWorthNumberOfPeriodEntity>());
      }, (response) {
        response.props;
        response.periodList.first.props;
        expect(response, isA<NetWorthNumberOfPeriodEntity>());
      });
    });

    test('AppError should be return on api call failure', () async {
      final getNetWorthNumberOfPeriod = MockGetNetWorthNumberOfPeriod();

      when(getNetWorthNumberOfPeriod(const NetWorthNumberOfPeriodParams()))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result =
          await getNetWorthNumberOfPeriod(const NetWorthNumberOfPeriodParams());

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });

    test('NetWorthPeriodEntity should be return on success api call', () async {
      final getNetWorthPeriod = MockGetNetWorthPeriod();

      when(getNetWorthPeriod(const NetWorthPeriodParams())).thenAnswer(
          (_) async => const Right(
              NetWorthPeriodEntity(periodList: [PeriodItemData()])));

      final result = await getNetWorthPeriod(const NetWorthPeriodParams());

      const NetWorthPeriodParams().toJson();
      NetWorthPeriodModel.fromJson(const {});
      // NetWorthPeriodModel().toJson();
      PeriodItem.fromJson(const {});
      const PeriodItem().toJson();
      result.fold((error) {
        expect(error, isA<NetWorthPeriodEntity>());
      }, (response) {
        response.props;
        response.periodList.first.props;
        expect(response, isA<NetWorthPeriodEntity>());
      });
    });

    test('AppError should be return on api call failure', () async {
      final getNetWorthPeriod = MockGetNetWorthPeriod();

      when(getNetWorthPeriod(const NetWorthPeriodParams()))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result = await getNetWorthPeriod(const NetWorthPeriodParams());

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });

    test('NetWorthSubGroupingEntity should be return on success api call',
        () async {
      final getNetWorthSubGrouping = MockGetNetWorthSubGrouping();

      when(getNetWorthSubGrouping(const NetWorthSubGroupingParams()))
          .thenAnswer((_) async => const Right(NetWorthSubGroupingEntity(
              subGroupingList: [SubGroupingItemData()])));

      final result =
          await getNetWorthSubGrouping(const NetWorthSubGroupingParams());

      const NetWorthSubGroupingParams().toJson();
      NetWorthSubGroupingModel.fromJson(const {});
      // NetWorthSubGroupingModel().toJson();
      SubGroupingItem.fromJson(const {});
      const SubGroupingItem().toJson();
      result.fold((error) {
        expect(error, isA<NetWorthSubGroupingEntity>());
      }, (response) {
        response.props;
        response.subGroupingList.first.props;
        expect(response, isA<NetWorthSubGroupingEntity>());
      });
    });

    test('AppError should be return on api call failure', () async {
      final getNetWorthSubGrouping = MockGetNetWorthSubGrouping();

      when(getNetWorthSubGrouping(const NetWorthSubGroupingParams()))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result =
          await getNetWorthSubGrouping(const NetWorthSubGroupingParams());

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });

    test('NetWorthReportEntity should be return on success api call', () async {
      final getNetWorthReport = MockGetNetWorthReport();

      when(getNetWorthReport(const NetWorthReportParams()))
          .thenAnswer((_) async => const Right(NetWorthReportEntity(report: [
                ReportEntity(
                    date: '',
                    children: [Child(name: '', value: 0.0)],
                    total: 0.0)
              ])));

      final result = await getNetWorthReport(const NetWorthReportParams());

      NetWorthReportParams().toJson();

      result.fold((error) {
        expect(error, isA<NetWorthReportEntity>());
      }, (response) {
        response.props;
        expect(response, isA<NetWorthReportEntity>());
      });
    });

    test('AppError should be return on api call failure', () async {
      final getNetWorthReport = MockGetNetWorthReport();

      when(getNetWorthReport(const NetWorthReportParams()))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result = await getNetWorthReport(const NetWorthReportParams());

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });
  });
}
