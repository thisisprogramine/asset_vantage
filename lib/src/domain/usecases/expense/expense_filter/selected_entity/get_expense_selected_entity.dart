
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../repositories/av_repository.dart';


class GetExpenseSelectedEntity {
  final AVRepository _avRepository;

  GetExpenseSelectedEntity(this._avRepository);

  Future<Entity?> call() async =>
      await _avRepository.getExpenseSelectedEntity();
}
