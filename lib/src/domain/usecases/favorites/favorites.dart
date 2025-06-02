
import 'package:asset_vantage/src/domain/entities/favorites/favorites_entity.dart';
import 'package:dartz/dartz.dart';
import '../../entities/app_error.dart';
import '../../params/favorites/favorites_params.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class FavoritesReport extends UseCase<FavoritesEntity, FavoritesParams> {
  final AVRepository _avRepository;

  FavoritesReport(this._avRepository);

  @override
  Future<Either<AppError, FavoritesEntity>> call(FavoritesParams params) async =>
      await _avRepository.favoriteReport(context: params.context, requestBody: params.toJson());
}