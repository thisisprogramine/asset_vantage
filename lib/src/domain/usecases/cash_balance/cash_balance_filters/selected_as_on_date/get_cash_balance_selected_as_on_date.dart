
import '../../../../repositories/av_repository.dart';


class GetCashBalanceSelectedAsOnDate {
  final AVRepository _avRepository;

  GetCashBalanceSelectedAsOnDate(this._avRepository);

  Future<String?> call(String tileName) async =>
      await _avRepository.getCashBalanceSelectedAsOnDate(tileName: tileName);
}
