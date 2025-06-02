
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../repositories/av_repository.dart';


class SaveNetWorthSelectedEntity {
  final AVRepository _avRepository;

  SaveNetWorthSelectedEntity(this._avRepository);

  Future<void> call(Entity params) async =>
      await _avRepository.saveNetWorthSelectedEntity(response: params.toJson());
}
