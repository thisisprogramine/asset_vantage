
import '../../../../../data/models/performance/performance_secondary_grouping_model.dart';
import '../../../../repositories/av_repository.dart';


class SavePerformanceSelectedSecondaryGrouping {
  final AVRepository _avRepository;

  SavePerformanceSelectedSecondaryGrouping(this._avRepository);

  Future<void> call(SecondaryGrouping params) async =>
      await _avRepository.savePerformanceSelectedSecondaryGrouping(response: params.toJson());
}
