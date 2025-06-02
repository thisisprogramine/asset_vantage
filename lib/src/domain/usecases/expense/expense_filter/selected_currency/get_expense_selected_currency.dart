
import '../../../../../data/models/currency/currency_model.dart';
import '../../../../repositories/av_repository.dart';


class GetExpenseSelectedCurrency {
  final AVRepository _avRepository;

  GetExpenseSelectedCurrency(this._avRepository);

  Future<CurrencyData?> call() async =>
      await _avRepository.getExpenseSelectedCurrency();
}
