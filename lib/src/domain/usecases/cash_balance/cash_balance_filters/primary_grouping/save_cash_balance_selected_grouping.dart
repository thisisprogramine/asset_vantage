
import '../../../../../data/models/cash_balance/cash_balance_grouping_model.dart';
import '../../../../entities/dashboard/dashboard_list_entity.dart';
import '../../../../repositories/av_repository.dart';


class SaveCashBalanceSelectedPrimaryGrouping {
  final AVRepository _avRepository;

  SaveCashBalanceSelectedPrimaryGrouping(this._avRepository);

  Future<void> call(String tileName,EntityData entity,PrimaryGrouping params) async =>
      await _avRepository.saveCashBalanceSelectedPrimaryGrouping(tileName: tileName, entity: entity,response: params.toJson());
}
