
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetCBSortFilter extends UseCase<int?, NoParams> {
  final AVRepository _avRepository;

  GetCBSortFilter(this._avRepository);

  @override
  Future<Either<AppError, int?>> call(NoParams params) async =>
      _avRepository.getCBSortFilter();
}
