

import 'package:asset_vantage/main.dart';
import 'package:asset_vantage/src/domain/params/income/income_report_params.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../entities/income/income_report_entity.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetIncomeReport extends UseCase<IncomeReportEntity, IncomeReportParams> {
  final AVRepository _avRepository;

  GetIncomeReport(this._avRepository);

  @override
  Future<Either<AppError, IncomeReportEntity>> call(IncomeReportParams params) async =>
      await ieResponseQueue.add(() async=> await _avRepository.getIncomeReport(context: params.context, requestBody: params.toJson()));
}
