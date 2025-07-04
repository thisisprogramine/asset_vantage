import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class ClearCashBalance extends UseCase<void, NoParams> {
  final AVRepository _avRepository;

  ClearCashBalance(this._avRepository);

  @override
  Future<Either<AppError, void>> call(NoParams params) async =>
      await _avRepository.clearCashBalance();
}
