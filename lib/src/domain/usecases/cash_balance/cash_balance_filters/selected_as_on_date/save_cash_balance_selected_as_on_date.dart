
import '../../../../repositories/av_repository.dart';


class SaveCashBalanceSelectedAsOnDate {
  final AVRepository _avRepository;

  SaveCashBalanceSelectedAsOnDate(this._avRepository);

  Future<void> call(String tileName,String params) async =>
      await _avRepository.saveCashBalanceSelectedAsOnDate(tileName: tileName,response: params);
}
