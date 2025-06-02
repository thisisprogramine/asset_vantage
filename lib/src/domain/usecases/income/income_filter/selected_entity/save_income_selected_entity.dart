
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../repositories/av_repository.dart';


class SaveIncomeSelectedEntity {
  final AVRepository _avRepository;

  SaveIncomeSelectedEntity(this._avRepository);

  Future<void> call(Entity params) async =>
      await _avRepository.saveIncomeSelectedEntity(response: params.toJson());
}
