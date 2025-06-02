
import '../../../../../data/models/currency/currency_model.dart';
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../repositories/av_repository.dart';


class GetIncomeSelectedCurrency {
  final AVRepository _avRepository;

  GetIncomeSelectedCurrency(this._avRepository);

  Future<CurrencyData?> call() async =>
      await _avRepository.getIncomeSelectedCurrency();
}
