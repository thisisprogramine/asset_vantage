
import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/blocs/universal_filter/as_on_date_universal_filter/universal_filter_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/widgets/filter_name_with_cross.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../config/constants/size_constants.dart';
import '../../../../domain/entities/authentication/user_entity.dart';
import '../../../../utilities/helper/app_helper.dart';
import '../../../../utilities/helper/ui_helper.dart';
import '../../../blocs/app_theme/theme_cubit.dart';
import '../../../blocs/authentication/user/user_cubit.dart';
import '../../../theme/theme_color.dart';
import '../../../widgets/apply_button.dart';
import '../../../widgets/crossSign.dart';

class UniversalAsOnDateFilter extends StatefulWidget {
  final UniversalFilterAsOnDateCubit universalFilterAsOnDateCubit;
  final Function loadReport;
  const UniversalAsOnDateFilter({
    super.key,
    required this.universalFilterAsOnDateCubit,
    required this.loadReport,
  });

  @override
  State<UniversalAsOnDateFilter> createState() => _UniversalAsOnDateFilterState();
}

class _UniversalAsOnDateFilterState extends State<UniversalAsOnDateFilter> {
  String? selectedDate;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserEntity?>(
        builder: (context, user) {
          return BlocBuilder<UniversalFilterAsOnDateCubit,
              UniversalFilterAsOnDateState>(
              bloc: widget.universalFilterAsOnDateCubit,
              builder: (context, state) {
                return Column(
                  children: [
                    UIHelper.verticalSpaceSmall,
                    Expanded(
                        child: CalendarDatePicker(
                          initialDate: DateTime.tryParse(widget.universalFilterAsOnDateCubit.state.asOnDate ?? DateTime.now().subtract(const Duration(days: 1)).toString()) ?? DateTime.now().subtract(const Duration(days: 1)),
                          firstDate: DateTime(1980),
                          lastDate: DateTime.now(),
                          onDateChanged: (value) {
                            selectedDate = DateFormat('yyyy-MM-dd').format(value);
                            setState(() {});
                          },
                        )
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
                      child: ApplyButton(
                        text: StringConstants.applyButton,
                        onPressed: () {
                          widget.universalFilterAsOnDateCubit.changeAsOnDate(asOnDate: selectedDate);
                          widget.loadReport();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    UIHelper.verticalSpaceSmall
                  ],
                );
              });
        });
  }

  void _showBottomSheet() {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) {
        return Material(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_8.h, horizontal: Sizes.dimen_16.w),
                  child: FilterNameWithCross(
                      text: StringConstants.dateFilterHeader,
                  )

                ),
                Expanded(
                    child: CalendarDatePicker(
                      initialDate: DateTime.tryParse(widget.universalFilterAsOnDateCubit.state.asOnDate ?? DateTime.now().subtract(const Duration(days: 1)).toString()) ?? DateTime.now().subtract(const Duration(days: 1)),
                      firstDate: DateTime(1980),
                      lastDate: DateTime.now(),
                      onDateChanged: (value) {
                        selectedDate = DateFormat('yyyy-MM-dd').format(value);
                        setState(() {});
                      },
                    )
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h, horizontal: Sizes.dimen_12.w),
                  child: ApplyButton(
                    text: StringConstants.applyButton,
                    onPressed: () {
                      widget.universalFilterAsOnDateCubit.changeAsOnDate(asOnDate: selectedDate);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                UIHelper.verticalSpaceSmall
              ],
            ),
          ),
        );
        return StatefulBuilder(
          builder: (context, setState) {
            return Material(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Sizes.dimen_6.h, horizontal: Sizes.dimen_14.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
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
                            ],
                          ),
                        ),
                        Text(
                          'As on Date',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.universalFilterAsOnDateCubit.changeAsOnDate(asOnDate: selectedDate);
                            Navigator.of(context).pop();
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
                  CalendarDatePicker(
                    initialDate: DateTime.tryParse(widget.universalFilterAsOnDateCubit.state.asOnDate ?? DateTime.now().subtract(const Duration(days: 1)).toString()) ?? DateTime.now().subtract(const Duration(days: 1)),
                    firstDate: DateTime(1980),
                    lastDate: DateTime.now(),
                    onDateChanged: (value) {
                      selectedDate = DateFormat('yyyy-MM-dd').format(value);
                      setState(() {});
                    },
                  ),
                  if(DateTime.parse((selectedDate ?? DateTime.now().subtract(const Duration(days: 1))).toString())
                      .toIso8601String()
                      .split('T')[0] ==
                      DateTime.now().toIso8601String().split('T')[0])
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Sizes.dimen_0.h, horizontal: Sizes.dimen_14.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                text: "Note: ",
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Securities valuations are likely to be updated from previous market day close.",
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                ],
              ),
            );
          }
        );
      },
    );
  }
}
