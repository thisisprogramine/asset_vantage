
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../../data/models/performance/performance_primary_grouping_model.dart';
import '../../../../../data/models/performance/performance_primary_sub_grouping_model.dart';
import '../../../../repositories/av_repository.dart';


class GetPerformanceSelectedPrimarySubGrouping {
  final AVRepository _avRepository;

  GetPerformanceSelectedPrimarySubGrouping(this._avRepository);

  Future<List<SubGroupingItem?>?> call(Map<dynamic, dynamic> param) async =>
      await _avRepository.getPerformanceSelectedPrimarySubGrouping(requestBody: param);
}
