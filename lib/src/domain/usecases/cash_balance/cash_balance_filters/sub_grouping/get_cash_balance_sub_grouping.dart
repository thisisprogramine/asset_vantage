import 'package:asset_vantage/main.dart';
import 'package:dartz/dartz.dart';

import '../../../../entities/app_error.dart';
import '../../../../entities/cash_balance/cash_balance_sub_grouping_entity.dart';
import '../../../../params/cash_balance/cash_balance_sub_grouping_params.dart';
import '../../../../repositories/av_repository.dart';
import '../../../usecase.dart';

class GetCashBalanceSubGrouping extends UseCase<CashBalanceSubGroupingEntity, CashBalanceSubGroupingParam> {
  final AVRepository _avRepository;

  GetCashBalanceSubGrouping(this._avRepository);

  @override
  Future<Either<AppError, CashBalanceSubGroupingEntity>> call(CashBalanceSubGroupingParam params) async =>
      await cbResponseQueue.add(() async=> await _avRepository.getCashBalanceSubGrouping(context: params.context, requestBody: params.toJson()));
}
