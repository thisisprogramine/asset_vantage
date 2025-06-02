
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../../data/models/performance/performance_primary_grouping_model.dart';
import '../../../../repositories/av_repository.dart';


class SavePerformanceSelectedPrimaryGrouping {
  final AVRepository _avRepository;

  SavePerformanceSelectedPrimaryGrouping(this._avRepository);

  Future<void> call(PrimaryGrouping params) async =>
      await _avRepository.savePerformanceSelectedPrimaryGrouping(response: params.toJson());
}
