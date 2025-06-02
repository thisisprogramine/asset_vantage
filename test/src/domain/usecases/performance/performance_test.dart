import 'package:asset_vantage/src/data/models/performance/performance_grouping_model.dart';
import 'package:asset_vantage/src/data/models/performance/performance_report_model.dart';
import 'package:asset_vantage/src/data/models/performance/performance_sort_by_model.dart';
import 'package:asset_vantage/src/data/models/performance/performance_top_item_model.dart';
import 'package:asset_vantage/src/domain/entities/app_error.dart';
import 'package:asset_vantage/src/domain/entities/performance/performance_chart_data.dart';
import 'package:asset_vantage/src/domain/entities/performance/performance_grouping_entity.dart';
import 'package:asset_vantage/src/domain/entities/performance/performance_report_entity.dart';
import 'package:asset_vantage/src/domain/entities/performance/sort_by_entity.dart';
import 'package:asset_vantage/src/domain/entities/performance/top_item_entity.dart';
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:asset_vantage/src/domain/params/performance/performance_report_params.dart';
import 'package:asset_vantage/src/domain/usecases/performance/get_performance_grouping.dart';
import 'package:asset_vantage/src/domain/usecases/performance/get_performance_report.dart';
import 'package:asset_vantage/src/domain/usecases/performance/get_performance_sort_by.dart';
import 'package:asset_vantage/src/domain/usecases/performance/get_performance_top_items.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'performance_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<GetPerformanceGrouping>()])
@GenerateMocks([], customMocks: [MockSpec<GetPerformanceSortBy>()])
@GenerateMocks([], customMocks: [MockSpec<GetPerformanceTopItems>()])
@GenerateMocks([], customMocks: [MockSpec<GetPerformanceReport>()])
void main() async {
  group('Notifications test', () {
    test('PerformanceGroupingEntity should be return on success api call',
        () async {
      final getPerformanceGrouping = MockGetPerformanceGrouping();

      when(getPerformanceGrouping(NoParams())).thenAnswer((_) async =>
          Right(PerformanceGroupingEntity(grouping: [GroupingEntity()])));

      final result = await getPerformanceGrouping(NoParams());

      PerformanceReportModel.fromJson({});
      // PerformanceReportModel().toJson();
      PerformanceReport.fromJson({});
      PerformanceReport().toJson();
      const PerformanceChartData(title: '', value: 0.0, returnPercent: 0.0);
      PerformancePrimaryGroupingModel.fromJson({});
      // PerformanceGroupingModel().toJson();
      PrimaryGrouping.fromJson({});
      const PrimaryGrouping().toJson();
      result.fold((error) {
        expect(error, isA<PerformanceGroupingEntity>());
      }, (response) {
        expect(response, isA<PerformanceGroupingEntity>());
      });
    });

    test('AppError should be return on api call failure', () async {
      final getPerformanceGrouping = MockGetPerformanceGrouping();

      when(getPerformanceGrouping(NoParams()))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result = await getPerformanceGrouping(NoParams());

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });

    test('SortByEntity should be return on success api call', () async {
      final getPerformanceSortBy = MockGetPerformanceSortBy();

      when(getPerformanceSortBy(NoParams())).thenAnswer((_) async =>
          Right(SortByEntity(sortList: [Sort(id: '', name: '', key: '')])));

      final result = await getPerformanceSortBy(NoParams());
      SortByModel.fromJson(const {});
      SortBy.fromJson({});
      // SortByModel().toJson();
      SortBy().toJson();
      result.fold((error) {
        expect(error, isA<SortByEntity>());
      }, (response) {
        response.props;
        expect(response, isA<SortByEntity>());
      });
    });

    test('AppError should be return on api call failure', () async {
      final getPerformanceSortBy = MockGetPerformanceSortBy();

      when(getPerformanceSortBy(NoParams()))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result = await getPerformanceSortBy(NoParams());

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });

    test('TopItemEntity should be return on success api call', () async {
      final getPerformanceTopItems = MockGetPerformanceTopItems();

      when(getPerformanceTopItems(NoParams()))
          .thenAnswer((_) async => Right(TopItemEntity(topItemList: [Item()])));

      final result = await getPerformanceTopItems(NoParams());
      TopItemModel.fromJson(const {});
      // TopItemModel().toJson();
      TopItem.fromJson({});
      TopItem().toJson();
      result.fold((error) {
        expect(error, isA<TopItemEntity>());
      }, (response) {
        response.props;
        expect(response, isA<TopItemEntity>());
      });
    });

    test('AppError should be return on api call failure', () async {
      final getPerformanceTopItems = MockGetPerformanceTopItems();

      when(getPerformanceTopItems(NoParams()))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result = await getPerformanceTopItems(NoParams());

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });

    test('PerformanceReportEntity should be return on success api call',
        () async {
      final getPerformanceReport = MockGetPerformanceReport();

      when(getPerformanceReport(const PerformanceReportParams())).thenAnswer(
          (_) async => const Right(
              PerformanceReportEntity(report: [PerformanceReportData()])));

      final result =
          await getPerformanceReport(const PerformanceReportParams());

      PerformanceReportParams().toJson();

      result.fold((error) {
        expect(error, isA<PerformanceReportEntity>());
      }, (response) {
        response.props;
        response.report.first.props;
        expect(response, isA<PerformanceReportEntity>());
      });
    });

    test('AppError should be return on api call failure', () async {
      final getPerformanceReport = MockGetPerformanceReport();

      when(getPerformanceReport(const PerformanceReportParams()))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result =
          await getPerformanceReport(const PerformanceReportParams());

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });
  });
}
