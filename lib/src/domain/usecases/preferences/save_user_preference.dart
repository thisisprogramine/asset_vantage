import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../params/preference/user_preference_params.dart';
import '../../repositories/app_repository.dart';
import '../usecase.dart';

class SaveUserPreference extends UseCase<void, UserPreferenceParams> {
  final AppRepository _appRepository;

  SaveUserPreference(this._appRepository);

  @override
  Future<Either<AppError, void>> call(UserPreferenceParams params) async =>
      _appRepository.saveUserPreference(preference: params.preference);
}
