
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:asset_vantage/src/domain/params/performance/performance_secondary_sub_grouping_param.dart';
import 'package:dartz/dartz.dart';

import '../../../../main.dart';
import '../../entities/app_error.dart';
import '../../entities/performance/performance_secondary_sub_grouping_enity.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetPerformanceSecondarySubGrouping extends UseCase<PerformanceSecondarySubGroupingEntity, PerformanceSecondarySubGroupingParam> {
  final AVRepository _avRepository;

  GetPerformanceSecondarySubGrouping(this._avRepository);

  @override
  Future<Either<AppError, PerformanceSecondarySubGroupingEntity>> call(PerformanceSecondarySubGroupingParam params) async =>
      await perResponseQueue.add(() async=> await _avRepository.getPerformanceSecondarySubGrouping(context: params.context, requestBody: params.toJson()));
}