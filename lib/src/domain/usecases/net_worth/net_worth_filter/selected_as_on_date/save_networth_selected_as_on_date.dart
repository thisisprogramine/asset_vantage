
import '../../../../repositories/av_repository.dart';


class SaveNetWorthSelectedAsOnDate {
  final AVRepository _avRepository;

  SaveNetWorthSelectedAsOnDate(this._avRepository);

  Future<void> call(String params) async =>
      await _avRepository.saveNetWorthSelectedAsOnDate(response: params);
}
