
import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/utilities/helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/constants/size_constants.dart';
import '../../../domain/entities/number_of_period/number_of_period.dart';
import '../../blocs/app_theme/theme_cubit.dart';
import '../../blocs/performance/performance_number_of_period/performance_number_of_period_cubit.dart';
import '../../theme/theme_color.dart';

class PerformanceNumberOfPeriodFilter extends StatefulWidget {
  final void Function() onDone;
  final ScrollController scrollController;
  final PerformanceNumberOfPeriodCubit performanceNumberOfPeriodCubit;
  const PerformanceNumberOfPeriodFilter({
    super.key,
    required this.onDone,
    required this.scrollController,
    required this.performanceNumberOfPeriodCubit,
  });

  @override
  State<PerformanceNumberOfPeriodFilter> createState() => _PerformanceNumberOfPeriodFilterState();
}

class _PerformanceNumberOfPeriodFilterState extends State<PerformanceNumberOfPeriodFilter> {
  NumberOfPeriodItemData? selectedNumberOfPeriodItemData;

  @override
  void initState() {
    super.initState();
    selectedNumberOfPeriodItemData = widget.performanceNumberOfPeriodCubit.state.selectedPerformanceNumberOfPeriod;
  }

  @override
  Widget build(BuildContext context) {
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
              Text(StringConstants.periodFilterString,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              GestureDetector(
                onTap: () {
                  widget.performanceNumberOfPeriodCubit.changeSelectedPerformanceNumberOfPeriod(selectedNumberOfPeriod: selectedNumberOfPeriodItemData);
                  widget.onDone();
                },
                child: Text(StringConstants.applyButton,
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
                  itemCount: widget.performanceNumberOfPeriodCubit.state.performanceNumberOfPeriodList?.length ?? 0,
                  itemBuilder: (context, index) {
                    final filterData = widget.performanceNumberOfPeriodCubit.state.performanceNumberOfPeriodList?[index];
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if(filterData != null) {
                              setState((){
                                selectedNumberOfPeriodItemData = filterData;
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
                                if(selectedNumberOfPeriodItemData?.id == filterData?.id)
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
