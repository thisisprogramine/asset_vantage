//TODO:: add new file

import 'package:asset_vantage/src/domain/entities/investment_policy_statement/investment_policy_statement_time_period_entity.dart';
import 'package:asset_vantage/src/domain/params/investment_policy_statement/ips_get_filter_params.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetIpsReturnFilter extends UseCase<TimePeriodItemData?, GetIpsFilterParams> {
  final AVRepository _avRepository;

  GetIpsReturnFilter(this._avRepository);

  @override
  Future<Either<AppError, TimePeriodItemData?>> call(GetIpsFilterParams params) async =>
      _avRepository.getIpsReturnFilter(entityName: params.entityName, grouping: params.grouping);
}
