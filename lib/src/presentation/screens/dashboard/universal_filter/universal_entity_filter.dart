
import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/blocs/universal_filter/as_on_date_universal_filter/universal_filter_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/universal_filter/enitity_universal_filter/universal_entity_filter_cubit.dart';
import 'package:asset_vantage/src/presentation/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../config/constants/size_constants.dart';
import '../../../../domain/entities/authentication/user_entity.dart';
import '../../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../../utilities/helper/ui_helper.dart';
import '../../../blocs/app_theme/theme_cubit.dart';
import '../../../blocs/authentication/user/user_cubit.dart';
import '../../../theme/theme_color.dart';
import '../../../widgets/apply_button.dart';
import '../../../widgets/button.dart';

enum EntityType { groups, entities }

class UniversalEntityFilter extends StatefulWidget {
  final UniversalEntityFilterCubit universalEntityFilterCubit;
  final Function onStateChange;
  final Function loadReport;

  const UniversalEntityFilter({
    super.key,
    required this.universalEntityFilterCubit,
    required this.onStateChange,
    required this.loadReport,
  });

  @override
  State<UniversalEntityFilter> createState() => _UniversalEntityFilterState();
}

class _UniversalEntityFilterState extends State<UniversalEntityFilter> with SingleTickerProviderStateMixin{
  final TextEditingController controller = TextEditingController();
  late EntityType entityType;
  EntityData? selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.universalEntityFilterCubit.state.selectedUniversalEntity;
    entityType = selectedItem?.type?.toLowerCase() ==
        "entity"
        ? EntityType.entities
        : EntityType.groups;

  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UniversalEntityFilterCubit,
        UniversalEntityFilterState>(
        bloc: widget.universalEntityFilterCubit,
        builder: (context, state) {
          if (state is UniversalEntityLoaded) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            widget.onStateChange(() {
                              setState(() {
                                entityType = EntityType.entities;
                              });
                            });
                          },
                          child: Semantics(
                            identifier: StringConstants.entityTabKey,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h, horizontal: Sizes.dimen_12.w),
                              decoration: BoxDecoration(
                                color: entityType == EntityType.entities ? AppColor.primary : null,
                                  borderRadius: BorderRadius.circular(Sizes.dimen_8),
                                  border: entityType != EntityType.entities ? Border.all(color: AppColor.lightGrey.withValues(alpha: 0.4)) : null
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(StringConstants.entityTab, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: entityType == EntityType.entities ? AppColor.white : AppColor.lightGrey),)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      UIHelper.horizontalSpaceSmall,
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            widget.onStateChange(() {
                              setState(() {
                                entityType = EntityType.groups;
                              });
                            });
                          },
                          child: Semantics(
                            identifier: StringConstants.groupTabKey,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h, horizontal: Sizes.dimen_12.w),
                              decoration: BoxDecoration(
                                  color: entityType == EntityType.groups ? AppColor.primary : null,
                                  borderRadius: BorderRadius.circular(Sizes.dimen_8),
                                  border: entityType != EntityType.groups ? Border.all(color: AppColor.lightGrey.withValues(alpha: 0.4)) : null
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(StringConstants.groupTab, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: entityType == EntityType.groups ? AppColor.white : AppColor.lightGrey),)
                                ],
                              ),
                            ),
                          )
                        ),
                      )
                    ],
                  ),
                ),

                SearchBarWidget(
                    textController: controller,
                    feildKey: widget.key,
                    onChanged: (String text) {
                      setState(() {});
                    },),
                Expanded(
                    child: entityType == EntityType.entities ?
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
                          final item = widget.universalEntityFilterCubit.state.universalEntityList?[index];
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
                        itemCount: widget.universalEntityFilterCubit.state.universalEntityList?.length ?? 0,
                        physics: const BouncingScrollPhysics(),
                      ),
                    )
                        : RawScrollbar(
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
                          final item = widget.universalEntityFilterCubit.state.universalEntityList?[index];
                          if (item?.type?.toLowerCase() ==
                              (entityType == EntityType.groups
                                  ? 'group'
                                  : 'entity')) {
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
                                                itemCount: widget.universalEntityFilterCubit.state.universalEntityList?.length ?? 0,
                                                physics: const BouncingScrollPhysics(),
                                              ),
                        )
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
                  child: ApplyButton(
                    isEnabled: true,
                    text: StringConstants.applyButton,
                    onPressed: () {
                      widget.universalEntityFilterCubit.changeSelectedUniversalEntity(selectedEntity: selectedItem);
                      widget.loadReport();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                UIHelper.verticalSpaceSmall
              ],
            );
          }
          return SizedBox(
            width: ScreenUtil().screenWidth,
            height: Sizes.dimen_24.h,
            child: Shimmer.fromColors(
              baseColor: AppColor.grey.withOpacity(0.1),
              highlightColor: AppColor.grey.withOpacity(0.2),
              direction: ShimmerDirection.ltr,
              period: const Duration(seconds: 1),
              child: Container(
                width: ScreenUtil().screenWidth,
                height: Sizes.dimen_24.h,
                decoration: BoxDecoration(
                    color: AppColor.grey,
                    borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
          );
        });
  }

  void _showBottomSheet() {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (context, setState) {
              return Material(
                textStyle: Theme.of(context).textTheme.titleLarge,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: Container(),
                ),
              );
            }
        );
      },
    );
  }
}
