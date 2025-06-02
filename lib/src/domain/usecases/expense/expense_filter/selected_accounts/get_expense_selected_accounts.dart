
import '../../../../../data/models/expense/expense_account_model.dart';
import '../../../../repositories/av_repository.dart';


class GetExpenseSelectedAccounts {
  final AVRepository _avRepository;

  GetExpenseSelectedAccounts(this._avRepository);

  Future<List<ExpenseAccount>?> call(Map<String, dynamic> params) async =>
      await _avRepository.getExpenseSelectedAccounts(requestBody: params);
}
