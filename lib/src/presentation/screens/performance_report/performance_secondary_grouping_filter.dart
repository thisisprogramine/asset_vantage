
import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_entity/performance_entity_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_loading/performance_loading_cubit.dart';
import 'package:asset_vantage/src/presentation/widgets/filter_name_with_cross.dart';
import 'package:asset_vantage/src/presentation/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/constants/size_constants.dart';
import '../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../domain/entities/performance/performance_secondary_grouping_entity.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../blocs/app_theme/theme_cubit.dart';
import '../../blocs/performance/performance_primary_sub_grouping/performance_primary_sub_grouping_cubit.dart';
import '../../blocs/performance/performance_secondary_grouping/performance_secondary_grouping_cubit.dart';
import '../../blocs/performance/performance_secondary_sub_grouping/performance_secondary_sub_grouping_cubit.dart';
import '../../theme/theme_color.dart';
import '../../widgets/apply_button.dart';
import '../../widgets/crossSign.dart';

class PerformanceSecondaryGroupingFilter extends StatefulWidget {
  final void Function() onDone;
  final ScrollController scrollController;
  final PerformanceSecondaryGroupingCubit performanceSecondaryGroupingCubit;
  final PerformanceSecondarySubGroupingCubit performanceSecondarySubGroupingCubit;
  final PerformancePrimarySubGroupingCubit performancePrimarySubGroupingCubit;
  final PerformanceEntityCubit performanceEntityCubit;
  final PerformanceLoadingCubit performanceLoadingCubit;
  final String? asOnDate;
  final EntityData? selectedEntity;

  const PerformanceSecondaryGroupingFilter({
    super.key,
    required this.onDone,
    required this.scrollController,
    required this.performanceSecondaryGroupingCubit,
    required this.performanceSecondarySubGroupingCubit,
    required this.performancePrimarySubGroupingCubit,
    required this.performanceEntityCubit,
    required this.performanceLoadingCubit,
    required this.asOnDate,
    required this.selectedEntity,
  });

  @override
  State<PerformanceSecondaryGroupingFilter> createState() => _PerformanceSecondaryGroupingFilterState();
}

class _PerformanceSecondaryGroupingFilterState extends State<PerformanceSecondaryGroupingFilter> {
  GroupingEntity? selectedSecondaryGrouping;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedSecondaryGrouping = widget.performanceSecondaryGroupingCubit.state.selectedGrouping;
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
              child: FilterNameWithCross(text: StringConstants.secondaryGrpFilterString,
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
                  itemBuilder: (context, index) {
                    final item = widget.performanceSecondaryGroupingCubit.state.groupingList?.toSet().toList()[index];
                    if ((item?.name
                        ?.toLowerCase()
                        .contains(controller.text.toLowerCase()) ??
                        true) ||
                        controller.text.isEmpty) {
                      return GestureDetector(
                        onTap: () {
                          if(item != null) {
                            setState((){
                              selectedSecondaryGrouping = item;
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
                                  (selectedSecondaryGrouping?.id ?? ''))
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
                  itemCount: widget.performanceSecondarySubGroupingCubit.state.selectedSubGroupingList?.length ?? 0,
                  physics: const BouncingScrollPhysics(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
              child: ApplyButton(
                text: StringConstants.applyButton,
                onPressed: () {
                  widget.performanceLoadingCubit.startLoading();
                  widget.performanceSecondaryGroupingCubit.changeSelectedPerformanceSecondaryGrouping(
                    selectedGrouping: selectedSecondaryGrouping,
                  ).then((value) {
                    widget.performanceSecondarySubGroupingCubit.loadPerformanceSecondarySubGrouping(
                        context: mounted ? context : null,
                        selectedEntity: widget.selectedEntity,
                        primarySubGroupingItem: widget.performancePrimarySubGroupingCubit.state.selectedSubGroupingList,
                        selectedGrouping: widget.performanceSecondaryGroupingCubit.state.selectedGrouping,
                        asOnDate: widget.asOnDate
                    ).then((value) =>
                        widget.performanceLoadingCubit.endLoading());
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
              Text('Secondary Grouping',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              GestureDetector(
                onTap: () {
                  widget.performanceLoadingCubit.startLoading();
                  widget.performanceSecondaryGroupingCubit.changeSelectedPerformanceSecondaryGrouping(
                      selectedGrouping: selectedSecondaryGrouping,
                  ).then((value) {
                    widget.performanceSecondarySubGroupingCubit.loadPerformanceSecondarySubGrouping(
                        context: mounted ? context : null,
                        selectedEntity: widget.selectedEntity,
                        selectedGrouping: widget.performanceSecondaryGroupingCubit.state.selectedGrouping,
                        primarySubGroupingItem: widget.performancePrimarySubGroupingCubit.state.selectedSubGroupingList,
                        asOnDate: widget.asOnDate
                    ).then((value) =>
                        widget.performanceLoadingCubit.endLoading());
                  });
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
                  itemCount: widget.performanceSecondaryGroupingCubit.state.groupingList?.length ?? 0,
                  itemBuilder: (context, index) {
                    final filterData = widget.performanceSecondaryGroupingCubit.state.groupingList?[index];
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if(filterData != null) {
                              setState((){
                                selectedSecondaryGrouping = filterData;
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
                                if(selectedSecondaryGrouping?.id == filterData?.id)
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
