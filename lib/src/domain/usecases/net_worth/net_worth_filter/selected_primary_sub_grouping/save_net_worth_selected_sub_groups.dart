
import '../../../../repositories/av_repository.dart';


class SaveNetWorthSelectedPrimarySubGrouping {
  final AVRepository _avRepository;

  SaveNetWorthSelectedPrimarySubGrouping(this._avRepository);

  Future<void> call(Map<dynamic, dynamic> param, Map<dynamic, dynamic> response) async =>
      await _avRepository.saveNetWorthSelectedPrimarySubGrouping(requestBody: param, response: response);
}
