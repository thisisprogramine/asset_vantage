import 'package:asset_vantage/src/domain/entities/authentication/forgot_password_entity.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../params/authentication/forget_password_params.dart';
import '../../repositories/authentication_repository.dart';
import '../usecase.dart';

class ForgotPassword extends UseCase<ForgotPasswordEntity, ForgetPasswordParams> {
  final AuthenticationRepository _authenticationRepository;

  ForgotPassword(this._authenticationRepository);

  @override
  Future<Either<AppError, ForgotPasswordEntity>> call(ForgetPasswordParams params) async =>
      _authenticationRepository.forgotPassword(email: params.email);
}
