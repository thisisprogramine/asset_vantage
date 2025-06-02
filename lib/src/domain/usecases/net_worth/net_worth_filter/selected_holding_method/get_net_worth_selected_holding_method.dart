import 'package:asset_vantage/src/domain/entities/partnership_method/holding_method_entities.dart';
import 'package:asset_vantage/src/domain/repositories/av_repository.dart';

class GetNetWorthSelectedHoldingMethod{
  final AVRepository _avRepository;

  GetNetWorthSelectedHoldingMethod(this._avRepository);

  Future<HoldingMethodItemData?> call(String tileName) async =>
      await _avRepository.getNetWorthSelectedHoldingMethod(tileName: tileName);


}