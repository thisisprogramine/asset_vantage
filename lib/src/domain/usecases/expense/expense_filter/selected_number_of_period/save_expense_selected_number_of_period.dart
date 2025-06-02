
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../../data/models/number_of_period/number_of_period_model.dart';
import '../../../../repositories/av_repository.dart';


class SaveExpenseSelectedNumberOfPeriod {
  final AVRepository _avRepository;

  SaveExpenseSelectedNumberOfPeriod(this._avRepository);

  Future<void> call(NumberOfPeriodItem params) async =>
      await _avRepository.saveExpenseSelectedNumberOfPeriod(response: params.toJson());
}
