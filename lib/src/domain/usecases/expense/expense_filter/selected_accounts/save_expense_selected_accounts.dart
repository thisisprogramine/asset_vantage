
import '../../../../../data/models/expense/expense_account_model.dart';
import '../../../../repositories/av_repository.dart';


class SaveExpenseSelectedAccounts {
  final AVRepository _avRepository;

  SaveExpenseSelectedAccounts(this._avRepository);

  Future<void> call(Map<String, dynamic> requestBody, ExpenseAccountModel params) async =>
      await _avRepository.saveExpenseSelectedAccounts(requestBody: requestBody, response: params.toJson());
}
