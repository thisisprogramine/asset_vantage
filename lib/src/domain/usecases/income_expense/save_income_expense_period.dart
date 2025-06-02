

import 'package:asset_vantage/src/domain/entities/income_expense/income_expense_number_of_period_entity.dart';
import 'package:asset_vantage/src/domain/params/income/income_expense_save_filter_params.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class SaveSelectedIncExpPeriod extends UseCase<void, SaveIncExpFilterParams> {
  final AVRepository _avRepository;

  SaveSelectedIncExpPeriod(this._avRepository);

  @override
  Future<Either<AppError, void>> call(SaveIncExpFilterParams params) async =>
      _avRepository.saveSelectedIncomeOrExpensePeriod(entityName: params.entityName, grouping: params.grouping, item: params.filter as NumberOfPeriodItemData?);
}
