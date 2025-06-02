import 'package:asset_vantage/src/domain/entities/partnership_method/partnership_method.dart';
import 'package:asset_vantage/src/domain/repositories/av_repository.dart';

class SaveNetWorthSelectedPartnershipMethod{
  final AVRepository _avRepository;

  SaveNetWorthSelectedPartnershipMethod(this._avRepository);

  Future<void> call(String tileName,PartnershipMethodItemData param) async =>
      await _avRepository.saveNetWorthSelectedPartnershipMethod(tileName: tileName, response: param.toJson());

}