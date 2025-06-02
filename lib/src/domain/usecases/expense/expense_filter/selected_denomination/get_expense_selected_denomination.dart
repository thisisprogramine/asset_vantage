
import '../../../../../data/models/denomination/denomination_model.dart';
import '../../../../repositories/av_repository.dart';


class GetExpenseSelectedDenomination {
  final AVRepository _avRepository;

  GetExpenseSelectedDenomination(this._avRepository);

  Future<DenData?> call() async =>
      await _avRepository.getExpenseSelectedDenomination();
}
