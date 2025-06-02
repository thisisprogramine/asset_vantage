
import 'package:asset_vantage/src/domain/entities/authentication/forgot_password_entity.dart';
import 'package:dartz/dartz.dart';

import '../../data/models/authentication/credentials.dart';
import '../../data/models/authentication/token.dart';
import '../entities/app_error.dart';

abstract class AuthenticationRepository {
  Future<Either<AppError, ForgotPasswordEntity>> forgotPassword({required String email});
  Future<Either<AppError, Token>> loginUser({required Map<String, String> params});
  Future<Either<AppError, void>> logoutUser();
  Future<Either<AppError, Token>> resetPassword({required Map<String, dynamic> params});
  Future<Either<AppError, Token>> verifyOtp({required Map<String, dynamic> params});
  Future<Credentials> getCredential();
  Future<void> saveCredential({required Map<dynamic, dynamic> credentials});

}
