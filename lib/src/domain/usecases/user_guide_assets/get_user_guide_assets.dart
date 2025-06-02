

import 'package:asset_vantage/src/domain/entities/user_guide_assets/user_guide_assets_entity.dart';
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetUserGuideAssets extends UseCase<UserGuideAssetsEntity, NoParams> {
  final AVRepository _avRepository;

  GetUserGuideAssets(this._avRepository);

  @override
  Future<Either<AppError, UserGuideAssetsEntity>> call(NoParams noParams) async =>
      _avRepository.getUserGuideAssets(requestBody: {});
}
