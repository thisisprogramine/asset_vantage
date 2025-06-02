import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/domain/entities/favorites/favorites_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../config/constants/favorite_constants.dart';
import '../../../config/constants/route_constants.dart';
import '../../../config/constants/size_constants.dart';
import '../../blocs/expense/expense_account/expense_account_cubit.dart';
import '../../blocs/expense/expense_as_on_date/expense_as_on_date_cubit.dart';
import '../../blocs/expense/expense_chart/expense_chart_cubit.dart';
import '../../blocs/expense/expense_currency/expense_currency_cubit.dart';
import '../../blocs/expense/expense_denomination/expense_denomination_cubit.dart';
import '../../blocs/expense/expense_entity/expense_entity_cubit.dart';
import '../../blocs/expense/expense_loading/expense_loading_cubit.dart';
import '../../blocs/expense/expense_number_of_period/expense_number_of_period_cubit.dart';
import '../../blocs/expense/expense_period/expense_period_cubit.dart';
import '../../blocs/expense/expense_report/expense_report_cubit.dart';
import '../../blocs/expense/expense_sort_cubit/expense_sort_cubit.dart';
import '../../blocs/favorites/favorites_cubit.dart';
import '../../blocs/universal_filter/as_on_date_universal_filter/universal_filter_as_on_date_cubit.dart';
import '../../blocs/universal_filter/enitity_universal_filter/universal_entity_filter_cubit.dart';
import '../../blocs/universal_filter/favourite_as_on_date_universal_filter/favourite_universal_filter_as_on_date_cubit.dart';
import '../../theme/theme_color.dart';
import '../dashboard/highlights/expense_highlight_widget.dart';

class FavoriteExpenseWidget extends StatefulWidget {
  final Favorite? favorite;
  final ExpenseReportCubit expenseReportCubit;
  final UniversalEntityFilterCubit universalEntityFilterCubit;
  final UniversalFilterAsOnDateCubit universalFilterAsOnDateCubit;
  final FavouriteUniversalFilterAsOnDateCubit favouriteUniversalFilterAsOnDateCubit;
  final ScrollController? scrollController;
  const FavoriteExpenseWidget({
    super.key,
    required this.favorite,
    required this.universalEntityFilterCubit,
    required this.universalFilterAsOnDateCubit,
    required this.favouriteUniversalFilterAsOnDateCubit,
    required this.expenseReportCubit,
    required this.scrollController,
  });

  @override
  State<FavoriteExpenseWidget> createState() => _FavoriteExpenseWidgetState();
}

class _FavoriteExpenseWidgetState extends State<FavoriteExpenseWidget>
    with TickerProviderStateMixin {

  late final ExpenseReportCubit expenseReportCubit;
  late final ExpenseSortCubit expenseSortCubit;
  late final ExpenseEntityCubit expenseEntityCubit;
  late final ExpenseAccountCubit expenseAccountCubit;
  late final ExpensePeriodCubit expensePeriodCubit;
  late final ExpenseNumberOfPeriodCubit expenseNumberOfPeriodCubit;
  late final ExpenseChartCubit expenseChartCubit;
  late final ExpenseCurrencyCubit expenseCurrencyCubit;
  late final ExpenseDenominationCubit expenseDenominationCubit;
  late final ExpenseAsOnDateCubit expenseAsOnDateCubit;
  late final ExpenseLoadingCubit expenseLoadingCubit;

  @override
  void initState() {
    super.initState();
    expenseReportCubit = widget.expenseReportCubit;
    expenseSortCubit = widget.expenseReportCubit.expenseSortCubit;
    expenseEntityCubit = widget.expenseReportCubit.expenseEntityCubit;
    expenseAccountCubit = widget.expenseReportCubit.expenseAccountCubit;
    expensePeriodCubit = widget.expenseReportCubit.expensePeriodCubit;
    expenseNumberOfPeriodCubit =
        widget.expenseReportCubit.expenseNumberOfPeriodCubit;
    expenseChartCubit = expenseNumberOfPeriodCubit.expenseChartCubit;
    expenseCurrencyCubit = widget.expenseReportCubit.expenseCurrencyCubit;
    expenseDenominationCubit =
        widget.expenseReportCubit.expenseDenominationCubit;
    expenseAsOnDateCubit = widget.expenseReportCubit.expenseAsOnDateCubit;
    expenseLoadingCubit = widget.expenseReportCubit.expenseLoadingCubit;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: expenseReportCubit,
        ),
        BlocProvider.value(
          value: expenseSortCubit,
        ),
        BlocProvider.value(
          value: expenseEntityCubit,
        ),
        BlocProvider.value(
          value: expenseAccountCubit,
        ),
        BlocProvider.value(
          value: expensePeriodCubit,
        ),
        BlocProvider.value(
          value: expenseNumberOfPeriodCubit,
        ),
        BlocProvider.value(
          value: expenseChartCubit,
        ),
        BlocProvider.value(
          value: expenseCurrencyCubit,
        ),
        BlocProvider.value(
          value: expenseDenominationCubit,
        ),
        BlocProvider.value(
          value: expenseAsOnDateCubit,
        ),
      ],
      child: Slidable(
        child: ExpenseHighlightWidget(
          isFavorite: true,
          favorite: widget.favorite,
          isDetailScreen: false,
          expenseReportCubit: expenseReportCubit,
          expenseSortCubit: expenseSortCubit,
          expenseEntityCubit: expenseEntityCubit,
          expenseLoadingCubit: expenseLoadingCubit,
          universalEntityFilterCubit: widget.universalEntityFilterCubit,
          universalFilterAsOnDateCubit: widget.universalFilterAsOnDateCubit,
          favouriteUniversalFilterAsOnDateCubit: widget.favouriteUniversalFilterAsOnDateCubit,
          expenseAsOnDateCubit: expenseAsOnDateCubit,
          expensePeriodCubit: expensePeriodCubit,
          expenseNumberOfPeriodCubit: expenseNumberOfPeriodCubit,
          expenseChartCubit: expenseChartCubit,
          expenseAccountCubit: expenseAccountCubit,
          expenseDenominationCubit: expenseDenominationCubit,
          expenseCurrencyCubit: expenseCurrencyCubit,
        ),
      ),
    );
  }
}
