import 'package:asset_vantage/src/domain/params/authentication/reset_password_params.dart';
import 'package:asset_vantage/src/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

import '../../../data/models/authentication/token.dart';
import '../../entities/app_error.dart';
import '../../repositories/authentication_repository.dart';

class ResetPassword extends UseCase<Token, ResetPasswordParams> {
  final AuthenticationRepository _authenticationRepository;

  ResetPassword(this._authenticationRepository);

  @override
  Future<Either<AppError, Token>> call(ResetPasswordParams params) async =>
      _authenticationRepository.resetPassword(params: params.toJson());
}