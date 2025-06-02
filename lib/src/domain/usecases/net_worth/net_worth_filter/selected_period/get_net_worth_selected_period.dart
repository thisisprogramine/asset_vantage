
import 'package:asset_vantage/src/domain/entities/period/period_enitity.dart';

import '../../../../repositories/av_repository.dart';

class GetNetWorthSelectedPeriod {
  final AVRepository _avRepository;

  GetNetWorthSelectedPeriod(this._avRepository);

  Future<PeriodItemData?> call(String tileName) async =>
      await _avRepository.getNetWorthSelectedPeriod(tileName: tileName);
}
