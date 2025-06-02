
import '../../../../../data/models/currency/currency_model.dart';
import '../../../../repositories/av_repository.dart';


class GetCashBalanceSelectedCurrency {
  final AVRepository _avRepository;

  GetCashBalanceSelectedCurrency(this._avRepository);

  Future<CurrencyData?> call(String tileName) async =>
      await _avRepository.getCashBalanceSelectedCurrency(tileName: tileName);
}
