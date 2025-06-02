
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:dartz/dartz.dart';

import '../../../../main.dart';
import '../../entities/app_error.dart';
import '../../entities/performance/performance_primary_grouping_entity.dart';
import '../../params/performance/performance_primary_grouping_param.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetPerformancePrimaryGrouping extends UseCase<PerformancePrimaryGroupingEntity, PerformancePrimaryGroupingParam> {
  final AVRepository _avRepository;

  GetPerformancePrimaryGrouping(this._avRepository);

  @override
  Future<Either<AppError, PerformancePrimaryGroupingEntity>> call(PerformancePrimaryGroupingParam params) async =>
      await perResponseQueue.add(() async=> await _avRepository.getPerformancePrimaryGrouping(context: params.context, requestBody: params.toJson()));
}