
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../repositories/av_repository.dart';


class GetPerformanceSelectedEntity {
  final AVRepository _avRepository;

  GetPerformanceSelectedEntity(this._avRepository);

  Future<Entity?> call() async =>
      await _avRepository.getPerformanceSelectedEntity();
}
