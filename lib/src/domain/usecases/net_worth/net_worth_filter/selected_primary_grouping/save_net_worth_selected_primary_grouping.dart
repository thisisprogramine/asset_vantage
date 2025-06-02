
import 'package:asset_vantage/src/data/models/net_worth/net_worth_grouping_model.dart';
import '../../../../repositories/av_repository.dart';


class SaveNetWorthSelectedPrimaryGrouping {
  final AVRepository _avRepository;

  SaveNetWorthSelectedPrimaryGrouping(this._avRepository);

  Future<void> call(PrimaryGrouping params) async =>
      await _avRepository.saveNetWorthSelectedPrimaryGrouping(response: params.toJson());
}
