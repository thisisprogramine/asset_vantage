import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../config/constants/favorite_constants.dart';
import '../../../config/constants/route_constants.dart';
import '../../../config/constants/size_constants.dart';
import '../../../domain/entities/favorites/favorites_entity.dart';
import '../../blocs/favorites/favorites_cubit.dart';
import '../../blocs/income/income_account/income_account_cubit.dart';
import '../../blocs/income/income_as_on_date/income_as_on_date_cubit.dart';
import '../../blocs/income/income_chart/income_chart_cubit.dart';
import '../../blocs/income/income_currency/income_currency_cubit.dart';
import '../../blocs/income/income_denomination/income_denomination_cubit.dart';
import '../../blocs/income/income_entity/income_entity_cubit.dart';
import '../../blocs/income/income_loading/income_loading_cubit.dart';
import '../../blocs/income/income_number_of_period/income_number_of_period_cubit.dart';
import '../../blocs/income/income_period/income_period_cubit.dart';
import '../../blocs/income/income_report/income_report_cubit.dart';
import '../../blocs/income/income_sort_cubit/income_sort_cubit.dart';
import '../../blocs/universal_filter/as_on_date_universal_filter/universal_filter_as_on_date_cubit.dart';
import '../../blocs/universal_filter/enitity_universal_filter/universal_entity_filter_cubit.dart';
import '../../blocs/universal_filter/favourite_as_on_date_universal_filter/favourite_universal_filter_as_on_date_cubit.dart';
import '../../theme/theme_color.dart';
import '../dashboard/highlights/income_highlight_widget.dart';

class FavoriteIncomeWidget extends StatefulWidget {
  final Favorite? favorite;
  final IncomeReportCubit incomeReportCubit;
  final UniversalEntityFilterCubit universalEntityFilterCubit;
  final UniversalFilterAsOnDateCubit universalFilterAsOnDateCubit;
  final FavouriteUniversalFilterAsOnDateCubit favouriteUniversalFilterAsOnDateCubit;
  final ScrollController? scrollController;
  const FavoriteIncomeWidget({
    super.key,
    required this.favorite,
    required this.universalEntityFilterCubit,
    required this.universalFilterAsOnDateCubit,
    required this.favouriteUniversalFilterAsOnDateCubit,
    required this.incomeReportCubit,
    required this.scrollController,
  });

  @override
  State<FavoriteIncomeWidget> createState() => _FavoriteIncomeWidgetState();
}

class _FavoriteIncomeWidgetState extends State<FavoriteIncomeWidget>
    with TickerProviderStateMixin {

  late final IncomeReportCubit incomeReportCubit;
  late final IncomeSortCubit incomeSortCubit;
  late final IncomeEntityCubit incomeEntityCubit;
  late final IncomeAccountCubit incomeAccountCubit;
  late final IncomePeriodCubit incomePeriodCubit;
  late final IncomeNumberOfPeriodCubit incomeNumberOfPeriodCubit;
  late final IncomeChartCubit incomeChartCubit;
  late final IncomeCurrencyCubit incomeCurrencyCubit;
  late final IncomeDenominationCubit incomeDenominationCubit;
  late final IncomeAsOnDateCubit incomeAsOnDateCubit;
  late final IncomeLoadingCubit incomeLoadingCubit;

  @override
  void initState() {
    super.initState();
    incomeReportCubit = widget.incomeReportCubit;
    incomeSortCubit = widget.incomeReportCubit.incomeSortCubit;
    incomeEntityCubit = widget.incomeReportCubit.incomeEntityCubit;
    incomeAccountCubit = widget.incomeReportCubit.incomeAccountCubit;
    incomePeriodCubit = widget.incomeReportCubit.incomePeriodCubit;
    incomeNumberOfPeriodCubit =
        widget.incomeReportCubit.incomeNumberOfPeriodCubit;
    incomeChartCubit = incomeNumberOfPeriodCubit.incomeChartCubit;
    incomeCurrencyCubit = widget.incomeReportCubit.incomeCurrencyCubit;
    incomeDenominationCubit = widget.incomeReportCubit.incomeDenominationCubit;
    incomeAsOnDateCubit = widget.incomeReportCubit.incomeAsOnDateCubit;
    incomeLoadingCubit = widget.incomeReportCubit.incomeLoadingCubit;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: incomeReportCubit,
        ),
        BlocProvider.value(
          value: incomeSortCubit,
        ),
        BlocProvider.value(
          value: incomeEntityCubit,
        ),
        BlocProvider.value(
          value: incomeAccountCubit,
        ),
        BlocProvider.value(
          value: incomePeriodCubit,
        ),
        BlocProvider.value(
          value: incomeNumberOfPeriodCubit,
        ),
        BlocProvider.value(
          value: incomeChartCubit,
        ),
        BlocProvider.value(
          value: incomeCurrencyCubit,
        ),
        BlocProvider.value(
          value: incomeDenominationCubit,
        ),
        BlocProvider.value(
          value: incomeAsOnDateCubit,
        ),
      ],
      child: Slidable(
        child: IncomeHighlightWidget(
          incomeLoadingCubit: incomeLoadingCubit,
          isFavorite: true,
          favorite: widget.favorite,
          isDetailScreen: false,
          incomeReportCubit: incomeReportCubit,
          incomeSortCubit: incomeSortCubit,
          incomeEntityCubit: incomeEntityCubit,
          incomeAsOnDateCubit: incomeAsOnDateCubit,
          incomePeriodCubit: incomePeriodCubit,
          incomeNumberOfPeriodCubit: incomeNumberOfPeriodCubit,
          incomeChartCubit: incomeChartCubit,
          incomeAccountCubit: incomeAccountCubit,
          universalEntityFilterCubit: widget.universalEntityFilterCubit,
          universalFilterAsOnDateCubit: widget.universalFilterAsOnDateCubit,
          favouriteUniversalFilterAsOnDateCubit: widget.favouriteUniversalFilterAsOnDateCubit,
          incomeDenominationCubit: incomeDenominationCubit,
          incomeCurrencyCubit: incomeCurrencyCubit,
        ),
      ),
    );
  }
}
