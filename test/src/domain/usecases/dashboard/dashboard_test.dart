import 'package:asset_vantage/src/data/models/dashboard/dashboard_entity_model.dart';
import 'package:asset_vantage/src/data/models/dashboard/dashboard_widget_model.dart';
import 'package:asset_vantage/src/domain/entities/app_error.dart';
import 'package:asset_vantage/src/domain/entities/dashboard/dashboard_list_entity.dart';
import 'package:asset_vantage/src/domain/entities/dashboard/dashboard_widget_entity.dart';
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:asset_vantage/src/domain/usecases/dashboard/get_dashboard_entity_list.dart';
import 'package:asset_vantage/src/domain/usecases/dashboard/get_dashboard_widgets.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'dashboard_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<GetDashboardWidgetData>()])
@GenerateMocks([], customMocks: [MockSpec<GetDashboardEntityListData>()])
void main() async {
  group('Dashboard test', () {
    test('WidgetListEntity should be return on success api call', () async {
      final getDashboardWidgetData = MockGetDashboardWidgetData();

      when(getDashboardWidgetData(NoParams())).thenAnswer(
          (_) async => Right(WidgetListEntity(widgetData: [WidgetData()])));

      final result = await getDashboardWidgetData(NoParams());
      WidgetListModel.fromJson({});
      // WidgetListModel().toJson();
      Data.fromJson({});
      Data().toJson();
      result.fold((error) {
        expect(error, isA<WidgetListEntity>());
      }, (response) {
        expect(response, isA<WidgetListEntity>());
      });
    });

    test('AppError should be return on api call failure', () async {
      final getDashboardWidgetData = MockGetDashboardWidgetData();

      when(getDashboardWidgetData(NoParams()))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result = await getDashboardWidgetData(NoParams());

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });

    test('DashboardEntity should be return on success api call', () async {
      final getDashboardEntityListData = MockGetDashboardEntityListData();

      when(getDashboardEntityListData(NoParams())).thenAnswer(
          (_) async => Right(DashboardEntity(list: [EntityData()])));

      final result = await getDashboardEntityListData(NoParams());
      DashboardEntityModel.fromJson({});
      // DashboardEntityModel().toJson();
      Entity.fromJson({});
      Entity().toJson();
      result.fold((error) {
        expect(error, isA<DashboardEntity>());
      }, (response) {
        expect(response, isA<DashboardEntity>());
      });
    });

    test('AppError should be return on api call failure', () async {
      final getDashboardEntityListData = MockGetDashboardEntityListData();

      when(getDashboardEntityListData(NoParams()))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result = await getDashboardEntityListData(NoParams());

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });
  });
}
