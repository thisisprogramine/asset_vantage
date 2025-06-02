
import '../../../../../data/models/denomination/denomination_model.dart';
import '../../../../repositories/av_repository.dart';


class SaveCashBalanceSelectedDenomination {
  final AVRepository _avRepository;

  SaveCashBalanceSelectedDenomination(this._avRepository);

  Future<void> call(String tileName,DenData params) async =>
      await _avRepository.saveCashBalanceSelectedDenomination(tileName: tileName,response: params.toJson());
}
