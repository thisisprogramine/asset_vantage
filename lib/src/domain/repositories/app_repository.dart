import 'package:dartz/dartz.dart';
import '../../data/models/preferences/user_preference.dart';
import '../entities/app_error.dart';

abstract class AppRepository {

  Future<Either<AppError, UserPreference>> getUserPreference();
  Future<Either<AppError, void>> saveUserPreference({required UserPreference preference});
}
