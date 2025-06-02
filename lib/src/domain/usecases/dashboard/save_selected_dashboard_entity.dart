//TODO:: add new file


import 'package:asset_vantage/src/domain/entities/dashboard/dashboard_list_entity.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class SaveSelectedDashboardEntity extends UseCase<void, EntityData?> {
  final AVRepository _avRepository;

  SaveSelectedDashboardEntity(this._avRepository);

  @override
  Future<Either<AppError, void>> call(EntityData? params) async =>
      _avRepository.saveSelectedDashboardEntity(entity: params);
}
