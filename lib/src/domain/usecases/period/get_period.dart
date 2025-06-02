
import 'package:asset_vantage/src/domain/entities/period/period_enitity.dart';
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../../entities/app_error.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetPeriod extends UseCase<PeriodEntity, BuildContext> {
  final AVRepository _avRepository;

  GetPeriod(this._avRepository);

  @override
  Future<Either<AppError, PeriodEntity>> call(BuildContext context) async =>
      _avRepository.getPeriods(context: context, requestBody: {});
}
