
import 'package:asset_vantage/src/domain/entities/period/period_enitity.dart';

import '../../../../repositories/av_repository.dart';

class SaveNetWorthSelectedPeriod {
  final AVRepository _avRepository;

  SaveNetWorthSelectedPeriod(this._avRepository);

  Future<void> call(String tileName,PeriodItemData params) async =>
      await _avRepository.saveNetWorthSelectedPeriod(response: params.toJson(), tileName: tileName);
}
