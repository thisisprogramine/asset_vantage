
import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/presentation/widgets/filter_name_with_cross.dart';
import 'package:asset_vantage/src/utilities/helper/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/constants/size_constants.dart';
import '../../../domain/entities/return_percentage/return_percentage_entity.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../blocs/app_theme/theme_cubit.dart';
import '../../blocs/performance/performance_return_percent/performance_return_percent_cubit.dart';
import '../../theme/theme_color.dart';
import '../../widgets/apply_button.dart';
import '../../widgets/crossSign.dart';

class PerformanceReturnPercentFilter extends StatefulWidget {
  final void Function() onDone;
  final ScrollController scrollController;
  final PerformanceReturnPercentCubit performanceReturnPercentCubit;
  const PerformanceReturnPercentFilter({
    super.key,
    required this.onDone,
    required this.scrollController,
    required this.performanceReturnPercentCubit,
  });

  @override
  State<PerformanceReturnPercentFilter> createState() => _PerformanceReturnPercentFilterState();
}

class _PerformanceReturnPercentFilterState extends State<PerformanceReturnPercentFilter> {
  List<ReturnPercentItemData?> selectedReturnPercentItemData = [];

  @override
  void initState() {
    super.initState();
    selectedReturnPercentItemData.addAll(widget.performanceReturnPercentCubit.state.selectedPerformanceReturnPercentList ?? []);
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
              child: FilterNameWithCross(text: StringConstants.returnPercentageFilterString,
              isSubHeader: true,
              onDone: (){
                widget.onDone();
              },)
            ),
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
                child: StatefulBuilder(builder: (context, setState) {
                  return ListView.builder(
                    controller: widget.scrollController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: widget.performanceReturnPercentCubit.state.performanceReturnPercentList?.length ?? 0,
                    itemBuilder: (context, index) {
                      final filterData = widget.performanceReturnPercentCubit.state.performanceReturnPercentList?[index];
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if(filterData != null) {
                                setState((){
                                  if((selectedReturnPercentItemData.length <= 3) || selectedReturnPercentItemData.contains(filterData)) {
                                    if(selectedReturnPercentItemData.contains(filterData)) {
                                      selectedReturnPercentItemData.remove(filterData);
                                    }else {
                                      selectedReturnPercentItemData.add(filterData);
                                    }
                                  }else {
                                    FlashHelper.showToastMessage(context, message: 'Select only four', type: ToastType.info);
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
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: (selectedReturnPercentItemData.length <= 3) || selectedReturnPercentItemData.contains(filterData) ? null : AppColor.lightGrey.withOpacity(0.6)),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis
                                      ),
                                    ),
                                  ),
                                  if(selectedReturnPercentItemData.contains(filterData))
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
                }),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
              child: ApplyButton(
                text: StringConstants.applyButton,
                onPressed: () {
                  widget.performanceReturnPercentCubit.changeSelectedPerformanceReturnPercent(context: context, selectedReturnPercentList: selectedReturnPercentItemData);
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
              Text('Return(Annualised) %',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              GestureDetector(
                onTap: () {
                  widget.performanceReturnPercentCubit.changeSelectedPerformanceReturnPercent(context: context, selectedReturnPercentList: selectedReturnPercentItemData);
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
                  itemCount: widget.performanceReturnPercentCubit.state.performanceReturnPercentList?.length ?? 0,
                  itemBuilder: (context, index) {
                    final filterData = widget.performanceReturnPercentCubit.state.performanceReturnPercentList?[index];
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if(filterData != null) {
                              setState((){
                                if((selectedReturnPercentItemData.length <= 3) || selectedReturnPercentItemData.contains(filterData)) {
                                  if(selectedReturnPercentItemData.contains(filterData)) {
                                    selectedReturnPercentItemData.remove(filterData);
                                  }else {
                                    selectedReturnPercentItemData.add(filterData);
                                  }
                                }else {
                                  FlashHelper.showToastMessage(context, message: 'Select only four', type: ToastType.info);
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
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: (selectedReturnPercentItemData.length <= 3) || selectedReturnPercentItemData.contains(filterData) ? null : AppColor.lightGrey.withOpacity(0.6)),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis
                                    ),
                                  ),
                                ),
                                if(selectedReturnPercentItemData.contains(filterData))
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
