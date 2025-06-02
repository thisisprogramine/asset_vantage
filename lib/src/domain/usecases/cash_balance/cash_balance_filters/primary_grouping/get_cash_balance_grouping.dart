
import 'package:asset_vantage/main.dart';
import 'package:asset_vantage/src/domain/params/cash_balance/cash_balance_primary_grouping_params.dart';
import 'package:dartz/dartz.dart';

import '../../../../entities/app_error.dart';
import '../../../../entities/cash_balance/cash_balance_grouping_entity.dart';
import '../../../../repositories/av_repository.dart';
import '../../../usecase.dart';

class GetCashBalanceGrouping extends UseCase<CashBalanceGroupingEntity, CashBalancePrimaryGroupingParam> {
  final AVRepository _avRepository;

  GetCashBalanceGrouping(this._avRepository);

  @override
  Future<Either<AppError, CashBalanceGroupingEntity>> call(CashBalancePrimaryGroupingParam params) async =>
      await cbResponseQueue.add(() async=> await _avRepository.getCashBalanceGrouping(context: params.context, requestBody: params.toJson()));
}
