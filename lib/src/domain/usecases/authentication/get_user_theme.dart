import 'package:asset_vantage/src/data/models/preferences/app_theme.dart';
import 'package:asset_vantage/src/domain/repositories/av_repository.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../params/preference/app_theme_params.dart';
import '../usecase.dart';

class GetUserTheme extends UseCase<AppThemeModel, AppThemeParams> {
  final AVRepository _avRepository;

  GetUserTheme(this._avRepository);

  @override
  Future<Either<AppError, AppThemeModel>> call(AppThemeParams params) async =>
      _avRepository.getUserTheme(context: params.context, requestBody: params.toJson());
}
