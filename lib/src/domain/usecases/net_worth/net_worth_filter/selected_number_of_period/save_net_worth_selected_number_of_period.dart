
import 'package:asset_vantage/src/domain/entities/number_of_period/number_of_period.dart';

import '../../../../repositories/av_repository.dart';


class SaveNetWorthSelectedNumberOfPeriod {
  final AVRepository _avRepository;

  SaveNetWorthSelectedNumberOfPeriod(this._avRepository);

  Future<void> call(String tileName,NumberOfPeriodItemData params) async =>
      await _avRepository.saveNetWorthSelectedNumberOfPeriod(response: params.toJson(), tileName: tileName);
}
