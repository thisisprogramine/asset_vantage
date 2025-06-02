//TODO:: add new file

import 'package:asset_vantage/src/domain/params/investment_policy_statement/ips_get_filter_params.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../entities/investment_policy_statement/investment_policy_statement_policies_entity.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetIpsPolicyFilter extends UseCase<Policies?, GetIpsFilterParams> {
  final AVRepository _avRepository;

  GetIpsPolicyFilter(this._avRepository);

  @override
  Future<Either<AppError, Policies?>> call(GetIpsFilterParams params) async =>
      _avRepository.getIpsPolicyFilter(entityName: params.entityName, grouping: params.grouping);
}
