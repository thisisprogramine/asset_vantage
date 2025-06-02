
import 'package:asset_vantage/src/domain/entities/number_of_period/number_of_period.dart';
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../entities/app_error.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetNumberOfPeriod extends UseCase<NumberOfPeriodEntity, BuildContext> {
  final AVRepository _avRepository;

  GetNumberOfPeriod(this._avRepository);

  @override
  Future<Either<AppError, NumberOfPeriodEntity>> call(BuildContext context) async =>
      _avRepository.getNumberOfPeriod(context: context, requestBody: {});
}
