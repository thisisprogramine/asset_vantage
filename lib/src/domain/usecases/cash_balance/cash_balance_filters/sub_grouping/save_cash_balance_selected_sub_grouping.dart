
import '../../../../repositories/av_repository.dart';


class SaveCashBalanceSelectedPrimarySubGrouping {
  final AVRepository _avRepository;

  SaveCashBalanceSelectedPrimarySubGrouping(this._avRepository);

  Future<void> call(String tileName,Map<dynamic, dynamic> param, Map<dynamic, dynamic> response) async =>
      await _avRepository.saveCashBalanceSelectedPrimarySubGrouping(tileName: tileName,requestBody: param, response: response);
}
