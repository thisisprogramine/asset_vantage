
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../../data/models/performance/performance_primary_grouping_model.dart';
import '../../../../../data/models/performance/performance_secondary_grouping_model.dart';
import '../../../../../data/models/performance/performance_secondary_sub_grouping_model.dart';
import '../../../../repositories/av_repository.dart';


class SavePerformanceSelectedSecondarySubGrouping {
  final AVRepository _avRepository;

  SavePerformanceSelectedSecondarySubGrouping(this._avRepository);

  Future<void> call(Map<dynamic, dynamic> param, Map<dynamic, dynamic> response) async =>
      await _avRepository.savePerformanceSelectedSecondarySubGrouping(requestBody: param, response: response);
}
