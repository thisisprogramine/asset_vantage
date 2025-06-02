

import 'package:asset_vantage/main.dart';
import 'package:asset_vantage/src/domain/params/expense/expense_report_params.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../entities/expense/expense_report_entity.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetExpenseReport extends UseCase<ExpenseReportEntity, ExpenseReportParams> {
  final AVRepository _avRepository;

  GetExpenseReport(this._avRepository);

  @override
  Future<Either<AppError, ExpenseReportEntity>> call(ExpenseReportParams params) async =>
      await ieResponseQueue.add(() async=> await _avRepository.getExpenseReport(context: params.context, requestBody: params.toJson()));
}
