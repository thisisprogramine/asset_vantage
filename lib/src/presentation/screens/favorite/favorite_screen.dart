
import 'dart:developer';

import 'package:asset_vantage/src/config/constants/favorite_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/arguments/income_report_argument.dart';
import 'package:asset_vantage/src/presentation/arguments/net_worth_argument.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_report/cash_balance_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/expense/expense_report/expense_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/favorites/favorites_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_report/income_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_report/net_worth_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_report/performance_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/universal_filter/as_on_date_universal_filter/universal_filter_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/universal_filter/enitity_universal_filter/universal_entity_filter_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/universal_filter/favourite_as_on_date_universal_filter/favourite_universal_filter_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/screens/favorite/favorite_cash_balance_widget.dart';
import 'package:asset_vantage/src/presentation/screens/favorite/favorite_net_worth_widget.dart';
import 'package:asset_vantage/src/presentation/screens/favorite/favourite_universal_as_on_date_filter.dart';
import 'package:asset_vantage/src/presentation/widgets/sliver_hidden_header.dart';
import 'package:asset_vantage/src/utilities/helper/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../config/constants/size_constants.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../arguments/cash_balance_argument.dart';
import '../../arguments/expense_report_argument.dart';
import '../../arguments/performance_argument.dart';
import '../../blocs/universal_filter/favourite_universal_filter_cubit.dart';
import '../../theme/theme_color.dart';
import '../../widgets/circular_progress.dart';
import '../../widgets/loading_widgets/loading_bg.dart';
import '../../widgets/favorite_slivers/sliver_reorderable_list.dart';
import '../cash_balance_report/cash_balance_filter_modal.dart';
import '../dashboard/dashboard_personalisation.dart';
import '../dashboard/net_worth_summary/net_worth_filter_modal.dart';
import '../dashboard/universal_filter/universal_as_on_date_filter.dart';
import '../expense_report/expense_universal_filter.dart';
import '../income_report/income_universal_filter.dart';
import '../performance_report/performance_universal_filter.dart';
import 'favorite_expense_widget.dart';
import 'favorite_income_widget.dart';
import 'favorite_performance_widget.dart';

class FavoritesScreen extends StatefulWidget {
  final UniversalEntityFilterCubit universalEntityFilterCubit;
  final FavouriteUniversalFilterAsOnDateCubit favouriteUniversalFilterAsOnDateCubit;
  final UniversalFilterAsOnDateCubit universalFilterAsOnDateCubit;
  final FavouriteUniversalFilterCubit favouriteUniversalFilterCubit;
  final CashBalanceArgument cashBalanceArgument;
  final PerformanceArgument performanceArgument;
  final NetWorthArgument netWorthArgument;
  final IncomeReportArgument incomeReportArgument;
  final ExpenseReportArgument expenseReportArgument;
  final Function() changeBool;
  final ScrollController scrollController;
  const FavoritesScreen({
    super.key,
    required this.universalFilterAsOnDateCubit,
    required this.universalEntityFilterCubit,
    required this.favouriteUniversalFilterCubit,
    required this.cashBalanceArgument,
    required this.performanceArgument,
    required this.netWorthArgument,
    required this.incomeReportArgument,
    required this.changeBool,
    required this.expenseReportArgument,
    required this.scrollController,
    required this.favouriteUniversalFilterAsOnDateCubit
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final ScrollController _scrollController = ScrollController();
  String? successMessage;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
        bloc: context.read<FavoritesCubit>(),
        builder: (context, state) {
          print("fav Build method: fav list ${state.favorites?.length}");
          if (state is FavoritesLoaded) {
            if (state.success != null) {
              successMessage = state.success?.message;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                FlashHelper.showToastMessage(context,
                    message: successMessage ?? "Success", type: ToastType.success);
              });
            } else if (state.error != null) {
              errorMessage = state.error?.message;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                FlashHelper.showToastMessage(context,
                    message: errorMessage ?? "Error", type: ToastType.error);
              });
            }
            state.success = null;
            state.error = null;
            if(state.favoritesList == null){
              return SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_14.w),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(Sizes.dimen_8.r),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_14.w, vertical: Sizes.dimen_4.h),
                      child: LoadingBg(
                        height: Sizes.dimen_58.h,
                        message: Message.loading,
                      ),
                    ),
                  ),
                ),
              );
            }
            if (state.favoritesList != null &&
                (state.favoritesList?.isNotEmpty ?? false)) {

              return SliverReorderableListWidget(
              changeBool: widget.changeBool,
                state: state,
                changeBoolFromDetails: () {},
                universalFilterAsOnDateCubit: widget.universalFilterAsOnDateCubit,
                universalEntityFilterCubit: widget.universalEntityFilterCubit,
                favouriteUniversalFilterAsOnDateCubit: widget.favouriteUniversalFilterAsOnDateCubit
              );

              print("");

              print("");
            } if(state.favoritesList!.isEmpty) {
              return SliverToBoxAdapter(
                child: Center(
                    child: DashboardPersonalisation(scrollController: widget.scrollController,)
                ),
              );
            }
          } else if (state is FavoritesLoading) {
            return SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_14.w),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(Sizes.dimen_8.r),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_14.w, vertical: Sizes.dimen_4.h),
                    child: LoadingBg(
                      height: Sizes.dimen_58.h,
                      message: Message.loading,
                    ),
                  ),
                ),
              ),
            );
          } else if (state is FavoritesError) {
            return SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_14.w),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(Sizes.dimen_8.r),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_14.w, vertical: Sizes.dimen_4.h),
                    child: LoadingBg(
                      height: Sizes.dimen_58.h,
                      message: Message.error,
                    ),
                  ),
                ),
              ),
            );
          }
          return SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_14.w),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(Sizes.dimen_8.r),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_14.w, vertical: Sizes.dimen_4.h),
                  child: LoadingBg(
                    height: Sizes.dimen_58.h,
                    message: Message.loading,
                  ),
                ),
              ),
            ),
          );
        });
  }
}
