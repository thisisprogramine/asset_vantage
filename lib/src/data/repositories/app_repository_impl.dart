import 'package:asset_vantage/src/data/models/preferences/user_preference.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/app_error.dart';
import '../../domain/repositories/app_repository.dart';
import '../datasource/local/app_local_datasource.dart';

class AppRepositoryImpl extends AppRepository {
  final AppLocalDataSource _appLocalDataSource;

  AppRepositoryImpl(this._appLocalDataSource);

  @override
  Future<Either<AppError, UserPreference>> getUserPreference() async{
    try {
      final response = await _appLocalDataSource.getUserPreference();
      return Right(response);
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, void>> saveUserPreference({required UserPreference preference}) async{
    try {
      final response = await _appLocalDataSource.saveUserPreference(preference: preference);
      return Right(response);
    } on Exception {
      return const Left(AppError(AppErrorType.database));
    }
  }

}
