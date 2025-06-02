import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/widgets/filter_name_with_cross.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../config/constants/size_constants.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../blocs/expense/expense_as_on_date/expense_as_on_date_cubit.dart';
import '../../blocs/app_theme/theme_cubit.dart';
import '../../theme/theme_color.dart';
import '../../widgets/apply_button.dart';
import '../../widgets/crossSign.dart';

class ExpenseAsOnDateFilter extends StatefulWidget {
  final ScrollController scrollController;
  final void Function() onDone;
  DateTime? prevDate;
  final String dateLimit;
  final ExpenseAsOnDateCubit expenseAsOnDateCubit;

  ExpenseAsOnDateFilter({
    Key? key,
    required this.scrollController,
    required this.onDone,
    required this.dateLimit,
    required this.expenseAsOnDateCubit,
    this.prevDate,
  }) : super(key: key);

  @override
  State<ExpenseAsOnDateFilter> createState() => _ExpenseAsOnDateFilterState();
}

class _ExpenseAsOnDateFilterState extends State<ExpenseAsOnDateFilter> {
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
                initialDate: DateTime.tryParse(widget.expenseAsOnDateCubit.state.asOnDate ?? DateTime.now().subtract(const Duration(days: 1)).toString()) ?? DateTime.now().subtract(const Duration(days: 1)),
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
                widget.expenseAsOnDateCubit.changeAsOnDate(asOnDate: selectedDate);
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
              Text(
                'As on Date',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              GestureDetector(
                onTap: () {
                  widget.expenseAsOnDateCubit.changeAsOnDate(asOnDate: selectedDate);
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
          initialDate: DateTime.tryParse(widget.expenseAsOnDateCubit.state.asOnDate ?? DateTime.now().subtract(const Duration(days: 1)).toString()) ?? DateTime.now().subtract(Duration(days: 1)),
          firstDate: DateTime(1980),
          lastDate: DateTime.now().subtract(const Duration(days: 1)),
          onDateChanged: (value) {
            selectedDate = DateFormat('yyyy-MM-dd').format(value);
            setState(() {});
          },
        ),
      ],
    );
  }
}
