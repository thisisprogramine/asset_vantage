import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/num_extensions.dart';
import 'package:asset_vantage/src/config/extensions/string_extensions.dart';
import 'package:asset_vantage/src/presentation/widgets/custom_popup_menu.dart';
import 'package:asset_vantage/src/presentation/widgets/delete_favorite_dialog.dart';
import 'package:asset_vantage/src/presentation/widgets/entity_asondate_label.dart';
import 'package:asset_vantage/src/presentation/widgets/filter_icon.dart';
import 'package:asset_vantage/src/presentation/widgets/navigation_arrow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../config/constants/favorite_constants.dart';
import '../../../../config/constants/route_constants.dart';
import '../../../../config/constants/size_constants.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/authentication/user_entity.dart';
import '../../../../domain/entities/expense/expense_chart_data.dart';
import '../../../../domain/entities/favorites/favorites_entity.dart';
import '../../../../utilities/helper/app_helper.dart';
import '../../../../utilities/helper/flash_helper.dart';
import '../../../../utilities/helper/ui_helper.dart';
import '../../../arguments/expense_report_argument.dart';
import '../../../blocs/expense/expense_loading/expense_loading_cubit.dart';
import '../../../blocs/expense/expense_sort_cubit/expense_sort_cubit.dart';
import '../../../blocs/authentication/user/user_cubit.dart';
import '../../../blocs/expense/expense_account/expense_account_cubit.dart';
import '../../../blocs/expense/expense_chart/expense_chart_cubit.dart';
import '../../../blocs/expense/expense_entity/expense_entity_cubit.dart';
import '../../../blocs/expense/expense_number_of_period/expense_number_of_period_cubit.dart';
import '../../../blocs/expense/expense_period/expense_period_cubit.dart';
import '../../../blocs/expense/expense_report/expense_report_cubit.dart';
import '../../../blocs/expense/expense_as_on_date/expense_as_on_date_cubit.dart';
import '../../../blocs/expense/expense_currency/expense_currency_cubit.dart';
import '../../../blocs/expense/expense_denomination/expense_denomination_cubit.dart';
import '../../../blocs/favorites/favorites_cubit.dart';
import '../../../blocs/stealth/stealth_cubit.dart';
import '../../../blocs/universal_filter/as_on_date_universal_filter/universal_filter_as_on_date_cubit.dart';
import '../../../blocs/universal_filter/enitity_universal_filter/universal_entity_filter_cubit.dart';
import '../../../blocs/universal_filter/favourite_as_on_date_universal_filter/favourite_universal_filter_as_on_date_cubit.dart';
import '../../../theme/theme_color.dart';
import '../../../widgets/EditableTitle.dart';
import '../../../widgets/blue_dot_icon.dart';
import '../../../widgets/cie_balance_for.dart';
import '../../../widgets/editable_title_row.dart';
import '../../../widgets/favorite_icon.dart';
import '../../../widgets/filter_personalization_hint.dart';
import '../../../widgets/loading_widgets/loading_bg.dart';
import '../../expense_report/expense_universal_filter.dart';

class ExpenseHighlightWidget extends StatefulWidget {
  final bool isDetailScreen;
  final bool isFavorite;
  final Favorite? favorite;
  final ExpenseReportCubit expenseReportCubit;
  final ExpenseSortCubit expenseSortCubit;
  final ExpenseEntityCubit expenseEntityCubit;
  final ExpenseAccountCubit expenseAccountCubit;
  final ExpensePeriodCubit expensePeriodCubit;
  final ExpenseNumberOfPeriodCubit expenseNumberOfPeriodCubit;
  final ExpenseChartCubit expenseChartCubit;
  final ExpenseCurrencyCubit expenseCurrencyCubit;
  final ExpenseDenominationCubit expenseDenominationCubit;
  final ExpenseAsOnDateCubit expenseAsOnDateCubit;
  final ExpenseLoadingCubit expenseLoadingCubit;
  final UniversalEntityFilterCubit universalEntityFilterCubit;
  final UniversalFilterAsOnDateCubit universalFilterAsOnDateCubit;
  final FavouriteUniversalFilterAsOnDateCubit favouriteUniversalFilterAsOnDateCubit;
  final int currentLevel;
  final String? selectedPosition;
  final void Function(int)? selectChartBarFunc;
  final List<int>? selectedChartBarMonth;

  const ExpenseHighlightWidget(
      {super.key,
      this.isFavorite = false,
      this.favorite,
      required this.isDetailScreen,
      required this.universalEntityFilterCubit,
      required this.expenseReportCubit,
      required this.universalFilterAsOnDateCubit,
      required this.favouriteUniversalFilterAsOnDateCubit,
      required this.expenseSortCubit,
      required this.expenseAccountCubit,
      required this.expensePeriodCubit,
      required this.expenseNumberOfPeriodCubit,
      required this.expenseChartCubit,
      required this.expenseCurrencyCubit,
      required this.expenseDenominationCubit,
      required this.expenseEntityCubit,
      required this.expenseAsOnDateCubit,
      required this.expenseLoadingCubit,
      this.currentLevel = 0,
      this.selectedPosition,
      this.selectChartBarFunc,
      this.selectedChartBarMonth});

  @override
  State<ExpenseHighlightWidget> createState() => _ExpenseHighlightWidgetState();
}

class _ExpenseHighlightWidgetState extends State<ExpenseHighlightWidget> {
  bool canEdit = false;
  int? activeIndex;
  int? greatestMarketValue;
  List? chartData;
  List<int> periodItemVal = [0, 0];
  double height = Sizes.dimen_13.h/1.84;

  void setChildHeight(double newHeight) => setState(() {
    height = newHeight;
  });

  @override
  void didUpdateWidget(covariant ExpenseHighlightWidget oldWidget) {
    if (widget.currentLevel < oldWidget.currentLevel) {
      activeIndex = widget.selectedChartBarMonth?[widget.currentLevel];
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StealthCubit, bool>(builder: (context, stealthValue) {
      return BlocBuilder<UserCubit, UserEntity?>(builder: (context, user) {
        return BlocBuilder<ExpenseEntityCubit, ExpenseEntityState>(
            bloc: widget.expenseEntityCubit,
            builder: (context, entityState) {
              return BlocBuilder<ExpenseAsOnDateCubit, ExpenseAsOnDateState>(
                  bloc: widget.expenseAsOnDateCubit,
                  builder: (context, asOnDate) {
                    return BlocBuilder<ExpenseReportCubit, ExpenseReportState>(
                        bloc: widget.expenseReportCubit,
                        builder: (context, expenseState) {
                          if (expenseState is ExpenseReportLoaded) {
                            return BlocBuilder<ExpenseNumberOfPeriodCubit,
                                    ExpenseNumberOfPeriodState>(
                                bloc: widget.expenseNumberOfPeriodCubit,
                                builder: (context, numberOfPeriodState) {
                                  if(expenseState.chartData.isNotEmpty) {
                                    if (widget.currentLevel == 0) {
                                      chartData = expenseState.chartData.sublist(
                                          expenseState.chartData.length -
                                              (numberOfPeriodState
                                                  .selectedExpenseNumberOfPeriod
                                                  ?.value ??
                                                  0),
                                          expenseState.chartData.length);
                                      greatestMarketValue =
                                          AppHelpers.getExpenseGreaterValue(
                                              expenseList: chartData
                                              as List<ExpenseChartData>);
                                    } else {
                                      chartData = expenseState.chartData
                                          .map(
                                            (e) {
                                          final item = e.children.where(
                                                (element) {
                                              return element.accountName ==
                                                  widget.selectedPosition;
                                            },
                                          ).toList();
                                          if (item.isNotEmpty) {
                                            return item.first;
                                          } else {
                                            return Child(
                                              date: e.date,
                                              accounts: [],
                                              accNumber: "",
                                              accountId: 0,
                                              accountName: "",
                                              currencyData: "",
                                              percentage: 0,
                                              total: 0,
                                            );
                                          }
                                        },
                                      )
                                          .toList()
                                          .sublist(
                                          expenseState.chartData.length -
                                              (numberOfPeriodState
                                                  .selectedExpenseNumberOfPeriod
                                                  ?.value ??
                                                  0),
                                          expenseState.chartData.length);
                                      greatestMarketValue = AppHelpers
                                          .getExpenseChildrenGreaterValue(
                                          expenseList:
                                          chartData as List<Child>);
                                    }
                                    if (periodItemVal[widget.currentLevel] !=
                                        numberOfPeriodState
                                            .selectedExpenseNumberOfPeriod
                                            ?.value) {
                                      if (widget.currentLevel != 0) {
                                        activeIndex =
                                        widget.selectedChartBarMonth?[
                                        widget.currentLevel];
                                        Future.delayed(const Duration(seconds: 0),
                                                () {
                                              if (widget.selectChartBarFunc != null) {
                                                widget.selectChartBarFunc!(
                                                    activeIndex ?? 0);
                                              }
                                            });
                                      } else {
                                        activeIndex = chartData!.length - 1;
                                        Future.delayed(const Duration(seconds: 0),
                                                () {
                                              if (widget.selectChartBarFunc != null) {
                                                widget.selectChartBarFunc!(
                                                    activeIndex ?? 0);
                                              }
                                            });
                                      }
                                    }
                                    periodItemVal[widget.currentLevel] =
                                        numberOfPeriodState
                                            .selectedExpenseNumberOfPeriod
                                            ?.value ??
                                            0;
                                    return Container(
                                      decoration: !widget.isDetailScreen && !widget.isFavorite ? BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                              color: AppColor.textGrey.withValues(alpha: 0.2),
                                              width: 0.6,
                                            )),
                                      ) : null,
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                        vertical: Sizes.dimen_14.r,
                                      ),
                                      margin: EdgeInsets.symmetric(
                                        horizontal: Sizes.dimen_14.r,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if(!widget.isDetailScreen && !widget.isFavorite)
                                            Container(
                                              child: Column(
                                                children: [
                                                  BlocBuilder<UserCubit, UserEntity?>(
                                                      builder: (context, user) {
                                                        return BlocBuilder<ExpenseEntityCubit, ExpenseEntityState>(
                                                            bloc: widget.expenseEntityCubit,
                                                            builder: (context, entityState) {
                                                              return BlocBuilder<ExpenseAsOnDateCubit, ExpenseAsOnDateState>(
                                                                  bloc: widget.expenseAsOnDateCubit,
                                                                  builder: (context, asOnDate) {
                                                                    return Row(
                                                                      children: [
                                                                        if(entityState.selectedExpenseEntity?.id != widget.universalEntityFilterCubit.state.selectedUniversalEntity?.id ||
                                                                            !((entityState.selectedExpenseEntity?.type?.contains(widget.universalEntityFilterCubit.state.selectedUniversalEntity?.type ?? 'None') ?? false))
                                                                        )

                                                                          EntityAsonDateLabels(text: "${entityState.selectedExpenseEntity?.name}"),
                                                                        UIHelper.horizontalSpaceSmall,
                                                                        if(!(asOnDate.asOnDate?.contains(widget.universalFilterAsOnDateCubit.state.asOnDate ?? "None") ?? false))

                                                                          EntityAsonDateLabels(text: "${DateFormat(user?.dateFormat ?? 'dd MMM yyyy').format(DateTime.parse(asOnDate.asOnDate ?? DateTime.now().toString()))}"),

                                                                        if((asOnDate.asOnDate?.contains(widget.universalFilterAsOnDateCubit.state.asOnDate ?? "None") ?? true) && !(entityState.selectedExpenseEntity?.id != widget.universalEntityFilterCubit.state.selectedUniversalEntity?.id ||
                                                                            !((entityState.selectedExpenseEntity?.type?.contains(widget.universalEntityFilterCubit.state.selectedUniversalEntity?.type ?? 'None') ?? true))))

                                                                          const FilterPersonalizationHint(),

                                                                        UIHelper.horizontalSpaceSmall,
                                                                        Expanded(child: Container()),
                                                                        GestureDetector(
                                                                          onTap: () async {
                                                                            await showModalBottomSheet(
                                                                              context: context,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.only(
                                                                                  topLeft: Radius.circular(Sizes.dimen_10.r),
                                                                                  topRight: Radius.circular(Sizes.dimen_10.r),
                                                                                ),
                                                                              ),
                                                                              isScrollControlled: true,
                                                                              builder: (context) {
                                                                                return ExpenseUniversalFilter(
                                                                                  favorite: widget.favorite,
                                                                                  isFavorite: widget.isFavorite,
                                                                                  expenseLoadingCubit:
                                                                                  widget.expenseLoadingCubit,
                                                                                  expenseEntityCubit: widget.expenseEntityCubit,
                                                                                  expenseAccountCubit:
                                                                                  widget.expenseAccountCubit,
                                                                                  expenseNumberOfPeriodCubit:
                                                                                  widget.expenseNumberOfPeriodCubit,
                                                                                  expenseCurrencyCubit:
                                                                                  widget.expenseCurrencyCubit,
                                                                                  expenseDenominationCubit:
                                                                                  widget.expenseDenominationCubit,
                                                                                  expenseAsOnDateCubit:
                                                                                  widget.expenseAsOnDateCubit,
                                                                                  expensePeriodCubit: widget.expensePeriodCubit,
                                                                                  expenseReportCubit: widget.expenseReportCubit,
                                                                                );
                                                                              },
                                                                            );

                                                                          },
                                                                          child: Stack(
                                                                            children: [
                                                                              if(!((asOnDate.asOnDate?.contains(widget.universalFilterAsOnDateCubit.state.asOnDate ?? "None") ?? true) && !(entityState.selectedExpenseEntity?.id != widget.universalEntityFilterCubit.state.selectedUniversalEntity?.id ||
                                                                                  !((entityState.selectedExpenseEntity?.type?.contains(widget.universalEntityFilterCubit.state.selectedUniversalEntity?.type ?? 'None') ?? true)))))

                                                                                const BlueDotIcon(),

                                                                              const FilterIcon()
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        UIHelper.horizontalSpace(Sizes.dimen_4.w),

                                                                      ],
                                                                    );
                                                                  }
                                                              );
                                                            }
                                                        );
                                                      }
                                                  ),
                                                ],
                                              ),

                                            ),

                                          if(widget.isDetailScreen)
                                            BlocBuilder<UserCubit, UserEntity?>(
                                                builder: (context, user) {
                                                  return BlocBuilder<ExpenseEntityCubit, ExpenseEntityState>(
                                                      bloc: widget.expenseEntityCubit,
                                                      builder: (context, entityState) {
                                                        return BlocBuilder<ExpenseAsOnDateCubit, ExpenseAsOnDateState>(
                                                            bloc: widget.expenseAsOnDateCubit,
                                                            builder: (context, asOnDate) {
                                                              return Container(
                                                                padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
                                                                decoration:
                                                                const BoxDecoration(
                                                                  border: Border(
                                                                    bottom: BorderSide(
                                                                        color: AppColor
                                                                            .textGrey,
                                                                        width: 0.1),
                                                                  ),
                                                                ),
                                                                child: Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Expanded(
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Flexible(
                                                                                child: Text("${entityState.selectedExpenseEntity?.name}",
                                                                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          UIHelper.horizontalSpaceSmall,
                                                                          Text("as on ${DateFormat(user?.dateFormat ?? 'dd MMM yyyy').format(DateTime.parse(asOnDate.asOnDate ?? DateTime.now().toString()))}",
                                                                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.normal, fontSize: Sizes.dimen_12)),
                                                                          UIHelper.horizontalSpaceSmall,
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    if (widget.currentLevel == 0)
                                                                      ...[
                                                                        if(widget.isDetailScreen)
                                                                          GestureDetector(
                                                                            onTap: () async {
                                                                              await showModalBottomSheet(
                                                                                context: context,
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.only(
                                                                                    topLeft: Radius.circular(Sizes.dimen_10.r),
                                                                                    topRight: Radius.circular(Sizes.dimen_10.r),
                                                                                  ),
                                                                                ),
                                                                                isScrollControlled: true,
                                                                                builder: (context) {
                                                                                  return ExpenseUniversalFilter(
                                                                                    favorite: widget.favorite,
                                                                                    isFavorite: widget.isFavorite,
                                                                                    expenseEntityCubit:
                                                                                    widget.expenseEntityCubit,
                                                                                    expenseLoadingCubit:
                                                                                    widget.expenseLoadingCubit,
                                                                                    expenseAccountCubit:
                                                                                    widget.expenseAccountCubit,
                                                                                    expenseNumberOfPeriodCubit: widget
                                                                                        .expenseNumberOfPeriodCubit,
                                                                                    expenseCurrencyCubit:
                                                                                    widget.expenseCurrencyCubit,
                                                                                    expenseDenominationCubit: widget
                                                                                        .expenseDenominationCubit,
                                                                                    expenseAsOnDateCubit:
                                                                                    widget.expenseAsOnDateCubit,
                                                                                    expensePeriodCubit:
                                                                                    widget.expensePeriodCubit,
                                                                                    expenseReportCubit:
                                                                                    widget.expenseReportCubit,
                                                                                  );
                                                                                },
                                                                              );
                                                                            },
                                                                            child: const FilterIcon(isSummary: true,)
                                                                          ),
                                                                        if(!widget.isDetailScreen)
                                                                          ...[
                                                                            UIHelper.horizontalSpaceMedium,
                                                                            GestureDetector(
                                                                                onTap: () {
                                                                                  Navigator.of(context)
                                                                                      .pushNamed(
                                                                                      RouteList
                                                                                          .expenseReport,
                                                                                      arguments: ExpenseReportArgument(
                                                                                        favorite:
                                                                                        widget.favorite,
                                                                                        universalEntityFilterCubit: widget.universalEntityFilterCubit,
                                                                                        universalFilterAsOnDateCubit: widget.universalFilterAsOnDateCubit,
                                                                                        favouriteUniversalFilterAsOnDateCubit: widget.favouriteUniversalFilterAsOnDateCubit,
                                                                                        isFavorite:
                                                                                        widget.isFavorite,
                                                                                        expenseReportCubit: widget
                                                                                            .expenseReportCubit,
                                                                                        expenseLoadingCubit:
                                                                                        widget
                                                                                            .expenseLoadingCubit,
                                                                                        expenseSortCubit: widget
                                                                                            .expenseSortCubit,
                                                                                        expenseEntityCubit: widget
                                                                                            .expenseEntityCubit,
                                                                                        expenseAccountCubit:
                                                                                        widget
                                                                                            .expenseAccountCubit,
                                                                                        expensePeriodCubit: widget
                                                                                            .expensePeriodCubit,
                                                                                        expenseNumberOfPeriodCubit:
                                                                                        widget
                                                                                            .expenseNumberOfPeriodCubit,
                                                                                        expenseChartCubit: widget
                                                                                            .expenseChartCubit,
                                                                                        expenseCurrencyCubit:
                                                                                        widget
                                                                                            .expenseCurrencyCubit,
                                                                                        expenseDenominationCubit:
                                                                                        widget
                                                                                            .expenseDenominationCubit,
                                                                                        expenseAsOnDateCubit:
                                                                                        widget
                                                                                            .expenseAsOnDateCubit,
                                                                                      ));
                                                                                },
                                                                                child: const NavigationArrow()

                                                                            )
                                                                          ]
                                                                      ]
                                                                  ],
                                                                ),
                                                              );
                                                            }
                                                        );
                                                      }
                                                  );
                                                }
                                            ),

                                          if (!widget.isDetailScreen && !widget.isFavorite)
                                            ...[
                                              UIHelper.verticalSpace(Sizes.dimen_6.h),
                                              Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        if (!widget.isDetailScreen)
                                                          BlocBuilder<
                                                              FavoritesCubit,
                                                              FavoritesState>(
                                                              builder: (context,
                                                                  favoriteState) {
                                                                return EditableTitleRow.editableRowWithoutTransform(
                                                                    canEditTransform: canEdit,
                                                                    favoriteT: widget.favorite,
                                                                    titleT: widget.favorite?.reportname,
                                                                    defaultTitle: StringConstants.expenseReport,
                                                                    onEditComplete: (){
                                                                      setState(() {
                                                                        canEdit = false;
                                                                      });
                                                                    },
                                                                    onEditToggle: (){
                                                                      setState(() {
                                                                        canEdit =
                                                                        !canEdit;
                                                                      });
                                                                    },
                                                                    isFavT: widget.isFavorite,
                                                                    context: context);
                                                              }),
                                                      ],
                                                    ),
                                                  ),
                                                  if (!widget.isDetailScreen)
                                                    Row(
                                                      children: [
                                                        GestureDetector(
                                                            onTap: () {
                                                              Navigator.of(context)
                                                                  .pushNamed(
                                                                  RouteList
                                                                      .expenseReportScreen,
                                                                  arguments: ExpenseReportArgument(
                                                                    favorite:
                                                                    widget.favorite,
                                                                    isFavorite:
                                                                    widget.isFavorite,
                                                                    expenseReportCubit: widget
                                                                        .expenseReportCubit,
                                                                    universalEntityFilterCubit: widget.universalEntityFilterCubit,
                                                                    universalFilterAsOnDateCubit: widget.universalFilterAsOnDateCubit,
                                                                    favouriteUniversalFilterAsOnDateCubit: widget.favouriteUniversalFilterAsOnDateCubit,
                                                                    expenseLoadingCubit:
                                                                    widget
                                                                        .expenseLoadingCubit,
                                                                    expenseSortCubit: widget
                                                                        .expenseSortCubit,
                                                                    expenseEntityCubit: widget
                                                                        .expenseEntityCubit,
                                                                    expenseAccountCubit:
                                                                    widget
                                                                        .expenseAccountCubit,
                                                                    expensePeriodCubit: widget
                                                                        .expensePeriodCubit,
                                                                    expenseNumberOfPeriodCubit:
                                                                    widget
                                                                        .expenseNumberOfPeriodCubit,
                                                                    expenseChartCubit: widget
                                                                        .expenseChartCubit,
                                                                    expenseCurrencyCubit:
                                                                    widget
                                                                        .expenseCurrencyCubit,
                                                                    expenseDenominationCubit:
                                                                    widget
                                                                        .expenseDenominationCubit,
                                                                    expenseAsOnDateCubit:
                                                                    widget
                                                                        .expenseAsOnDateCubit,
                                                                  )

                                                              );
                                                            },
                                                            child: const NavigationArrow()

                                                        ),
                                                      ],
                                                    )
                                                ],
                                              ),
                                            ],

                                          if(!widget.isDetailScreen && widget.isFavorite)
                                            ...[
                                              BlocBuilder<UserCubit, UserEntity?>(
                                                  builder: (context, user) {
                                                    return BlocBuilder<ExpenseEntityCubit, ExpenseEntityState>(
                                                        bloc: widget.expenseEntityCubit,
                                                        builder: (context, entityState) {
                                                          return BlocBuilder<ExpenseAsOnDateCubit, ExpenseAsOnDateState>(
                                                              bloc: widget.expenseAsOnDateCubit,
                                                              builder: (context, asOnDate) {
                                                                return Container(
                                                                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
                                                                  decoration:
                                                                  const BoxDecoration(
                                                                    border: Border(
                                                                      bottom: BorderSide(
                                                                          color: AppColor
                                                                              .textGrey,
                                                                          width: 0.1),
                                                                    ),
                                                                  ),
                                                                  child: Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Expanded(
                                                                          child: BlocBuilder<FavoritesCubit, FavoritesState>(
                                                                              builder: (context, favoriteState) {
                                                                                return Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    EditableTitleRow(
                                                                                      canEdit: canEdit,
                                                                                      favorite: widget.favorite,
                                                                                      title: widget.favorite?.reportname,
                                                                                      onEditComplete: () {
                                                                                        setState((){
                                                                                          canEdit = false;
                                                                                        });
                                                                                      },
                                                                                      isFav: widget.isFavorite,
                                                                                      defaultTitle: StringConstants.expenseReport,
                                                                                      onEditToggle: () {
                                                                                        setState((){
                                                                                          canEdit = !canEdit;
                                                                                        });
                                                                                      },

                                                                                    ),
                                                                                    UIHelper.verticalSpace(Sizes.dimen_2.h),
                                                                                    Row(
                                                                                      children: [

                                                                                        EntityAsonDateLabels(text: "${entityState.selectedExpenseEntity?.name}"),
                                                                                        UIHelper.horizontalSpaceSmall,
                                                                                        if(!(asOnDate.asOnDate?.contains(widget.favouriteUniversalFilterAsOnDateCubit.state.asOnDate ?? "None") ?? false))

                                                                                          EntityAsonDateLabels(text: "${DateFormat(user?.dateFormat ?? 'dd MMM yyyy').format(DateTime.parse(asOnDate.asOnDate ?? DateTime.now().toString()))}")
                                                                                      ],
                                                                                    )
                                                                                  ],
                                                                                );

                                                                              }
                                                                          )
                                                                      ),
                                                                      if (widget.currentLevel == 0)
                                                                        ...[
                                                                          if(!widget.isFavorite)
                                                                            GestureDetector(
                                                                              onTap: () async {
                                                                                await showModalBottomSheet(
                                                                                  context: context,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.only(
                                                                                      topLeft: Radius.circular(Sizes.dimen_10.r),
                                                                                      topRight: Radius.circular(Sizes.dimen_10.r),
                                                                                    ),
                                                                                  ),
                                                                                  isScrollControlled: true,
                                                                                  builder: (context) {
                                                                                    return ExpenseUniversalFilter(
                                                                                      favorite: widget.favorite,
                                                                                      isFavorite: widget.isFavorite,
                                                                                      expenseLoadingCubit:
                                                                                      widget.expenseLoadingCubit,
                                                                                      expenseEntityCubit: widget.expenseEntityCubit,
                                                                                      expenseAccountCubit:
                                                                                      widget.expenseAccountCubit,
                                                                                      expenseNumberOfPeriodCubit:
                                                                                      widget.expenseNumberOfPeriodCubit,
                                                                                      expenseCurrencyCubit:
                                                                                      widget.expenseCurrencyCubit,
                                                                                      expenseDenominationCubit:
                                                                                      widget.expenseDenominationCubit,
                                                                                      expenseAsOnDateCubit:
                                                                                      widget.expenseAsOnDateCubit,
                                                                                      expensePeriodCubit: widget.expensePeriodCubit,
                                                                                      expenseReportCubit: widget.expenseReportCubit,
                                                                                    );
                                                                                  },
                                                                                );
                                                                              },
                                                                              child: FilterIcon.getFilterIcon()

                                                                            ),
                                                                          UIHelper.horizontalSpaceMedium,

                                                                          if(widget.isFavorite)
                                                                            Row(
                                                                              children: [
                                                                                CustomPopupMenu(onSelect: (int index) async {
                                                                                  if (index == 1) {
                                                                                    context
                                                                                        .read<FavoritesCubit>()
                                                                                        .saveFilters(
                                                                                      context: context,
                                                                                      shouldUpdate: false,
                                                                                      isPinned: false,
                                                                                      reportId: FavoriteConstants.expenseId,
                                                                                      reportName: "${widget.favorite?.reportname} Copy",
                                                                                      entity: widget.expenseReportCubit.expenseEntityCubit.state.selectedExpenseEntity,
                                                                                      currency:
                                                                                      widget.expenseReportCubit.expenseCurrencyCubit.state.selectedExpenseCurrency,
                                                                                      denomination: widget.expenseReportCubit.expenseDenominationCubit
                                                                                          .state.selectedExpenseDenomination,
                                                                                      asOnDate: widget.expenseReportCubit.expenseAsOnDateCubit.state.asOnDate,
                                                                                      expenseAccounts:
                                                                                      widget.expenseReportCubit.expenseAccountCubit.state.selectedAccountList,
                                                                                      period: widget.expenseReportCubit.expensePeriodCubit.state.selectedExpensePeriod,
                                                                                      numberOfPeriod: widget.expenseReportCubit.expenseNumberOfPeriodCubit
                                                                                          .state.selectedExpenseNumberOfPeriod,
                                                                                    );

                                                                                  } else if (index == 2) {

                                                                                    DeleteFavoriteDialog.show(context: context,
                                                                                    onCancel: (){
                                                                                       Navigator.of(context).popUntil(
                                                                                            (route) =>
                                                                                        route.settings.name ==
                                                                                            RouteList.dashboard,
                                                                                      );
                                                                                    },
                                                                                    onDelete: (){
                                                                                      context
                                                                                          .read<FavoritesCubit>()
                                                                                          .removeFavorites(
                                                                                          context: context,
                                                                                          favorite: widget.favorite);
                                                                                      Navigator.of(context).pop();
                                                                                    });
                                                                                  }
                                                                                }),
                                                                                UIHelper.horizontalSpaceMedium,
                                                                                GestureDetector(
                                                                                    onTap: () {
                                                                                      Navigator.of(context)
                                                                                          .pushNamed(
                                                                                          RouteList
                                                                                              .expenseReportScreen,
                                                                                          arguments: ExpenseReportArgument(
                                                                                            favorite:
                                                                                            widget.favorite,
                                                                                            universalEntityFilterCubit: widget.universalEntityFilterCubit,
                                                                                            universalFilterAsOnDateCubit: widget.universalFilterAsOnDateCubit,
                                                                                            favouriteUniversalFilterAsOnDateCubit: widget.favouriteUniversalFilterAsOnDateCubit,
                                                                                            isFavorite:
                                                                                            widget.isFavorite,
                                                                                            expenseReportCubit: widget
                                                                                                .expenseReportCubit,
                                                                                            expenseLoadingCubit:
                                                                                            widget
                                                                                                .expenseLoadingCubit,
                                                                                            expenseSortCubit: widget
                                                                                                .expenseSortCubit,
                                                                                            expenseEntityCubit: widget
                                                                                                .expenseEntityCubit,
                                                                                            expenseAccountCubit:
                                                                                            widget
                                                                                                .expenseAccountCubit,
                                                                                            expensePeriodCubit: widget
                                                                                                .expensePeriodCubit,
                                                                                            expenseNumberOfPeriodCubit:
                                                                                            widget
                                                                                                .expenseNumberOfPeriodCubit,
                                                                                            expenseChartCubit: widget
                                                                                                .expenseChartCubit,
                                                                                            expenseCurrencyCubit:
                                                                                            widget
                                                                                                .expenseCurrencyCubit,
                                                                                            expenseDenominationCubit:
                                                                                            widget
                                                                                                .expenseDenominationCubit,
                                                                                            expenseAsOnDateCubit:
                                                                                            widget
                                                                                                .expenseAsOnDateCubit,
                                                                                          ));
                                                                                    },
                                                                                    child: const NavigationArrow(isFav: true,)

                                                                                )
                                                                              ],
                                                                            )
                                                                        ]
                                                                    ],
                                                                  ),
                                                                );
                                                              }
                                                          );
                                                        }
                                                    );
                                                  }
                                              ),
                                            ],

                                          SizedBox(
                                            height: ScreenUtil().screenHeight *
                                                (widget.isDetailScreen ? 0.15 : 0.20)+height,
                                            child: Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.only(
                                                    top: Sizes.dimen_5.h,
                                                    bottom: height,
                                                  ),

                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                      top: Sizes.dimen_8.w,
                                                    ),
                                                    decoration:
                                                    const BoxDecoration(
                                                      border: Border(
                                                        left: BorderSide(
                                                            color: AppColor
                                                                .textGrey,
                                                            width: 0.1),
                                                        bottom: BorderSide(
                                                            color: AppColor
                                                                .textGrey,
                                                            width: 0.1),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      children: List.generate(
                                                        5,
                                                            (index) {
                                                          return Expanded(
                                                            child: Container(
                                                              decoration:
                                                              BoxDecoration(
                                                                  border:
                                                                  Border(
                                                                    top: BorderSide(
                                                                        color: AppColor
                                                                            .grey
                                                                            .withOpacity(
                                                                            0.2)),
                                                                  )),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                    bottom: 0,
                                                    left: Sizes.dimen_0.w,
                                                    height: (ScreenUtil()
                                                        .screenHeight *
                                                        (widget.isDetailScreen ? 0.15 : 0.20))+height -
                                                        Sizes.dimen_5.h,
                                                    width: (ScreenUtil()
                                                        .screenWidth) -
                                                        (Sizes.dimen_28.r +
                                                            Sizes.dimen_28.w),
                                                    child: BlocBuilder<
                                                        ExpenseChartCubit,
                                                        int>(
                                                        bloc: widget
                                                            .expenseChartCubit,
                                                        builder: (context,
                                                            expenseChartState) {
                                                          return Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            children:
                                                            List.generate(
                                                              chartData
                                                                  ?.length ??
                                                                  0,
                                                                  (index) {
                                                                final currentData =
                                                                chartData?[
                                                                index];
                                                                return Expanded(
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                        Padding(
                                                                          padding:
                                                                          EdgeInsets.symmetric(horizontal: Sizes.dimen_4.w),
                                                                          child:
                                                                          Column(
                                                                            mainAxisSize:
                                                                            MainAxisSize.max,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Stack(
                                                                                  fit: StackFit.loose,
                                                                                  alignment: Alignment.bottomCenter,
                                                                                  children: [
                                                                                    GestureDetector(
                                                                                      onTap: () {
                                                                                        activeIndex = index;
                                                                                        if (widget.selectChartBarFunc != null) {
                                                                                          widget.selectChartBarFunc!(index);
                                                                                        }
                                                                                        setState(() {});
                                                                                      },
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.only(top: Sizes.dimen_5.h),
                                                                                        child: AnimatedOpacity(
                                                                                          opacity: index == activeIndex ? 1 : 0.4,
                                                                                          duration: const Duration(milliseconds: 300),
                                                                                          curve: Curves.easeIn,
                                                                                          child: Column(
                                                                                            children: [
                                                                                              Expanded(
                                                                                                child: Container(
                                                                                                  color: AppColor.transparent,
                                                                                                  child: AnimatedFractionallySizedBox(
                                                                                                    heightFactor: AppHelpers.getExpenseChartFraction(
                                                                                                        actualValue: currentData.total,
                                                                                                        greaterValue: greatestMarketValue?.toDouble() ?? 0.0
                                                                                                    ),
                                                                                                    duration: const Duration(milliseconds: 500),
                                                                                                    alignment: Alignment.bottomCenter,
                                                                                                    child: Container(
                                                                                                      color: AppColor.expenseChartColor,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    if (index == activeIndex)
                                                                                      Container(
                                                                                        alignment: Alignment.center,
                                                                                        height: ScreenUtil().screenHeight * 0.20,
                                                                                        child: const DottedLine(
                                                                                          direction: Axis.vertical,
                                                                                          lineThickness: 1.0,
                                                                                          dashLength: 4.0,
                                                                                          dashColor: Colors.black,
                                                                                          dashGapLength: 4.0,
                                                                                          dashGapColor: Colors.transparent,
                                                                                        ),
                                                                                      ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              TextAbbr(setHeight: setChildHeight, text: AppHelpers.getNetWorthMonthAbbreviation(date: currentData.date, length: (numberOfPeriodState.selectedExpenseNumberOfPeriod?.value ?? 0) <= 6 ? 3 : 1)),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        })),
                                              ],
                                            ),
                                          ),
                                          BlocBuilder<ExpenseDenominationCubit,
                                              ExpenseDenominationState>(
                                              bloc: widget
                                                  .expenseDenominationCubit,
                                              builder:
                                                  (context, denominationState) {
                                                return BlocBuilder<
                                                    ExpenseChartCubit, int>(
                                                    bloc: widget
                                                        .expenseChartCubit,
                                                    builder: (context,
                                                        expenseChartState) {
                                                      return BalanceFor(
                                                        isSummary: !widget.isDetailScreen,
                                                        balanceFor: "Total Expense For ${DateFormat.yMMM().format(DateTime.parse(chartData?[activeIndex!].date))}",
                                                        balance: "${NumberFormat.simpleCurrency(name: widget.expenseCurrencyCubit.state.selectedExpenseCurrency?.code ?? 'USD').currencySymbol} ${(chartData?[activeIndex!].total) < 0.0 ? '(${NumberFormat(widget.expenseCurrencyCubit.state.selectedExpenseCurrency?.format ?? '###,###,##0.00').format((chartData?[activeIndex!].total as num).abs().denominate(denominator: denominationState.selectedExpenseDenomination?.denomination))})' : NumberFormat(widget.expenseCurrencyCubit.state.selectedExpenseCurrency?.format ?? '###,###,##0.00').format((chartData?[activeIndex!].total as num).denominate(denominator: denominationState.selectedExpenseDenomination?.denomination))}${denominationState.selectedExpenseDenomination?.suffix}".stealth(stealthValue),
                                                      );
                                                    });
                                              })
                                        ],
                                      ),
                                    );
                                  }else {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_14.w,),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            decoration: !widget.isFavorite && !widget.isDetailScreen ?BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(
                                                    color: AppColor.textGrey.withValues(alpha: 0.2),
                                                    width: 0.6,
                                                  )),
                                            ): null,
                                            padding: EdgeInsets.only(
                                              top: Sizes.dimen_4.h,
                                              bottom: Sizes.dimen_1.h,
                                            ),
                                          ),
                                          if(!widget.isDetailScreen && !widget.isFavorite)
                                            Expanded(
                                                child: LoadingBg(
                                                  message: Message.noPositionFound,
                                                  onRetry: () async{
                                                    await showModalBottomSheet(
                                                      context: context,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(Sizes.dimen_10.r),
                                                          topRight: Radius.circular(Sizes.dimen_10.r),
                                                        ),
                                                      ),
                                                      isScrollControlled: true,
                                                      builder: (context) {
                                                        return ExpenseUniversalFilter(
                                                          favorite: widget.favorite,
                                                          isFavorite: widget.isFavorite,
                                                          expenseLoadingCubit:
                                                          widget.expenseLoadingCubit,
                                                          expenseEntityCubit: widget.expenseEntityCubit,
                                                          expenseAccountCubit:
                                                          widget.expenseAccountCubit,
                                                          expenseNumberOfPeriodCubit:
                                                          widget.expenseNumberOfPeriodCubit,
                                                          expenseCurrencyCubit:
                                                          widget.expenseCurrencyCubit,
                                                          expenseDenominationCubit:
                                                          widget.expenseDenominationCubit,
                                                          expenseAsOnDateCubit:
                                                          widget.expenseAsOnDateCubit,
                                                          expensePeriodCubit: widget.expensePeriodCubit,
                                                          expenseReportCubit: widget.expenseReportCubit,
                                                        );
                                                      },
                                                    );
                                                  },
                                                )
                                            )
                                          else
                                            LoadingBg(
                                              height: widget.isFavorite ? ScreenUtil().screenHeight * 0.25 : ScreenUtil().screenHeight * 0.20,
                                              message: Message.noPositionFound,
                                              menu: widget.isFavorite && !widget.isDetailScreen ?
                                                  CustomPopupMenu(
                                                      onSelect: (int index) async {
                                                    if (index == 1) {
                                                      context
                                                          .read<FavoritesCubit>()
                                                          .saveFilters(
                                                        context: context,
                                                        shouldUpdate: false,
                                                        isPinned: false,
                                                        reportId: FavoriteConstants.expenseId,
                                                        reportName: "${widget.favorite?.reportname} Copy",
                                                        entity: widget.expenseReportCubit.expenseEntityCubit.state.selectedExpenseEntity,
                                                        currency:
                                                        widget.expenseReportCubit.expenseCurrencyCubit.state.selectedExpenseCurrency,
                                                        denomination: widget.expenseReportCubit.expenseDenominationCubit
                                                            .state.selectedExpenseDenomination,
                                                        asOnDate: widget.expenseReportCubit.expenseAsOnDateCubit.state.asOnDate,
                                                        expenseAccounts:
                                                        widget.expenseReportCubit.expenseAccountCubit.state.selectedAccountList,
                                                        period: widget.expenseReportCubit.expensePeriodCubit.state.selectedExpensePeriod,
                                                        numberOfPeriod: widget.expenseReportCubit.expenseNumberOfPeriodCubit
                                                            .state.selectedExpenseNumberOfPeriod,
                                                      );
                                                    } else if (index == 2) {
                                                      DeleteFavoriteDialog.show(context: context,
                                                      onCancel: (){
                                                        Navigator.of(context).popUntil(
                                                              (route) =>
                                                          route.settings.name ==
                                                              RouteList.dashboard,
                                                        );
                                                      },
                                                      onDelete: (){
                                                        context
                                                            .read<FavoritesCubit>()
                                                            .removeFavorites(
                                                            context: context,
                                                            favorite: widget.favorite);
                                                        Navigator.of(context).pop();
                                                      });
                                                    }
                                                  },
                                                    isLoading: true,
                                                  )
                                                  : null,
                                              onRetry: () async{
                                                await showModalBottomSheet(
                                                  context: context,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(Sizes.dimen_10.r),
                                                      topRight: Radius.circular(Sizes.dimen_10.r),
                                                    ),
                                                  ),
                                                  isScrollControlled: true,
                                                  builder: (context) {
                                                    return ExpenseUniversalFilter(
                                                      favorite: widget.favorite,
                                                      isFavorite: widget.isFavorite,
                                                      expenseLoadingCubit:
                                                      widget.expenseLoadingCubit,
                                                      expenseEntityCubit: widget.expenseEntityCubit,
                                                      expenseAccountCubit:
                                                      widget.expenseAccountCubit,
                                                      expenseNumberOfPeriodCubit:
                                                      widget.expenseNumberOfPeriodCubit,
                                                      expenseCurrencyCubit:
                                                      widget.expenseCurrencyCubit,
                                                      expenseDenominationCubit:
                                                      widget.expenseDenominationCubit,
                                                      expenseAsOnDateCubit:
                                                      widget.expenseAsOnDateCubit,
                                                      expensePeriodCubit: widget.expensePeriodCubit,
                                                      expenseReportCubit: widget.expenseReportCubit,
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          UIHelper.verticalSpaceSmall,
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: Sizes.dimen_22.h,
                                                child: Row(
                                                  children: [
                                                    Expanded(child: LoadingBg()),
                                                    Expanded(child: LoadingBg()),
                                                    UIHelper.horizontalSpaceMedium,
                                                    Expanded(child: Container()),
                                                  ],
                                                ),
                                              ),
                                              if(!widget.isDetailScreen && !widget.isFavorite)
                                                ...[
                                                  UIHelper.verticalSpaceSmall,
                                                  SizedBox(
                                                    height: Sizes.dimen_10.h,
                                                    child: Row(
                                                      children: [
                                                        Expanded(child: Container()),
                                                        UIHelper.horizontalSpaceMedium,
                                                        Expanded(child: Container()),
                                                        UIHelper.horizontalSpaceMedium,
                                                        Expanded(child: Container()),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              UIHelper.verticalSpaceSmall,
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                });
                          } else if (expenseState is ExpenseReportLoading) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_14.w,),
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: !widget.isFavorite && !widget.isDetailScreen ? BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                            color: AppColor.textGrey.withValues(alpha: 0.2),
                                            width: 0.6,
                                          )),
                                    ): null,
                                    padding: EdgeInsets.only(
                                      top: Sizes.dimen_4.h,
                                      bottom: Sizes.dimen_1.h,
                                    ),
                                  ),

                                  if(!widget.isDetailScreen && !widget.isFavorite)
                                    Expanded(
                                        child: LoadingBg(message: Message.loading,)
                                    )
                                  else
                                    LoadingBg(
                                      height: widget.isFavorite ? ScreenUtil().screenHeight * 0.25 : ScreenUtil().screenHeight * 0.20,
                                      message: Message.loading,
                                      menu: widget.isFavorite && !widget.isDetailScreen ? CustomPopupMenu(
                                          onSelect: (int index) async {
                                        if (index == 1) {
                                          context
                                              .read<FavoritesCubit>()
                                              .saveFilters(
                                            context: context,
                                            shouldUpdate: false,
                                            isPinned: false,
                                            reportId: FavoriteConstants.expenseId,
                                            reportName: "${widget.favorite?.reportname} Copy",
                                            entity: widget.expenseReportCubit.expenseEntityCubit.state.selectedExpenseEntity,
                                            currency:
                                            widget.expenseReportCubit.expenseCurrencyCubit.state.selectedExpenseCurrency,
                                            denomination: widget.expenseReportCubit.expenseDenominationCubit
                                                .state.selectedExpenseDenomination,
                                            asOnDate: widget.expenseReportCubit.expenseAsOnDateCubit.state.asOnDate,
                                            expenseAccounts:
                                            widget.expenseReportCubit.expenseAccountCubit.state.selectedAccountList,
                                            period: widget.expenseReportCubit.expensePeriodCubit.state.selectedExpensePeriod,
                                            numberOfPeriod: widget.expenseReportCubit.expenseNumberOfPeriodCubit
                                                .state.selectedExpenseNumberOfPeriod,
                                          );

                                        } else if (index == 2) {

                                          DeleteFavoriteDialog.show(context: context,
                                          onCancel: (){
                                            Navigator.of(context).popUntil(
                                                  (route) =>
                                              route.settings.name ==
                                                  RouteList.dashboard,
                                            );
                                          },
                                          onDelete: (){
                                            context
                                                .read<FavoritesCubit>()
                                                .removeFavorites(
                                                context: context,
                                                favorite: widget.favorite);
                                            Navigator.of(context).pop();
                                          });
                                        }
                                      },
                                      isLoading: true,
                                      ): null,
                                    ),
                                  UIHelper.verticalSpaceSmall,
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: Sizes.dimen_22.h,
                                        child: Row(
                                          children: [
                                            Expanded(child: LoadingBg()),
                                            Expanded(child: LoadingBg()),
                                            UIHelper.horizontalSpaceMedium,
                                            Expanded(child: Container()),
                                          ],
                                        ),
                                      ),
                                      if(!widget.isDetailScreen && !widget.isFavorite)
                                        ...[
                                          UIHelper.verticalSpaceSmall,
                                          SizedBox(
                                            height: Sizes.dimen_10.h,
                                            child: Row(
                                              children: [
                                                Expanded(child: Container()),
                                                UIHelper.horizontalSpaceMedium,
                                                Expanded(child: Container()),
                                                UIHelper.horizontalSpaceMedium,
                                                Expanded(child: Container()),
                                              ],
                                            ),
                                          ),
                                        ],
                                      UIHelper.verticalSpaceSmall,
                                    ],
                                  ),
                                ],
                              ),
                            );
                          } else if (expenseState is ExpenseReportError) {
                            if (expenseState.errorType ==
                                AppErrorType.unauthorised) {
                              AppHelpers.logout(context: context);
                            }
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_14.w,),
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                            color: AppColor.textGrey.withValues(alpha: 0.2),
                                            width: 0.6,
                                          )),
                                    ),
                                    padding: EdgeInsets.only(
                                      top: Sizes.dimen_4.h,
                                      bottom: Sizes.dimen_1.h,
                                    ),
                                  ),
                                  if(!widget.isDetailScreen && !widget.isFavorite)
                                    Expanded(
                                        child: LoadingBg(
                                          message: Message.error,
                                          onRetry: () async{
                                            await showModalBottomSheet(
                                              context: context,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(Sizes.dimen_10.r),
                                                  topRight: Radius.circular(Sizes.dimen_10.r),
                                                ),
                                              ),
                                              isScrollControlled: true,
                                              builder: (context) {
                                                return ExpenseUniversalFilter(
                                                  favorite: widget.favorite,
                                                  isFavorite: widget.isFavorite,
                                                  expenseLoadingCubit:
                                                  widget.expenseLoadingCubit,
                                                  expenseEntityCubit: widget.expenseEntityCubit,
                                                  expenseAccountCubit:
                                                  widget.expenseAccountCubit,
                                                  expenseNumberOfPeriodCubit:
                                                  widget.expenseNumberOfPeriodCubit,
                                                  expenseCurrencyCubit:
                                                  widget.expenseCurrencyCubit,
                                                  expenseDenominationCubit:
                                                  widget.expenseDenominationCubit,
                                                  expenseAsOnDateCubit:
                                                  widget.expenseAsOnDateCubit,
                                                  expensePeriodCubit: widget.expensePeriodCubit,
                                                  expenseReportCubit: widget.expenseReportCubit,
                                                );
                                              },
                                            );
                                          },
                                        )
                                    )
                                  else
                                    LoadingBg(
                                      height: widget.isFavorite ? ScreenUtil().screenHeight * 0.25 : ScreenUtil().screenHeight * 0.20,
                                      message: Message.error,
                                      menu: CustomPopupMenu(
                                          onSelect: (int index) async {
                                        if (index == 1) {
                                          context
                                              .read<FavoritesCubit>()
                                              .saveFilters(
                                            context: context,
                                            shouldUpdate: false,
                                            isPinned: false,
                                            reportId: FavoriteConstants.expenseId,
                                            reportName: "${widget.favorite?.reportname} Copy",
                                            entity: widget.expenseReportCubit.expenseEntityCubit.state.selectedExpenseEntity,
                                            currency:
                                            widget.expenseReportCubit.expenseCurrencyCubit.state.selectedExpenseCurrency,
                                            denomination: widget.expenseReportCubit.expenseDenominationCubit
                                                .state.selectedExpenseDenomination,
                                            asOnDate: widget.expenseReportCubit.expenseAsOnDateCubit.state.asOnDate,
                                            expenseAccounts:
                                            widget.expenseReportCubit.expenseAccountCubit.state.selectedAccountList,
                                            period: widget.expenseReportCubit.expensePeriodCubit.state.selectedExpensePeriod,
                                            numberOfPeriod: widget.expenseReportCubit.expenseNumberOfPeriodCubit
                                                .state.selectedExpenseNumberOfPeriod,
                                          );

                                        } else if (index == 2) {

                                          DeleteFavoriteDialog.show(context: context,
                                          onCancel: (){
                                            Navigator.of(context).popUntil(
                                                  (route) =>
                                              route.settings.name ==
                                                  RouteList.dashboard,
                                            );
                                          },
                                          onDelete: (){
                                            context
                                                .read<FavoritesCubit>()
                                                .removeFavorites(
                                                context: context,
                                                favorite: widget.favorite);
                                            Navigator.of(context).pop();
                                          });
                                        }
                                      },
                                      isLoading: true,
                                      ),
                                      onRetry: () async{
                                        await showModalBottomSheet(
                                          context: context,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(Sizes.dimen_10.r),
                                              topRight: Radius.circular(Sizes.dimen_10.r),
                                            ),
                                          ),
                                          isScrollControlled: true,
                                          builder: (context) {
                                            return ExpenseUniversalFilter(
                                              favorite: widget.favorite,
                                              isFavorite: widget.isFavorite,
                                              expenseLoadingCubit:
                                              widget.expenseLoadingCubit,
                                              expenseEntityCubit: widget.expenseEntityCubit,
                                              expenseAccountCubit:
                                              widget.expenseAccountCubit,
                                              expenseNumberOfPeriodCubit:
                                              widget.expenseNumberOfPeriodCubit,
                                              expenseCurrencyCubit:
                                              widget.expenseCurrencyCubit,
                                              expenseDenominationCubit:
                                              widget.expenseDenominationCubit,
                                              expenseAsOnDateCubit:
                                              widget.expenseAsOnDateCubit,
                                              expensePeriodCubit: widget.expensePeriodCubit,
                                              expenseReportCubit: widget.expenseReportCubit,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  UIHelper.verticalSpaceSmall,
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: Sizes.dimen_22.h,
                                        child: Row(
                                          children: [
                                            Expanded(child: LoadingBg()),
                                            Expanded(child: LoadingBg()),
                                            UIHelper.horizontalSpaceMedium,
                                            Expanded(child: Container()),
                                          ],
                                        ),
                                      ),
                                      if(!widget.isDetailScreen && !widget.isFavorite)
                                        ...[
                                          UIHelper.verticalSpaceSmall,
                                          SizedBox(
                                            height: Sizes.dimen_10.h,
                                            child: Row(
                                              children: [
                                                Expanded(child: Container()),
                                                UIHelper.horizontalSpaceMedium,
                                                Expanded(child: Container()),
                                                UIHelper.horizontalSpaceMedium,
                                                Expanded(child: Container()),
                                              ],
                                            ),
                                          ),
                                        ],
                                      UIHelper.verticalSpaceSmall,
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_14.w,),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                          color: AppColor.textGrey.withValues(alpha: 0.2),
                                          width: 0.6,
                                        )),
                                  ),
                                  padding: EdgeInsets.only(
                                    top: Sizes.dimen_4.h,
                                    bottom: Sizes.dimen_1.h,
                                  ),
                                ),
                                if(!widget.isDetailScreen && !widget.isFavorite)
                                  Expanded(
                                      child: LoadingBg(message: Message.loading,)
                                  )
                                else
                                  LoadingBg(
                                    height: widget.isFavorite ? ScreenUtil().screenHeight * 0.25 : ScreenUtil().screenHeight * 0.20,
                                    message: Message.loading,
                                    menu: CustomPopupMenu(onSelect: (int index) async {
                                      if (index == 1) {
                                        context
                                            .read<FavoritesCubit>()
                                            .saveFilters(
                                          context: context,
                                          shouldUpdate: false,
                                          isPinned: false,
                                          reportId: FavoriteConstants.expenseId,
                                          reportName: "${widget.favorite?.reportname} Copy",
                                          entity: widget.expenseReportCubit.expenseEntityCubit.state.selectedExpenseEntity,
                                          currency:
                                          widget.expenseReportCubit.expenseCurrencyCubit.state.selectedExpenseCurrency,
                                          denomination: widget.expenseReportCubit.expenseDenominationCubit
                                              .state.selectedExpenseDenomination,
                                          asOnDate: widget.expenseReportCubit.expenseAsOnDateCubit.state.asOnDate,
                                          expenseAccounts:
                                          widget.expenseReportCubit.expenseAccountCubit.state.selectedAccountList,
                                          period: widget.expenseReportCubit.expensePeriodCubit.state.selectedExpensePeriod,
                                          numberOfPeriod: widget.expenseReportCubit.expenseNumberOfPeriodCubit
                                              .state.selectedExpenseNumberOfPeriod,
                                        );
                                      } else if (index == 2) {

                                        DeleteFavoriteDialog.show(context: context,
                                        onCancel: (){
                                          Navigator.of(context).popUntil(
                                                (route) =>
                                            route.settings.name ==
                                                RouteList.dashboard,
                                          );
                                        },
                                        onDelete: (){
                                          context
                                              .read<FavoritesCubit>()
                                              .removeFavorites(
                                              context: context,
                                              favorite: widget.favorite);
                                          Navigator.of(context).pop();
                                        });
                                      }
                                    }),
                                  ),
                                UIHelper.verticalSpaceSmall,
                                Column(
                                  children: [
                                    SizedBox(
                                      height: Sizes.dimen_22.h,
                                      child: Row(
                                        children: [
                                          Expanded(child: LoadingBg()),
                                          Expanded(child: LoadingBg()),
                                          UIHelper.horizontalSpaceMedium,
                                          Expanded(child: Container()),
                                        ],
                                      ),
                                    ),
                                    if(!widget.isDetailScreen && !widget.isFavorite)
                                      ...[
                                        UIHelper.verticalSpaceSmall,
                                        SizedBox(
                                          height: Sizes.dimen_10.h,
                                          child: Row(
                                            children: [
                                              Expanded(child: Container()),
                                              UIHelper.horizontalSpaceMedium,
                                              Expanded(child: Container()),
                                              UIHelper.horizontalSpaceMedium,
                                              Expanded(child: Container()),
                                            ],
                                          ),
                                        ),
                                      ],
                                    UIHelper.verticalSpaceSmall,
                                  ],
                                ),
                              ],
                            ),
                          );
                        });
                  });
            });
      });
    });
  }
}

class TextAbbr extends StatefulWidget {
  final void Function(double) setHeight;
  final String text;
  const TextAbbr({
    super.key,
    required this.setHeight,
    required this.text,
  });

  @override
  State<TextAbbr> createState() => _TextAbbrState();
}

class _TextAbbrState extends State<TextAbbr> {
  double? _oldSize;

  void _notifySize() {
    if (!mounted) {
      return;
    }
    final size = context.size?.height;
    if (_oldSize != size && size != null) {
      _oldSize = size;
      widget.setHeight(size);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
    return Text(
      widget.text,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleSmall
          ?.copyWith(
        color: AppColor.grey,
        fontWeight:
        FontWeight.normal,
      ),
    );
  }
}