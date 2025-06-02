import 'package:asset_vantage/main.dart';
import 'package:asset_vantage/src/domain/entities/performance/performance_report_entity.dart';
import 'package:asset_vantage/src/domain/params/performance/performance_report_params.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetPerformanceReport
    extends UseCase<PerformanceReportEntity, PerformanceReportParams> {
  final AVRepository _avRepository;

  GetPerformanceReport(this._avRepository);

  @override
  Future<Either<AppError, PerformanceReportEntity>> call(
          PerformanceReportParams params) async =>
      await perResponseQueue.add(() async =>
          await _avRepository.getPerformanceReport(
            context: params.context,
              requestBody: params.toJson()));
}
