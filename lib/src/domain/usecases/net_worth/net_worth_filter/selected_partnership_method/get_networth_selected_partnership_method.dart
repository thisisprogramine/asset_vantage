import 'package:asset_vantage/src/domain/entities/partnership_method/partnership_method.dart';
import 'package:asset_vantage/src/domain/repositories/av_repository.dart';

class GetNetWorthSelectedPartnershipMethod{
  final AVRepository _avRepository;

  GetNetWorthSelectedPartnershipMethod(this._avRepository);

  Future<PartnershipMethodItemData?> call(String tileName) async =>
      await _avRepository.getNetWorthSelectedPartnershipMethod(tileName: tileName);

}