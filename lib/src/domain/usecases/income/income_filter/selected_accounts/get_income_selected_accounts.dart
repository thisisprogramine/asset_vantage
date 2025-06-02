
import '../../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../../data/models/income/income_account_model.dart';
import '../../../../repositories/av_repository.dart';


class GetIncomeSelectedAccounts {
  final AVRepository _avRepository;

  GetIncomeSelectedAccounts(this._avRepository);

  Future<List<IncomeAccount>?> call(Map<String, dynamic> params) async =>
      await _avRepository.getIncomeSelectedAccounts(requestBody: params);
}
