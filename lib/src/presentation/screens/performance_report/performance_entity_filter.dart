
import 'dart:math';

import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_entity/performance_entity_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_primary_grouping/performance_primary_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/widgets/filter_name_with_cross.dart';
import 'package:asset_vantage/src/presentation/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../config/constants/size_constants.dart';
import '../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../blocs/app_theme/theme_cubit.dart';
import '../../blocs/performance/performance_loading/performance_loading_cubit.dart';
import '../../blocs/performance/performance_primary_sub_grouping/performance_primary_sub_grouping_cubit.dart';
import '../../blocs/performance/performance_secondary_grouping/performance_secondary_grouping_cubit.dart';
import '../../blocs/performance/performance_secondary_sub_grouping/performance_secondary_sub_grouping_cubit.dart';
import '../../theme/theme_color.dart';
import '../../widgets/apply_button.dart';
import '../../widgets/crossSign.dart';

enum EntityType { groups, entities }

class PerformanceEntityFilter extends StatefulWidget {
  final void Function(EntityData? entity) onDone;
  final EntityData? entity;
  final ScrollController scrollController;
  final PerformanceEntityCubit performanceEntityCubit;
  final PerformancePrimaryGroupingCubit performancePrimaryGroupingCubit;
  final PerformancePrimarySubGroupingCubit performancePrimarySubGroupingCubit;
  final PerformanceSecondaryGroupingCubit performanceSecondaryGroupingCubit;
  final PerformanceSecondarySubGroupingCubit performanceSecondarySubGroupingCubit;
  final PerformanceLoadingCubit performanceLoadingCubit;
  final String? asOnDate;
  const PerformanceEntityFilter({
    super.key,
    required this.onDone,
    required this.entity,
    required this.scrollController,
    required this.performanceEntityCubit,
    required this.performancePrimaryGroupingCubit,
    required this.performancePrimarySubGroupingCubit,
    required this.performanceSecondaryGroupingCubit,
    required this.performanceSecondarySubGroupingCubit,
    required this.asOnDate,
    required this.performanceLoadingCubit,
  });

  @override
  State<PerformanceEntityFilter> createState() => _PerformanceEntityFilterState();
}

class _PerformanceEntityFilterState extends State<PerformanceEntityFilter> with SingleTickerProviderStateMixin{
  final TextEditingController controller = TextEditingController();
  late EntityType entityType;
  EntityData? selectedItem;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.entity ?? widget.performanceEntityCubit.state.selectedPerformanceEntity;
    entityType = selectedItem?.type?.toLowerCase() ==
        "entity"
        ? EntityType.entities
        : EntityType.entities;

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        entityType = _tabController.index == 0 ? EntityType.entities : EntityType.groups;
      }
    });
  }

  Future<void> fetchingPrimary() async {
    await widget.performancePrimaryGroupingCubit.loadPerformancePrimaryGrouping(
      context: context,
        selectedEntity: selectedItem,
        asOnDate: widget.asOnDate
    );
    await widget.performancePrimarySubGroupingCubit.loadPerformancePrimarySubGrouping(
        context: mounted ? context : null,
        selectedEntity: selectedItem,
        selectedGrouping: widget.performancePrimaryGroupingCubit.state.selectedGrouping,
        asOnDate: widget.asOnDate
    );
  }

  Future<void> fetchingSecondary() async {
    await widget.performanceSecondaryGroupingCubit.loadPerformanceSecondaryGrouping(
        context: context,
        selectedEntity: selectedItem,
        asOnDate: widget.asOnDate
    );
    await widget.performanceSecondarySubGroupingCubit.loadPerformanceSecondarySubGrouping(
        context: mounted ? context : null,
        selectedEntity: selectedItem,
        primarySubGroupingItem: widget.performancePrimarySubGroupingCubit.state.selectedSubGroupingList,
        selectedGrouping: widget.performanceSecondaryGroupingCubit.state.selectedGrouping,
        asOnDate: widget.asOnDate
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: DefaultTabController(
        length: 2,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_16.w),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: Sizes.dimen_8.h),
                child: FilterNameWithCross(
                  text: StringConstants.entityGroupFilterHeader,
                isSubHeader: true,
                onDone: (){
                  widget.onDone(null);
                },)
              ),
              TabBar(
                indicatorColor: AppColor.primary,
                unselectedLabelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.normal),
                labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(width: Sizes.dimen_4, color: AppColor.primary),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: AppColor.grey.withValues(alpha: 0.5),
                tabs: const [
                  Tab(text: StringConstants.entityTab,),
                  Tab(text: StringConstants.groupTab),
                ],
              ),
              SearchBarWidget(textController: controller,
                  feildKey: widget.key, onChanged: (String text) {
                  setState(() {});
                },),
              Expanded(
                child: TabBarView(
                  children: [
                    RawScrollbar(
                      thickness: Sizes.dimen_2,
                      radius: const Radius.circular(Sizes.dimen_10),
                      notificationPredicate: (notification) => true,
                      thumbVisibility: true,
                      trackVisibility: true,
                      interactive: true,
                      thumbColor: AppColor.grey,
                      trackColor: AppColor.grey.withValues(alpha: 0.2),
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          final item = widget.performanceEntityCubit.state.performanceEntityList?[index];
                          if (item?.type?.toLowerCase() ==
                              (entityType == EntityType.entities
                                  ? 'entity'
                                  : 'group')) {
                            if ((item?.name
                                ?.toLowerCase()
                                .contains(controller.text.toLowerCase()) ??
                                true) ||
                                controller.text.isEmpty) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedItem = item;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: Sizes.dimen_0.h,
                                      horizontal: Sizes.dimen_14.w),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: AppColor.grey.withValues(alpha: 0.3)))),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: Sizes.dimen_4.h,
                                              horizontal: Sizes.dimen_14.w),
                                          child: Text(item?.name ?? 'Loading',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                  fontStyle:
                                                  item?.type == "Group"
                                                      ? FontStyle.italic
                                                      : null),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                      if ((item?.id ?? '--') ==
                                          (selectedItem?.id ?? '') &&
                                          (item?.type ?? '--') ==
                                              (selectedItem?.type ?? ''))
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
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                        itemCount: widget.performanceEntityCubit.state.performanceEntityList?.length ?? 0,
                        physics: const BouncingScrollPhysics(),
                      ),
                    ),
                    RawScrollbar(
                      thickness: Sizes.dimen_2,
                      radius: const Radius.circular(Sizes.dimen_10),
                      notificationPredicate: (notification) => true,
                      thumbVisibility: true,
                      trackVisibility: true,
                      interactive: true,
                      thumbColor: AppColor.grey,
                      trackColor: AppColor.grey.withValues(alpha: 0.2),
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          final item = widget.performanceEntityCubit.state.performanceEntityList?[index];
                          if (item?.type?.toLowerCase() ==
                              (entityType == EntityType.groups
                                  ? 'entity'
                                  : 'group')) {
                            if ((item?.name
                                ?.toLowerCase()
                                .contains(controller.text.toLowerCase()) ??
                                true) ||
                                controller.text.isEmpty) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedItem = item;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: Sizes.dimen_0.h,
                                      horizontal: Sizes.dimen_14.w),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: AppColor.grey.withValues(alpha: 0.3)))),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: Sizes.dimen_4.h,
                                              horizontal: Sizes.dimen_14.w),
                                          child: Text(item?.name ?? 'Loading',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                  fontStyle:
                                                  item?.type == "Group"
                                                      ? FontStyle.normal
                                                      : null),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                      if ((item?.id ?? '--') ==
                                          (selectedItem?.id ?? '') &&
                                          (item?.type ?? '--') ==
                                              (selectedItem?.type ?? ''))
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
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                        itemCount: widget.performanceEntityCubit.state.performanceEntityList?.length ?? 0,
                        physics: const BouncingScrollPhysics(),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
                child: ApplyButton(
                  text: StringConstants.applyButton,
                  onPressed: () {
                    widget.performanceLoadingCubit.startLoading();
                    Future.wait([fetchingPrimary(),
                      fetchingSecondary()]).then((value) => widget.performanceLoadingCubit.endLoading(),);
                    widget.performanceEntityCubit.sortSelectedPerformanceEntity(selectedEntity: selectedItem);

                    widget.onDone(selectedItem);
                  },
                ),
              ),
              UIHelper.verticalSpaceSmall
            ],
          ),
        ),
      ),
    );
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: Sizes.dimen_6.h, horizontal: Sizes.dimen_14.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  widget.onDone(null);
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svgs/back_arrow.svg',
                      width: Sizes.dimen_24.w,
                      color: context
                          .read<AppThemeCubit>()
                          .state
                          ?.bottomSheet
                          ?.backArrowColor !=
                          null
                          ? Color(int.parse(context
                          .read<AppThemeCubit>()
                          .state!
                          .bottomSheet!
                          .backArrowColor!))
                          : AppColor.primary,
                    ),
                    Text(
                      'Back',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                          color: context
                              .read<AppThemeCubit>()
                              .state
                              ?.bottomSheet
                              ?.backArrowColor !=
                              null
                              ? Color(int.parse(context
                              .read<AppThemeCubit>()
                              .state!
                              .bottomSheet!
                              .backArrowColor!))
                              : AppColor.primary,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Text(
                entityType == EntityType.entities
                    ? "Entities"
                    : 'Groups',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              GestureDetector(
                onTap: () {
                  widget.performanceLoadingCubit.startLoading();
                  Future.wait([fetchingPrimary(),
                 fetchingSecondary()]).then((value) => widget.performanceLoadingCubit.endLoading(),);
                  widget.performanceEntityCubit.sortSelectedPerformanceEntity(selectedEntity: selectedItem);

                  widget.onDone(selectedItem);
                },
                child: Text(
                  'Apply',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: context
                          .read<AppThemeCubit>()
                          .state
                          ?.bottomSheet
                          ?.backArrowColor !=
                          null
                          ? Color(int.parse(context
                          .read<AppThemeCubit>()
                          .state!
                          .bottomSheet!
                          .backArrowColor!))
                          : AppColor.primary,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: ScreenUtil().screenWidth,
          padding: EdgeInsets.only(top: Sizes.dimen_6.h),
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: Sizes.dimen_5.w, vertical: Sizes.dimen_2.h),
            decoration: BoxDecoration(
                color: AppColor.textGrey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6.0)),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        entityType = EntityType.entities;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Sizes.dimen_12.w,
                          vertical: Sizes.dimen_1.h),
                      decoration: BoxDecoration(
                          color: entityType == EntityType.entities
                              ? AppColor.textGrey.withOpacity(0.3)
                              : null,
                          borderRadius: BorderRadius.circular(6.0)),
                      child: Center(
                        child: Text(
                          'Entities',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        entityType = EntityType.groups;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Sizes.dimen_12.w,
                          vertical: Sizes.dimen_1.h),
                      decoration: BoxDecoration(
                          color: entityType == EntityType.groups
                              ? AppColor.textGrey.withOpacity(0.3)
                              : null,
                          borderRadius: BorderRadius.circular(6.0)),
                      child: Center(
                        child: Text(
                          'Groups',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: Sizes.dimen_6.h,
                    horizontal: Sizes.dimen_12.w),
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
                          child: SvgPicture.asset(
                              'assets/svgs/search.svg',
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
                      color: AppColor.textGrey,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
        if (widget.performanceEntityCubit.state.performanceEntityList?.any((element) =>
        (element?.name
            ?.toLowerCase()
            .contains(controller.text.toLowerCase()) ??
            true) ||
            controller.text.isEmpty) ??
            false)
          Expanded(
            child: ListView.builder(
              controller: widget.scrollController,
              itemBuilder: (context, index) {
                final item = widget.performanceEntityCubit.state.performanceEntityList?[index];
                if (item?.type?.toLowerCase() ==
                    (entityType == EntityType.entities
                        ? 'entity'
                        : 'group')) {
                  if ((item?.name
                      ?.toLowerCase()
                      .contains(controller.text.toLowerCase()) ??
                      true) ||
                      controller.text.isEmpty) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedItem = item;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: Sizes.dimen_0.h,
                            horizontal: Sizes.dimen_14.w),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: AppColor.textGrey
                                        .withOpacity(0.4)))),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: Sizes.dimen_4.h,
                                    horizontal: Sizes.dimen_14.w),
                                child: Text(item?.name ?? 'Loading',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                        fontStyle:
                                        item?.type == "Group"
                                            ? FontStyle.italic
                                            : null),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            if ((item?.id ?? '--') ==
                                (selectedItem?.id ?? '') &&
                                (item?.type ?? '--') ==
                                    (selectedItem?.type ?? ''))
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
                } else {
                  return const SizedBox.shrink();
                }
              },
              itemCount: widget.performanceEntityCubit.state.performanceEntityList?.length ?? 0,
              physics: const BouncingScrollPhysics(),
            ),
          )
        else
          Expanded(
            child: Container(
              color: AppColor.textGrey.withOpacity(0.1),
              child: Center(
                child: Text(
                  'No result found',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          )
      ],
    );
  }
}
