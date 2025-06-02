
import 'package:asset_vantage/src/domain/entities/number_of_period/number_of_period.dart';

import '../../../../repositories/av_repository.dart';


class GetCashBalanceSelectedNumberOfPeriod {
  final AVRepository _avRepository;

  GetCashBalanceSelectedNumberOfPeriod(this._avRepository);

  Future<NumberOfPeriodItemData?> call(String tileName) async =>
      await _avRepository.getCashBalanceSelectedNumberOfPeriod(tileName: tileName);
}
