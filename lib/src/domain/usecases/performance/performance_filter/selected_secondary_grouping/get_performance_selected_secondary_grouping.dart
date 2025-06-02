
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../../data/models/performance/performance_secondary_grouping_model.dart';
import '../../../../repositories/av_repository.dart';


class GetPerformanceSelectedSecondaryGrouping {
  final AVRepository _avRepository;

  GetPerformanceSelectedSecondaryGrouping(this._avRepository);

  Future<SecondaryGrouping?> call() async =>
      await _avRepository.getPerformanceSelectedSecondaryGrouping();
}
