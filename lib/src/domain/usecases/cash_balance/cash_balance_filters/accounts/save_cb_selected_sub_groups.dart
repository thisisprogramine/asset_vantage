import '../../../../repositories/av_repository.dart';

class SaveCashBalanceSelectedAccounts {
  final AVRepository _avRepository;

  SaveCashBalanceSelectedAccounts(this._avRepository);

  @override
  Future<void> call(String tileName,Map<dynamic, dynamic> param, Map<dynamic, dynamic> response) async =>
      _avRepository.saveCashBalanceSelectedAccounts(requestBody: param,tileName: tileName,response: response);
}
