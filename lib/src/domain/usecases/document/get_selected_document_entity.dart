//TODO:: add new file


import 'package:asset_vantage/src/domain/entities/dashboard/dashboard_list_entity.dart';
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetSelectedDocumentEntity extends UseCase<EntityData?, NoParams> {
  final AVRepository _avRepository;

  GetSelectedDocumentEntity(this._avRepository);

  @override
  Future<Either<AppError, EntityData?>> call(NoParams params) async =>
      _avRepository.getSelectedDocumentEntity();
}
