
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../repositories/av_repository.dart';


class SaveExpenseSelectedEntity {
  final AVRepository _avRepository;

  SaveExpenseSelectedEntity(this._avRepository);

  Future<void> call(Entity params) async =>
      await _avRepository.saveExpenseSelectedEntity(response: params.toJson());
}
