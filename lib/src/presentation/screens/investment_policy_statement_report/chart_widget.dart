
import 'dart:math';

import 'package:asset_vantage/src/config/constants/size_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/domain/entities/app_error.dart';
import 'package:asset_vantage/src/domain/entities/investment_policy_statement/investment_policy_statement_sub_grouping_entity.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_no_position/investment_policy_statement_no_position_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_sub_grouping/investment_policy_statement_sub_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_time_period/investment_policy_statement_time_period_cubit.dart';
import 'package:asset_vantage/src/presentation/theme/theme_color.dart';
import 'package:asset_vantage/src/utilities/helper/flash_helper.dart';
import 'package:asset_vantage/src/utilities/helper/ui_helper.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/constants/route_constants.dart';
import '../../../domain/entities/investment_policy_statement/chart_data.dart';
import '../../../utilities/helper/app_helper.dart';
import '../../blocs/app_theme/theme_cubit.dart';
import '../../blocs/authentication/login/login_cubit.dart';
import '../../blocs/investment_policy_statement/investment_policy_statement_report/investment_policy_statement_report_cubit.dart';
import '../../blocs/investment_policy_statement/investment_policy_statement_tabbed/investment_policy_statement_tabbed_cubit.dart';
import '../../blocs/investment_policy_statement/investment_policy_statement_timestamp/investment_policy_statement_timestamp_cubit.dart';
import '../../widgets/circular_progress.dart';
import 'chart_label.dart';

class ChartWidget extends StatefulWidget {
  const ChartWidget({Key? key}) : super(key: key);

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        children: [
          const ChartLabelWidget(),
          UIHelper.verticalSpace(Sizes.dimen_2.h),
          Expanded(
            child: Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)
                  )
              ),
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: Sizes.dimen_12.w),
                padding: EdgeInsets.symmetric(vertical: Sizes.dimen_0.h),
                child: BlocBuilder<InvestmentPolicyStatementTabbedCubit, InvestmentPolicyStatementTabbedState>(
                  builder: (context, tabbedState) {
                    return BlocBuilder<InvestmentPolicyStatementReportCubit, InvestmentPolicyStatementReportState>(
                        builder: (context, state) {
                          if(state is InvestmentPolicyStatementReportLoaded && tabbedState is InvestmentPolicyStatementTabChanged) {
                            return BlocBuilder<InvestmentPolicyStatementTimePeriodCubit, InvestmentPolicyStatementTimePeriodState>(
                                builder: (context, timePeriodState) {
                                  return BlocBuilder<InvestmentPolicyStatementSubGroupingCubit, InvestmentPolicyStatementSubGroupingState>(
                                      builder: (context, sunGroupingState) {
                                        context.read<InvestmentPolicyNoPositionCubit>().showNoPositionFound(show: true);
                                        return Column(
                                          children: [
                                            UIHelper.verticalSpace(Sizes.dimen_4.h),
                                            context.read<InvestmentPolicyStatementSubGroupingCubit>().state.subGroupingSelectedItems.isNotEmpty && !(context.read<InvestmentPolicyStatementSubGroupingCubit>().state.subGroupingSelectedItems.length == 1 && context.read<InvestmentPolicyStatementSubGroupingCubit>().state.subGroupingSelectedItems.first.name == 'Select All') ?
                                              Row(
                                              children: [
                                                Expanded(
                                                  flex: 7,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            left: BorderSide(
                                                                color: AppColor.grey.withOpacity(0.4)
                                                            ),
                                                            right: BorderSide(
                                                                color: AppColor.grey.withOpacity(0.4)
                                                            ),
                                                            bottom: BorderSide(
                                                                color: AppColor.grey.withOpacity(0.6)
                                                            )
                                                        )
                                                    ),
                                                    child: Center(
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_8.w, vertical: Sizes.dimen_2.h),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Text('Allocation',
                                                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 4,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            right: BorderSide(
                                                                color: AppColor.grey.withOpacity(0.4)
                                                            ),
                                                            bottom: BorderSide(
                                                                color: AppColor.grey.withOpacity(0.6)
                                                            )
                                                        )
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_8.w, vertical: Sizes.dimen_2.h),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text('Return',
                                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ) : const SizedBox(),
                                            Expanded(
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  if(context.read<InvestmentPolicyStatementSubGroupingCubit>().state.subGroupingSelectedItems.isNotEmpty && !(context.read<InvestmentPolicyStatementSubGroupingCubit>().state.subGroupingSelectedItems.length == 1 && context.read<InvestmentPolicyStatementSubGroupingCubit>().state.subGroupingSelectedItems.first.name == 'Select All'))
                                                    ListView.builder(
                                                        padding: EdgeInsets.zero,
                                                        physics: const BouncingScrollPhysics(),
                                                        itemCount: state.chartData.length,
                                                        itemBuilder: (context, index) {
                                                          final data = state.chartData[index];
                                                          if(data.title != '--') {
                                                            if(_isItemContain(data, sunGroupingState.subGroupingSelectedItems)) {
                                                              context.read<InvestmentPolicyNoPositionCubit>().showNoPositionFound(show: false);
                                                              return Container(
                                                                decoration: DottedDecoration(
                                                                    color: AppColor.grey.withOpacity(0.4)
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                        flex: 7,
                                                                        child: Container(
                                                                          decoration: BoxDecoration(
                                                                              border: Border(
                                                                                left: BorderSide(
                                                                                  color: AppColor.grey.withOpacity(0.4),
                                                                                ),
                                                                                right: BorderSide(
                                                                                  color: AppColor.grey.withOpacity(0.4),
                                                                                ),

                                                                              )
                                                                          ),
                                                                          child: Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h, horizontal: Sizes.dimen_8.w),
                                                                                child: Text(data.title,
                                                                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                                                                                  maxLines: 1,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                ),
                                                                              ),
                                                                              UIHelper.verticalSpace(Sizes.dimen_6),
                                                                              Tooltip(
                                                                                message: '${data.actualAlloc.toStringAsFixed(2)}%',
                                                                                textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColor.pink, fontWeight: FontWeight.bold),
                                                                                preferBelow: false,
                                                                                decoration: BoxDecoration(
                                                                                    color: context.read<AppThemeCubit>().state?.card?.color != null ? Color(int.parse(context.read<AppThemeCubit>().state!.card!.color!)) : AppColor.lightGrey,
                                                                                    border: Border.all(color: Theme.of(context).iconTheme.color ?? AppColor.white),
                                                                                    borderRadius: BorderRadius.circular(5.0)
                                                                                ),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Flexible(
                                                                                      child: FractionallySizedBox(
                                                                                        alignment: Alignment.centerLeft,
                                                                                        widthFactor: _formatForFraction(data.actualAlloc.toInt()),
                                                                                        child: Container(
                                                                                          decoration: const BoxDecoration(
                                                                                              color: AppColor.pink,
                                                                                              borderRadius: BorderRadius.only(topRight: Radius.circular(10.0))
                                                                                          ),
                                                                                          child: Text('',
                                                                                            style: Theme.of(context).textTheme.titleSmall,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Container(
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_6.w, vertical: Sizes.dimen_0.h),
                                                                                        child: Text('${data.actualAlloc.toStringAsFixed(2)}%',
                                                                                          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColor.pink, fontWeight: FontWeight.bold),
                                                                                          maxLines: 1,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Tooltip(
                                                                                message: '${data.expectedAlloc.toStringAsFixed(2)}%',
                                                                                textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColor.purple, fontWeight: FontWeight.bold),
                                                                                preferBelow: false,
                                                                                decoration: BoxDecoration(
                                                                                    color: context.read<AppThemeCubit>().state?.card?.color != null ? Color(int.parse(context.read<AppThemeCubit>().state!.card!.color!)) : AppColor.lightGrey,
                                                                                    border: Border.all(color: Theme.of(context).iconTheme.color ?? AppColor.white),
                                                                                    borderRadius: BorderRadius.circular(5.0)
                                                                                ),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Flexible(
                                                                                      child: FractionallySizedBox(
                                                                                          alignment: Alignment.centerLeft,
                                                                                          widthFactor: _formatForFraction(data.expectedAlloc.toInt()),
                                                                                          child: Container(
                                                                                            decoration: const BoxDecoration(
                                                                                                color: AppColor.purple,
                                                                                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(10.0))
                                                                                            ),
                                                                                            child: Text('',
                                                                                              style: Theme.of(context).textTheme.titleSmall,
                                                                                            ),
                                                                                          )
                                                                                      ),
                                                                                    ),
                                                                                    Container(
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_6.w, vertical: Sizes.dimen_0.h),
                                                                                        child: Text('${data.expectedAlloc.toStringAsFixed(2)}%',
                                                                                          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColor.purple, fontWeight: FontWeight.bold),
                                                                                          maxLines: 1,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              UIHelper.verticalSpace(Sizes.dimen_6),
                                                                            ],
                                                                          ),
                                                                        )
                                                                    ),
                                                                    Expanded(
                                                                        flex: 4,
                                                                        child: Row(
                                                                          children: [
                                                                            Expanded(
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                      border: Border(
                                                                                          right: BorderSide(
                                                                                            color: AppColor.grey.withOpacity(0.4),
                                                                                          )
                                                                                      )
                                                                                  ),
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h, horizontal: Sizes.dimen_2.w),
                                                                                        child: Text('',
                                                                                          style: Theme.of(context).textTheme.titleSmall,
                                                                                        ),
                                                                                      ),
                                                                                      UIHelper.verticalSpace(Sizes.dimen_6),
                                                                                      Tooltip(
                                                                                        message: double.parse(data.returnPercent.toStringAsFixed(2)) >= 0.0 ? '${data.returnPercent.abs().toStringAsFixed(2)}%' : '(${data.returnPercent.abs().toStringAsFixed(2)}%)',
                                                                                        textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(color: double.parse(data.returnPercent.toStringAsFixed(2)) >= 0.0 ? AppColor.green : AppColor.red, fontWeight: FontWeight.bold),
                                                                                        preferBelow: false,
                                                                                        decoration: BoxDecoration(
                                                                                            color: context.read<AppThemeCubit>().state?.card?.color != null ? Color(int.parse(context.read<AppThemeCubit>().state!.card!.color!)) : AppColor.lightGrey,
                                                                                            border: Border.all(color: Theme.of(context).iconTheme.color ?? AppColor.white),
                                                                                            borderRadius: BorderRadius.circular(5.0)
                                                                                        ),
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Flexible(
                                                                                              child: FractionallySizedBox(
                                                                                                  alignment: Alignment.centerLeft,
                                                                                                  widthFactor: _formatForFraction(data.returnPercent.toInt()),
                                                                                                  child: Container(
                                                                                                    decoration: BoxDecoration(
                                                                                                        color: data.returnPercent.toInt() >= 0 ? AppColor.green : AppColor.red,
                                                                                                        borderRadius: const BorderRadius.only(topRight: Radius.circular(5.0))
                                                                                                    ),
                                                                                                    child: Text('',
                                                                                                      style: Theme.of(context).textTheme.titleSmall,
                                                                                                    ),
                                                                                                  )
                                                                                              ),
                                                                                            ),
                                                                                            Container(
                                                                                              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_0.h, horizontal: Sizes.dimen_6.w),
                                                                                              child: Text(double.parse(data.returnPercent.toStringAsFixed(2)) >= 0.0 ? '${data.returnPercent.abs().toStringAsFixed(2)}%' : '(${data.returnPercent.abs().toStringAsFixed(2)}%)',
                                                                                                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: double.parse(data.returnPercent.toStringAsFixed(2)) >= 0.0 ? AppColor.green : AppColor.red, fontWeight: FontWeight.bold),
                                                                                                maxLines: 1,
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Tooltip(
                                                                                        message: data.benchmark >= 0.0 ? '${data.benchmark.toStringAsFixed(2)}%' : '(${data.benchmark.abs().toStringAsFixed(2)}%)',
                                                                                        textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(color: data.benchmark >= 0.0 ? AppColor.grey : AppColor.red, fontWeight: FontWeight.bold),
                                                                                        preferBelow: false,
                                                                                        decoration: BoxDecoration(
                                                                                            color: context.read<AppThemeCubit>().state?.card?.color != null ? Color(int.parse(context.read<AppThemeCubit>().state!.card!.color!)) : AppColor.lightGrey,
                                                                                            border: Border.all(color: Theme.of(context).iconTheme.color ?? AppColor.white),
                                                                                            borderRadius: BorderRadius.circular(5.0)
                                                                                        ),
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Flexible(
                                                                                              child: FractionallySizedBox(
                                                                                                  alignment: Alignment.centerLeft,
                                                                                                  widthFactor: _formatForFraction(data.benchmark.toInt()),
                                                                                                  child: Container(
                                                                                                    decoration: BoxDecoration(
                                                                                                        color: data.benchmark.toInt() >= 0 ? AppColor.grey : AppColor.red,
                                                                                                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(5.0))
                                                                                                    ),
                                                                                                    child: Text('',
                                                                                                      style: Theme.of(context).textTheme.titleSmall,
                                                                                                    ),
                                                                                                  )
                                                                                              ),
                                                                                            ),
                                                                                            Container(
                                                                                              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_0.h, horizontal: Sizes.dimen_6.w),
                                                                                              child: Text(data.benchmark >= 0.0 ? '${data.benchmark.toStringAsFixed(2)}%' : '(${data.benchmark.abs().toStringAsFixed(2)}%)',
                                                                                                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: data.benchmark >= 0.0 ? AppColor.grey : AppColor.red, fontWeight: FontWeight.bold),
                                                                                                maxLines: 1,
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      UIHelper.verticalSpace(Sizes.dimen_6),
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                            )
                                                                          ],
                                                                        )
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            }else {
                                                              return const SizedBox.shrink();
                                                            }
                                                          }else {
                                                            return const SizedBox.shrink();
                                                          }
                                                        }
                                                    )
                                                  else
                                                    Center(
                                                      child: Text('No Position Found', style: Theme.of(context).textTheme.headlineMedium,),
                                                    )
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                  );
                                }
                            );
                          }else if(state is InvestmentPolicyStatementReportLoading || tabbedState is InvestmentPolicyStatementTabbedLoading) {
                            return const CircularProgressWidget();
                          }else if(state is InvestmentPolicyStatementReportError){
                            if(state.errorType == AppErrorType.unauthorised) {
                              AppHelpers.logout(context: context);
                            }
                            return Center(
                              child: Text('No Position Found', style: Theme.of(context).textTheme.headlineMedium,),
                            );
                          }
                          return const CircularProgressWidget();
                        }
                    );
                  }
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isItemContain(InvestmentPolicyStatementChartData item, List<SubGroupingItemData> selectedFilter) {

    bool isExist = false;

    selectedFilter.forEach((element) {
      if(element.name == item.title){
        isExist = true;
      }
    });

    return isExist;
  }

  double _formatForFraction(int value) {
    if(value < 100 && value > 0) {
      return value / 100;
    }else {
      if(value <= 0) {
        if(value == 0) {
          return 0.0;
        }else {
          if(value.abs() < 100) {
            return value.abs() / 100;
          }else {
            return 1.0;
          }
        }
      }else {
        return 1.0;
      }
    }
  }

  int _getGreaterValue(List<InvestmentPolicyStatementChartData> list) {

    final List<int> intList = [];

    for(int i = 0; i < list.length; i++) {
      final item = list[i];

      intList.add(item.actualAlloc.toInt());
      intList.add(item.expectedAlloc.toInt());
      intList.add(item.returnPercent.toInt());
      intList.add(item.benchmark.toInt());
    }

    return intList.reduce(max);
  }

  int _getPercentage(int greaterValue, int value) {
    return ((value / greaterValue) * 100).toInt();
  }
}