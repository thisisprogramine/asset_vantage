
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../../data/models/denomination/denomination_model.dart';
import '../../../../repositories/av_repository.dart';


class GetPerformanceSelectedDenomination {
  final AVRepository _avRepository;

  GetPerformanceSelectedDenomination(this._avRepository);

  Future<DenData?> call() async =>
      await _avRepository.getPerformanceSelectedDenomination();
}
