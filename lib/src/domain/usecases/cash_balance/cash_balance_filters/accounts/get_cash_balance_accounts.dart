
import 'package:asset_vantage/main.dart';
import 'package:asset_vantage/src/domain/entities/cash_balance/cash_balance_sub_grouping_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../../entities/app_error.dart';
import '../../../../params/cash_balance/cash_balance_account_params.dart';
import '../../../../params/cash_balance/cash_balance_sub_grouping_params.dart';
import '../../../../repositories/av_repository.dart';
import '../../../usecase.dart';


class GetCashBalanceAccounts extends UseCase<CashBalanceSubGroupingEntity, CashBalanceAccountParams> {
  final AVRepository _avRepository;

  GetCashBalanceAccounts(this._avRepository);

  @override
  Future<Either<AppError, CashBalanceSubGroupingEntity>> call(CashBalanceAccountParams params) async =>
      await cbResponseQueue.add(() async=> await _avRepository.getCashBalanceAccounts(context: params.context, requestBody: params.toJson()));
}