//TODO:: add new file


import 'package:asset_vantage/src/domain/entities/investment_policy_statement/investment_policy_statement_time_period_entity.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../params/investment_policy_statement/ips_save_filter_params.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class SaveIpsReturnFilter extends UseCase<void, SaveIpsFilterParams> {
  final AVRepository _avRepository;

  SaveIpsReturnFilter(this._avRepository);

  @override
  Future<Either<AppError, void>> call(SaveIpsFilterParams params) async =>
      _avRepository.saveIpsReturnFilter(entityName: params.entityName, grouping: params.grouping, period: params.filter as  TimePeriodItemData?);
}
