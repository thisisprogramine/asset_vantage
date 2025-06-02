
import 'package:asset_vantage/src/config/constants/size_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/domain/entities/dashboard/dashboard_list_entity.dart';
import 'package:asset_vantage/src/domain/entities/investment_policy_statement/investment_policy_statement_sub_grouping_entity.dart';
import 'package:asset_vantage/src/domain/entities/investment_policy_statement/investment_policy_statement_time_period_entity.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_grouping/investment_policy_statement_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_sub_grouping/investment_policy_statement_sub_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_time_period/investment_policy_statement_time_period_cubit.dart';
import 'package:asset_vantage/src/presentation/theme/theme_color.dart';
import 'package:asset_vantage/src/utilities/helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../config/constants/route_constants.dart';
import '../../../domain/entities/app_error.dart';
import '../../../domain/entities/investment_policy_statement/investment_policy_statement_policies_entity.dart';
import '../../../utilities/helper/app_helper.dart';
import '../../../utilities/helper/flash_helper.dart';
import '../../blocs/authentication/login/login_cubit.dart';
import '../../blocs/investment_policy_statement/investment_policy_statement_policy/investment_policy_statement_policy_cubit.dart';
import '../../blocs/investment_policy_statement/investment_policy_statement_report/investment_policy_statement_report_cubit.dart';
import '../../blocs/investment_policy_statement/investment_policy_statement_tabbed/investment_policy_statement_tabbed_cubit.dart';
import 'grouping_filter.dart';
import 'policy_filter.dart';
import 'year1_filter.dart';

class FilterWidget extends StatefulWidget {
  final EntityData? entity;
  final String? asOnDate;
  const FilterWidget({
    Key? key,
    required this.entity,
    required this.asOnDate,
  }) : super(key: key);

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_12.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BlocBuilder<InvestmentPolicyStatementTabbedCubit, InvestmentPolicyStatementTabbedState>(
                            builder: (context, state) {
                              if(state is InvestmentPolicyStatementTabChanged) {
                                return Flexible(
                                    child: PolicyFilter(
                                      hint: const Policies(id: 0, policyname: "Policy"),
                                      items: state.policyEntity?.policyList ?? [],
                                      entity: widget.entity,
                                      asOnDate: widget.asOnDate,
                                      investmentPolicyStatementReportCubit: context.read<InvestmentPolicyStatementReportCubit>(),
                                      investmentPolicyStatementGroupingCubit: context.read<InvestmentPolicyStatementGroupingCubit>(),
                                      investmentPolicyStatementTabbedCubit: context.read<InvestmentPolicyStatementTabbedCubit>(),
                                      investmentPolicyStatementTimePeriodCubit: context.read<InvestmentPolicyStatementTimePeriodCubit>(),
                                      investmentPolicyStatementPolicyCubit: context.read<InvestmentPolicyStatementPolicyCubit>(),
                                    )
                                );
                              }
                              return Flexible(
                                child: Card(
                                  child: Shimmer.fromColors(
                                    baseColor: AppColor.white.withOpacity(0.1),
                                    highlightColor: AppColor.white.withOpacity(0.2),
                                    direction: ShimmerDirection.ltr,
                                    period: Duration(seconds: 1),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColor.lightGrey,
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_3.h, horizontal: Sizes.dimen_6.w),
                                              child: Text('',
                                                style: Theme.of(context).textTheme.titleSmall,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                        ),
                        UIHelper.horizontalSpaceSmall,
                        BlocBuilder<InvestmentPolicyStatementTabbedCubit, InvestmentPolicyStatementTabbedState>(
                            builder: (context, state) {
                              if(state is InvestmentPolicyStatementTabChanged) {
                                return Flexible(
                                    child: GroupingFilter(
                                      hint: SubGroupingItemData(id: "0", name: state.selectedGrouping?.name),
                                      items: state.subGroupingEntity?.subGroupingList ?? [],
                                      selectedItems: [],
                                      entity: widget.entity,
                                      investmentPolicyStatementSubGroupingCubit: context.read<InvestmentPolicyStatementSubGroupingCubit>(),
                                      investmentPolicyStatementReportCubit: context.read<InvestmentPolicyStatementReportCubit>(),
                                      investmentPolicyStatementGroupingCubit: context.read<InvestmentPolicyStatementGroupingCubit>(),
                                      investmentPolicyStatementTabbedCubit: context.read<InvestmentPolicyStatementTabbedCubit>(),
                                    )
                                );
                              }else if(state is InvestmentPolicyStatementTabbedError){
                                AppHelpers.logout(context: context);
                              }
                              return Flexible(
                                child: Card(
                                  child: Shimmer.fromColors(
                                    baseColor: AppColor.white.withOpacity(0.1),
                                    highlightColor: AppColor.white.withOpacity(0.2),
                                    direction: ShimmerDirection.ltr,
                                    period: Duration(seconds: 1),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColor.lightGrey,
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_3.h, horizontal: Sizes.dimen_6.w),
                                              child: Text('',
                                                style: Theme.of(context).textTheme.titleSmall,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                        ),
                        UIHelper.horizontalSpaceSmall,
                        BlocBuilder<InvestmentPolicyStatementTabbedCubit, InvestmentPolicyStatementTabbedState>(
                            builder: (context, state) {
                              if(state is InvestmentPolicyStatementTabChanged) {
                                return Flexible(
                                    child: Year1Filter(
                                      hint: const TimePeriodItemData(id: "0", name: "1 year %"),
                                      items: state.timePeriodEntity?.timePeriodList ?? [],
                                      entity: widget.entity,
                                      asOnDate: widget.asOnDate,
                                      investmentPolicyStatementReportCubit: context.read<InvestmentPolicyStatementReportCubit>(),
                                      investmentPolicyStatementPolicyCubit: context.read<InvestmentPolicyStatementPolicyCubit>(),
                                      investmentPolicyStatementGroupingCubit: context.read<InvestmentPolicyStatementGroupingCubit>(),
                                      investmentPolicyStatementTabbedCubit: context.read<InvestmentPolicyStatementTabbedCubit>(),
                                      investmentPolicyStatementTimePeriodCubit: context.read<InvestmentPolicyStatementTimePeriodCubit>(),
                                    )
                                );
                              }
                              return Flexible(
                                child: Card(
                                  child: Shimmer.fromColors(
                                    baseColor: AppColor.white.withOpacity(0.1),
                                    highlightColor: AppColor.white.withOpacity(0.2),
                                    direction: ShimmerDirection.ltr,
                                    period: Duration(seconds: 1),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColor.lightGrey,
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_3.h, horizontal: Sizes.dimen_6.w),
                                              child: Text('',
                                                style: Theme.of(context).textTheme.titleSmall,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                        ),
                      ],
                    )
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _showDialog({List<SubGroupingItemData>? list}) {
    List<SubGroupingItemData> selectedItems = [];

    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              height: ScreenUtil().screenHeight * 0.6,
              width: ScreenUtil().screenWidth * 0.8,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return ListView.builder(
                    itemCount: list?.length ?? 0,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          title: Text(list?[index].name ?? ''),
                            value: selectedItems.contains(list?[index]),
                            onChanged: (value) {
                              setState(() {
                                if(list?[index].name == 'Select All') {
                                  if(selectedItems.length == list?.length) {
                                    selectedItems = [];
                                  }else {
                                    selectedItems.clear();
                                    selectedItems.addAll(list ?? []);
                                  }
                                }else {
                                  if(selectedItems.contains(list?[index])) {
                                    selectedItems.remove(list?[index]);
                                  }else {
                                    if(list?[index] != null) {
                                      selectedItems.add(list![index]);
                                    }
                                  }
                                }
                              });
                            }
                        );
                      }
                  );
                }
              ),
            ),
          );
        }
    );
  }
}
