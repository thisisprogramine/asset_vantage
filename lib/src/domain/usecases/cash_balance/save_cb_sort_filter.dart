
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class SaveCBSortFilter extends UseCase<void, int> {
  final AVRepository _avRepository;

  SaveCBSortFilter(this._avRepository);

  @override
  Future<Either<AppError, void>> call(int params) async =>
      _avRepository.saveCBSortFilter(sort: params);
}
