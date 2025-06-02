


import 'package:asset_vantage/src/domain/entities/denomination/denomination_entity.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../params/denomination/get_selected_denomination.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetSelectedDenomination extends UseCase<DenominationData?, GetDenominationFilterParams> {
  final AVRepository _avRepository;

  GetSelectedDenomination(this._avRepository);

  @override
  Future<Either<AppError, DenominationData?>> call(GetDenominationFilterParams params) async =>
      _avRepository.getSelectedDenomination(tileName: params.tileName);
}
