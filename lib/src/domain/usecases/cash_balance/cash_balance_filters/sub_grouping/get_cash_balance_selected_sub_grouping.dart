
import '../../../../../data/models/cash_balance/cash_balance_sub_grouping_model.dart';
import '../../../../repositories/av_repository.dart';


class GetCashBalanceSelectedPrimarySubGrouping {
  final AVRepository _avRepository;

  GetCashBalanceSelectedPrimarySubGrouping(this._avRepository);

  Future<List<SubGroupingItem?>?> call(String tileName,Map<dynamic, dynamic> param) async =>
      await _avRepository.getCashBalanceSelectedPrimarySubGrouping(tileName: tileName,requestBody: param);
}