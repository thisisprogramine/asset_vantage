import 'package:asset_vantage/src/domain/entities/app_error.dart';
import 'package:asset_vantage/src/domain/entities/partnership_method/partnership_method.dart';
import 'package:asset_vantage/src/domain/repositories/av_repository.dart';
import 'package:asset_vantage/src/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class GetPartnershipMethod extends UseCase<PartnershipMethodEntities,BuildContext>{
  final AVRepository _avRepository;

  GetPartnershipMethod(this._avRepository);

  @override
  Future<Either<AppError, PartnershipMethodEntities>> call(BuildContext context) async =>
      _avRepository.getPartnershipMethod(context: context, requestBody: {});

}