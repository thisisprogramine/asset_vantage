
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../repositories/av_repository.dart';


class SavePerformanceSelectedAsOnDate {
  final AVRepository _avRepository;

  SavePerformanceSelectedAsOnDate(this._avRepository);

  Future<void> call(String params) async =>
      await _avRepository.savePerformanceSelectedAsOnDate(response: params);
}
