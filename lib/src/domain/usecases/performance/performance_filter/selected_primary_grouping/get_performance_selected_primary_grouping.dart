
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../../data/models/performance/performance_primary_grouping_model.dart';
import '../../../../repositories/av_repository.dart';


class GetPerformanceSelectedPrimaryGrouping {
  final AVRepository _avRepository;

  GetPerformanceSelectedPrimaryGrouping(this._avRepository);

  Future<PrimaryGrouping?> call() async =>
      await _avRepository.getPerformanceSelectedPrimaryGrouping();
}
