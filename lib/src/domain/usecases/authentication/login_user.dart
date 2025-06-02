import 'package:dartz/dartz.dart';

import '../../../data/models/authentication/token.dart';
import '../../entities/app_error.dart';
import '../../params/authentication/login_request_params.dart';
import '../../repositories/authentication_repository.dart';
import '../usecase.dart';

class LoginUser extends UseCase<Token, LoginRequestParams> {
  final AuthenticationRepository _authenticationRepository;

  LoginUser(this._authenticationRepository);

  @override
  Future<Either<AppError, Token>> call(LoginRequestParams params) async =>
      _authenticationRepository.loginUser(params: params.toJson());
}
