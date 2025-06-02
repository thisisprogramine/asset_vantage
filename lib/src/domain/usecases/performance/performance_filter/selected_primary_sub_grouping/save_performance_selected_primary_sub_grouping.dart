
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../../data/models/performance/performance_primary_grouping_model.dart';
import '../../../../../data/models/performance/performance_primary_sub_grouping_model.dart';
import '../../../../repositories/av_repository.dart';


class SavePerformanceSelectedPrimarySubGrouping {
  final AVRepository _avRepository;

  SavePerformanceSelectedPrimarySubGrouping(this._avRepository);

  Future<void> call(Map<dynamic, dynamic> param, Map<dynamic, dynamic> response) async =>
      await _avRepository.savePerformanceSelectedPrimarySubGrouping(requestBody: param, response: response);
}
