
import '../../../../repositories/av_repository.dart';


class SaveNetWorthSelectedReturnPercent {
  final AVRepository _avRepository;

  SaveNetWorthSelectedReturnPercent(this._avRepository);

  Future<void> call(Map<dynamic, dynamic> params) async =>
      await _avRepository.saveNetWorthSelectedReturnPercent(response: params);
}
