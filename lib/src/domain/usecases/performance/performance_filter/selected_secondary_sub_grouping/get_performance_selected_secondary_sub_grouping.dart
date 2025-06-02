
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../../data/models/performance/performance_secondary_grouping_model.dart';
import '../../../../../data/models/performance/performance_secondary_sub_grouping_model.dart';
import '../../../../repositories/av_repository.dart';


class GetPerformanceSelectedSecondarySubGrouping {
  final AVRepository _avRepository;

  GetPerformanceSelectedSecondarySubGrouping(this._avRepository);

  Future<List<SubGroupingItem?>?> call(Map<dynamic, dynamic> param) async =>
      await _avRepository.getPerformanceSelectedSecondarySubGrouping(requestBody: param);
}
