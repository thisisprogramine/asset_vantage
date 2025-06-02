
import 'package:asset_vantage/main.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../entities/net_worth/net_worth_entity.dart';
import '../../params/net_worth/net_worth_report_params.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetNetWorthReport extends UseCase<NetWorthReportEntity, NetWorthReportParams> {
  final AVRepository _avRepository;

  GetNetWorthReport(this._avRepository);

  @override
  Future<Either<AppError, NetWorthReportEntity>> call(NetWorthReportParams params) async =>
      await nwResponseQueue.add(() async=> await _avRepository.getNetWorthReport(context: params.context, requestBody: params.toJson()));
}