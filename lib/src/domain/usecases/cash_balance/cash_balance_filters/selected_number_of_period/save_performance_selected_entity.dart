
import 'package:asset_vantage/src/domain/entities/number_of_period/number_of_period.dart';
import 'package:asset_vantage/src/domain/entities/period/period_enitity.dart';

import '../../../../repositories/av_repository.dart';


class SaveCashBalanceSelectedNumberOfPeriod {
  final AVRepository _avRepository;

  SaveCashBalanceSelectedNumberOfPeriod(this._avRepository);

  Future<void> call(String tileName,NumberOfPeriodItemData params) async =>
      await _avRepository.saveCashBalanceSelectedNumberOfPeriod(response: params.toJson(), tileName: tileName);
}
