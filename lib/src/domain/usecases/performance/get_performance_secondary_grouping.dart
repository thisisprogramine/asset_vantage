
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:dartz/dartz.dart';

import '../../../../main.dart';
import '../../entities/app_error.dart';
import '../../entities/performance/performance_secondary_grouping_entity.dart';
import '../../params/performance/performance_secondary_grouping_param.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetPerformanceSecondaryGrouping extends UseCase<PerformanceSecondaryGroupingEntity, PerformanceSecondaryGroupingParam> {
  final AVRepository _avRepository;

  GetPerformanceSecondaryGrouping(this._avRepository);

  @override
  Future<Either<AppError, PerformanceSecondaryGroupingEntity>> call(PerformanceSecondaryGroupingParam params) async =>
      await perResponseQueue.add(() async=> await _avRepository.getPerformanceSecondaryGrouping(context: params.context, requestBody: params.toJson()));
}