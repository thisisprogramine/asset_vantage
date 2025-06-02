
import 'package:asset_vantage/main.dart';
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../entities/app_error.dart';
import '../../entities/investment_policy_statement/investment_policy_statement_grouping_entity.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetInvestmentPolicyStatementGrouping extends UseCase<InvestmentPolicyStatementGroupingEntity, BuildContext> {
  final AVRepository _avRepository;

  GetInvestmentPolicyStatementGrouping(this._avRepository);

  @override
  Future<Either<AppError, InvestmentPolicyStatementGroupingEntity>> call(BuildContext context) async =>
      await ipsResponseQueue.add(() async=> await _avRepository.getInvestmentPolicyStatementGrouping(context: context));
}
