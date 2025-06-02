
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../../data/models/denomination/denomination_model.dart';
import '../../../../repositories/av_repository.dart';


class SaveIncomeSelectedDenomination {
  final AVRepository _avRepository;

  SaveIncomeSelectedDenomination(this._avRepository);

  Future<void> call(DenData params) async =>
      await _avRepository.saveIncomeSelectedDenomination(response: params.toJson());
}
