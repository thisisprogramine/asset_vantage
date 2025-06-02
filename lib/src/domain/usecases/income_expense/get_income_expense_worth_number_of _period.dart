

import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../../entities/app_error.dart';
import '../../entities/income_expense/income_expense_number_of_period_entity.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetIncomeExpenseNumberOfPeriod extends UseCase<IncomeExpenseNumberOfPeriodEntity, BuildContext> {
  final AVRepository _avRepository;

  GetIncomeExpenseNumberOfPeriod(this._avRepository);

  @override
  Future<Either<AppError, IncomeExpenseNumberOfPeriodEntity>> call(BuildContext context) async =>
      _avRepository.getIncomeExpenseNumberOfPeriod(context: context, requestBody: {});
}
