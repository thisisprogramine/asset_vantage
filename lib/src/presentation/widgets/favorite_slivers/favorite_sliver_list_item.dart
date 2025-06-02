import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/presentation/blocs/universal_filter/favourite_as_on_date_universal_filter/favourite_universal_filter_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/widgets/custom_popup_menu.dart';
import 'package:asset_vantage/src/presentation/widgets/delete_favorite_dialog.dart';
import 'package:asset_vantage/src/presentation/widgets/filter_icon.dart';
import 'package:flutter/material.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/constants/favorite_constants.dart';
import '../../../config/constants/size_constants.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../blocs/cash_balance/cash_balance_report/cash_balance_report_cubit.dart';
import '../../blocs/expense/expense_report/expense_report_cubit.dart';
import '../../blocs/favorites/favorites_cubit.dart';
import '../../blocs/income/income_report/income_report_cubit.dart';
import '../../blocs/net_worth/net_worth_report/net_worth_report_cubit.dart';
import '../../blocs/performance/performance_report/performance_report_cubit.dart';
import '../../blocs/universal_filter/as_on_date_universal_filter/universal_filter_as_on_date_cubit.dart';
import '../../blocs/universal_filter/enitity_universal_filter/universal_entity_filter_cubit.dart';
import '../../screens/cash_balance_report/cash_balance_filter_modal.dart';
import '../../screens/dashboard/net_worth_summary/net_worth_filter_modal.dart';
import '../../screens/expense_report/expense_universal_filter.dart';
import '../../screens/favorite/favorite_cash_balance_widget.dart';
import '../../screens/favorite/favorite_expense_widget.dart';
import '../../screens/favorite/favorite_income_widget.dart';
import '../../screens/favorite/favorite_net_worth_widget.dart';
import '../../screens/favorite/favorite_performance_widget.dart';
import '../../screens/income_report/income_universal_filter.dart';
import '../../screens/performance_report/performance_universal_filter.dart';
import '../../theme/theme_color.dart';

class FavoriteSliverListItem extends StatefulWidget {
  final int index;
  final FavoritesLoaded state;
  final Function() changeBool;
  final Function() changeBoolFromDetails;
  final UniversalEntityFilterCubit universalEntityFilterCubit;
  final UniversalFilterAsOnDateCubit universalFilterAsOnDateCubit;
  final FavouriteUniversalFilterAsOnDateCubit favouriteUniversalFilterAsOnDateCubit;
  const FavoriteSliverListItem({
    super.key,
    required this.index,
    required this.state,
    required this.changeBool,
    required this.changeBoolFromDetails,
    required this.universalEntityFilterCubit,
    required this.universalFilterAsOnDateCubit,
    required this.favouriteUniversalFilterAsOnDateCubit,
  });

  @override
  State<FavoriteSliverListItem> createState() => _FavoriteSliverListItemState();
}

class _FavoriteSliverListItemState extends State<FavoriteSliverListItem> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.state.favoritesList?[widget.index].reportId ==
        "${FavoriteConstants.performanceId}") {
      return ReorderableDelayedDragStartListener(
        key: Key("${widget.index}"),
        index: widget.index,
        child: widget.state.favoritesList?[widget.index].filter != null
            ? Padding(
          key: ValueKey(widget.state.favoritesList?[widget.index].id),
          padding: EdgeInsets.symmetric(
              horizontal: Sizes.dimen_10.w,
              vertical: Sizes.dimen_1.h),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(Sizes.dimen_8.r),
              ),
            ),
            child: FavoritePerformanceWidget(
              universalEntityFilterCubit: widget.universalEntityFilterCubit,
              universalFilterAsOnDateCubit: widget.universalFilterAsOnDateCubit,
              favouriteUniversalFilterAsOnDateCubit: widget.favouriteUniversalFilterAsOnDateCubit,
              favorite: widget.state.favoritesList?[widget.index],
              performanceReportCubit:
              widget.state.reportCubitList?[widget.index],
              scrollController: null,
            ),
          ),
        )
            : BlankWidget(
          reportId: FavoriteConstants.performanceId,
          popupMenu: CustomPopupMenu(showCopy: false, onSelect: (int popUpIndex) async {
            if (popUpIndex == 1) {
              DeleteFavoriteDialog.show(context: context,
              onCancel: (){
                Navigator.of(context).pop();
              },
              onDelete: (){
                context
                    .read<FavoritesCubit>()
                    .removeFavorites(
                    context: context,
                    favorite: widget.state.favoritesList?[widget.index]);
                Navigator.of(context).pop();
              });
            }
          }),
          universalFilter: PerformanceUniversalFilter(
            fromBlankWidget: true,
            changeBool: widget.changeBool,
            changeBoolFromDetails: widget.changeBoolFromDetails,
            favorite:
            widget.state.favoritesList?[widget.index],
            isFavorite: true,
            performanceEntityCubit:
            (widget.state.reportCubitList?[widget.index] as PerformanceReportCubit).performanceEntityCubit,
            performancePrimaryGroupingCubit:
            (widget.state.reportCubitList?[widget.index] as PerformanceReportCubit).performancePrimaryGroupingCubit,
            performanceSecondaryGroupingCubit:
            (widget.state.reportCubitList?[widget.index] as PerformanceReportCubit).performanceSecondaryGroupingCubit,
            performancePrimarySubGroupingCubit:
            (widget.state.reportCubitList?[widget.index] as PerformanceReportCubit).performancePrimarySubGroupingCubit,
            performanceSecondarySubGroupingCubit:
            (widget.state.reportCubitList?[widget.index] as PerformanceReportCubit).performanceSecondarySubGroupingCubit,
            performancePeriodCubit:
            (widget.state.reportCubitList?[widget.index] as PerformanceReportCubit).performancePeriodCubit,
            performanceNumberOfPeriodCubit:
            (widget.state.reportCubitList?[widget.index] as PerformanceReportCubit).performanceNumberOfPeriodCubit,
            performanceReturnPercentCubit:
            (widget.state.reportCubitList?[widget.index] as PerformanceReportCubit).performanceReturnPercentCubit,
            performanceCurrencyCubit:
            (widget.state.reportCubitList?[widget.index] as PerformanceReportCubit).performanceCurrencyCubit,
            performanceDenominationCubit:
            (widget.state.reportCubitList?[widget.index] as PerformanceReportCubit).performanceDenominationCubit,
            performanceAsOnDateCubit:
            (widget.state.reportCubitList?[widget.index] as PerformanceReportCubit).performanceAsOnDateCubit,
            performanceReportCubit:
            (widget.state.reportCubitList?[widget.index] as PerformanceReportCubit),
            performanceLoadingCubit:
            (widget.state.reportCubitList?[widget.index] as PerformanceReportCubit).performanceLoadingCubit,
            performancePartnershipMethodCubit:
            (widget.state.reportCubitList?[widget.index] as PerformanceReportCubit).performancePartnershipMethodCubit,
            performanceHoldingMethodCubit:
            (widget.state.reportCubitList?[widget.index] as PerformanceReportCubit).performanceHoldingMethodCubit,
          ),
        ),
      );
    } else if (widget.state.favoritesList?[widget.index].reportId ==
        "${FavoriteConstants.incomeId}") {
      return ReorderableDelayedDragStartListener(
        key: Key("${widget.index}"),
        index: widget.index,
        child: widget.state.favoritesList?[widget.index].filter != null
            ? Padding(
          key: ValueKey(widget.state.favoritesList?[widget.index].id),
          padding: EdgeInsets.symmetric(
              horizontal: Sizes.dimen_10.w,
              vertical: Sizes.dimen_1.h),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(Sizes.dimen_8.r),
              ),
            ),
            child: FavoriteIncomeWidget(
              universalEntityFilterCubit: widget.universalEntityFilterCubit,
              universalFilterAsOnDateCubit: widget.universalFilterAsOnDateCubit,
              favouriteUniversalFilterAsOnDateCubit: widget.favouriteUniversalFilterAsOnDateCubit,
              favorite: widget.state.favoritesList?[widget.index],
              incomeReportCubit: widget.state.reportCubitList?[widget.index],
              scrollController: null,
            ),
          ),
        )
            : BlankWidget(
          reportId: FavoriteConstants.incomeId,
          popupMenu: CustomPopupMenu(showCopy: false, onSelect: (int popUpIndex) async {
            if (popUpIndex == 1) {
              DeleteFavoriteDialog.show(context: context,
                  onCancel: (){
                    Navigator.of(context).pop();
                  },
                  onDelete: (){
                    context
                        .read<FavoritesCubit>()
                        .removeFavorites(
                        context: context,
                        favorite: widget.state.favoritesList?[widget.index]);
                    Navigator.of(context).pop();
                  }
              );

            }
          }),
          universalFilter: IncomeUniversalFilter(
            fromBlankWidget: true,
            favorite: widget.state.favoritesList?[widget.index],
            isFavorite: true,
            incomeLoadingCubit:
            (widget.state.reportCubitList?[widget.index] as IncomeReportCubit).incomeLoadingCubit,
            incomeEntityCubit: (widget.state.reportCubitList?[widget.index] as IncomeReportCubit).incomeEntityCubit,
            incomeAccountCubit:
            (widget.state.reportCubitList?[widget.index] as IncomeReportCubit).incomeAccountCubit,
            incomeNumberOfPeriodCubit:
            (widget.state.reportCubitList?[widget.index] as IncomeReportCubit).incomeNumberOfPeriodCubit,
            incomeCurrencyCubit:
            (widget.state.reportCubitList?[widget.index] as IncomeReportCubit).incomeCurrencyCubit,
            incomeDenominationCubit:
            (widget.state.reportCubitList?[widget.index] as IncomeReportCubit).incomeDenominationCubit,
            incomeAsOnDateCubit:
            (widget.state.reportCubitList?[widget.index] as IncomeReportCubit).incomeAsOnDateCubit,
            incomePeriodCubit: (widget.state.reportCubitList?[widget.index] as IncomeReportCubit).incomePeriodCubit,
            incomeReportCubit: (widget.state.reportCubitList?[widget.index] as IncomeReportCubit),
          ),
        ),
      );
    } else if (widget.state.favoritesList?[widget.index].reportId ==
        "${FavoriteConstants.expenseId}") {
      return ReorderableDelayedDragStartListener(
        key: Key("${widget.index}"),
        index: widget.index,
        child: widget.state.favoritesList?[widget.index].filter != null
            ? Padding(
          key: ValueKey(widget.state.favoritesList?[widget.index].id),
          padding: EdgeInsets.symmetric(
              horizontal: Sizes.dimen_10.w,
              vertical: Sizes.dimen_1.h),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(Sizes.dimen_8.r),
              ),
            ),
            child: FavoriteExpenseWidget(
              favorite: widget.state.favoritesList?[widget.index],
              universalEntityFilterCubit: widget.universalEntityFilterCubit,
              universalFilterAsOnDateCubit: widget.universalFilterAsOnDateCubit,
              favouriteUniversalFilterAsOnDateCubit: widget.favouriteUniversalFilterAsOnDateCubit,
              expenseReportCubit: widget.state.reportCubitList?[widget.index],
              scrollController: null,
            ),
          ),
        )
            : BlankWidget(reportId: FavoriteConstants.expenseId, popupMenu: CustomPopupMenu(showCopy: false, onSelect: (int popUpIndex) async {
          if (popUpIndex == 1) {
            DeleteFavoriteDialog.show(context: context,
            onCancel: (){
              Navigator.of(context).pop();
            },
            onDelete: (){
              context
                  .read<FavoritesCubit>()
                  .removeFavorites(
                  context: context,
                  favorite: widget.state.favoritesList?[widget.index]);
              Navigator.of(context).pop();
            });
          }
        }), universalFilter: ExpenseUniversalFilter(
          fromBlankWidget: true,
          favorite: widget.state.favoritesList?[widget.index],
          isFavorite: true,
          expenseEntityCubit:
          (widget.state.reportCubitList?[widget.index] as ExpenseReportCubit).expenseEntityCubit,
          expenseLoadingCubit:
          (widget.state.reportCubitList?[widget.index] as ExpenseReportCubit).expenseLoadingCubit,
          expenseAccountCubit:
          (widget.state.reportCubitList?[widget.index] as ExpenseReportCubit).expenseAccountCubit,
          expenseNumberOfPeriodCubit: (widget.state.reportCubitList?[widget.index] as ExpenseReportCubit).expenseNumberOfPeriodCubit,
          expenseCurrencyCubit:
          (widget.state.reportCubitList?[widget.index] as ExpenseReportCubit).expenseCurrencyCubit,
          expenseDenominationCubit: (widget.state.reportCubitList?[widget.index] as ExpenseReportCubit).expenseDenominationCubit,
          expenseAsOnDateCubit:
          (widget.state.reportCubitList?[widget.index] as ExpenseReportCubit).expenseAsOnDateCubit,
          expensePeriodCubit:
          (widget.state.reportCubitList?[widget.index] as ExpenseReportCubit).expensePeriodCubit,
          expenseReportCubit:
          (widget.state.reportCubitList?[widget.index] as ExpenseReportCubit),
        )),
      );
    } else if (widget.state.favoritesList?[widget.index].reportId ==
        "${FavoriteConstants.cashBalanceId}") {
      return ReorderableDelayedDragStartListener(
        key: Key("${widget.index}"),
        index: widget.index,
        child: widget.state.favoritesList?[widget.index].filter != null
            ? Padding(
          key: ValueKey(widget.state.favoritesList?[widget.index].id),
          padding: EdgeInsets.symmetric(
              horizontal: Sizes.dimen_10.w,
              vertical: Sizes.dimen_1.h),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(Sizes.dimen_8.r),
              ),
            ),
            child: FavoriteCashBalanceWidget(
              universalEntityFilterCubit: widget.universalEntityFilterCubit,
              universalFilterAsOnDateCubit: widget.universalFilterAsOnDateCubit,
              favouriteUniversalFilterAsOnDateCubit: widget.favouriteUniversalFilterAsOnDateCubit,
              favorite: widget.state.favoritesList?[widget.index],
              cashBalanceReportCubit:
              widget.state.reportCubitList?[widget.index],
              scrollController: null,
            ),
          ),
        )
            : BlankWidget(reportId: FavoriteConstants.cashBalanceId, popupMenu: CustomPopupMenu(showCopy: false, onSelect: (int popUpIndex) async {
          if (popUpIndex == 1) {
            DeleteFavoriteDialog.show(context: context,
            onCancel: (){
              Navigator.of(context).pop();
            },
            onDelete: (){
              context
                  .read<FavoritesCubit>()
                  .removeFavorites(
                  context: context,
                  favorite: widget.state.favoritesList?[widget.index]);
              Navigator.of(context).pop();
            });
          }
        },), universalFilter: CashBalanceFilterModal(
          fromBlankWidget: true,
          favorite: widget.state.favoritesList?[widget.index],
          isFavorite: true,
          cashBalanceEntityCubit: (widget.state.reportCubitList?[widget.index] as CashBalanceReportCubit).
          cashBalanceEntityCubit,
          cashBalanceLoadingCubit: (widget.state.reportCubitList?[widget.index] as CashBalanceReportCubit).
          cashBalanceLoadingCubit,
          cashBalanceSortCubit: (widget.state.reportCubitList?[widget.index] as CashBalanceReportCubit).
          cashBalanceSortCubit,
          cashBalancePrimaryGroupingCubit: (widget.state.reportCubitList?[widget.index] as CashBalanceReportCubit).
          cashBalancePrimaryGroupingCubit,
          cashBalancePrimarySubGroupingCubit: (widget.state.reportCubitList?[widget.index] as CashBalanceReportCubit). cashBalancePrimarySubGroupingCubit,
          cashBalanceAsOnDateCubit: (widget.state.reportCubitList?[widget.index] as CashBalanceReportCubit).
          cashBalanceAsOnDateCubit,
          cashBalanceCurrencyCubit: (widget.state.reportCubitList?[widget.index] as CashBalanceReportCubit).
          cashBalanceCurrencyCubit,
          cashBalanceDenominationCubit: (widget.state.reportCubitList?[widget.index] as CashBalanceReportCubit).
          cashBalanceDenominationCubit,
          cashBalanceNumberOfPeriodCubit: (widget.state.reportCubitList?[widget.index] as CashBalanceReportCubit).
          cashBalanceNumberOfPeriodCubit,
          cashBalancePeriodCubit: (widget.state.reportCubitList?[widget.index] as CashBalanceReportCubit).
          cashBalancePeriodCubit,
          cashBalanceReportCubit: (widget.state.reportCubitList?[widget.index] as CashBalanceReportCubit),
          cashBalanceAccountCubit: (widget.state.reportCubitList?[widget.index] as CashBalanceReportCubit).
          cashBalanceAccountCubit,
        )),
      );
    } else if (widget.state.favoritesList?[widget.index].reportId ==
        "${FavoriteConstants.netWorthId}") {
      return ReorderableDelayedDragStartListener(
        key: Key("${widget.index}"),
        index: widget.index,
        child: widget.state.favoritesList?[widget.index].filter != null
            ? Padding(
          key: ValueKey(widget.state.favoritesList?[widget.index].id),
          padding: EdgeInsets.symmetric(
              horizontal: Sizes.dimen_10.w,
              vertical: Sizes.dimen_1.h),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(Sizes.dimen_8.r),
              ),
            ),
            child: FavoriteNetWorthWidget(
              universalEntityFilterCubit: widget.universalEntityFilterCubit,
              favouriteUniversalFilterAsOnDateCubit: widget.favouriteUniversalFilterAsOnDateCubit,
              universalFilterAsOnDateCubit: widget.universalFilterAsOnDateCubit,
              favorite: widget.state.favoritesList?[widget.index],
              netWorthReportCubit:
              widget.state.reportCubitList?[widget.index],
              scrollController: null,
            ),
          ),
        )
            : BlankWidget(reportId: FavoriteConstants.netWorthId, popupMenu: CustomPopupMenu(showCopy: false, onSelect: (int popUpIndex) async {
          if (popUpIndex == 1) {
            DeleteFavoriteDialog.show(context: context,
                onCancel: (){
                  Navigator.of(context).pop();
                },
                onDelete: (){
                  context
                      .read<FavoritesCubit>()
                      .removeFavorites(
                      context: context,
                      favorite: widget.state.favoritesList?[widget.index]);
                  Navigator.of(context).pop();
                }
            );

          }
        }), universalFilter: NetWorthFilterModalSheet(
          fromBlankWidget: true,
          favorite:
          widget.state.favoritesList?[widget.index],
          isFavorite: true,
          favoritesCubit: context.read<FavoritesCubit>(),
          netWorthGroupingCubit:
          (widget.state.reportCubitList?[widget.index] as NetWorthReportCubit).netWorthPrimaryGroupingCubit,
          netWorthReturnPercentCubit:
          (widget.state.reportCubitList?[widget.index] as NetWorthReportCubit).netWorthReturnPercentCubit,
          netWorthPrimarySubGroupingCubit:
          (widget.state.reportCubitList?[widget.index] as NetWorthReportCubit).netWorthPrimarySubGroupingCubit,
          netWorthNumberOfPeriodCubit:
          (widget.state.reportCubitList?[widget.index] as NetWorthReportCubit).netWorthNumberOfPeriodCubit,
          netWorthLoadingCubit: (widget.state.reportCubitList?[widget.index] as NetWorthReportCubit).netWorthLoadingCubit,
          netWorthEntityCubit: (widget.state.reportCubitList?[widget.index] as NetWorthReportCubit).netWorthEntityCubit,
          netWorthDenominationCubit:
          (widget.state.reportCubitList?[widget.index] as NetWorthReportCubit).netWorthDenominationCubit,
          netWorthReportCubit: (widget.state.reportCubitList?[widget.index] as NetWorthReportCubit),
          netWorthAsOnDateCubit:
          (widget.state.reportCubitList?[widget.index] as NetWorthReportCubit).netWorthAsOnDateCubit,
          netWorthCurrencyCubit:
          (widget.state.reportCubitList?[widget.index] as NetWorthReportCubit).netWorthCurrencyCubit,
          netWorthPeriodCubit: (widget.state.reportCubitList?[widget.index] as NetWorthReportCubit).netWorthPeriodCubit,
          netWorthPartnershipMethodCubit: (widget.state.reportCubitList?[widget.index] as NetWorthReportCubit).netWorthPartnershipMethodCubit,
          netWorthHoldingMethodCubit: (widget.state.reportCubitList?[widget.index] as NetWorthReportCubit).netWorthHoldingMethodCubit,
        )),
      );
    }
    return Container(key: widget.key);
  }
}

class BlankWidget extends StatefulWidget {
  final int reportId;
  final Widget popupMenu;
  final Widget universalFilter;
  const BlankWidget({
    super.key,
    required this.reportId,
    required this.popupMenu,
    required this.universalFilter,
  });

  @override
  State<BlankWidget> createState() => _BlankWidgetState();
}

class _BlankWidgetState extends State<BlankWidget> {

  String _getReportName(int reportId) {
    if(reportId == FavoriteConstants.performanceId) {
      return StringConstants.favPerformanceWidget;
    }else if(reportId == FavoriteConstants.incomeId) {
      return StringConstants.favIncomeWidget;
    }else if(reportId == FavoriteConstants.expenseId) {
      return StringConstants.favExpenseWidget;
    }else if(reportId == FavoriteConstants.cashBalanceId) {
      return StringConstants.favCashBalanceWidget;
    }else if(reportId == FavoriteConstants.netWorthId) {
      return StringConstants.favNetWorthWidget;
    }
    return "Report Widget";
  }

  String _getReportIcon(int reportId) {
    if(reportId == FavoriteConstants.performanceId) {
      return "assets/svgs/performance_icon.svg";
    }else if(reportId == FavoriteConstants.incomeId) {
      return "assets/svgs/income_icon.svg";
    }else if(reportId == FavoriteConstants.expenseId) {
      return "assets/svgs/expense_icon.svg";
    }else if(reportId == FavoriteConstants.cashBalanceId) {
      return "assets/svgs/cashbalance_icon.svg";
    }else if(reportId == FavoriteConstants.netWorthId) {
      return "assets/svgs/networth_icon.svg";
    }
    return "assets/svgs/performance_icon.svg";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: Sizes.dimen_14.w, vertical: Sizes.dimen_4.h),
      child: Container(
        height: ScreenUtil().screenHeight * 0.4,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_22.w, vertical: Sizes.dimen_6.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  widget.popupMenu
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UIHelper.verticalSpaceMedium,
                  SvgPicture.asset(_getReportIcon(widget.reportId),height: Sizes.dimen_24.h,),
                  UIHelper.verticalSpaceSmall,
                  Text(_getReportName(widget.reportId), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),),
                  UIHelper.verticalSpaceSmall,
                  GestureDetector(
                    onTap: () async{
                      await showModalBottomSheet(
                        context:
                        context,
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.only(
                            topLeft:
                            Radius.circular(Sizes.dimen_10.r),
                            topRight:
                            Radius.circular(Sizes.dimen_10.r),
                          ),
                        ),
                        isScrollControlled:
                        true,
                        builder:
                            (context) {
                          return widget.universalFilter;
                        },
                      );
                    },
                    child: Card(
                        color: AppColor.lightGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(Sizes.dimen_8.r),
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_22.w),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FilterIcon.getFilterIconForBlankWidget(),
                              UIHelper.horizontalSpaceMedium,
                              Text(StringConstants.favConfigureButton, style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold, color: AppColor.white),)
                            ],
                          ),
                        )
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
