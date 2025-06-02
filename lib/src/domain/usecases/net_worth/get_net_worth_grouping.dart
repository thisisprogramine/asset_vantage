
import 'package:asset_vantage/main.dart';
import 'package:asset_vantage/src/domain/params/net_worth/net_worth_primary_grouping_params.dart';
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../entities/net_worth/net_worth_grouping_entity.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetNetWorthGrouping extends UseCase<NetWorthGroupingEntity, NetWorthPrimaryGroupingParam> {
  final AVRepository _avRepository;

  GetNetWorthGrouping(this._avRepository);

  @override
  Future<Either<AppError, NetWorthGroupingEntity>> call(NetWorthPrimaryGroupingParam params) async =>
      await nwResponseQueue.add(() async=> await _avRepository.getNetWorthGrouping(context: params.context, requestBody: params.toJson()));
}