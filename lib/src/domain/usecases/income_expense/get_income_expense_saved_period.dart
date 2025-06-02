
import 'package:asset_vantage/src/domain/entities/income_expense/income_expense_number_of_period_entity.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../params/income/income_expense_get_filter_params.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetIncExpSavedPeriod extends UseCase<NumberOfPeriodItemData?, GetIncExpFilterParams> {
  final AVRepository _avRepository;

  GetIncExpSavedPeriod(this._avRepository);

  @override
  Future<Either<AppError, NumberOfPeriodItemData?>> call(GetIncExpFilterParams params) async =>
      _avRepository.getSavedIncomeOrExpensePeriod(entityName: params.entityName, grouping: params.grouping);
}
