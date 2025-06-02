
import '../../domain/entities/favorites/favorites_entity.dart';
import '../blocs/net_worth/net_worth_as_on_date/net_worth_as_on_date_cubit.dart';
import '../blocs/net_worth/net_worth_currency/net_worth_currency_cubit.dart';
import '../blocs/net_worth/net_worth_denomination/net_worth_denomination_cubit.dart';
import '../blocs/net_worth/net_worth_entity/net_worth_entity_cubit.dart';
import '../blocs/net_worth/net_worth_grouping/net_worth_grouping_cubit.dart';
import '../blocs/net_worth/net_worth_loading/net_worth_loading_cubit.dart';
import '../blocs/net_worth/net_worth_number_of_period/net_worth_number_of_period_cubit.dart';
import '../blocs/net_worth/net_worth_period/net_worth_period_cubit.dart';
import '../blocs/net_worth/net_worth_report/net_worth_report_cubit.dart';
import '../blocs/net_worth/net_worth_return_percent/net_worth_return_percent_cubit.dart';
import '../blocs/net_worth/net_worth_sub_grouping/net_worth_sub_grouping_cubit.dart';


class NetWorthArgument {
  final bool isFavorite;
  final Favorite? favorite;
  final NetWorthGroupingCubit netWorthPrimaryGroupingCubit;
  final NetWorthEntityCubit netWorthEntityCubit;
  final NetWorthPrimarySubGroupingCubit netWorthPrimarySubGroupingCubit;
  final NetWorthReportCubit netWorthReportCubit;
  final NetWorthPeriodCubit netWorthPeriodCubit;
  final NetWorthNumberOfPeriodCubit netWorthNumberOfPeriodCubit;
  final NetWorthReturnPercentCubit netWorthReturnPercentCubit;
  final NetWorthDenominationCubit netWorthDenominationCubit;
  final NetWorthCurrencyCubit netWorthCurrencyCubit;
  final NetWorthAsOnDateCubit netWorthAsOnDateCubit;
  final NetWorthLoadingCubit netWorthLoadingCubit;

  NetWorthArgument({
    this.isFavorite = false,
    this.favorite,
    required this.netWorthPrimaryGroupingCubit,
    required this.netWorthEntityCubit,
    required this.netWorthPrimarySubGroupingCubit,
    required this.netWorthReportCubit,
    required this.netWorthPeriodCubit,
    required this.netWorthNumberOfPeriodCubit,
    required this.netWorthReturnPercentCubit,
    required this.netWorthDenominationCubit,
    required this.netWorthCurrencyCubit,
    required this.netWorthAsOnDateCubit,
    required this.netWorthLoadingCubit,
  });
}