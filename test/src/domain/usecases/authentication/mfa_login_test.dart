
import 'package:asset_vantage/src/data/models/authentication/token.dart';
import 'package:asset_vantage/src/domain/entities/app_error.dart';
import 'package:asset_vantage/src/domain/params/authentication/verify_otp_params.dart';
import 'package:asset_vantage/src/domain/usecases/authentication/verify_otp.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mfa_login_test.mocks.dart';

@GenerateMocks([],
    customMocks: [MockSpec<VerifyOtp>()])
void main() async {

  group('Mfa Login test', () {

    test('Token should be returned on successful mfa login', () async {

      final verifyOtp = MockVerifyOtp();

      when(verifyOtp(const VerifyOtpParams(smsmfacode: "",username: "",awssession:"" ,challenge: "",systemName: "",))).thenAnswer((_) async => Right(Token()));

      final result = await verifyOtp(const VerifyOtpParams(smsmfacode: "",username: "",awssession:"" ,challenge: "",systemName: "",));
      const VerifyOtpParams(systemName: "",challenge: "",awssession: "",username: "",smsmfacode: "").toJson();
      result.fold((error) {
        expect(error, isA<Token>());
      }, (response) {
        response.toJson();
        expect(response, isA<Token>());
      });

    });

    test('AppError should be returned on mfa login failed', () async {

      final verifyOtp = MockVerifyOtp();

      when(verifyOtp(const VerifyOtpParams(systemName: "",challenge: "",awssession: "",username: "",smsmfacode: ""))).thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result = await verifyOtp(const VerifyOtpParams(systemName: "",challenge: "",awssession: "",username: "",smsmfacode: ""));

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        response.toJson();
        expect(response, isA<AppError>());
      });

    });

  });
}