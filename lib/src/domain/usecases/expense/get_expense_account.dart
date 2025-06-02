
import 'package:asset_vantage/main.dart';
import 'package:asset_vantage/src/domain/params/expense/expense_account_params.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../entities/expense/expense_account_entity.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetExpenseAccount extends UseCase<ExpenseAccountEntity, ExpenseAccountParams> {
  final AVRepository _avRepository;

  GetExpenseAccount(this._avRepository);

  @override
  Future<Either<AppError, ExpenseAccountEntity>> call(ExpenseAccountParams params) async =>
      await ieResponseQueue.add(() => _avRepository.getExpenseReportPeriod(context: params.context, requestBody: params.toJson()));
}
