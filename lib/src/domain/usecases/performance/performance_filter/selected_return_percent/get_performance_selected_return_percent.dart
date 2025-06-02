
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../../data/models/return_percentage/return_percentage_model.dart';
import '../../../../repositories/av_repository.dart';


class GetPerformanceSelectedReturnPercent {
  final AVRepository _avRepository;

  GetPerformanceSelectedReturnPercent(this._avRepository);

  Future<List<ReturnPercentItem?>?> call() async =>
      await _avRepository.getPerformanceSelectedReturnPercent();
}
