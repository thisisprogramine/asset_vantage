import 'package:asset_vantage/main.dart';
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../entities/app_error.dart';
import '../../entities/investment_policy_statement/investment_policy_statement_policies_entity.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetInvestmentPolicyStatementPolicies extends UseCase<InvestmentPolicyStatementPoliciesEntity, BuildContext> {
  final AVRepository _avRepository;

  GetInvestmentPolicyStatementPolicies(this._avRepository);

  @override
  Future<Either<AppError, InvestmentPolicyStatementPoliciesEntity>> call(BuildContext context) async =>
      await ipsResponseQueue.add(() async=> await _avRepository.getInvestmentPolicyStatementPolicies(context: context));
}
