
import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/widgets/filter_name_with_cross.dart';
import 'package:asset_vantage/src/presentation/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/constants/size_constants.dart';
import '../../../domain/entities/cash_balance/cash_balance_grouping_entity.dart';
import '../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../blocs/app_theme/theme_cubit.dart';
import '../../blocs/cash_balance/cash_balance_accounts/cash_balance_account_cubit.dart';
import '../../blocs/cash_balance/cash_balance_entity/cash_balance_entity_cubit.dart';
import '../../blocs/cash_balance/cash_balance_grouping/cash_balance_grouping_cubit.dart';
import '../../blocs/cash_balance/cash_balance_loading/cash_balance_loading_cubit.dart';
import '../../blocs/cash_balance/cash_balance_sub_grouping/cash_balance_sub_grouping_cubit.dart';
import '../../theme/theme_color.dart';
import '../../widgets/apply_button.dart';
import '../../widgets/crossSign.dart';

class CashBalancePrimaryGroupingFilter extends StatefulWidget {
  final void Function() onDone;
  final ScrollController scrollController;
  final CashBalancePrimaryGroupingCubit cashBalancePrimaryGroupingCubit;
  final CashBalancePrimarySubGroupingCubit cashBalancePrimarySubGroupingCubit;
  final CashBalanceAccountCubit cashBalanceAccountCubit;
  final CashBalanceEntityCubit cashBalanceEntityCubit;
  final CashBalanceLoadingCubit cashBalanceLoadingCubit;
  final String? asOnDate;
  final EntityData? selectedEntity;

  const CashBalancePrimaryGroupingFilter({
    super.key,
    required this.onDone,
    required this.scrollController,
    required this.cashBalancePrimaryGroupingCubit,
    required this.cashBalanceAccountCubit,
    required this.cashBalanceEntityCubit,
    required this.cashBalancePrimarySubGroupingCubit,
    required this.cashBalanceLoadingCubit,
    required this.asOnDate,
    required this.selectedEntity,
  });

  @override
  State<CashBalancePrimaryGroupingFilter> createState() => _CashBalancePrimaryGroupingFilterState();
}

class _CashBalancePrimaryGroupingFilterState extends State<CashBalancePrimaryGroupingFilter> {
  GroupingEntity? selectedPrimaryGrouping;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedPrimaryGrouping = widget.cashBalancePrimaryGroupingCubit.state.selectedGrouping;
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
                  text: StringConstants.primaryGrpFilterString,
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
                  itemBuilder: (context, index) {
                    final item = widget.cashBalancePrimaryGroupingCubit.state.groupingList?[index];
                    if ((item?.name
                        ?.toLowerCase()
                        .contains(controller.text.toLowerCase()) ??
                        true) ||
                        controller.text.isEmpty) {
                      return GestureDetector(
                        onTap: () {
                          if(item != null) {
                            setState((){
                              selectedPrimaryGrouping = item;
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
                                      color: AppColor.grey.withValues(alpha: 0.5)))),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Sizes.dimen_4.h,
                                      horizontal: Sizes.dimen_14.w),
                                  child: Text(item?.name ?? '--',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                              if ((item?.id ?? '--') ==
                                  (selectedPrimaryGrouping?.id ?? ''))
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Sizes.dimen_2.h,
                                      horizontal: Sizes.dimen_14.w),
                                  child: Icon(
                                    Icons.check_rounded,
                                    color: context
                                        .read<AppThemeCubit>()
                                        .state
                                        ?.filter
                                        ?.iconColor !=
                                        null
                                        ? Color(int.parse(context
                                        .read<AppThemeCubit>()
                                        .state!
                                        .filter!
                                        .iconColor!))
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
                  },
                  itemCount: widget.cashBalancePrimaryGroupingCubit.state.groupingList?.length ?? 0,
                  physics: const BouncingScrollPhysics(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
              child: ApplyButton(
                text: StringConstants.applyButton,
                onPressed: () {
                  widget.cashBalanceLoadingCubit.startLoading();
                  widget.cashBalancePrimaryGroupingCubit.changeSelectedCashBalancePrimaryGrouping(
                    selectedGrouping: selectedPrimaryGrouping,
                  ).then((value) {
                    widget.cashBalancePrimarySubGroupingCubit.loadCashBalancePrimarySubGrouping(
                        context: mounted ? context : null,
                        tileName: "cash_balance",
                        selectedEntity: widget.selectedEntity,
                        selectedGrouping: widget.cashBalancePrimaryGroupingCubit.state.selectedGrouping,
                        asOnDate: widget.asOnDate
                    ).then((onValue) {
                      widget.cashBalanceAccountCubit.loadCashBalanceAccounts(
                        context: mounted ? context : null,
                        tileName: "cash_balance",
                        selectedEntity: widget.selectedEntity,
                        primaryGrouping: widget.cashBalancePrimaryGroupingCubit.state.selectedGrouping,
                        primarySubGrouping: widget.cashBalancePrimarySubGroupingCubit.state.selectedSubGroupingList,
                        asOnDate: widget.asOnDate,
                      );
                    }).then((onValue) => widget.cashBalanceLoadingCubit.endLoading());
                  });
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
