
import 'package:asset_vantage/src/config/constants/size_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/domain/entities/dashboard/dashboard_list_entity.dart';
import 'package:asset_vantage/src/domain/entities/investment_policy_statement/investment_policy_statement_time_period_entity.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_grouping/investment_policy_statement_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_report/investment_policy_statement_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_tabbed/investment_policy_statement_tabbed_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_time_period/investment_policy_statement_time_period_cubit.dart';
import 'package:asset_vantage/src/presentation/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../data/models/investment_policy_statement/investment_policy_statement_time_period_model.dart';
import '../../blocs/app_theme/theme_cubit.dart';
import '../../blocs/currency_filter/currency_filter_cubit.dart';
import '../../blocs/investment_policy_statement/investment_policy_statement_policy/investment_policy_statement_policy_cubit.dart';


class Year1Filter extends StatefulWidget {
  TimePeriodItemData hint;
  List<TimePeriodItemData> items;
  TimePeriodItemData? selectedItem;
  final EntityData? entity;
  final String? asOnDate;
  final InvestmentPolicyStatementTimePeriodCubit investmentPolicyStatementTimePeriodCubit;
  final InvestmentPolicyStatementPolicyCubit investmentPolicyStatementPolicyCubit;
  final InvestmentPolicyStatementReportCubit investmentPolicyStatementReportCubit;
  final InvestmentPolicyStatementGroupingCubit investmentPolicyStatementGroupingCubit;
  final InvestmentPolicyStatementTabbedCubit investmentPolicyStatementTabbedCubit;

  Year1Filter({
    Key? key,
    required this.hint,
    required this.items,
    required this.entity,
    required this.asOnDate,
    required this.investmentPolicyStatementTimePeriodCubit,
    required this.investmentPolicyStatementPolicyCubit,
    required this.investmentPolicyStatementReportCubit,
    required this.investmentPolicyStatementGroupingCubit,
    required this.investmentPolicyStatementTabbedCubit,
  }) : super(key: key);

  @override
  State<Year1Filter> createState() => _Year1FilterState();
}

class _Year1FilterState extends State<Year1Filter> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showBottomSheet();
      },
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)
            )
        ),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
          ),
          width: ScreenUtil().screenWidth * 0.30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_3.h, horizontal: Sizes.dimen_6.w),
                  child: Text('Return %',
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_4.w),
                  child: Icon(Icons.arrow_drop_down_outlined, color: context.read<AppThemeCubit>().state?.filter?.iconColor != null ? Color(int.parse(context.read<AppThemeCubit>().state!.filter!.iconColor!)) : AppColor.primary, size: Sizes.dimen_24.w,)
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) {
        return ReturnYearFilter(
          hint: widget.hint,
          items: widget.items,
          entity: widget.entity,
          asOnDate: widget.asOnDate,
          investmentPolicyStatementTimePeriodCubit: widget.investmentPolicyStatementTimePeriodCubit,
          investmentPolicyStatementPolicyCubit: widget.investmentPolicyStatementPolicyCubit,
          investmentPolicyStatementReportCubit: widget.investmentPolicyStatementReportCubit,
          investmentPolicyStatementGroupingCubit: widget.investmentPolicyStatementGroupingCubit,
          investmentPolicyStatementTabbedCubit: widget.investmentPolicyStatementTabbedCubit,
        );
      },
    );
  }
}

class ReturnYearFilter extends StatefulWidget {
  TimePeriodItemData hint;
  List<TimePeriodItemData> items;
  TimePeriodItemData? selectedItem;
  final EntityData? entity;
  final String? asOnDate;
  final InvestmentPolicyStatementTimePeriodCubit investmentPolicyStatementTimePeriodCubit;
  final InvestmentPolicyStatementPolicyCubit investmentPolicyStatementPolicyCubit;
  final InvestmentPolicyStatementReportCubit investmentPolicyStatementReportCubit;
  final InvestmentPolicyStatementGroupingCubit investmentPolicyStatementGroupingCubit;
  final InvestmentPolicyStatementTabbedCubit investmentPolicyStatementTabbedCubit;
  ReturnYearFilter({
    Key? key,
    required this.hint,
    required this.items,
    required this.entity,
    required this.asOnDate,
    required this.investmentPolicyStatementTimePeriodCubit,
    required this.investmentPolicyStatementPolicyCubit,
    required this.investmentPolicyStatementReportCubit,
    required this.investmentPolicyStatementGroupingCubit,
    required this.investmentPolicyStatementTabbedCubit,
  }) : super(key: key);

  @override
  State<ReturnYearFilter> createState() => _ReturnYearFilterState();
}

class _ReturnYearFilterState extends State<ReturnYearFilter> {

  @override
  void initState() {
    super.initState();
    widget.selectedItem = widget.investmentPolicyStatementTimePeriodCubit.state.timePeriodSelectedItem;
    widget.items..removeWhere((element) => element.id==widget.selectedItem?.id)..sort((a, b) => int.parse(a.name?.split(' ')[0] ?? '').compareTo(int.parse(b.name?.split(' ')[0] ?? '')),)..insert(0,widget.selectedItem ?? const TimePeriodItem());  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColor.grey.withOpacity(0.1),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_6.h, horizontal: Sizes.dimen_14.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/svgs/back_arrow.svg', width: Sizes.dimen_24.w, color: context.read<AppThemeCubit>().state?.bottomSheet?.backArrowColor != null ? Color(int.parse(context.read<AppThemeCubit>().state!.bottomSheet!.backArrowColor!)) : AppColor.primary,),
                        Text('Back',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: context.read<AppThemeCubit>().state?.bottomSheet?.backArrowColor != null ? Color(int.parse(context.read<AppThemeCubit>().state!.bottomSheet!.backArrowColor!)) : AppColor.primary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Text('Return %',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                      widget.hint = widget.selectedItem ?? const TimePeriodItemData();

                      widget.investmentPolicyStatementTimePeriodCubit.selectYear1(selectedTimePeriod: widget.selectedItem ?? const TimePeriodItemData(),entityName: widget.entity?.name,grouping: widget.investmentPolicyStatementGroupingCubit.investmentPolicyStatementTabbedCubit.state.selectedGrouping?.name);

                      widget.investmentPolicyStatementReportCubit.loadInvestmentPolicyStatementReport(
                          context: context,
                        timePeriod: [widget.selectedItem ?? const TimePeriodItemData()],
                        selectedEntity: widget.entity,
                        selectedPolicy: widget.investmentPolicyStatementPolicyCubit.state.selectedPolicy,
                        selectedGrouping: widget.investmentPolicyStatementGroupingCubit.investmentPolicyStatementTabbedCubit.state.selectedGrouping,
                        subGrouping: widget.investmentPolicyStatementGroupingCubit.investmentPolicyStatementTabbedCubit.state.subGroupingEntity?.subGroupingList,
                        asOnDate: widget.asOnDate,
                        reportingCurrency: context.read<CurrencyFilterCubit>().state.selectedIPSCurrency

                      );
                    });

                      Navigator.pop(context);
                    },
                    child: Text('Done',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: context.read<AppThemeCubit>().state?.bottomSheet?.backArrowColor != null ? Color(int.parse(context.read<AppThemeCubit>().state!.bottomSheet!.backArrowColor!)) : AppColor.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StatefulBuilder(
                  builder: (context, setState) {
                    return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: widget.items.length,
                        itemBuilder: (context, index) {
                          final filterData = widget.items[index];
                          return GestureDetector(
                            onTap: () {
                              setState((){
                                widget.selectedItem = filterData;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: Sizes.dimen_0.h, horizontal: Sizes.dimen_14.w),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: context.read<AppThemeCubit>().state?.bottomSheet?.borderColor != null ? Color(int.parse(context.read<AppThemeCubit>().state!.bottomSheet!.borderColor!)) : AppColor.grey.withOpacity(0.4))
                                  )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_14.w),
                                      child: Text(
                                          filterData.name ?? '--',
                                          style: Theme.of(context).textTheme.titleMedium,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis
                                      ),
                                    ),
                                  ),
                                  if(widget.selectedItem?.id == filterData.id)
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h, horizontal: Sizes.dimen_14.w),
                                      child: Icon(
                                        Icons.check_rounded,
                                        color: context.read<AppThemeCubit>().state?.bottomSheet?.checkColor != null ? Color(int.parse(context.read<AppThemeCubit>().state!.bottomSheet!.checkColor!)) : AppColor.primary,
                                        size: Sizes.dimen_24.w,
                                      ),
                                    )
                                ],
                              ),
                            ),
                          );
                        }
                    );
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
}
