import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/screens/dashboard/universal_filter/universal_as_on_date_filter.dart';
import 'package:asset_vantage/src/presentation/screens/dashboard/universal_filter/universal_entity_filter.dart';
import 'package:asset_vantage/src/presentation/widgets/filter_name_with_cross.dart';
import 'package:asset_vantage/src/utilities/helper/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../config/constants/size_constants.dart';
import '../../../../domain/entities/authentication/user_entity.dart';
import '../../../../utilities/helper/ui_helper.dart';
import '../../../blocs/authentication/user/user_cubit.dart';
import '../../../blocs/universal_filter/as_on_date_universal_filter/universal_filter_as_on_date_cubit.dart';
import '../../../blocs/universal_filter/enitity_universal_filter/universal_entity_filter_cubit.dart';
import '../../../theme/theme_color.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../widgets/apply_button.dart';
import '../../../widgets/crossSign.dart';
import '../../../widgets/loading_widgets/loading_bg.dart';
import '../../../widgets/toast_message.dart';

class UniversalHeader extends StatefulWidget {
  final void Function()? onCollapsed;
  final void Function() resetUniversalFilters;
  final Widget child;
  final PageController controller;
  final int length;
  final UniversalEntityFilterCubit universalEntityFilterCubit;
  final UniversalFilterAsOnDateCubit universalFilterAsOnDateCubit;
  final bool is_Collapsed;

  const UniversalHeader({
    super.key,
    required this.child,
    required this.onCollapsed,
    required this.resetUniversalFilters,
    required this.controller,
    required this.length,
    required this.universalFilterAsOnDateCubit,
    required this.universalEntityFilterCubit, required this.is_Collapsed,
  });

  @override
  State<UniversalHeader> createState() => _UniversalHeaderState();
}

class _UniversalHeaderState extends State<UniversalHeader> with TickerProviderStateMixin{
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController=AnimationController(duration: Duration(
      milliseconds: 600
    ),vsync: this,
      value: 0.0,
    );

    _animation=CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

  }
  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  void didUpdateWidget(UniversalHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.is_Collapsed != widget.is_Collapsed) {
      if (widget.is_Collapsed) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_12.w),
      child: Column(
        children: [
          BlocBuilder<UserCubit, UserEntity?>(
              builder: (context, user) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_12.w),
                child: Row(
                  children: [
                    Expanded(
                        child: Row(
                          children: [
                            Text(StringConstants.welcomeHeader,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if(user != null)
                              Expanded(
                                child: Text(" ${user.displayname}",
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                          ],
                        )
                    ),
                  ],
                ),
              );
            }
          ),
          UIHelper.verticalSpace(Sizes.dimen_2.h),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(Sizes.dimen_8.r),
              ),
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: Sizes.dimen_14.r,
              ),
              child: BlocBuilder<UserCubit, UserEntity?>(
                builder: (context, user) {
                  return Column(
                    children: [
                      Padding(
                        padding:const EdgeInsets.symmetric(horizontal: Sizes.dimen_14),
                        child: Row(
                          children: [
                            Expanded(
                                child: Row(
                                  children: [
                                    Text(StringConstants.primaryReportHeader,
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                )
                            ),
                            GestureDetector(
                              onTap: () {
                                widget.onCollapsed?.call();

                              },
                              child: Container(
                                  padding:const EdgeInsets.symmetric(horizontal: Sizes.dimen_8, vertical: Sizes.dimen_8),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColor.grey.withValues(alpha: 0.2)
                                  ),
                                  child: Semantics(
                                    identifier: "carousalArrow",
                                      child: SvgPicture.asset(!widget.is_Collapsed ? "assets/svgs/up_arrow.svg" : "assets/svgs/down_arrow.svg", width: Sizes.dimen_12,))
                              ),
                            )
                          ],
                        ),
                      ),
                      SizeTransition(sizeFactor: _animation,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_14.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BlocBuilder<UserCubit, UserEntity?>(
                                    builder: (context, user) {
                                      return BlocBuilder<UniversalFilterAsOnDateCubit,
                                          UniversalFilterAsOnDateState>(
                                          bloc: widget.universalFilterAsOnDateCubit,
                                          builder: (context, asOnDateState) {
                                            return BlocBuilder<UniversalEntityFilterCubit,
                                                UniversalEntityFilterState>(
                                                bloc: widget.universalEntityFilterCubit,
                                                builder: (context, entityState) {
                                                  if (entityState is UniversalEntityLoaded) {
                                                    return Flexible(
                                                        child: GestureDetector(
                                                          behavior: HitTestBehavior.translucent,
                                                          onTap: () {
                                                            _showBottomSheet();
                                                          },
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Flexible(
                                                                      child: Text("${entityState.selectedEntity?.name}",
                                                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.normal, color: AppColor.lightGrey.withValues(alpha: 0.9)),
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                      )
                                                                  ),
                                                                  UIHelper.horizontalSpaceSmall,
                                                                  Semantics(
                                                                    identifier: "downArrow",
                                                                      child: Padding(  padding: const EdgeInsets.only(right: Sizes.dimen_20,top: Sizes.dimen_4,bottom: Sizes.dimen_4),  child: SvgPicture.asset("assets/svgs/down_arrow.svg", width: Sizes.dimen_14,),))
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text("${DateFormat(user?.dateFormat ?? 'dd MMM yyyy').format(DateTime.parse(asOnDateState.asOnDate ?? DateTime.now().toString()))}",
                                                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.normal, color: AppColor.lightGrey.withValues(alpha: 0.9)),
                                                                    maxLines: 1,
                                                                    overflow: TextOverflow.ellipsis,
                                                                  )
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                    );
                                                  }
                                                  return LoadingBg(
                                                    width: ScreenUtil().screenWidth * 0.50,
                                                    height: Sizes.dimen_22.h,
                                                  );
                                                });
                                          }
                                      );
                                    }
                                ),

                              ],
                            ),
                          ),
                          widget.child,
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                    color: AppColor.textGrey.withValues(alpha: 0.2),
                                    width: 0.6,
                                  )),
                            ),
                            margin: EdgeInsets.symmetric(
                                horizontal: Sizes.dimen_14.w
                            ),
                            padding: EdgeInsets.only(
                              top: Sizes.dimen_6.h,
                              bottom: Sizes.dimen_1.h,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SmoothPageIndicator(
                                  controller: widget.controller,
                                  count: widget.length,
                                  effect: WormEffect(
                                    dotHeight: Sizes.dimen_6,
                                    dotWidth: Sizes.dimen_6,
                                    spacing: Sizes.dimen_6,
                                    activeDotColor: AppColor.primary,
                                    dotColor: AppColor.grey.withValues(alpha: 0.7),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      )

                    ],
                  );
                }
              ),
            ),
          ),
        ],
      ),
    );
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
                  child: DefaultTabController(
                    length: 2,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_16.w),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: Sizes.dimen_8.h),
                            child: const FilterNameWithCross(text: StringConstants.filter),

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
                              Semantics(
                                identifier: "entityTab",
                                  child: Tab(text: StringConstants.entityGroupFilterString,)),
                              Semantics(
                                identifier: "dateTab",
                                  child: Tab(text: "${DateFormat('d-MMM-yyyy').format(DateTime.parse(widget.universalFilterAsOnDateCubit.state.asOnDate ?? DateTime.now().toString()))}")),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                UniversalEntityFilter(
                                  loadReport: () {
                                    widget.resetUniversalFilters();
                                  },
                                    onStateChange: setState,
                                    universalEntityFilterCubit: widget.universalEntityFilterCubit
                                ),
                                UniversalAsOnDateFilter(
                                  loadReport: () {
                                    widget.resetUniversalFilters();
                                  },
                                    universalFilterAsOnDateCubit: widget.universalFilterAsOnDateCubit
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
        );
      },
    );
  }
}
