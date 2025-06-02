
import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/widgets/filter_name_with_cross.dart';
import 'package:asset_vantage/src/presentation/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/constants/size_constants.dart';
import '../../../domain/entities/performance/performance_secondary_sub_grouping_enity.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../blocs/app_theme/theme_cubit.dart';
import '../../blocs/performance/performance_secondary_grouping/performance_secondary_grouping_cubit.dart';
import '../../blocs/performance/performance_secondary_sub_grouping/performance_secondary_sub_grouping_cubit.dart';
import '../../theme/theme_color.dart';
import '../../widgets/apply_button.dart';
import '../../widgets/crossSign.dart';

class PerformanceSecondarySubGroupingFilter extends StatefulWidget {
  final void Function() onDone;
  final ScrollController scrollController;
  final PerformanceSecondarySubGroupingCubit performanceSecondarySubGroupingCubit;
  final PerformanceSecondaryGroupingCubit performanceSecondaryGroupingCubit;

  const PerformanceSecondarySubGroupingFilter({
    super.key,
    required this.onDone,
    required this.scrollController,
    required this.performanceSecondarySubGroupingCubit,
    required this.performanceSecondaryGroupingCubit,
  });

  @override
  State<PerformanceSecondarySubGroupingFilter> createState() => _PerformanceSecondarySubGroupingFilterState();
}

class _PerformanceSecondarySubGroupingFilterState extends State<PerformanceSecondarySubGroupingFilter> {
  List<SubGroupingItemData?> selectedSecondarySubGrouping = [];
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedSecondarySubGrouping.addAll(widget.performanceSecondarySubGroupingCubit.state.selectedSubGroupingList ?? []);
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
              child: FilterNameWithCross(text: StringConstants.secondarySubGrpFilterString,
              isSubHeader: true,
              onDone: (){
                widget.onDone();
              },)
            ),
            SearchBarWidget(textController: controller,
                feildKey: widget.key,
                onChanged: (String text) {
                  setState(() {});
                }),
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
                    itemCount: widget.performanceSecondarySubGroupingCubit.state
                        .subGroupingList?.length ??
                        0,
                    itemBuilder: (context, index) {
                      final filterData = widget.performanceSecondarySubGroupingCubit
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
                                    if (selectedSecondarySubGrouping.length !=
                                        (widget.performanceSecondarySubGroupingCubit
                                            .state.subGroupingList?.length ??
                                            0)) {
                                      selectedSecondarySubGrouping.clear();
                                      selectedSecondarySubGrouping.addAll(widget
                                          .performanceSecondarySubGroupingCubit
                                          .state
                                          .subGroupingList ??
                                          []);
                                    } else {
                                      selectedSecondarySubGrouping.clear();
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
                                      if (selectedSecondarySubGrouping.length ==
                                          (widget
                                              .performanceSecondarySubGroupingCubit
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
                                    if (selectedSecondarySubGrouping
                                        .contains(filterData)) {
                                      selectedSecondarySubGrouping
                                          .remove(filterData);
                                    } else {
                                      selectedSecondarySubGrouping.add(filterData);
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
                                    if (selectedSecondarySubGrouping
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
              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
              child: ApplyButton(
                text: StringConstants.applyButton,
                onPressed: () {
                  widget.performanceSecondarySubGroupingCubit.changeSelectedPerformanceSecondarySubGrouping(selectedSubGroupingList: selectedSecondarySubGrouping);
                  widget.onDone();
                },
              ),
            ),
            UIHelper.verticalSpaceSmall
          ],
        ),
      ),
    );
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: Sizes.dimen_6.h, horizontal: Sizes.dimen_14.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: widget.onDone,
                child: Row(
                  children: [
                    SvgPicture.asset('assets/svgs/back_arrow.svg', width: Sizes.dimen_24.w, color: context.read<AppThemeCubit>().state?.bottomSheet?.backArrowColor != null ? Color(int.parse(context.read<AppThemeCubit>().state!.bottomSheet!.backArrowColor!)) : AppColor.primary,),
                    Text('Back',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: context.read<AppThemeCubit>().state?.bottomSheet?.backArrowColor != null ? Color(int.parse(context.read<AppThemeCubit>().state!.bottomSheet!.backArrowColor!)) : AppColor.primary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Text(widget.performanceSecondaryGroupingCubit.state.selectedGrouping?.name?.replaceAll('-', ' ') ?? '--',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              GestureDetector(
                onTap: () {
                  widget.performanceSecondarySubGroupingCubit.changeSelectedPerformanceSecondarySubGrouping(selectedSubGroupingList: selectedSecondarySubGrouping);
                  widget.onDone();
                },
                child: Text('Apply',
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
                  controller: widget.scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.performanceSecondarySubGroupingCubit.state.subGroupingList?.length ?? 0,
                  itemBuilder: (context, index) {
                    final filterData = widget.performanceSecondarySubGroupingCubit.state.subGroupingList?[index];
                    return Column(
                      children: [
                        if(index == 0)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if(selectedSecondarySubGrouping.length != (widget.performanceSecondarySubGroupingCubit.state.subGroupingList?.length ?? 0)) {
                                  selectedSecondarySubGrouping.clear();
                                  selectedSecondarySubGrouping.addAll(widget.performanceSecondarySubGroupingCubit.state.subGroupingList ?? []);
                                }else {
                                  selectedSecondarySubGrouping.clear();
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
                                      child: Text('Select All',
                                          style: Theme.of(context).textTheme.titleMedium,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis
                                      ),
                                    ),
                                  ),
                                  if(selectedSecondarySubGrouping.length == (widget.performanceSecondarySubGroupingCubit.state.subGroupingList?.length ?? 0))
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
                          ),
                        GestureDetector(
                          onTap: () {
                            if(filterData != null) {
                              setState((){
                                if(selectedSecondarySubGrouping.contains(filterData)) {
                                  selectedSecondarySubGrouping.remove(filterData);
                                }else {
                                  selectedSecondarySubGrouping.add(filterData);
                                }
                              });
                            }
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
                                        filterData?.name ?? '--',
                                        style: Theme.of(context).textTheme.titleMedium,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis
                                    ),
                                  ),
                                ),
                                if(selectedSecondarySubGrouping.contains(filterData))
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
                        ),
                      ],
                    );
                  },
                );
              }
          ),
        )
      ],
    );
  }
}
