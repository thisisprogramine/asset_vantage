import 'package:asset_vantage/src/domain/entities/partnership_method/partnership_method.dart';
import 'package:asset_vantage/src/domain/repositories/av_repository.dart';

class SavePerformanceSelectedPartnershipMethod{
  final AVRepository _avRepository;

  SavePerformanceSelectedPartnershipMethod(this._avRepository);

  Future<void> call(String tileName,PartnershipMethodItemData param) async=>
      await _avRepository.savePerformanceSelectedPartnershipMethod(tileName: tileName, response: param.toJson());

}