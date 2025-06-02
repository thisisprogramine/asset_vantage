
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../../entities/app_error.dart';
import '../../entities/income_expense/income_expense_period_entity.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetIncomeExpensePeriod extends UseCase<IncomeExpensePeriodEntity, BuildContext> {
  final AVRepository _avRepository;

  GetIncomeExpensePeriod(this._avRepository);

  @override
  Future<Either<AppError, IncomeExpensePeriodEntity>> call(BuildContext context) async =>
      _avRepository.getIncomeExpensePeriod(context: context, requestBody: {});
}
