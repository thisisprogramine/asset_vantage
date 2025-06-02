
import 'package:asset_vantage/src/domain/entities/number_of_period/number_of_period.dart';

import '../../../../repositories/av_repository.dart';


class GetNetWorthSelectedNumberOfPeriod {
  final AVRepository _avRepository;

  GetNetWorthSelectedNumberOfPeriod(this._avRepository);

  Future<NumberOfPeriodItemData?> call(String tileName) async =>
      await _avRepository.getNetWorthSelectedNumberOfPeriod(tileName: tileName);
}

