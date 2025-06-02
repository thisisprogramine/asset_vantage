
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../../data/models/denomination/denomination_model.dart';
import '../../../../repositories/av_repository.dart';


class SavePerformanceSelectedDenomination {
  final AVRepository _avRepository;

  SavePerformanceSelectedDenomination(this._avRepository);

  Future<void> call(DenData params) async =>
      await _avRepository.savePerformanceSelectedDenomination(response: params.toJson());
}
