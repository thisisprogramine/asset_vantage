
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../../data/models/period/period_model.dart';
import '../../../../repositories/av_repository.dart';


class GetIncomeSelectedPeriod {
  final AVRepository _avRepository;

  GetIncomeSelectedPeriod(this._avRepository);

  Future<PeriodItem?> call() async =>
      await _avRepository.getIncomeSelectedPeriod();
}
