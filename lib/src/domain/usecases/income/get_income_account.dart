
import 'package:asset_vantage/main.dart';
import 'package:asset_vantage/src/domain/params/income/income_account_params.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../entities/income/income_account_entity.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetIncomeAccount extends UseCase<IncomeAccountEntity, IncomeAccountParams> {
  final AVRepository _avRepository;

  GetIncomeAccount(this._avRepository);

  @override
  Future<Either<AppError, IncomeAccountEntity>> call(IncomeAccountParams params) async =>
      await ieResponseQueue.add(() => _avRepository.getIncomeReportPeriod(context: params.context, requestBody: params.toJson()));
}
