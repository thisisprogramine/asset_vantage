

import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_entity/net_worth_entity_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_grouping/net_worth_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_loading/net_worth_loading_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_sub_grouping/net_worth_sub_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/widgets/filter_name_with_cross.dart';
import 'package:asset_vantage/src/presentation/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../config/constants/size_constants.dart';
import '../../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../../utilities/helper/ui_helper.dart';
import '../../../blocs/app_theme/theme_cubit.dart';
import '../../../theme/theme_color.dart';
import '../../../widgets/apply_button.dart';
import '../../../widgets/crossSign.dart';

enum EntityType { groups, entities }

class NetWorthEntityList extends StatefulWidget {
  final void Function(EntityData? entity) onDone;
  final EntityData? entity;
  final ScrollController scrollController;
  final NetWorthEntityCubit netWorthEntityCubit;
  final NetWorthGroupingCubit netWorthGroupingCubit;
  final NetWorthPrimarySubGroupingCubit netWorthPrimarySubGroupingCubit;
  final NetWorthLoadingCubit netWorthLoadingCubit;
  final String? asOnDate;
  const NetWorthEntityList({
    Key? key,
    required this.onDone,
    required this.entity,
    required this.scrollController,
    required this.netWorthPrimarySubGroupingCubit,
    required this.netWorthLoadingCubit,
    required this.netWorthGroupingCubit,
    required this.netWorthEntityCubit,
    required this.asOnDate,
  }) : super(key: key);

  @override
  State<NetWorthEntityList> createState() => _NetWorthEntityListState();
}

class _NetWorthEntityListState extends State<NetWorthEntityList> with SingleTickerProviderStateMixin{
  final TextEditingController controller = TextEditingController();
  late TabController _tabController;
  late EntityType entityType;
  EntityData? selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.entity ?? widget.netWorthEntityCubit.state.selectedNetWorthEntity;
    entityType = selectedItem?.type?.toLowerCase() ==
        "entity"
        ? EntityType.entities
        : EntityType.entities;

    _tabController = TabController(length: 2, vsync: this);

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
                },),

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
                tabs:  [
                  Semantics(
                    identifier: StringConstants.entityTabKey,
                      child: Tab(text: StringConstants.entityTab,)),
                  Semantics(
                    identifier: StringConstants.groupTabKey,
                      child: Tab(text: StringConstants.groupTab)),
                ],
              ),

              SearchBarWidget(
                  textController: controller,
                  feildKey: widget.key,
                  onChanged: (String text) {
                setState(() {});
              }),
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
                          final item = widget.netWorthEntityCubit.state.netWorthEntityList?[index];
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
                        itemCount: widget.netWorthEntityCubit.state.netWorthEntityList?.length ?? 0,
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
                          final item = widget.netWorthEntityCubit.state.netWorthEntityList?[index];
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
                        itemCount: widget.netWorthEntityCubit.state.netWorthEntityList?.length ?? 0,
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
                    widget.netWorthLoadingCubit.startLoading();
                    widget.netWorthGroupingCubit.loadNetWorthPrimaryGrouping(
                        context: context,
                        selectedEntity: selectedItem,
                        asOnDate: widget.asOnDate
                    ).then((value) => widget.netWorthPrimarySubGroupingCubit.loadNetWorthPrimarySubGrouping(
                        context: mounted ? context : null,
                        selectedEntity: selectedItem,
                        selectedGrouping: widget.netWorthGroupingCubit.state.selectedGrouping,
                        asOnDate: widget.asOnDate
                    ).then((value) => widget.netWorthLoadingCubit.endLoading(),),);
                    widget.netWorthEntityCubit.sortSelectedNetWorthEntity(selectedEntity: selectedItem);
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
  }
}
