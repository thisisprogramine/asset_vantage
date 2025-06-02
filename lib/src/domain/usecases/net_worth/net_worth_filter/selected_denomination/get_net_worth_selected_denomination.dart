
import '../../../../../data/models/denomination/denomination_model.dart';
import '../../../../repositories/av_repository.dart';

class GetNetWorthSelectedDenomination {
  final AVRepository _avRepository;

  GetNetWorthSelectedDenomination(this._avRepository);

  Future<DenData?> call() async =>
      await _avRepository.getNetWorthSelectedDenomination();
}
