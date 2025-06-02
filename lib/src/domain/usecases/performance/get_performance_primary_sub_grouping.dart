
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:asset_vantage/src/domain/params/performance/performance_primary_sub_grouping_param.dart';
import 'package:dartz/dartz.dart';

import '../../../../main.dart';
import '../../entities/app_error.dart';
import '../../entities/performance/performance_primary_sub_grouping_enity.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetPerformancePrimarySubGrouping extends UseCase<PerformancePrimarySubGroupingEntity, PerformancePrimarySubGroupingParam> {
  final AVRepository _avRepository;

  GetPerformancePrimarySubGrouping(this._avRepository);

  @override
  Future<Either<AppError, PerformancePrimarySubGroupingEntity>> call(PerformancePrimarySubGroupingParam params) async =>
      await perResponseQueue.add(() async=> await _avRepository.getPerformancePrimarySubGrouping(context: params.context, requestBody: params.toJson()));
}