import 'package:asset_vantage/src/domain/entities/denomination/denomination_entity.dart';
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import '../../entities/app_error.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetDenomination extends UseCase<DenominationEntity, BuildContext> {
  final AVRepository _avRepository;

  GetDenomination(this._avRepository);

  @override
  Future<Either<AppError, DenominationEntity>> call(BuildContext context) async =>
      _avRepository.getDenominationList(context: context, requestBody: {});
}
