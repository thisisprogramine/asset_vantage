

import 'package:asset_vantage/src/domain/entities/net_worth/net_worth_return_percent_entity.dart';
import 'package:asset_vantage/src/domain/params/net_worth/net_worth_return_percent_params.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetNetWorthReturnPercent extends UseCase<NetWorthReturnPercentEntity, NetWorthReturnPercentParams> {
  final AVRepository _avRepository;

  GetNetWorthReturnPercent(this._avRepository);

  @override
  Future<Either<AppError, NetWorthReturnPercentEntity>> call(NetWorthReturnPercentParams params) async =>
      _avRepository.getNetWorthReturnPercent(context: params.context, requestBody: params.toJson());
}
