
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../../data/models/period/period_model.dart';
import '../../../../repositories/av_repository.dart';


class GetExpenseSelectedPeriod {
  final AVRepository _avRepository;

  GetExpenseSelectedPeriod(this._avRepository);

  Future<PeriodItem?> call() async =>
      await _avRepository.getExpenseSelectedPeriod();
}
