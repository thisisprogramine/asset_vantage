
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../../data/models/number_of_period/number_of_period_model.dart';
import '../../../../repositories/av_repository.dart';


class SaveIncomeSelectedNumberOfPeriod {
  final AVRepository _avRepository;

  SaveIncomeSelectedNumberOfPeriod(this._avRepository);

  Future<void> call(NumberOfPeriodItem params) async =>
      await _avRepository.saveIncomeSelectedNumberOfPeriod(response: params.toJson());
}
