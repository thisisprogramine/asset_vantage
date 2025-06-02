
import '../../../../../data/models/currency/currency_model.dart';
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../repositories/av_repository.dart';


class GetPerformanceSelectedCurrency {
  final AVRepository _avRepository;

  GetPerformanceSelectedCurrency(this._avRepository);

  Future<CurrencyData?> call() async =>
      await _avRepository.getPerformanceSelectedCurrency();
}
