
import '../../../../../data/models/currency/currency_model.dart';
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../repositories/av_repository.dart';


class SaveIncomeSelectedCurrency {
  final AVRepository _avRepository;

  SaveIncomeSelectedCurrency(this._avRepository);

  Future<void> call(CurrencyData params) async =>
      await _avRepository.saveIncomeSelectedCurrency(response: params.toJson());
}
