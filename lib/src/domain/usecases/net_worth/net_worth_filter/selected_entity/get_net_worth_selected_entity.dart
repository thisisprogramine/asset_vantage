
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../repositories/av_repository.dart';


class GetNetWorthSelectedEntity {
  final AVRepository _avRepository;

  GetNetWorthSelectedEntity(this._avRepository);

  Future<Entity?> call() async =>
      await _avRepository.getNetWorthSelectedEntity();
}
