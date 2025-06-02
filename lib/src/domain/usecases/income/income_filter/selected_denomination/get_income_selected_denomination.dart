
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../../data/models/denomination/denomination_model.dart';
import '../../../../repositories/av_repository.dart';


class GetIncomeSelectedDenomination {
  final AVRepository _avRepository;

  GetIncomeSelectedDenomination(this._avRepository);

  Future<DenData?> call() async =>
      await _avRepository.getIncomeSelectedDenomination();
}
