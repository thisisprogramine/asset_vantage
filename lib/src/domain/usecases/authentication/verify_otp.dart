import 'package:asset_vantage/src/domain/entities/app_error.dart';
import 'package:asset_vantage/src/domain/repositories/authentication_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../data/models/authentication/token.dart';
import '../../params/authentication/verify_otp_params.dart';
import '../usecase.dart';

class VerifyOtp extends UseCase<Token, VerifyOtpParams> {
  final AuthenticationRepository _authenticationRepository;

  VerifyOtp(this._authenticationRepository);

  @override
  Future<Either<AppError, Token>> call(VerifyOtpParams params) async => _authenticationRepository.verifyOtp(params: params.toJson());
}