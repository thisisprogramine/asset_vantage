
import '../../../../../data/models/denomination/denomination_model.dart';
import '../../../../repositories/av_repository.dart';


class SaveExpenseSelectedDenomination {
  final AVRepository _avRepository;

  SaveExpenseSelectedDenomination(this._avRepository);

  Future<void> call(DenData params) async =>
      await _avRepository.saveExpenseSelectedDenomination(response: params.toJson());
}
