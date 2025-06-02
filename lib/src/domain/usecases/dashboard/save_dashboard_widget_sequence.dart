

import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../params/dashboard/dashboard_seq_params.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class SaveDashboardWidgetSequence extends UseCase<void, DashboardSeqParams> {
  final AVRepository _avRepository;

  SaveDashboardWidgetSequence(this._avRepository);

  @override
  Future<Either<AppError, void>> call(DashboardSeqParams params) async =>
      _avRepository.saveDashSeq(context: params.context, seq: params.seq);
}
