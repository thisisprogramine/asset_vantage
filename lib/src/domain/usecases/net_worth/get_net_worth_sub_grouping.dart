
import 'package:asset_vantage/main.dart';
import 'package:asset_vantage/src/domain/params/net_worth/net_worth_primary_sub_grouping_params.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../entities/net_worth/net_worth_sub_grouping_enity.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetNetWorthSubGrouping extends UseCase<NetWorthSubGroupingEntity, NetWorthPrimarySubGroupingParam> {
  final AVRepository _avRepository;

  GetNetWorthSubGrouping(this._avRepository);

  @override
  Future<Either<AppError, NetWorthSubGroupingEntity>> call(NetWorthPrimarySubGroupingParam params) async =>
      await nwResponseQueue.add(() async=> await _avRepository.getNetWorthSubGrouping(context: params.context, requestBody: params.toJson()));
}
