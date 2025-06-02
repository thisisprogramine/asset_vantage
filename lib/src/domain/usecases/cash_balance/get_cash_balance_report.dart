import 'package:asset_vantage/main.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../entities/cash_balance/cash_balance_entity.dart';
import '../../params/cash_balance/cash_balance_report_params.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetCashBalanceReport extends UseCase<CashBalanceReportEntity, CashBalanceReportParams> {
  final AVRepository _avRepository;

  GetCashBalanceReport(this._avRepository);

  @override
  Future<Either<AppError, CashBalanceReportEntity>> call(CashBalanceReportParams params) async =>
    await cbResponseQueue.add(() async=> await _avRepository.getCashBalanceReport(context: params.context, requestBody: params.toJson()));

}
