//TODO:: add new file


import 'package:asset_vantage/src/domain/entities/investment_policy_statement/investment_policy_statement_sub_grouping_entity.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../params/investment_policy_statement/ips_save_filter_params.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class SaveIpsSubFilter extends UseCase<void, SaveIpsFilterParams> {
  final AVRepository _avRepository;

  SaveIpsSubFilter(this._avRepository);

  @override
  Future<Either<AppError, void>> call(SaveIpsFilterParams params) async =>
      _avRepository.saveIpsSubFilter(entityName: params.entityName, grouping: params.grouping, subGroup: params.filter as List<SubGroupingItemData>?);
}
