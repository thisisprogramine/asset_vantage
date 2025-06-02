import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_as_on_date/net_worth_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/widgets/filter_name_with_cross.dart';
import 'package:asset_vantage/src/utilities/helper/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../../config/constants/size_constants.dart';
import '../../../../utilities/helper/ui_helper.dart';
import '../../../blocs/app_theme/theme_cubit.dart';
import '../../../theme/theme_color.dart';
import 'dart:ui' as ui;

import '../../../widgets/apply_button.dart';
import '../../../widgets/crossSign.dart';

class NetWorthDatePickerFilter extends StatefulWidget {
  final ScrollController scrollController;
  final void Function() onDone;
  final String dateLimit;
  final NetWorthAsOnDateCubit netWorthAsonDateCubit;

  const NetWorthDatePickerFilter({
    Key? key,
    required this.scrollController,
    required this.onDone,
    required this.dateLimit,
    required this.netWorthAsonDateCubit,
  }) : super(key: key);

  @override
  State<NetWorthDatePickerFilter> createState() => _NetWorthDatePickerFilterState();
}

class _NetWorthDatePickerFilterState extends State<NetWorthDatePickerFilter> {
  String? selectedDate;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: Sizes.dimen_8.h, horizontal: Sizes.dimen_16.w),
            child: FilterNameWithCross(
              text: StringConstants.asOnDateFilterString,
            isSubHeader: true,
            onDone: (){
              widget.onDone();
            },)

          ),
          Expanded(
              child: CalendarDatePicker(
                initialDate: DateTime.tryParse(widget.netWorthAsonDateCubit.state.asOnDate ?? DateTime.now().subtract(const Duration(days: 1)).toString()) ?? DateTime.now().subtract(const Duration(days: 1)),
                firstDate: DateTime(1980),
                lastDate: DateTime.now(),
                onDateChanged: (value) {
                  selectedDate = DateFormat('yyyy-MM-dd').format(value);
                  setState(() {});
                },
              )
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_12.w),
            child: ApplyButton(
              text: StringConstants.applyButton,
              onPressed: () {
                widget.netWorthAsonDateCubit.changeAsOnDate(asOnDate: selectedDate);
                widget.onDone();
              },
            ),
          ),
          UIHelper.verticalSpaceSmall
        ],
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
                  widget.onDone();
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
              Flexible(
                child: Text(
                  'As on Date',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(overflow: TextOverflow.ellipsis),
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.netWorthAsonDateCubit.changeAsOnDate(asOnDate: selectedDate);
                  widget.onDone();
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
          initialDate: DateTime.tryParse(widget.netWorthAsonDateCubit.state.asOnDate ?? DateTime.now().subtract(const Duration(days: 1)).toString()) ?? DateTime.now().subtract(const Duration(days: 1)),
          firstDate: DateTime(1980),
          lastDate: DateTime.tryParse(
              AppHelpers.getDateLimit(dateLimit: widget.dateLimit)) ??
              DateTime.now(),
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
    );
  }
}
