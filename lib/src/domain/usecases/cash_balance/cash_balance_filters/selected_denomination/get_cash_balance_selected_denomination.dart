
import '../../../../../data/models/denomination/denomination_model.dart';
import '../../../../repositories/av_repository.dart';


class GetCashBalanceSelectedDenomination {
  final AVRepository _avRepository;

  GetCashBalanceSelectedDenomination(this._avRepository);

  Future<DenData?> call(String tileName) async =>
      await _avRepository.getCashBalanceSelectedDenomination(tileName: tileName);
}
