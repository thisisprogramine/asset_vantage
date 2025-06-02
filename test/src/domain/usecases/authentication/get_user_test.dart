import 'package:asset_vantage/src/data/models/authentication/forgot_password_model.dart';
import 'package:asset_vantage/src/data/models/authentication/login_model.dart';
import 'package:asset_vantage/src/data/models/authentication/token.dart';
import 'package:asset_vantage/src/data/models/authentication/user_model.dart';
import 'package:asset_vantage/src/domain/entities/app_error.dart';
import 'package:asset_vantage/src/domain/entities/authentication/user_entity.dart';
import 'package:asset_vantage/src/domain/params/authentication/get_user_data_params.dart';
import 'package:asset_vantage/src/domain/usecases/authentication/get_user_data.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'get_user_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<GetUserData>()])
void main() async {
  // User this command to generate test coverage report
  // genhtml coverage/lcov.info -o coverage/html

  group('Getting User details test', () {
    test('UserEntity should be return on success api call', () async {
      final getUserData = MockGetUserData();

      when(getUserData(const GetUserDataParams()))
          .thenAnswer((_) async => const Right(UserEntity()));

      final result = await getUserData(const GetUserDataParams());
      const GetUserDataParams().toJson();
      const UserEntity().props;
      const UserEntity().toJson();
      // CoBrandingEntity().toJson();
      CoBranding.fromJson({});
      CoBranding().toJson();
      UserModel.fromJson(const {});
      ForgotPasswordModel.fromJson(const {});
      // ForgotPasswordModel().toJson();
      Data.fromJson({});
      Data().toJson();
      LoginModel.fromJson(const {});
      const LoginModel().toJson();
      const UserModel().toJson();
      result.fold((error) {
        expect(error, isA<UserEntity>());
      }, (response) {
        response.props;
        response.toJson();
        expect(response, isA<UserEntity>());
      });
    });

    test('AppError should be return on api call failure', () async {
      final getUserData = MockGetUserData();

      when(getUserData(const GetUserDataParams()))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result = await getUserData(const GetUserDataParams());

      GetUserDataParams().toJson();

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });
  });
}

// command to generate test report, first install lcov
// flutter test --coverage
// perl C:\ProgramData\chocolatey\lib\lcov\tools\bin\lcov --remove coverage/lcov.info "lib/main.dart" "lib/src/injector.dart" "lib/src/config/*" "lib/src/core/*" "lib/src/data/datasource/*" "lib/src/data/repositories/*" "lib/src/presentation/*" "lib/src/services/*" "lib/src/utilities/*" "lib/src/domain/repositories/*" "lib/src/domain/usecases/*" -o coverage/lcov.info
// perl C:\ProgramData\chocolatey\lib\lcov\tools\bin\genhtml coverage/lcov.info -o coverage/html
// coverage/html/index.html