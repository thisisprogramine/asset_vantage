
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../params/income/income_expense_get_filter_params.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetIncExpSavedAccounts extends UseCase<List<Map>?, GetIncExpFilterParams> {
  final AVRepository _avRepository;

  GetIncExpSavedAccounts(this._avRepository);

  @override
  Future<Either<AppError, List<Map>?>> call(GetIncExpFilterParams params) async =>
      _avRepository.getSavedIncomeOrExpenseAccount(entityName: params.entityName, grouping: params.grouping,);
}
