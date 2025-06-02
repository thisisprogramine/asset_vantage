
import 'package:asset_vantage/src/data/models/net_worth/net_worth_grouping_model.dart';
import '../../../../repositories/av_repository.dart';


class GetNetWorthSelectedPrimaryGrouping {
  final AVRepository _avRepository;

  GetNetWorthSelectedPrimaryGrouping(this._avRepository);

  Future<PrimaryGrouping?> call() async =>
      await _avRepository.getNetWorthSelectedPrimaryGrouping();
}
