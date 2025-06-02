
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../../data/models/number_of_period/number_of_period_model.dart';
import '../../../../repositories/av_repository.dart';


class GetExpenseSelectedNumberOfPeriod {
  final AVRepository _avRepository;

  GetExpenseSelectedNumberOfPeriod(this._avRepository);

  Future<NumberOfPeriodItem?> call() async =>
      await _avRepository.getExpenseSelectedNumberOfPeriod();
}
