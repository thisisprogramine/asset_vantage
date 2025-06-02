import 'dart:async';
import 'dart:io';

import 'package:asset_vantage/src/core/api_constants.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/app_error.dart';
import '../../domain/entities/authentication/user_entity.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../datasource/local/app_local_datasource.dart';
import '../datasource/local/authentication_local_datasouce.dart';
import '../datasource/remote/authentication_remote_datasource.dart';
import '../models/authentication/credentials.dart';
import '../models/authentication/forgot_password_model.dart';
import '../models/authentication/token.dart';
import '../models/preferences/user_preference.dart';

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final AppLocalDataSource _appLocalDataSource;
  final AuthenticationRemoteDataSource _authenticationRemoteDataSource;
  final AuthenticationLocalDataSource _authenticationLocalDataSource;

  AuthenticationRepositoryImpl(
    this._appLocalDataSource,
    this._authenticationRemoteDataSource,
    this._authenticationLocalDataSource,
  );

  @override
  Future<Either<AppError, ForgotPasswordModel>> forgotPassword({required String email}) async {
    try {
      final response = await _authenticationRemoteDataSource.forgotPassword(email: email);

      return Right(response);
    } on SocketException {
      return const Left(AppError(AppErrorType.network));
    } on Exception {
      return const Left(AppError(AppErrorType.api));
    }
  }

  @override
  Future<Credentials> getCredential() async {
    final response = await _authenticationLocalDataSource.getCredential();
    return response;
  }

  @override
  Future<void> saveCredential({required Map<dynamic, dynamic> credentials}) async {
    final response = await _authenticationLocalDataSource.saveCredential(credentials: credentials);
  }

  @override
  Future<Either<AppError, Token>> loginUser({required Map<String, String> params}) async {
    try {
      await _appLocalDataSource.saveUserPreference(preference: const UserPreference(regionUrl: 'base_login'));
      final response = await _authenticationRemoteDataSource.loginUser(params: params);
      if(ApiConstants.isProd) {
        switch(response.region) {
          case 'prod-us':
            await _appLocalDataSource.saveUserPreference(preference: const UserPreference(regionUrl: 'base_us'));
          break;
          case 'prod-ind':
            await _appLocalDataSource.saveUserPreference(preference: const UserPreference(regionUrl: 'base_ind'));
          break;
          case 'prod-sgt':
            await _appLocalDataSource.saveUserPreference(preference: const UserPreference(regionUrl: 'base_sgt'));
          break;
          case 'uat-us':
            await _appLocalDataSource.saveUserPreference(preference: const UserPreference(regionUrl: 'base_uat_us'));
          break;
          case 'uat-ind':
            await _appLocalDataSource.saveUserPreference(preference: const UserPreference(regionUrl: 'base_uat_ind'));
          break;
          case 'dev-poc':
            await _appLocalDataSource.saveUserPreference(preference: const UserPreference(regionUrl: 'base_dev_poc'));
          break;
          case 'dev-insight':
            await _appLocalDataSource.saveUserPreference(preference: const UserPreference(regionUrl: 'base_dev_insight'));
          break;
          case 'dev-qa':
            await _appLocalDataSource.saveUserPreference(preference: const UserPreference(regionUrl: 'base_dev_qa'));
          break;
          case 'dev-sso':
            await _appLocalDataSource.saveUserPreference(preference: const UserPreference(regionUrl: 'base_dev_sso'));
          break;
          default:
            await _appLocalDataSource.saveUserPreference(preference: const UserPreference(regionUrl: 'base_dev_poc'));
          break;
        }
      }
      return Right(response);
    } on SocketException {
      return const Left(AppError(AppErrorType.network));
    } on Exception {
      return const Left(AppError(AppErrorType.api));
    }
  }

  @override
  Future<Either<AppError, void>> logoutUser() async {
    try {
      final user = await _appLocalDataSource.getUserPreference();
      final username = user.username;
      final systemName = user.systemName;
      await _appLocalDataSource.saveUserPreference(preference: UserPreference(
        loginStatus: false,
        isFirstOpen: user.isFirstOpen,
        user: null,
        credential: user.credential,
        username: user.username,
        password: user.password,
        systemName: user.systemName,
      ), shouldClear: true);
      final response = await _authenticationLocalDataSource.clear(systemName: systemName ?? '', username: username ?? '');
      return Right(response);
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, Token>> resetPassword({required Map<String, dynamic> params}) async {
    try {
      final response = await _authenticationRemoteDataSource.resetPassword(
          params: params);
      return Right(response);
    } on SocketException {
      return const Left(AppError(AppErrorType.network));
    } on Exception {
      return const Left(AppError(AppErrorType.api));
    }
  }

  @override
  Future<Either<AppError, Token>> verifyOtp({required Map<String, dynamic> params}) async {
    try {
      await _appLocalDataSource.saveUserPreference(preference: const UserPreference(regionUrl: 'base_login'));
      final response = await _authenticationRemoteDataSource.verifyOtp(params: params);
      if(ApiConstants.isProd) {
        switch(response.region) {
          case 'prod-us':
            await _appLocalDataSource.saveUserPreference(preference: const UserPreference(regionUrl: 'base_us'));
            break;
          case 'prod-ind':
            await _appLocalDataSource.saveUserPreference(preference: const UserPreference(regionUrl: 'base_ind'));
            break;
          case 'prod-sgt':
            await _appLocalDataSource.saveUserPreference(preference: const UserPreference(regionUrl: 'base_sgt'));
            break;
          case 'uat-us':
            await _appLocalDataSource.saveUserPreference(preference: const UserPreference(regionUrl: 'base_uat_us'));
            break;
          case 'uat-ind':
            await _appLocalDataSource.saveUserPreference(preference: const UserPreference(regionUrl: 'base_uat_ind'));
            break;
          case 'dev-poc':
            await _appLocalDataSource.saveUserPreference(preference: const UserPreference(regionUrl: 'base_dev_poc'));
            break;
          case 'dev-insight':
            await _appLocalDataSource.saveUserPreference(preference: const UserPreference(regionUrl: 'base_dev_insight'));
            break;
          case 'dev-qa':
            await _appLocalDataSource.saveUserPreference(preference: const UserPreference(regionUrl: 'base_dev_qa'));
            break;
          case 'dev-sso':
            await _appLocalDataSource.saveUserPreference(preference: const UserPreference(regionUrl: 'base_dev_sso'));
          break;
          default:
            await _appLocalDataSource.saveUserPreference(preference: const UserPreference(regionUrl: 'base_dev_poc'));
            break;
        }
      }
      return Right(response);
    } on SocketException {
      return const Left(AppError(AppErrorType.network));
    } on Exception {
      return const Left(AppError(AppErrorType.api));
    }
  }
}
