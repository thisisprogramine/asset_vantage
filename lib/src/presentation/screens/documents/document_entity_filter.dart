
import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/widgets/filter_name_with_cross.dart';
import 'package:asset_vantage/src/presentation/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_filex/open_filex.dart';
import 'package:shimmer/shimmer.dart';

import '../../../config/constants/size_constants.dart';
import '../../../domain/entities/app_error.dart';
import '../../../domain/entities/authentication/user_entity.dart';
import '../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../utilities/helper/app_helper.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../blocs/app_theme/theme_cubit.dart';
import '../../blocs/authentication/user/user_cubit.dart';
import '../../blocs/document/document_filter/document_filter_cubit.dart';
import '../../theme/theme_color.dart';
import '../../widgets/apply_button.dart';
import '../../widgets/crossSign.dart';

enum EntityType { groups, entities }

class DocumentEntityFilter extends StatefulWidget {
  final bool isIpad;
  final DocumentFilterCubit documentFilterCubit;
  const DocumentEntityFilter({
    Key? key,
    required this.isIpad,
    required this.documentFilterCubit
  }) : super(key: key);

  @override
  State<DocumentEntityFilter> createState() => _DocumentEntityFilterState();
}

class _DocumentEntityFilterState extends State<DocumentEntityFilter> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentFilterCubit, DocumentFilterState>(
        builder: (context, state) {
          if(state is DocumentFilterChanged) {
            return BlocBuilder<UserCubit, UserEntity?>(
                builder: (context, user) {
                  final list = state.list?.where((e) => e.name?.contains('${user?.defaultEntity}') ?? false).toList();
                  if((list?.length ?? 0) > 0) {
                  }
                  return GestureDetector(
                    onTap: () {
                      _showBottomSheet();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(state.selectedFilter?.name ?? '--',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Container(
                          color: AppColor.transparent,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_12.w),
                            child: SvgPicture.asset("assets/svgs/down_arrow.svg", color: AppColor.lightGrey),
                          ),
                        )
                      ],
                    ),
                  );
                }
            );
          }else if(state is DocumentFilterLoading) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: widget.isIpad ? Sizes.dimen_0.h : Sizes.dimen_2.h),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)
                  )
              ),
              child: Container(
                width: ScreenUtil().screenWidth * 0.50,
                child: Shimmer.fromColors(
                  baseColor: AppColor.white.withOpacity(0.1),
                  highlightColor: AppColor.white.withOpacity(0.2),
                  direction: ShimmerDirection.ltr,
                  period: Duration(seconds: 1),
                  child: Container(
                    width: ScreenUtil().screenWidth * 0.50,
                    padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_2.w, vertical: Sizes.dimen_3.h),
                    decoration: BoxDecoration(
                      color: AppColor.grey,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(''),

                  ),
                ),
              ),
            );
          }else if(state is DocumentFilterError) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: widget.isIpad ? Sizes.dimen_0.h : Sizes.dimen_2.h),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)
                  )
              ),
              child: Container(
                width: ScreenUtil().screenWidth * 0.50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_2.w, vertical: Sizes.dimen_3.h),
                          child: Text('ERROR',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColor.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_4.w),
                        child: const Icon(Icons.arrow_drop_down_outlined, color: AppColor.primary,)
                    )
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }
    );
  }

  void _showBottomSheet() {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) {
        return EntityList(
          documentFilterCubit: widget.documentFilterCubit,
        );
      },
    );
  }

}

class EntityList extends StatefulWidget {
  final DocumentFilterCubit documentFilterCubit;
  const EntityList({
    Key? key,
    required this.documentFilterCubit,
  }) : super(key: key);

  @override
  State<EntityList> createState() => _EntityListState();
}

class _EntityListState extends State<EntityList> with SingleTickerProviderStateMixin{
  final TextEditingController controller  = TextEditingController();
  late EntityType entityType;
  EntityData? selectedItem;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.documentFilterCubit.state.selectedFilter;
    entityType = selectedItem?.type?.toLowerCase() == "entity"
        ? EntityType.entities
        : EntityType.entities;

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        entityType = _tabController.index == 0 ? EntityType.entities : EntityType.groups;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        child: DefaultTabController(
          length: 1,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_16.w),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_8.h),
                  child: FilterNameWithCross(
                      text: StringConstants.documentEntityFilterHeader,
                  isSubHeader: true,
                  onDone: (){
                    Navigator.of(context).pop();
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
                  tabs: [
                    Tab(text: StringConstants.entityTab,),
                  ],
                ),
                SearchBarWidget(
                    textController: controller,
                    feildKey: widget.key,
                    onChanged: (String text) {
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
                            final item = widget.documentFilterCubit.state.filterList?[index];
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
                          itemCount: widget.documentFilterCubit.state.filterList?.length ?? 0,
                          physics: const BouncingScrollPhysics(),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
                  child: ApplyButton(
                    text: StringConstants.applyButton,
                    onPressed: () {
                      widget.documentFilterCubit.selectDocumentEntity(context: context, entity: selectedItem);
                      Navigator.pop(context);
                    },
                  ),
                ),
                UIHelper.verticalSpaceSmall
              ],
            ),
          ),
        ),
      ),
    );
    return BlocBuilder<DocumentFilterCubit, DocumentFilterState>(
      bloc: widget.documentFilterCubit,
      builder: (context, state) {
        if(state is DocumentFilterChanged) {
          state.list?.removeWhere((element) => element.type == 'Group');
          final firstGrpIndex =
              (state.list?.indexWhere((element) => element.type == 'Group') ??
                  0) -
                  1;
          return Column(
            children: [
              Container(
                width: ScreenUtil().screenWidth,
                padding: EdgeInsets.only(top: Sizes.dimen_6.h),
                child: Center(
                  child: Text('Entities',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: Sizes.dimen_6.h, horizontal: Sizes.dimen_12.w),
                      child: Card(
                        color: context.read<AppThemeCubit>().state?.searchBar!.color != null ? Color(int.parse(context.read<AppThemeCubit>().state!.searchBar!.color!)) : null,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0),
                            )
                        ),
                        child: TextFormField(
                          key: widget.key,
                          controller: controller,
                          textInputAction: TextInputAction.search,
                          onChanged: (String text) {
                            setState(() {

                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search',
                            prefixIcon: Padding(
                                padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h, horizontal: Sizes.dimen_12.w),
                                child: SvgPicture.asset('assets/svgs/search.svg',
                                  width: Sizes.dimen_24.w,
                                  color: context.read<AppThemeCubit>().state?.searchBar!.iconColor != null ? Color(int.parse(context.read<AppThemeCubit>().state!.searchBar!.iconColor!)) : null,

                                ),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_12.w),
                            isDense: true,
                            border: InputBorder.none,
                            prefixIconConstraints: BoxConstraints(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: Sizes.dimen_12.w),
                      child: Text('Cancel',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColor.grey, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
              if (state.list?.any((element) =>
              (element.name
                  ?.toLowerCase()
                  .contains(controller.text.toLowerCase()) ??
                  true) ||
                  controller.text.isEmpty) ??
                  false)
                Expanded(
                  child: ListView.separated(
                      separatorBuilder: (context, index) {
                        if(index==(firstGrpIndex + (state.selectedFilter?.type == 'Group' ? 2 : 0))
                            && (state.list?.any((element) => element.type=='Group' && (element.name?.toLowerCase().contains(controller.text.toLowerCase())??true)) ?? false)){
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                padding: EdgeInsets.symmetric(vertical: Sizes.dimen_8.h, horizontal: Sizes.dimen_28.w),
                                child: Text(
                                  'Groups',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Color(int.parse(context.read<AppThemeCubit>().state?.grouping?.iconClor ?? '')) ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Divider(
                                height: 1,
                                color: Theme.of(context).textTheme.titleLarge?.color,
                                endIndent: Sizes.dimen_14.w,
                                indent: Sizes.dimen_14.w,
                              )
                            ],
                          );
                        }else {
                          return const SizedBox.shrink();
                        }
                      },
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.list?.length ?? 0,
                      itemBuilder: (context, index) {
                        final item = state.list?[index];
                        if((item?.name?.toLowerCase().contains(controller.text.toLowerCase()) ?? true) || controller.text.isEmpty) {
                          return GestureDetector(
                            onTap: () {
                              widget.documentFilterCubit.selectDocumentEntity(context: context, entity: item);
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: Sizes.dimen_0.h, horizontal: Sizes.dimen_14.w),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: AppColor.grey.withOpacity(0.4))
                                  )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_14.w),
                                      child: Text(
                                          item?.name ?? 'Loading',
                                          style: Theme.of(context).textTheme.titleMedium,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis
                                      ),
                                    ),
                                  ),
                                  if((item?.id ?? '--') == (state.selectFilter?.id ?? ''))
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h, horizontal: Sizes.dimen_14.w),
                                      child: Icon(
                                        Icons.check_rounded,
                                        color: context.read<AppThemeCubit>().state?.filter?.iconColor != null ? Color(int.parse(context.read<AppThemeCubit>().state!.filter!.iconColor!)) : AppColor.primary,
                                        size: Sizes.dimen_24.w,
                                      ),
                                    )
                                ],
                              ),
                            ),
                          );
                        }else {
                          return const SizedBox.shrink();
                        }

                      }
                  ),
                )
              else
                Expanded(
                  child: Container(
                    color: AppColor.grey.withOpacity(0.1),
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
        }else if(state is DocumentFilterError) {
          return Text('Filter Error',
            style: Theme.of(context).textTheme.titleSmall,
          );
        }
        return Text('Loading...',
          style: Theme.of(context).textTheme.titleSmall,
        );
      },
    );
  }
}