
import 'package:asset_vantage/src/domain/entities/favorites/favorites_sequence_enitity.dart';
import 'package:asset_vantage/src/domain/params/favorites/favorites_sequence_params.dart';
import 'package:dartz/dartz.dart';
import '../../entities/app_error.dart';
import '../../params/favorites/favorites_params.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class FavoritesSequenceReport extends UseCase<FavoritesSequenceEntity, FavoritesSequenceParams> {
  final AVRepository _avRepository;

  FavoritesSequenceReport(this._avRepository);

  @override
  Future<Either<AppError, FavoritesSequenceEntity>> call(FavoritesSequenceParams params) async =>
      await _avRepository.favoriteSequence(context: params.context, requestBody: params.toJson());
}