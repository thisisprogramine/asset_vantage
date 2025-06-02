
import '../../../../../data/models/period/period_model.dart';
import '../../../../repositories/av_repository.dart';


class SaveExpenseSelectedPeriod {
  final AVRepository _avRepository;

  SaveExpenseSelectedPeriod(this._avRepository);

  Future<void> call(PeriodItem params) async =>
      await _avRepository.saveExpenseSelectedPeriod(response: params.toJson());
}
