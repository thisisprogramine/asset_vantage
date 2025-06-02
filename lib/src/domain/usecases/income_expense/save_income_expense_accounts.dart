

import 'package:asset_vantage/src/domain/params/income/income_expense_save_filter_params.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class SaveSelectedIncExpAccounts extends UseCase<void, SaveIncExpFilterParams> {
  final AVRepository _avRepository;

  SaveSelectedIncExpAccounts(this._avRepository);

  @override
  Future<Either<AppError, void>> call(SaveIncExpFilterParams params) async =>
      _avRepository.saveSelectedIncomeOrExpenseAccount(entityName: params.entityName, grouping: params.grouping, item: params.filter as List<Object>?);
}
