import 'package:asset_vantage/src/domain/entities/app_error.dart';
import 'package:asset_vantage/src/domain/entities/partnership_method/holding_method_entities.dart';
import 'package:asset_vantage/src/domain/repositories/av_repository.dart';
import 'package:asset_vantage/src/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class GetHoldingMethod extends UseCase<HoldingMethodEntities,BuildContext>{
  final AVRepository _avRepository;

  GetHoldingMethod(this._avRepository);

  @override
  Future<Either<AppError, HoldingMethodEntities>> call(BuildContext context) async =>
      _avRepository.getHoldingMethod(context: context, requestBody: {});

}