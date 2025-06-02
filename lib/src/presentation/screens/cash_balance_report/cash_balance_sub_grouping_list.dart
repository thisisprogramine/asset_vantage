
import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_as_on_date/cash_balance_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_entity/cash_balance_entity_cubit.dart';
import 'package:asset_vantage/src/presentation/widgets/filter_name_with_cross.dart';
import 'package:asset_vantage/src/presentation/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/constants/size_constants.dart';
import '../../../domain/entities/cash_balance/cash_balance_sub_grouping_entity.dart';
import '../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../blocs/app_theme/theme_cubit.dart';
import '../../blocs/cash_balance/cash_balance_accounts/cash_balance_account_cubit.dart';
import '../../blocs/cash_balance/cash_balance_grouping/cash_balance_grouping_cubit.dart';
import '../../blocs/cash_balance/cash_balance_sub_grouping/cash_balance_sub_grouping_cubit.dart';
import '../../theme/theme_color.dart';
import '../../widgets/apply_button.dart';
import '../../widgets/crossSign.dart';


class CashBalancePrimarySubGroupingFilter extends StatefulWidget {
  final void Function() onDone;
  final ScrollController scrollController;
  final CashBalancePrimarySubGroupingCubit cashBalancePrimarySubGroupingCubit;
  final CashBalancePrimaryGroupingCubit cashBalancePrimaryGroupingCubit;
  final CashBalanceAccountCubit cashBalanceAccountCubit;
  final EntityData? selectedEntity;
  final CashBalanceAsOnDateCubit cashBalanceAsOnDateCubit;

  const CashBalancePrimarySubGroupingFilter({
    super.key,
    required this.onDone,
    required this.scrollController,
    required this.cashBalancePrimarySubGroupingCubit,
    required this.selectedEntity,
    required this.cashBalanceAccountCubit,
    required this.cashBalanceAsOnDateCubit,
    required this.cashBalancePrimaryGroupingCubit,
  });

  @override
  State<CashBalancePrimarySubGroupingFilter> createState() => _CashBalancePrimarySubGroupingFilterState();
}

class _CashBalancePrimarySubGroupingFilterState extends State<CashBalancePrimarySubGroupingFilter> {
  List<SubGroupingItemData?> selectedPrimarySubGrouping = [];
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedPrimarySubGrouping.addAll(widget.cashBalancePrimarySubGroupingCubit.state.selectedSubGroupingList ?? []);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> fetchingAccounts() async{
    await widget.cashBalanceAccountCubit.loadCashBalanceAccounts(
      context: mounted ? context : null,
      tileName: "cash_balance",
      selectedEntity: widget.selectedEntity,
      primaryGrouping: widget.cashBalancePrimaryGroupingCubit.state.selectedGrouping,
      primarySubGrouping: widget.cashBalancePrimarySubGroupingCubit.state.selectedSubGroupingList,
      asOnDate: widget.cashBalanceAsOnDateCubit.state.asOnDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_16.w),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_8.h),
              child: FilterNameWithCross(
                  text: StringConstants.primarySubGrpFilterString,
              isSubHeader: true,
              onDone: (){
                widget.onDone();
              },)

            ),

            SearchBarWidget(
                textController: controller,
                feildKey: widget.key,
                onChanged: (String text) {
                  setState(() {});
                },),
            Expanded(
              child: RawScrollbar(
                thickness: Sizes.dimen_2,
                radius: const Radius.circular(Sizes.dimen_10),
                notificationPredicate: (notification) => true,
                thumbVisibility: true,
                trackVisibility: true,
                interactive: true,
                thumbColor: AppColor.grey,
                trackColor: AppColor.grey.withValues(alpha: 0.2),
                child: ListView.builder(
                    controller: widget.scrollController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: widget.cashBalancePrimarySubGroupingCubit.state
                        .subGroupingList?.length ??
                        0,
                    itemBuilder: (context, index) {
                      final filterData = widget.cashBalancePrimarySubGroupingCubit
                          .state.subGroupingList?[index];
                      if ((filterData?.name
                          ?.toLowerCase()
                          .contains(controller.text.toLowerCase()) ??
                          true) ||
                          controller.text.isEmpty) {
                        return Column(
                          children: [
                            if (index == 0)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (selectedPrimarySubGrouping.length !=
                                        (widget.cashBalancePrimarySubGroupingCubit
                                            .state.subGroupingList?.length ??
                                            0)) {
                                      selectedPrimarySubGrouping.clear();
                                      selectedPrimarySubGrouping.addAll(widget
                                          .cashBalancePrimarySubGroupingCubit
                                          .state
                                          .subGroupingList ??
                                          []);
                                    } else {
                                      selectedPrimarySubGrouping.clear();
                                    }
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
                                                  : AppColor.grey
                                                  .withOpacity(0.4)))),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: Sizes.dimen_4.h,
                                              horizontal: Sizes.dimen_14.w),
                                          child: Text('Select All',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                      if (selectedPrimarySubGrouping.length ==
                                          (widget
                                              .cashBalancePrimarySubGroupingCubit
                                              .state
                                              .subGroupingList
                                              ?.length ??
                                              0))
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
                              ),
                            GestureDetector(
                              onTap: () {
                                if (filterData != null) {
                                  setState(() {
                                    if (selectedPrimarySubGrouping
                                        .contains(filterData)) {
                                      selectedPrimarySubGrouping
                                          .remove(filterData);
                                    } else {
                                      selectedPrimarySubGrouping.add(filterData);
                                    }
                                  });
                                }
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
                                                : AppColor.grey
                                                .withOpacity(0.4)))),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: Sizes.dimen_4.h,
                                            horizontal: Sizes.dimen_14.w),
                                        child: Text(filterData?.name ?? '--',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                    if (selectedPrimarySubGrouping
                                        .contains(filterData))
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
                            ),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
              child: ApplyButton(
                text: StringConstants.applyButton,
                onPressed: () async{
                  await widget.cashBalancePrimarySubGroupingCubit.changeSelectedCashBalancePrimarySubGrouping(selectedSubGroupingList: selectedPrimarySubGrouping);
                  Future.wait([fetchingAccounts()]).then((value) {},);
                  widget.onDone();
                },
              ),
            ),
            UIHelper.verticalSpaceSmall
          ],
        ),
      ),
    );
  }
}
