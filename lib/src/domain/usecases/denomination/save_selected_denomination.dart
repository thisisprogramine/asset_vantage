


import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../params/denomination/set_selected_denomination.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class SaveSelectedDenomination extends UseCase<void, SaveDenominationFilterParams> {
  final AVRepository _avRepository;

  SaveSelectedDenomination(this._avRepository);

  @override
  Future<Either<AppError, void>> call(SaveDenominationFilterParams params) async =>
      _avRepository.saveSelectedDenomination(denomination: params.filter, tileName: params.tileName);
}
