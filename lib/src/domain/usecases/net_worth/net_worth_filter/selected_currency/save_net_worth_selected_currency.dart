
import '../../../../../data/models/currency/currency_model.dart';
import '../../../../repositories/av_repository.dart';


class SaveNetWorthSelectedCurrency {
  final AVRepository _avRepository;

  SaveNetWorthSelectedCurrency(this._avRepository);

  Future<void> call(CurrencyData params) async =>
      await _avRepository.saveNetWorthSelectedCurrency(response: params.toJson());
}
