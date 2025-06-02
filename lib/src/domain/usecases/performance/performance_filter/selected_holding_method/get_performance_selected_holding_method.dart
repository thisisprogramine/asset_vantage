import 'package:asset_vantage/src/domain/entities/partnership_method/holding_method_entities.dart';
import 'package:asset_vantage/src/domain/repositories/av_repository.dart';

class GetPerformanceSelectedHoldingMethod{
  final AVRepository _avRepository;

  GetPerformanceSelectedHoldingMethod(this._avRepository);

  Future<HoldingMethodItemData?> call(String tileName) async =>
      await _avRepository.getPerformanceSelectedHoldingMethod(tileName: tileName);

}