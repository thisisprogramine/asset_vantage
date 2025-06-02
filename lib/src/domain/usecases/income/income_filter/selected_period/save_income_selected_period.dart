
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../../data/models/period/period_model.dart';
import '../../../../repositories/av_repository.dart';


class SaveIncomeSelectedPeriod {
  final AVRepository _avRepository;

  SaveIncomeSelectedPeriod(this._avRepository);

  Future<void> call(PeriodItem params) async =>
      await _avRepository.saveIncomeSelectedPeriod(response: params.toJson());
}
