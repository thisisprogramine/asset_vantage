
import '../../../../../data/models/net_worth/net_worth_return_percent_model.dart';
import '../../../../repositories/av_repository.dart';


class GetNetWorthSelectedReturnPercent {
  final AVRepository _avRepository;

  GetNetWorthSelectedReturnPercent(this._avRepository);

  Future<ReturnPercentItem?> call() async =>
      await _avRepository.getNetWorthSelectedReturnPercent();
}
