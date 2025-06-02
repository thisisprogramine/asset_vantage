
import '../../../../../data/models/currency/currency_model.dart';
import '../../../../repositories/av_repository.dart';


class SaveExpenseSelectedCurrency {
  final AVRepository _avRepository;

  SaveExpenseSelectedCurrency(this._avRepository);

  Future<void> call(CurrencyData params) async =>
      await _avRepository.saveExpenseSelectedCurrency(response: params.toJson());
}
