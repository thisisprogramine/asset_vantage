
import 'package:asset_vantage/src/config/constants/size_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/domain/entities/dashboard/dashboard_list_entity.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_grouping/investment_policy_statement_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_report/investment_policy_statement_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_sub_grouping/investment_policy_statement_sub_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_tabbed/investment_policy_statement_tabbed_cubit.dart';
import 'package:asset_vantage/src/presentation/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../data/models/investment_policy_statement/investment_policy_statement_sub_grouping_model.dart';
import '../../../domain/entities/investment_policy_statement/investment_policy_statement_sub_grouping_entity.dart';
import '../../blocs/app_theme/theme_cubit.dart';

class GroupingFilter extends StatefulWidget {
  SubGroupingItemData hint;
  List<SubGroupingItemData> items;
  List<SubGroupingItemData> selectedItems;
  final EntityData? entity;
  final InvestmentPolicyStatementSubGroupingCubit investmentPolicyStatementSubGroupingCubit;
  final InvestmentPolicyStatementReportCubit investmentPolicyStatementReportCubit;
  final InvestmentPolicyStatementGroupingCubit investmentPolicyStatementGroupingCubit;
  final InvestmentPolicyStatementTabbedCubit investmentPolicyStatementTabbedCubit;

  GroupingFilter({
    Key? key,
    required this.hint,
    required this.items,
    required this.selectedItems,
    required this.entity,
    required this.investmentPolicyStatementSubGroupingCubit,
    required this.investmentPolicyStatementReportCubit,
    required this.investmentPolicyStatementGroupingCubit,
    required this.investmentPolicyStatementTabbedCubit,
  }) : super(key: key);

  @override
  State<GroupingFilter> createState() => _GroupingFilterState();
}

class _GroupingFilterState extends State<GroupingFilter> {

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
              border: Border.all(color: context.read<AppThemeCubit>().state?.card?.color != null ? Color(int.parse(context.read<AppThemeCubit>().state!.card!.color!)) : AppColor.vulcan)
          ),
          width: ScreenUtil().screenWidth * 0.30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_3.h, horizontal: Sizes.dimen_6.w),
                  child: Text('${widget.hint.name?.replaceAll('-', ' ')}',
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_4.w),
                  child: Icon(Icons.arrow_drop_down_outlined,
                    color: context.read<AppThemeCubit>().state?.filter?.iconColor != null
                      ? Color(int.parse(context.read<AppThemeCubit>().state!.filter!.iconColor!))
                      : AppColor.primary, size: Sizes.dimen_24.w,)
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
        return GroupingFilterList(
          hint: widget.hint,
          items: widget.items,
          entity: widget.entity,
          investmentPolicyStatementSubGroupingCubit: widget.investmentPolicyStatementSubGroupingCubit,
          investmentPolicyStatementReportCubit: widget.investmentPolicyStatementReportCubit,
          investmentPolicyStatementGroupingCubit: widget.investmentPolicyStatementGroupingCubit,
          investmentPolicyStatementTabbedCubit: widget.investmentPolicyStatementTabbedCubit,
        );
      },
    );
  }
}

class GroupingFilterList extends StatefulWidget {
  SubGroupingItemData hint;
  final List<SubGroupingItemData> items;
  List<SubGroupingItemData> selectedItems = [];
  final EntityData? entity;
  final InvestmentPolicyStatementSubGroupingCubit investmentPolicyStatementSubGroupingCubit;
  final InvestmentPolicyStatementReportCubit investmentPolicyStatementReportCubit;
  final InvestmentPolicyStatementGroupingCubit investmentPolicyStatementGroupingCubit;
  final InvestmentPolicyStatementTabbedCubit investmentPolicyStatementTabbedCubit;
  GroupingFilterList({
    Key? key,
    required this.hint,
    required this.items,
    required this.entity,
    required this.investmentPolicyStatementSubGroupingCubit,
    required this.investmentPolicyStatementReportCubit,
    required this.investmentPolicyStatementGroupingCubit,
    required this.investmentPolicyStatementTabbedCubit,
  }) : super(key: key);

  @override
  State<GroupingFilterList> createState() => _GroupingFilterListState();
}

class _GroupingFilterListState extends State<GroupingFilterList> {

  @override
  void initState() {
    super.initState();
    widget.selectedItems.addAll(widget.investmentPolicyStatementSubGroupingCubit.state.subGroupingSelectedItems);
    if(widget.selectedItems.length==widget.items.length){
      widget.selectedItems.add(const SubGroupingItem(id: '1', name: 'Select All'));
    }
    widget.items..removeWhere((element) => widget.selectedItems.any((ele) => ele.id==element.id))..sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''),)..insertAll(0, widget.selectedItems.map((e) => SubGroupingItem.fromJson(e.toJson())).toList()..sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''),))..removeWhere((element) => element.name=='Select All')..insert(0, const SubGroupingItem(id: '1', name: 'Select All'));  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
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
                  Text('${widget.hint.name?.replaceAll('-', ' ')}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.investmentPolicyStatementSubGroupingCubit.selectItemInFilter1(selectedFilter: widget.selectedItems..removeWhere((element) => element.name=='Select All'),entityName: widget.entity?.name,grouping: widget.investmentPolicyStatementGroupingCubit.investmentPolicyStatementTabbedCubit.state.selectedGrouping?.name);
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
                              setState(() {
                                if(filterData.name == 'Select All') {
                                  if(widget.selectedItems.length == widget.items.length) {
                                    widget.selectedItems = [];
                                  }else {
                                    widget.selectedItems.clear();
                                    widget.selectedItems.addAll(widget.items);
                                  }
                                }else {
                                  if(widget.selectedItems.contains(filterData)) {
                                    widget.selectedItems.remove(filterData);
                                  }else {
                                    if(filterData != null) {
                                      widget.selectedItems.add(filterData);
                                    }
                                  }
                                }
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
                                  if(filterData.name == 'Select All' ? widget.selectedItems.length == widget.items.length : widget.selectedItems.contains(filterData))
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
