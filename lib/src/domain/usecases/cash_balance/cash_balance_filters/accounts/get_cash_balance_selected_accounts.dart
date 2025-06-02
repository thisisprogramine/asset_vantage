

import 'package:asset_vantage/src/data/models/cash_balance/cash_balance_sub_grouping_model.dart';
import '../../../../repositories/av_repository.dart';

class GetCashBalanceSelectedAccounts {
  final AVRepository _avRepository;

  GetCashBalanceSelectedAccounts(this._avRepository);

  @override
  Future<List<SubGroupingItem?>?> call(String tileName,Map<dynamic, dynamic> param) async =>
      _avRepository.getCashBalanceSelectedAccounts(tileName: tileName,requestBody: param);
}
