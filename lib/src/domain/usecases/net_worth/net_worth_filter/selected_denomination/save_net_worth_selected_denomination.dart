
import '../../../../../data/models/denomination/denomination_model.dart';
import '../../../../repositories/av_repository.dart';


class SaveNetWorthSelectedDenomination {
  final AVRepository _avRepository;

  SaveNetWorthSelectedDenomination(this._avRepository);

  Future<void> call(DenData params) async =>
      await _avRepository.saveNetWorthSelectedDenomination(response: params.toJson());
}
