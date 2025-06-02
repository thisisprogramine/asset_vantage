
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../repositories/av_repository.dart';


class SavePerformanceSelectedEntity {
  final AVRepository _avRepository;

  SavePerformanceSelectedEntity(this._avRepository);

  Future<void> call(Entity params) async =>
      await _avRepository.savePerformanceSelectedEntity(response: params.toJson());
}
