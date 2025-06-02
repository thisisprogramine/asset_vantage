
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../repositories/av_repository.dart';


class GetPerformanceSelectedAsOnDate {
  final AVRepository _avRepository;

  GetPerformanceSelectedAsOnDate(this._avRepository);

  Future<String?> call() async =>
      await _avRepository.getPerformanceSelectedAsOnDate();
}
