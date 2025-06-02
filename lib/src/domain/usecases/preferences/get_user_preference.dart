import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:dartz/dartz.dart';

import '../../../data/models/preferences/user_preference.dart';
import '../../entities/app_error.dart';
import '../../repositories/app_repository.dart';
import '../usecase.dart';

class GetUserPreference extends UseCase<UserPreference, NoParams> {
  final AppRepository _appRepository;

  GetUserPreference(this._appRepository);

  @override
  Future<Either<AppError, UserPreference>> call(NoParams params) async =>
      _appRepository.getUserPreference();
}
