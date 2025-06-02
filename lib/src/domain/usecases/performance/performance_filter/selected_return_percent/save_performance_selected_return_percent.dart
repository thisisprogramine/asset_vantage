
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../../data/models/return_percentage/return_percentage_model.dart';
import '../../../../repositories/av_repository.dart';


class SavePerformanceSelectedReturnPercent {
  final AVRepository _avRepository;

  SavePerformanceSelectedReturnPercent(this._avRepository);

  Future<void> call(Map<dynamic, dynamic> params) async =>
      await _avRepository.savePerformanceSelectedReturnPercent(response: params);
}
