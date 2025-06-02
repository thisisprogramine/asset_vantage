import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/widgets/filter_name_with_cross.dart';
import 'package:asset_vantage/src/utilities/helper/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../config/constants/size_constants.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../blocs/app_theme/theme_cubit.dart';
import '../../blocs/cash_balance/cash_balance_as_on_date/cash_balance_as_on_date_cubit.dart';
import '../../theme/theme_color.dart';
import '../../widgets/apply_button.dart';
import '../../widgets/crossSign.dart';

class CashBalanceAsOnDateFilter extends StatefulWidget {
  final ScrollController scrollController;
  final void Function() onDone;
  DateTime? prevDate;
  final String dateLimit;
  final CashBalanceAsOnDateCubit cashBalanceAsOnDateCubit;

  CashBalanceAsOnDateFilter({
    Key? key,
    required this.scrollController,
    required this.onDone,
    required this.dateLimit,
    required this.cashBalanceAsOnDateCubit,
    this.prevDate,
  }) : super(key: key);

  @override
  State<CashBalanceAsOnDateFilter> createState() => _CashBalanceAsOnDateFilterState();
}

class _CashBalanceAsOnDateFilterState extends State<CashBalanceAsOnDateFilter> {
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
                initialDate: DateTime.tryParse(widget.cashBalanceAsOnDateCubit.state.asOnDate ?? DateTime.now().subtract(const Duration(days: 1)).toString()) ?? DateTime.now().subtract(const Duration(days: 1)),
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
                widget.cashBalanceAsOnDateCubit.changeAsOnDate(asOnDate: selectedDate);
                widget.onDone();
              },
            ),
          ),
          UIHelper.verticalSpaceSmall
        ],
      ),
    );
  }
}
