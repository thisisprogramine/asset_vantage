
import 'package:asset_vantage/src/domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../../../data/models/cash_balance/cash_balance_grouping_model.dart';
import '../../../../repositories/av_repository.dart';


class GetCashBalanceSelectedPrimaryGrouping {
  final AVRepository _avRepository;

  GetCashBalanceSelectedPrimaryGrouping(this._avRepository);

  Future<PrimaryGrouping?> call(String? tileName,EntityData? entity) async =>
      await _avRepository.getCashBalanceSelectedPrimaryGrouping(tileName: tileName, entity: entity,);
}
