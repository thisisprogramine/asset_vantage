
import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/domain/entities/income/income_account_entity.dart';
import 'package:asset_vantage/src/presentation/widgets/filter_name_with_cross.dart';
import 'package:asset_vantage/src/presentation/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/constants/size_constants.dart';
import '../../../domain/entities/performance/performance_primary_sub_grouping_enity.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../blocs/app_theme/theme_cubit.dart';
import '../../blocs/income/income_account/income_account_cubit.dart';
import '../../blocs/performance/performance_primary_grouping/performance_primary_grouping_cubit.dart';
import '../../blocs/performance/performance_primary_sub_grouping/performance_primary_sub_grouping_cubit.dart';
import '../../theme/theme_color.dart';
import '../../widgets/apply_button.dart';
import '../../widgets/crossSign.dart';

class IncomeAccountFilter extends StatefulWidget {
  final void Function() onDone;
  final ScrollController scrollController;
  final IncomeAccountCubit incomeAccountCubit;

  const IncomeAccountFilter({
    super.key,
    required this.onDone,
    required this.scrollController,
    required this.incomeAccountCubit,
  });

  @override
  State<IncomeAccountFilter> createState() => _IncomeAccountFilterState();
}

class _IncomeAccountFilterState extends State<IncomeAccountFilter> {
  List<Account?> selectedAccounts = [];
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedAccounts.addAll(widget.incomeAccountCubit.state.selectedAccountList ?? []);
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
                  text: StringConstants.accountsFilterString,
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
                    itemCount: widget.incomeAccountCubit.state
                        .accountList?.length ??
                        0,
                    itemBuilder: (context, index) {
                      final filterData = widget.incomeAccountCubit
                          .state.accountList?[index];
                      if ((filterData?.accountname
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
                                    if(selectedAccounts.length != (widget.incomeAccountCubit.state.accountList?.length ?? 0)) {
                                      selectedAccounts.clear();
                                      selectedAccounts.addAll(widget.incomeAccountCubit.state.accountList ?? []);
                                    }else {
                                      selectedAccounts.clear();
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
                                      if(selectedAccounts.length == (widget.incomeAccountCubit.state.accountList?.length ?? 0))
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
                                  setState((){
                                    if(selectedAccounts.contains(filterData)) {
                                      selectedAccounts.remove(filterData);
                                    }else {
                                      selectedAccounts.add(filterData);
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
                                        child: Text(filterData?.accountname ?? '--',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                    if (selectedAccounts
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
                onPressed: () {
                  widget.incomeAccountCubit.changeSelectedIncomeAccount(selectedIncomeAccountList: selectedAccounts);
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
