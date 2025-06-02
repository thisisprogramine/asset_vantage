
import '../../../../../data/models/currency/currency_model.dart';
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../repositories/av_repository.dart';


class SavePerformanceSelectedCurrency {
  final AVRepository _avRepository;

  SavePerformanceSelectedCurrency(this._avRepository);

  Future<void> call(CurrencyData params) async =>
      await _avRepository.savePerformanceSelectedCurrency(response: params.toJson());
}
