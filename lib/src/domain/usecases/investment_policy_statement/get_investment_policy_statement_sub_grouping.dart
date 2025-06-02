import 'package:asset_vantage/main.dart';
import 'package:asset_vantage/src/domain/params/investment_policy_statement/investment_policy_statement_sub_grouping_params.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../entities/investment_policy_statement/investment_policy_statement_sub_grouping_entity.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetInvestmentPolicyStatementSubGrouping extends UseCase<InvestmentPolicyStatementSubGroupingEntity, InvestmentPolicyStatementSubGroupingParams> {
  final AVRepository _avRepository;

  GetInvestmentPolicyStatementSubGrouping(this._avRepository);

  @override
  Future<Either<AppError, InvestmentPolicyStatementSubGroupingEntity>> call(InvestmentPolicyStatementSubGroupingParams params) async =>
      await ipsResponseQueue.add(() async=> await _avRepository.getInvestmentPolicyStatementSubGrouping(context: params.context, requestBody: params.toJson()));
}
