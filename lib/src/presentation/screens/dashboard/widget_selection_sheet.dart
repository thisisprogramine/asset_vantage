import 'package:asset_vantage/src/config/constants/size_constants.dart';
import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/theme/theme_color.dart';
import 'package:asset_vantage/src/presentation/widgets/filter_name_with_cross.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';

import '../../../config/constants/favorite_constants.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../blocs/favorites/favorites_cubit.dart';
import '../../widgets/crossSign.dart';

class WidgetSelectionSheet extends StatelessWidget {
  final ScrollController scrollController;
  WidgetSelectionSheet({super.key, required this.scrollController});

  List<Map<String, String>> widgetData = [
    {"name": "Net Worth", "icon": "assets/svgs/networth_icon.svg"},
    {"name": "Performance", "icon": "assets/svgs/performance_icon.svg"},
    {"name": "Cash Balance", "icon": "assets/svgs/cashbalance_icon.svg"},
    {"name": "Income", "icon": "assets/svgs/income_icon.svg"},
    {"name": "Expense", "icon": "assets/svgs/expense_icon.svg"},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Sizes.dimen_10.h, horizontal: Sizes.dimen_16.w),
              child: const FilterNameWithCross(
                  text: StringConstants.selectWidgetsForDashboard)),
          Expanded(
              child: ListView.builder(
                  itemCount: widgetData.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (index == 1) {
                          context.read<FavoritesCubit>().saveFilters(
                                context: context,
                                isPinned: false,
                                isBlankWidget: true,
                                reportId: FavoriteConstants.performanceId,
                                reportName: FavoriteConstants.performanceName,
                              );
                        } else if (index == 3) {
                          context.read<FavoritesCubit>().saveFilters(
                                context: context,
                                isPinned: false,
                                isBlankWidget: true,
                                reportId: FavoriteConstants.incomeId,
                                reportName: FavoriteConstants.incomeName,
                              );
                        } else if (index == 4) {
                          context.read<FavoritesCubit>().saveFilters(
                                context: context,
                                isPinned: false,
                                isBlankWidget: true,
                                reportId: FavoriteConstants.expenseId,
                                reportName: FavoriteConstants.expenseName,
                              );
                        } else if (index == 2) {
                          context.read<FavoritesCubit>().saveFilters(
                                context: context,
                                isPinned: false,
                                isBlankWidget: true,
                                reportId: FavoriteConstants.cashBalanceId,
                                reportName: FavoriteConstants.cashBalanceName,
                              );
                        } else if (index == 0) {
                          context.read<FavoritesCubit>().saveFilters(
                                context: context,
                                isPinned: false,
                                isBlankWidget: true,
                                reportId: FavoriteConstants.netWorthId,
                                reportName: FavoriteConstants.netWorthName,
                              );
                        }
                        Future.delayed((const Duration(milliseconds: 1000)))
                            .then((value) {
                          scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        });
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Sizes.dimen_12.w,
                            vertical: Sizes.dimen_4.h),
                        margin: EdgeInsets.symmetric(
                            horizontal: Sizes.dimen_12.w,
                            vertical: Sizes.dimen_2.h),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    AppColor.lightGrey.withValues(alpha: 0.4)),
                            borderRadius:
                                BorderRadius.circular(Sizes.dimen_12)),
                        child: Row(
                          children: [
                            SvgPicture.asset(widgetData[index]["icon"]!),
                            UIHelper.horizontalSpaceMedium,
                            Expanded(
                              child: Text(
                                "${widgetData[index]["name"]}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Card(
                                color: AppColor.lightGrey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(Sizes.dimen_6.r),
                                  ),
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Sizes.dimen_6,
                                      horizontal: Sizes.dimen_6),
                                  child:
                                      SvgPicture.asset("assets/svgs/add.svg"),
                                )),
                          ],
                        ),
                      ),
                    );
                  })),
        ],
      ),
    );
  }
}
