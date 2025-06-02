
import '../../../../repositories/av_repository.dart';


class GetNetWorthSelectedAsOnDate {
  final AVRepository _avRepository;

  GetNetWorthSelectedAsOnDate(this._avRepository);

  Future<String?> call() async =>
      await _avRepository.getNetWorthSelectedAsOnDate();
}
