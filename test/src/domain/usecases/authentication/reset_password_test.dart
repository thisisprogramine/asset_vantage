
import 'package:asset_vantage/src/data/models/authentication/token.dart';
import 'package:asset_vantage/src/domain/entities/app_error.dart';
import 'package:asset_vantage/src/domain/params/authentication/reset_password_params.dart';
import 'package:asset_vantage/src/domain/params/authentication/verify_otp_params.dart';
import 'package:asset_vantage/src/domain/usecases/authentication/reset_password.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'reset_password_test.mocks.dart';

@GenerateMocks([],
    customMocks: [MockSpec<ResetPassword>()])
void main() async {

  group('Reset Password test', () {

    test('Token should be return on success reset password', () async {

      final resetPassword = MockResetPassword();

      when(resetPassword(const ResetPasswordParams(username: '', newpassword: '', awssession: '', challenge: '', systemName: ''))).thenAnswer((_) async => Right(Token()));

      final result = await resetPassword(const ResetPasswordParams(username: '', newpassword: '', awssession: '', challenge: '', systemName: ''));
      const ResetPasswordParams(username: '', newpassword: '', awssession: '', challenge: '', systemName: '').toJson();
      result.fold((error) {
        expect(error, isA<Token>());
      }, (response) {
        response.toJson();
        expect(response, isA<Token>());
      });

    });

    test('AppError should be return on reset password failed', () async {

      final resetPassword = MockResetPassword();

      when(resetPassword(const ResetPasswordParams(username: '', newpassword: '', awssession: '', challenge: '', systemName: ''))).thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result = await resetPassword(const ResetPasswordParams(username: '', newpassword: '', awssession: '', challenge: '', systemName: ''));

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        response.toJson();
        expect(response, isA<AppError>());
      });

    });

  });
}