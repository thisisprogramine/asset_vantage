//TODO:: add new file

import 'package:asset_vantage/src/domain/entities/investment_policy_statement/investment_policy_statement_sub_grouping_entity.dart';
import 'package:asset_vantage/src/domain/params/investment_policy_statement/ips_get_filter_params.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetIpsSubFilter extends UseCase<List<SubGroupingItemData>?, GetIpsFilterParams> {
  final AVRepository _avRepository;

  GetIpsSubFilter(this._avRepository);

  @override
  Future<Either<AppError, List<SubGroupingItemData>?>> call(GetIpsFilterParams params) async =>
      _avRepository.getIpsSubFilter(entityName: params.entityName, grouping: params.grouping);
}
