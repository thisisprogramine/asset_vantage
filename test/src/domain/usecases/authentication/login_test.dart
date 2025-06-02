import 'package:asset_vantage/src/config/validators/login_validators.dart';
import 'package:asset_vantage/src/data/models/authentication/token.dart';
import 'package:asset_vantage/src/domain/entities/app_error.dart';
import 'package:asset_vantage/src/domain/entities/authentication/asw_conginto_error.dart';
import 'package:asset_vantage/src/domain/entities/authentication/forgot_password_entity.dart';
import 'package:asset_vantage/src/domain/entities/authentication/login_entity.dart';
import 'package:asset_vantage/src/domain/params/authentication/forget_password_params.dart';
import 'package:asset_vantage/src/domain/params/authentication/login_request_params.dart';
import 'package:asset_vantage/src/domain/usecases/authentication/forgot_password.dart';
import 'package:asset_vantage/src/domain/usecases/authentication/login_user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<LoginUser>()])
void main() async {
  group('Authentication test', () {
    test('Username should not be null or empty', () async {
      var result = LoginValidators.validateUserName('username');
      expect(result, true);
    });

    test('Password should not be null or empty', () async {
      var result = LoginValidators.validatePassword('password');
      expect(result, true);
    });

    test('Client System Name should not be null or empty', () async {
      var result = LoginValidators.validateClientSystemName('system name');
      expect(result, true);
    });

    test('Token should be return on success login', () async {
      final loginUser = MockLoginUser();

      when(loginUser(const LoginRequestParams(
              username: '', password: '', systemName: '')))
          .thenAnswer((_) async => Right(Token()));

      final result = await loginUser(
          const LoginRequestParams(username: '', password: '', systemName: ''));
      AWSCognitoError.fromJson({});
      const AWSCognitoError().toJson();
      const ForgotPasswordEntity().props;
      const LoginEntity().props;
      const ForgetPasswordParams(email: "")
        ..props
        ..toJson();
      const LoginRequestParams(username: '', password: '', systemName: '').toJson();
      // const LoginRequestParams(username: '', password: '', systemName: '')
      //   ..props
      //   ..toJson();
      result.fold((error) {
        expect(error, isA<Token>());
      }, (response) {
        response.toJson();
        expect(response, isA<Token>());
      });
    });

    test('AppError should be return on login failed', () async {
      final loginUser = MockLoginUser();

      when(loginUser(const LoginRequestParams(
              username: '', password: '', systemName: '')))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result = await loginUser(
          const LoginRequestParams(username: '', password: '', systemName: ''));

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        response.toJson();
        expect(response, isA<AppError>());
      });
    });
  });
}
