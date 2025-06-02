
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../repositories/av_repository.dart';


class SaveCashBalanceSelectedEntity {
  final AVRepository _avRepository;

  SaveCashBalanceSelectedEntity(this._avRepository);

  Future<void> call(String tileName,Entity params) async =>
      await _avRepository.saveCashBalanceSelectedEntity(response: params.toJson(), tileName: tileName);
}
