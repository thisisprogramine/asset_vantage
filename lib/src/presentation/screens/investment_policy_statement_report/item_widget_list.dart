
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_grouping/investment_policy_statement_grouping_cubit.dart';
import 'package:asset_vantage/src/utilities/helper/app_helper.dart';
import 'package:asset_vantage/src/utilities/helper/flash_helper.dart';
import 'package:asset_vantage/src/utilities/helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../config/constants/route_constants.dart';
import '../../../config/constants/size_constants.dart';
import '../../../domain/entities/app_error.dart';
import '../../../domain/entities/authentication/user_entity.dart';
import '../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../blocs/authentication/login/login_cubit.dart';
import '../../blocs/authentication/user/user_cubit.dart';
import '../../blocs/investment_policy_statement/investment_policy_statement_report/investment_policy_statement_report_cubit.dart';
import '../../theme/theme_color.dart';
import 'item_widget.dart';

class ItemWidgetList extends StatefulWidget {
  final EntityData entity;
  final String asOnDate;
  final bool isLandscape;
  const ItemWidgetList({
    Key? key,
    required this.entity,
    required this.asOnDate,
    this.isLandscape = false,
  }) : super(key: key);

  @override
  State<ItemWidgetList> createState() => _ItemWidgetListState();
}

class _ItemWidgetListState extends State<ItemWidgetList> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvestmentPolicyStatementReportCubit, InvestmentPolicyStatementReportState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<UserCubit, UserEntity?>(
                builder: (context, user) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: Sizes.dimen_1.h, horizontal: Sizes.dimen_12.w),
                    child: Text('${widget.entity.name} as on: ${DateFormat(user?.dateFormat ?? 'yyyy-MM-dd').format(DateTime.parse(widget.asOnDate ?? ''))}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColor.grey),
                    ),
                  );
                }
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Padding(
                        padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_12.w),
                        child: BlocBuilder<InvestmentPolicyStatementGroupingCubit, InvestmentPolicyStatementGroupingState>(
                            builder: (context, state) {
                              if(state is InvestmentPolicyStatementGroupingLoaded) {
                                return ListView.separated(
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: widget.isLandscape ? Axis.vertical : Axis.horizontal,
                                    itemCount: state.grouping.groupingList.length ?? 0,
                                    separatorBuilder: (context, index) {
                                      return UIHelper.horizontalSpace(Sizes.dimen_14.w);
                                    },
                                    itemBuilder: (context, index) {
                                      return ItemWidget(
                                        isIpad: constraints.maxWidth > 600,
                                        isLandscape: widget.isLandscape,
                                        index: index,
                                        grouping: state.grouping.groupingList[index],
                                        asOnDate: widget.asOnDate,
                                        selectedEntity: widget.entity,
                                      );
                                    }
                                );
                              }else if(state is InvestmentPolicyStatementGroupingLoading) {
                                return widget.isLandscape
                                    ? Column(
                                  children: [
                                    Expanded(
                                      child: Card(
                                        child: Shimmer.fromColors(
                                          baseColor: AppColor.white.withOpacity(0.1),
                                          highlightColor: AppColor.white.withOpacity(0.2),
                                          direction: ShimmerDirection.ltr,
                                          period: const Duration(seconds: 1),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppColor.lightGrey,
                                              borderRadius: BorderRadius.circular(2.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Card(
                                        child: Shimmer.fromColors(
                                          baseColor: AppColor.white.withOpacity(0.1),
                                          highlightColor: AppColor.white.withOpacity(0.2),
                                          direction: ShimmerDirection.ltr,
                                          period: const Duration(seconds: 1),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppColor.lightGrey,
                                              borderRadius: BorderRadius.circular(2.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Card(
                                        child: Shimmer.fromColors(
                                          baseColor: AppColor.white.withOpacity(0.1),
                                          highlightColor: AppColor.white.withOpacity(0.2),
                                          direction: ShimmerDirection.ltr,
                                          period: const Duration(seconds: 1),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppColor.lightGrey,
                                              borderRadius: BorderRadius.circular(2.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                                    : Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width: ScreenUtil().screenWidth,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                width: ScreenUtil().screenWidth,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                        child: Card(
                                                          child: Shimmer.fromColors(
                                                            baseColor: AppColor.white.withOpacity(0.1),
                                                            highlightColor: AppColor.white.withOpacity(0.2),
                                                            direction: ShimmerDirection.ltr,
                                                            period: const Duration(seconds: 1),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: AppColor.lightGrey,
                                                                borderRadius: BorderRadius.circular(2.0),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                    ),
                                                    Card(
                                                      child: Shimmer.fromColors(
                                                        baseColor: AppColor.white.withOpacity(0.1),
                                                        highlightColor: AppColor.white.withOpacity(0.2),
                                                        direction: ShimmerDirection.ltr,
                                                        period: const Duration(seconds: 1),
                                                        child: Container(
                                                          width: double.infinity,
                                                          height: Sizes.dimen_12.w,
                                                          decoration: BoxDecoration(
                                                            color: AppColor.lightGrey,
                                                            borderRadius: BorderRadius.circular(5.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: ScreenUtil().screenWidth,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                width: ScreenUtil().screenWidth,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                        child: Card(
                                                          child: Shimmer.fromColors(
                                                            baseColor: AppColor.white.withOpacity(0.1),
                                                            highlightColor: AppColor.white.withOpacity(0.2),
                                                            direction: ShimmerDirection.ltr,
                                                            period: const Duration(seconds: 1),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: AppColor.lightGrey,
                                                                borderRadius: BorderRadius.circular(2.0),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                    ),
                                                    Card(
                                                      child: Shimmer.fromColors(
                                                        baseColor: AppColor.white.withOpacity(0.1),
                                                        highlightColor: AppColor.white.withOpacity(0.2),
                                                        direction: ShimmerDirection.ltr,
                                                        period: const Duration(seconds: 1),
                                                        child: Container(
                                                          width: double.infinity,
                                                          height: Sizes.dimen_12.w,
                                                          decoration: BoxDecoration(
                                                            color: AppColor.lightGrey,
                                                            borderRadius: BorderRadius.circular(5.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: ScreenUtil().screenWidth,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                width: ScreenUtil().screenWidth,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                        child: Card(
                                                          child: Shimmer.fromColors(
                                                            baseColor: AppColor.white.withOpacity(0.1),
                                                            highlightColor: AppColor.white.withOpacity(0.2),
                                                            direction: ShimmerDirection.ltr,
                                                            period: const Duration(seconds: 1),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: AppColor.lightGrey,
                                                                borderRadius: BorderRadius.circular(2.0),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                    ),
                                                    Card(
                                                      child: Shimmer.fromColors(
                                                        baseColor: AppColor.white.withOpacity(0.1),
                                                        highlightColor: AppColor.white.withOpacity(0.2),
                                                        direction: ShimmerDirection.ltr,
                                                        period: const Duration(seconds: 1),
                                                        child: Container(
                                                          width: double.infinity,
                                                          height: Sizes.dimen_12.w,
                                                          decoration: BoxDecoration(
                                                            color: AppColor.lightGrey,
                                                            borderRadius: BorderRadius.circular(5.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: ScreenUtil().screenWidth,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                width: ScreenUtil().screenWidth,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                        child: Card(
                                                          child: Shimmer.fromColors(
                                                            baseColor: AppColor.white.withOpacity(0.1),
                                                            highlightColor: AppColor.white.withOpacity(0.2),
                                                            direction: ShimmerDirection.ltr,
                                                            period: const Duration(seconds: 1),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: AppColor.lightGrey,
                                                                borderRadius: BorderRadius.circular(2.0),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                    ),
                                                    Card(
                                                      child: Shimmer.fromColors(
                                                        baseColor: AppColor.white.withOpacity(0.1),
                                                        highlightColor: AppColor.white.withOpacity(0.2),
                                                        direction: ShimmerDirection.ltr,
                                                        period: const Duration(seconds: 1),
                                                        child: Container(
                                                          width: double.infinity,
                                                          height: Sizes.dimen_12.w,
                                                          decoration: BoxDecoration(
                                                            color: AppColor.lightGrey,
                                                            borderRadius: BorderRadius.circular(5.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              }else if(state is InvestmentPolicyStatementGroupingError) {
                                if(state.errorType == AppErrorType.unauthorised) {
                                  AppHelpers.logout(context: context);
                                }

                                return Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width: ScreenUtil().screenWidth,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                width: ScreenUtil().screenWidth,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                        child: Card(
                                                          child: Shimmer.fromColors(
                                                            baseColor: AppColor.white.withOpacity(0.1),
                                                            highlightColor: AppColor.white.withOpacity(0.2),
                                                            direction: ShimmerDirection.ltr,
                                                            period: const Duration(seconds: 1),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: AppColor.lightGrey,
                                                                borderRadius: BorderRadius.circular(2.0),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                    ),
                                                    Card(
                                                      child: Shimmer.fromColors(
                                                        baseColor: AppColor.white.withOpacity(0.1),
                                                        highlightColor: AppColor.white.withOpacity(0.2),
                                                        direction: ShimmerDirection.ltr,
                                                        period: const Duration(seconds: 1),
                                                        child: Container(
                                                          width: double.infinity,
                                                          height: Sizes.dimen_12.w,
                                                          decoration: BoxDecoration(
                                                            color: AppColor.lightGrey,
                                                            borderRadius: BorderRadius.circular(5.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: ScreenUtil().screenWidth,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                width: ScreenUtil().screenWidth,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                        child: Card(
                                                          child: Shimmer.fromColors(
                                                            baseColor: AppColor.white.withOpacity(0.1),
                                                            highlightColor: AppColor.white.withOpacity(0.2),
                                                            direction: ShimmerDirection.ltr,
                                                            period: const Duration(seconds: 1),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: AppColor.lightGrey,
                                                                borderRadius: BorderRadius.circular(2.0),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                    ),
                                                    Card(
                                                      child: Shimmer.fromColors(
                                                        baseColor: AppColor.white.withOpacity(0.1),
                                                        highlightColor: AppColor.white.withOpacity(0.2),
                                                        direction: ShimmerDirection.ltr,
                                                        period: const Duration(seconds: 1),
                                                        child: Container(
                                                          width: double.infinity,
                                                          height: Sizes.dimen_12.w,
                                                          decoration: BoxDecoration(
                                                            color: AppColor.lightGrey,
                                                            borderRadius: BorderRadius.circular(5.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: ScreenUtil().screenWidth,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                width: ScreenUtil().screenWidth,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                        child: Card(
                                                          child: Shimmer.fromColors(
                                                            baseColor: AppColor.white.withOpacity(0.1),
                                                            highlightColor: AppColor.white.withOpacity(0.2),
                                                            direction: ShimmerDirection.ltr,
                                                            period: const Duration(seconds: 1),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: AppColor.lightGrey,
                                                                borderRadius: BorderRadius.circular(2.0),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                    ),
                                                    Card(
                                                      child: Shimmer.fromColors(
                                                        baseColor: AppColor.white.withOpacity(0.1),
                                                        highlightColor: AppColor.white.withOpacity(0.2),
                                                        direction: ShimmerDirection.ltr,
                                                        period: const Duration(seconds: 1),
                                                        child: Container(
                                                          width: double.infinity,
                                                          height: Sizes.dimen_12.w,
                                                          decoration: BoxDecoration(
                                                            color: AppColor.lightGrey,
                                                            borderRadius: BorderRadius.circular(5.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: ScreenUtil().screenWidth,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                width: ScreenUtil().screenWidth,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                        child: Card(
                                                          child: Shimmer.fromColors(
                                                            baseColor: AppColor.white.withOpacity(0.1),
                                                            highlightColor: AppColor.white.withOpacity(0.2),
                                                            direction: ShimmerDirection.ltr,
                                                            period: const Duration(seconds: 1),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: AppColor.lightGrey,
                                                                borderRadius: BorderRadius.circular(2.0),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                    ),
                                                    Card(
                                                      child: Shimmer.fromColors(
                                                        baseColor: AppColor.white.withOpacity(0.1),
                                                        highlightColor: AppColor.white.withOpacity(0.2),
                                                        direction: ShimmerDirection.ltr,
                                                        period: const Duration(seconds: 1),
                                                        child: Container(
                                                          width: double.infinity,
                                                          height: Sizes.dimen_12.w,
                                                          decoration: BoxDecoration(
                                                            color: AppColor.lightGrey,
                                                            borderRadius: BorderRadius.circular(5.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              }
                              return widget.isLandscape ?
                              Column(
                                children: [
                                  Expanded(
                                    child: Card(
                                      child: Shimmer.fromColors(
                                        baseColor: AppColor.white.withOpacity(0.1),
                                        highlightColor: AppColor.white.withOpacity(0.2),
                                        direction: ShimmerDirection.ltr,
                                        period: const Duration(seconds: 1),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppColor.lightGrey,
                                            borderRadius: BorderRadius.circular(2.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Card(
                                      child: Shimmer.fromColors(
                                        baseColor: AppColor.white.withOpacity(0.1),
                                        highlightColor: AppColor.white.withOpacity(0.2),
                                        direction: ShimmerDirection.ltr,
                                        period: const Duration(seconds: 1),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppColor.lightGrey,
                                            borderRadius: BorderRadius.circular(2.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Card(
                                      child: Shimmer.fromColors(
                                        baseColor: AppColor.white.withOpacity(0.1),
                                        highlightColor: AppColor.white.withOpacity(0.2),
                                        direction: ShimmerDirection.ltr,
                                        period: const Duration(seconds: 1),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppColor.lightGrey,
                                            borderRadius: BorderRadius.circular(2.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                                  : Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: ScreenUtil().screenWidth,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              width: ScreenUtil().screenWidth,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                      child: Card(
                                                        child: Shimmer.fromColors(
                                                          baseColor: AppColor.white.withOpacity(0.1),
                                                          highlightColor: AppColor.white.withOpacity(0.2),
                                                          direction: ShimmerDirection.ltr,
                                                          period: const Duration(seconds: 1),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color: AppColor.lightGrey,
                                                              borderRadius: BorderRadius.circular(2.0),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                  ),
                                                  Card(
                                                    child: Shimmer.fromColors(
                                                      baseColor: AppColor.white.withOpacity(0.1),
                                                      highlightColor: AppColor.white.withOpacity(0.2),
                                                      direction: ShimmerDirection.ltr,
                                                      period: const Duration(seconds: 1),
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: Sizes.dimen_12.w,
                                                        decoration: BoxDecoration(
                                                          color: AppColor.lightGrey,
                                                          borderRadius: BorderRadius.circular(5.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: ScreenUtil().screenWidth,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              width: ScreenUtil().screenWidth,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                      child: Card(
                                                        child: Shimmer.fromColors(
                                                          baseColor: AppColor.white.withOpacity(0.1),
                                                          highlightColor: AppColor.white.withOpacity(0.2),
                                                          direction: ShimmerDirection.ltr,
                                                          period: const Duration(seconds: 1),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color: AppColor.lightGrey,
                                                              borderRadius: BorderRadius.circular(2.0),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                  ),
                                                  Card(
                                                    child: Shimmer.fromColors(
                                                      baseColor: AppColor.white.withOpacity(0.1),
                                                      highlightColor: AppColor.white.withOpacity(0.2),
                                                      direction: ShimmerDirection.ltr,
                                                      period: const Duration(seconds: 1),
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: Sizes.dimen_12.w,
                                                        decoration: BoxDecoration(
                                                          color: AppColor.lightGrey,
                                                          borderRadius: BorderRadius.circular(5.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: ScreenUtil().screenWidth,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              width: ScreenUtil().screenWidth,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                      child: Card(
                                                        child: Shimmer.fromColors(
                                                          baseColor: AppColor.white.withOpacity(0.1),
                                                          highlightColor: AppColor.white.withOpacity(0.2),
                                                          direction: ShimmerDirection.ltr,
                                                          period: const Duration(seconds: 1),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color: AppColor.lightGrey,
                                                              borderRadius: BorderRadius.circular(2.0),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                  ),
                                                  Card(
                                                    child: Shimmer.fromColors(
                                                      baseColor: AppColor.white.withOpacity(0.1),
                                                      highlightColor: AppColor.white.withOpacity(0.2),
                                                      direction: ShimmerDirection.ltr,
                                                      period: const Duration(seconds: 1),
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: Sizes.dimen_12.w,
                                                        decoration: BoxDecoration(
                                                          color: AppColor.lightGrey,
                                                          borderRadius: BorderRadius.circular(5.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: ScreenUtil().screenWidth,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              width: ScreenUtil().screenWidth,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                      child: Card(
                                                        child: Shimmer.fromColors(
                                                          baseColor: AppColor.white.withOpacity(0.1),
                                                          highlightColor: AppColor.white.withOpacity(0.2),
                                                          direction: ShimmerDirection.ltr,
                                                          period: const Duration(seconds: 1),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color: AppColor.lightGrey,
                                                              borderRadius: BorderRadius.circular(2.0),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                  ),
                                                  Card(
                                                    child: Shimmer.fromColors(
                                                      baseColor: AppColor.white.withOpacity(0.1),
                                                      highlightColor: AppColor.white.withOpacity(0.2),
                                                      direction: ShimmerDirection.ltr,
                                                      period: const Duration(seconds: 1),
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: Sizes.dimen_12.w,
                                                        decoration: BoxDecoration(
                                                          color: AppColor.lightGrey,
                                                          borderRadius: BorderRadius.circular(5.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              );
                            }
                        )
                    );
                  }
                ),
              ),
            ],
          );
        }
    );
  }
}

