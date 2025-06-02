//TODO:: add new file


import 'package:asset_vantage/src/domain/params/investment_policy_statement/ips_save_filter_params.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../entities/investment_policy_statement/investment_policy_statement_policies_entity.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class SaveIpsPolicyFilter extends UseCase<void, SaveIpsFilterParams> {
  final AVRepository _avRepository;

  SaveIpsPolicyFilter(this._avRepository);

  @override
  Future<Either<AppError, void>> call(SaveIpsFilterParams params) async =>
      _avRepository.saveIpsPolicyFilter(entityName: params.entityName, grouping: params.grouping, policy: params.filter as  Policies?);
}
