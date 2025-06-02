
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../repositories/av_repository.dart';


class GetCashBalanceSelectedEntity {
  final AVRepository _avRepository;

  GetCashBalanceSelectedEntity(this._avRepository);

  Future<Entity?> call(String tileName) async =>
      await _avRepository.getCashBalanceSelectedEntity(tileName: tileName);
}
