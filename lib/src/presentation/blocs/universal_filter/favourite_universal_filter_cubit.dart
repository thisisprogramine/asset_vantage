
import 'dart:developer';

import 'package:asset_vantage/src/config/constants/favorite_constants.dart';
import 'package:asset_vantage/src/data/models/dashboard/dashboard_entity_model.dart';
import 'package:asset_vantage/src/domain/usecases/universal_filters/clear_all_the_filters.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_report/cash_balance_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/expense/expense_report/expense_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_report/income_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_report/net_worth_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/universal_filter/as_on_date_universal_filter/universal_filter_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/universal_filter/enitity_universal_filter/universal_entity_filter_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/universal_filter/favourite_as_on_date_universal_filter/favourite_universal_filter_as_on_date_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/favorites/favorites_entity.dart';
import '../favorites/favorites_cubit.dart';
import '../performance/performance_report/performance_report_cubit.dart';

class FavouriteUniversalFilterCubit extends Cubit<bool> {
  final FavouriteUniversalFilterAsOnDateCubit favouriteUniversalFilterAsOnDateCubit;


  FavouriteUniversalFilterCubit({required this.favouriteUniversalFilterAsOnDateCubit})
      : super(false);

  Future<void> resetAllTheFavouriteAsOnDate({
    required BuildContext context,
    required List? reportCubitList,
    required bool isFavorite,
    required List<Favorite?>? favorites,

  }) async {
    for(int i = 0; i < (favorites?.length ?? 0); i++) {

      if(favorites?[i]?.reportId == "${FavoriteConstants.performanceId}") {
        (reportCubitList?[i] as PerformanceReportCubit).loadPerformanceReportForFavorites(
            context: context,
            favorite: favorites?[i],
            universalAsOnDate: favouriteUniversalFilterAsOnDateCubit.state.asOnDate,
          favoriteCubit: context.read<FavoritesCubit>(),
            tileName: "Performance"
        );
      }else if(favorites?[i]?.reportId == "${FavoriteConstants.cashBalanceId}") {
        (reportCubitList?[i] as CashBalanceReportCubit).loadCashBalanceReportForFavorites(
            context: context,
            tileName: "cash_balance",
            favorite: favorites?[i],
            universalAsOnDate: favouriteUniversalFilterAsOnDateCubit.state.asOnDate,
            favoriteCubit: context.read<FavoritesCubit>()
        );
      }if(favorites?[i]?.reportId == "${FavoriteConstants.incomeId}") {
        (reportCubitList?[i] as IncomeReportCubit).loadIncomeReportForFavorites(
            context: context,
            favorite: favorites?[i],
            universalAsOnDate: favouriteUniversalFilterAsOnDateCubit.state.asOnDate,
            favoriteCubit: context.read<FavoritesCubit>()
        );
      }else if(favorites?[i]?.reportId == "${FavoriteConstants.expenseId}") {
        (reportCubitList?[i] as ExpenseReportCubit).loadExpenseReportForFavorites(
            context: context,
            favorite: favorites?[i],
            universalAsOnDate: favouriteUniversalFilterAsOnDateCubit.state.asOnDate,
            favoriteCubit: context.read<FavoritesCubit>()
        );
      }else if(favorites?[i]?.reportId == "${FavoriteConstants.netWorthId}") {
        (reportCubitList?[i] as NetWorthReportCubit).loadNetWorthReportForFavorites(
            context: context,
            tileName: "NetWorth",
            favorite: favorites?[i],
            universalAsOnDate: favouriteUniversalFilterAsOnDateCubit.state.asOnDate,
            favoriteCubit: context.read<FavoritesCubit>()
        );
      }
    }
  }
}