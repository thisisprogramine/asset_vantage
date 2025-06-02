
import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_primary_grouping/performance_primary_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/widgets/filter_name_with_cross.dart';
import 'package:asset_vantage/src/presentation/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/constants/size_constants.dart';
import '../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../domain/entities/performance/performance_primary_grouping_entity.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../blocs/app_theme/theme_cubit.dart';
import '../../blocs/performance/performance_entity/performance_entity_cubit.dart';
import '../../blocs/performance/performance_loading/performance_loading_cubit.dart';
import '../../blocs/performance/performance_primary_sub_grouping/performance_primary_sub_grouping_cubit.dart';
import '../../theme/theme_color.dart';
import '../../widgets/apply_button.dart';
import '../../widgets/crossSign.dart';

class PerformancePrimaryGroupingFilter extends StatefulWidget {
  final void Function() onDone;
  final ScrollController scrollController;
  final PerformancePrimaryGroupingCubit performancePrimaryGroupingCubit;
  final PerformancePrimarySubGroupingCubit performancePrimarySubGroupingCubit;
  final PerformanceEntityCubit performanceEntityCubit;
  final PerformanceLoadingCubit performanceLoadingCubit;
  final String? asOnDate;
  final EntityData? selectedEntity;

  const PerformancePrimaryGroupingFilter({
    super.key,
    required this.onDone,
    required this.scrollController,
    required this.performancePrimaryGroupingCubit,
    required this.performancePrimarySubGroupingCubit,
    required this.performanceEntityCubit,
    required this.asOnDate,
    required this.performanceLoadingCubit,
    required this.selectedEntity,
  });

  @override
  State<PerformancePrimaryGroupingFilter> createState() => _PerformancePrimaryGroupingFilterState();
}

class _PerformancePrimaryGroupingFilterState extends State<PerformancePrimaryGroupingFilter> {
  GroupingEntity? selectedPrimaryGrouping;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedPrimaryGrouping = widget.performancePrimaryGroupingCubit.state.selectedGrouping;
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
              child: FilterNameWithCross(text: StringConstants.primaryGrpFilterString,
              isSubHeader: true,
              onDone: (){
                widget.onDone();
              },)
            ),
            SearchBarWidget(
                textController: controller,
                feildKey: widget.key, onChanged: (String text) {
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
                    final item = widget.performancePrimaryGroupingCubit.state.groupingList?.toSet().toList()[index];
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
                  itemCount: widget.performancePrimaryGroupingCubit.state.groupingList?.length ?? 0,
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
                  widget.performancePrimaryGroupingCubit.changeSelectedPerformancePrimaryGrouping(
                    selectedGrouping: selectedPrimaryGrouping,
                  ).then((value) {
                    widget.performancePrimarySubGroupingCubit.loadPerformancePrimarySubGrouping(
                        context: mounted ? context : null,
                        selectedEntity: widget.selectedEntity,
                        selectedGrouping: widget.performancePrimaryGroupingCubit.state.selectedGrouping,
                        asOnDate: widget.asOnDate
                    ).then((value) => widget.performanceLoadingCubit.endLoading());
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
              Text('Grouping',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              GestureDetector(
                onTap: () {
                  widget.performanceLoadingCubit.startLoading();
                  widget.performancePrimaryGroupingCubit.changeSelectedPerformancePrimaryGrouping(
                      selectedGrouping: selectedPrimaryGrouping,
                  ).then((value) {
                    widget.performancePrimarySubGroupingCubit.loadPerformancePrimarySubGrouping(
                        context: mounted ? context : null,
                        selectedEntity: widget.selectedEntity,
                        selectedGrouping: widget.performancePrimaryGroupingCubit.state.selectedGrouping,
                        asOnDate: widget.asOnDate
                    ).then((value) => widget.performanceLoadingCubit.endLoading());
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
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: Sizes.dimen_6.h, horizontal: Sizes.dimen_12.w),
                            child: Card(
                              color: AppColor.white.withOpacity(0.8),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  )),
                              child: TextFormField(
                                key: widget.key,
                                controller: controller,
                                textInputAction: TextInputAction.search,
                                onChanged: (String text) {
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  prefixIcon: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: Sizes.dimen_2.h,
                                          horizontal: Sizes.dimen_12.w),
                                      child: SvgPicture.asset('assets/svgs/search.svg',
                                          width: Sizes.dimen_24.w,
                                          color: Theme.of(context).iconTheme.color)),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: Sizes.dimen_2.h,
                                      horizontal: Sizes.dimen_12.w),
                                  isDense: true,
                                  border: InputBorder.none,
                                  prefixIconConstraints: const BoxConstraints(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.text = "";
                            setState(() {});
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: Sizes.dimen_12.w),
                            child: Text(
                              'Cancel',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppColor.textGrey, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                    if(widget.performancePrimaryGroupingCubit.state.groupingList?.any((element) =>
                    (element?.name
                        ?.toLowerCase()
                        .contains(controller.text.toLowerCase()) ??
                        true) ||
                        controller.text.isEmpty) ??
                        false)
                      Expanded(
                      child: ListView.builder(
                          controller: widget.scrollController,
                          physics: const BouncingScrollPhysics(),
                          itemCount: widget.performancePrimaryGroupingCubit.state.groupingList?.length ?? 0,
                           itemBuilder: (context, index) {
                            final filterData = widget.performancePrimaryGroupingCubit.state.groupingList?[index];
                            if((filterData?.name
                                ?.toLowerCase()
                                .contains(controller.text.toLowerCase()) ??
                                true) ||
                                controller.text.isEmpty) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if(filterData != null) {
                                        setState((){
                                          selectedPrimaryGrouping = filterData;
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
                                          if(selectedPrimaryGrouping?.id == filterData?.id)
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
                            }else {
                              return const SizedBox.shrink();
                            }
                          },
                      ),
                    )
                    else
                      Expanded(
                        child: Center(
                          child: Text('No result found',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      )
                  ],
                );
              }
          ),
        )
      ],
    );
  }
}
