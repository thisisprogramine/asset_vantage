import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_tabbed/investment_policy_statement_tabbed_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/constants/size_constants.dart';
import '../../data/models/currency/currency_model.dart';
import '../../domain/entities/currency/currency_entity.dart';
import '../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../blocs/app_theme/theme_cubit.dart';
import '../blocs/cash_balance/cash_balance_grouping/cash_balance_grouping_cubit.dart';
import '../blocs/currency_filter/currency_filter_cubit.dart';
import '../blocs/expense/expense_account/expense_account_cubit.dart';
import '../blocs/income/income_account/income_account_cubit.dart';
import '../blocs/investment_policy_statement/investment_policy_statement_grouping/investment_policy_statement_grouping_cubit.dart';
import '../blocs/net_worth/net_worth_grouping/net_worth_grouping_cubit.dart';
import '../theme/theme_color.dart';

class CurrencyFilter extends StatefulWidget {
  final List<Currency>? items;
  final Currency? selectedCurrency;
  final ReportType type;
  final EntityData? selectedEntity;
  final String? asOnDate;
  final String? tileName;
  ScrollController? scrollController;
  void Function(Currency?)? onDone;
  InvestmentPolicyStatementGroupingCubit?
      investmentPolicyStatementGroupingCubit;
  CashBalancePrimaryGroupingCubit? cashBalanceGroupingCubit;
  NetWorthGroupingCubit? netWorthGroupingCubit;
  IncomeAccountCubit? incomeAccountCubit;
  ExpenseAccountCubit? expenseAccountCubit;
  InvestmentPolicyStatementTabbedCubit? investmentPolicyStatementTabbedCubit;

  CurrencyFilter(
      {Key? key,
      required this.items,this.selectedCurrency,
      required this.type,
      this.selectedEntity,
      required this.asOnDate,
      required this.tileName,
      this.investmentPolicyStatementGroupingCubit,
      this.cashBalanceGroupingCubit,
      this.netWorthGroupingCubit,
      this.incomeAccountCubit,
      this.expenseAccountCubit,
      this.investmentPolicyStatementTabbedCubit,
      this.onDone,
      this.scrollController})
      : super(key: key);

  @override
  State<CurrencyFilter> createState() => _CurrencyFilterState();
}

class _CurrencyFilterState extends State<CurrencyFilter> {
  Currency? selectedItem;
  List<Currency>? itemToShow;
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.type == ReportType.IPS) {
      selectedItem =
          context.read<CurrencyFilterCubit>().state.selectedIPSCurrency;
    } else if (widget.type == ReportType.CB) {
      selectedItem =
          context.read<CurrencyFilterCubit>().state.selectedCBCurrency;
    } else if (widget.type == ReportType.NW) {
      selectedItem =
         widget.selectedCurrency ?? context.read<CurrencyFilterCubit>().state.selectedNWCurrency;
    } else if (widget.type == ReportType.PER) {
      selectedItem =
          context.read<CurrencyFilterCubit>().state.selectedPERCurrency;
    } else if (widget.type == ReportType.IE) {
      selectedItem =
          context.read<CurrencyFilterCubit>().state.selectedIECurrency;
    }

    itemToShow = [...(widget.items ?? [])];

    itemToShow
      ?..removeWhere((element) => element.id == selectedItem?.id)
      ..insert(0, selectedItem ?? CurrencyData());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: Sizes.dimen_6.h, horizontal: Sizes.dimen_14.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  widget.onDone!(null);
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svgs/back_arrow.svg',
                      width: Sizes.dimen_24.w,
                      color: context
                                  .read<AppThemeCubit>()
                                  .state
                                  ?.bottomSheet
                                  ?.backArrowColor !=
                              null
                          ? Color(int.parse(context
                              .read<AppThemeCubit>()
                              .state!
                              .bottomSheet!
                              .backArrowColor!))
                          : AppColor.primary,
                    ),
                    Text(
                      'Back',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: context
                                      .read<AppThemeCubit>()
                                      .state
                                      ?.bottomSheet
                                      ?.backArrowColor !=
                                  null
                              ? Color(int.parse(context
                                  .read<AppThemeCubit>()
                                  .state!
                                  .bottomSheet!
                                  .backArrowColor!))
                              : AppColor.primary,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Text(
                'Currency',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (widget.type == ReportType.IPS) {
                      widget.investmentPolicyStatementGroupingCubit
                          ?.loadInvestmentPolicyStatementGrouping(
                        context: context,
                        currentTabIndex: widget
                            .investmentPolicyStatementTabbedCubit
                            ?.state
                            .currentTabIndex,
                        shouldClearData: true,
                        selectedEntity: widget.selectedEntity,
                        asOnDate: widget.asOnDate,
                        reportingCurrency: selectedItem,
                      );
                    } else if (widget.type == ReportType.CB) {
                    }
                    else if (widget.type == ReportType.PER) {

                    } else if (widget.type == ReportType.IE) {
                    }
                  });
                  widget.onDone!(selectedItem);
                },
                child: Text(
                  'Done',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: context
                                  .read<AppThemeCubit>()
                                  .state
                                  ?.bottomSheet
                                  ?.backArrowColor !=
                              null
                          ? Color(int.parse(context
                              .read<AppThemeCubit>()
                              .state!
                              .bottomSheet!
                              .backArrowColor!))
                          : AppColor.primary,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: Sizes.dimen_6.h, horizontal: Sizes.dimen_12.w),
                child: Card(
                  color: AppColor.white.withOpacity(0.8),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  )),
                  child: TextFormField(
                    key: widget.key,
                    controller: controller,
                    textInputAction: TextInputAction.search,
                    onChanged: (String text) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Sizes.dimen_2.h,
                              horizontal: Sizes.dimen_12.w),
                          child: SvgPicture.asset('assets/svgs/search.svg',
                              width: Sizes.dimen_24.w,
                              color: Theme.of(context).iconTheme.color)),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: Sizes.dimen_2.h,
                          horizontal: Sizes.dimen_12.w),
                      isDense: true,
                      border: InputBorder.none,
                      prefixIconConstraints: const BoxConstraints(),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                controller.text = "";
                setState(() {});
              },
              child: Padding(
                padding: EdgeInsets.only(right: Sizes.dimen_12.w),
                child: Text(
                  'Cancel',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColor.textGrey, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
        if (itemToShow?.any((element) =>
                (element.code
                        ?.toLowerCase()
                        .contains(controller.text.toLowerCase()) ??
                    true) ||
                controller.text.isEmpty) ??
            false)
          Expanded(
            child: StatefulBuilder(builder: (context, setState) {
              return ListView.builder(
                controller: widget.scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: itemToShow?.length ?? 0,
                  itemBuilder: (context, index) {
                    final filterData = itemToShow?[index];
                    if ((filterData?.code
                                ?.toLowerCase()
                                .contains(controller.text.toLowerCase()) ??
                            true) ||
                        controller.text.isEmpty) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedItem = filterData;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: Sizes.dimen_0.h,
                              horizontal: Sizes.dimen_14.w),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: context
                                                  .read<AppThemeCubit>()
                                                  .state
                                                  ?.bottomSheet
                                                  ?.borderColor !=
                                              null
                                          ? Color(int.parse(context
                                              .read<AppThemeCubit>()
                                              .state!
                                              .bottomSheet!
                                              .borderColor!))
                                          : AppColor.grey.withOpacity(0.4)))),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Sizes.dimen_4.h,
                                      horizontal: Sizes.dimen_14.w),
                                  child: Text(filterData?.code ?? '--',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                              if (selectedItem?.id == filterData?.id)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Sizes.dimen_2.h,
                                      horizontal: Sizes.dimen_14.w),
                                  child: Icon(
                                    Icons.check_rounded,
                                    color: context
                                                .read<AppThemeCubit>()
                                                .state
                                                ?.bottomSheet
                                                ?.checkColor !=
                                            null
                                        ? Color(int.parse(context
                                            .read<AppThemeCubit>()
                                            .state!
                                            .bottomSheet!
                                            .checkColor!))
                                        : AppColor.primary,
                                    size: Sizes.dimen_24.w,
                                  ),
                                )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  });
            }),
          )
        else
          Expanded(
            child: Center(
              child: Text(
                'No result found',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
      ],
    );
  }
}
