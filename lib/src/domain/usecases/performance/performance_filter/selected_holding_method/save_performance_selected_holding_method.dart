import 'package:asset_vantage/src/domain/entities/partnership_method/holding_method_entities.dart';
import 'package:asset_vantage/src/domain/repositories/av_repository.dart';

class SavePerformanceSelectedHoldingMethod{
  final AVRepository _avRepository;

  SavePerformanceSelectedHoldingMethod(this._avRepository);

  Future<void> call(String tileName,HoldingMethodItemData param) async =>
      await _avRepository.savePerformanceSelectedHoldingMethod(
          tileName: tileName, response: param.toJson());

}