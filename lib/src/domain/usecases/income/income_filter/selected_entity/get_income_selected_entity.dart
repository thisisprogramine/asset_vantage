
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../repositories/av_repository.dart';


class GetIncomeSelectedEntity {
  final AVRepository _avRepository;

  GetIncomeSelectedEntity(this._avRepository);

  Future<Entity?> call() async =>
      await _avRepository.getIncomeSelectedEntity();
}
