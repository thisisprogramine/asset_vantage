import 'dart:ffi';

import 'package:asset_vantage/src/data/models/preferences/app_theme.dart';
import 'package:asset_vantage/src/data/models/preferences/user_preference.dart';
import 'package:asset_vantage/src/domain/entities/app_error.dart';
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:asset_vantage/src/domain/params/preference/app_theme_params.dart';
import 'package:asset_vantage/src/domain/params/preference/user_preference_params.dart';
import 'package:asset_vantage/src/domain/usecases/preferences/get_user_preference.dart';
import 'package:asset_vantage/src/domain/usecases/preferences/save_user_preference.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_preference_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<GetUserPreference>()])
@GenerateMocks([], customMocks: [MockSpec<SaveUserPreference>()])
void main() async {
  group('User Preference test', () {
    test('UserPreference should be return on success api call', () async {
      final getUserPreference = MockGetUserPreference();

      when(getUserPreference(NoParams()))
          .thenAnswer((_) async => const Right(UserPreference()));

      final result = await getUserPreference(NoParams());

      result.fold((error) {
        expect(error, isA<UserPreference>());
      }, (response) {
        UserPreference.fromJson({});
        response.toJson();
        response.copyWith();
        expect(response, isA<UserPreference>());
      });
    });

    test('AppError should be return on api call failure', () async {
      final getUserPreference = MockGetUserPreference();

      when(getUserPreference(NoParams()))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result = await getUserPreference(NoParams());
      UserPreference.fromJson({});
      // const UserPreference().toJson();
      result.fold((error) {
        error.props;
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });

    test('void should be return on success api call', () async {
      final saveUserPreference = MockSaveUserPreference();

      when(saveUserPreference(
              const UserPreferenceParams(preference: UserPreference())))
          .thenAnswer((_) async => const Right(Void));

      final result = await saveUserPreference(
          const UserPreferenceParams(preference: UserPreference()));
      AppThemeModel.fromJson({});
      AppThemeModel().toJson();
      // const UserPreferenceParams(preference: UserPreference()).toJson();
      const UserPreferenceParams(preference: UserPreference())..props..toJson();
      AppThemeParams(index: 0).toJson();
      result.fold((error) {
        expect(error, isA<void>());
      }, (response) {
        expect(Void, isA<void>());
      });
    });

    test('AppError should be return on api call failure', () async {
      final saveUserPreference = MockSaveUserPreference();

      when(saveUserPreference(
              const UserPreferenceParams(preference: UserPreference())))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result = await saveUserPreference(
          const UserPreferenceParams(preference: UserPreference()));

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(Void, isA<AppError>());
      });
    });
  });
}
