
import 'package:asset_vantage/src/domain/entities/period/period_enitity.dart';

import '../../../../repositories/av_repository.dart';


class SaveCashBalanceSelectedPeriod {
  final AVRepository _avRepository;

  SaveCashBalanceSelectedPeriod(this._avRepository);

  Future<void> call(String tileName,PeriodItemData params) async =>
      await _avRepository.saveCashBalanceSelectedPeriod(response: params.toJson(), tileName: tileName);
}
