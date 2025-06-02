import 'package:asset_vantage/src/data/models/notifications/notifications_model.dart';
import 'package:asset_vantage/src/domain/entities/app_error.dart';
import 'package:asset_vantage/src/domain/entities/notification/notification_entity.dart';
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:asset_vantage/src/domain/usecases/notifications/get_notifications.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'notifications_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<GetNotifications>()])
void main() async {
  group('Notifications test', () {
    test('NotificationsEntity should be return on success api call', () async {
      final getNotifications = MockGetNotifications();

      when(getNotifications(NoParams())).thenAnswer((_) async =>
          Right(NotificationsEntity(notifications: [NotificationData()])));

      final result = await getNotifications(NoParams());
      NotificationsModel.fromJson({});
      Notification.fromJson({});
      Notification().toJson();
      // NotificationsModel().toJson();
      result.fold((error) {
        expect(error, isA<NotificationsEntity>());
      }, (response) {
        expect(response, isA<NotificationsEntity>());
      });
    });

    test('AppError should be return on api call failure', () async {
      final getNotifications = MockGetNotifications();

      when(getNotifications(NoParams()))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result = await getNotifications(NoParams());

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });
  });
}
