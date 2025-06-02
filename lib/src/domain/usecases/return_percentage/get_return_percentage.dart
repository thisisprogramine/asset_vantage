
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../entities/app_error.dart';
import '../../entities/return_percentage/return_percentage_entity.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetReturnPercentage extends UseCase<ReturnPercentEntity, BuildContext> {
  final AVRepository _avRepository;

  GetReturnPercentage(this._avRepository);

  @override
  Future<Either<AppError, ReturnPercentEntity>> call(BuildContext context) async =>
      _avRepository.getReturnPercentage(context: context, requestBody: {});
}
