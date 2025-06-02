
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../../data/models/income/income_account_model.dart';
import '../../../../repositories/av_repository.dart';


class SaveIncomeSelectedAccounts {
  final AVRepository _avRepository;

  SaveIncomeSelectedAccounts(this._avRepository);

  Future<void> call(Map<String, dynamic> requestBody, IncomeAccountModel params) async =>
      await _avRepository.saveIncomeSelectedAccounts(requestBody: requestBody, response: params.toJson());
}
