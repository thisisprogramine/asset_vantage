import '../../../../../data/models/net_worth/net_worth_sub_grouping_model.dart';
import '../../../../repositories/av_repository.dart';


class GetNetWorthSelectedPrimarySubGrouping {
  final AVRepository _avRepository;

  GetNetWorthSelectedPrimarySubGrouping(this._avRepository);

  Future<List<SubGroupingItem?>?> call(Map<dynamic, dynamic> param) async =>
      await _avRepository.getNetWorthSelectedPrimarySubGrouping(requestBody: param);
}
