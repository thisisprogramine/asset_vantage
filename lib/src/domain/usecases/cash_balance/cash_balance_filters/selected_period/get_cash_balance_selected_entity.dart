
import 'package:asset_vantage/src/domain/entities/period/period_enitity.dart';

import '../../../../repositories/av_repository.dart';


class GetCashBalanceSelectedPeriod {
  final AVRepository _avRepository;

  GetCashBalanceSelectedPeriod(this._avRepository);

  Future<PeriodItemData?> call(String tileName) async =>
      await _avRepository.getCashBalanceSelectedPeriod(tileName: tileName);
}
