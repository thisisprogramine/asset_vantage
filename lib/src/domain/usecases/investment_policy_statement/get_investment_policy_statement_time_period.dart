import 'package:asset_vantage/src/domain/params/investment_policy_statement/investment_policy_statement_time_period_params.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../entities/investment_policy_statement/investment_policy_statement_time_period_entity.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetInvestmentPolicyStatementTimePeriod extends UseCase<InvestmentPolicyStatementTimePeriodEntity, InvestmentPolicyStatementTimePeriodParams> {
  final AVRepository _avRepository;

  GetInvestmentPolicyStatementTimePeriod(this._avRepository);

  @override
  Future<Either<AppError, InvestmentPolicyStatementTimePeriodEntity>> call(InvestmentPolicyStatementTimePeriodParams params) async =>
      _avRepository.getInvestmentPolicyStatementTimePeriod(context: params.context, requestBody: params.toJson());
}
