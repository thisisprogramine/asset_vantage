
import '../../../../../data/models/currency/currency_model.dart';
import '../../../../repositories/av_repository.dart';


class SaveCashBalanceSelectedCurrency {
  final AVRepository _avRepository;

  SaveCashBalanceSelectedCurrency(this._avRepository);

  Future<void> call(String tileName,CurrencyData params) async =>
      await _avRepository.saveCashBalanceSelectedCurrency(response: params.toJson(),tileName: tileName,);
}
