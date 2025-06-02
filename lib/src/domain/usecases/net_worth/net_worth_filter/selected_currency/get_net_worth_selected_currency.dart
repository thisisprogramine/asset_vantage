
import '../../../../../data/models/currency/currency_model.dart';
import '../../../../repositories/av_repository.dart';


class GetNetWorthSelectedCurrency {
  final AVRepository _avRepository;

  GetNetWorthSelectedCurrency(this._avRepository);

  Future<CurrencyData?> call() async =>
      await _avRepository.getNetWorthSelectedCurrency();
}
