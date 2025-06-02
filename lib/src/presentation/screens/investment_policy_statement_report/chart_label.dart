
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:flutter/material.dart';

import '../../../config/constants/size_constants.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../theme/theme_color.dart';

class ChartLabelWidget extends StatelessWidget {
  const ChartLabelWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h, horizontal: Sizes.dimen_12.w),
      child: Row(
        children: [
          const ChartLabel(
            color: AppColor.purple,
            title: 'Target',
          ),
          UIHelper.horizontalSpaceMedium,
          const ChartLabel(
            color: AppColor.pink,
            title: 'Actual',
          ),
          Expanded(child: Container()),
          const ChartLabel(
              color: AppColor.red,
              secondColor: AppColor.green,
              title: 'Return %'// state.timePeriodSelectedItem?.name ?? '--',
          ),
          UIHelper.horizontalSpaceMedium,
          const ChartLabel(
              color: AppColor.grey,
              title: 'Benchmark'
          ),
        ],
      ),
    );
  }
}

class ChartLabel extends StatelessWidget {
  final Color? secondColor;
  final Color color;
  final String title;

  const ChartLabel({
    Key? key,
    this.secondColor,
    required this.color,
    required this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: Sizes.dimen_12,
          height: Sizes.dimen_12,
          child: Container(
            child: Row(
              children: [
                Expanded(
                    child: Container(
                      color: color,
                    )
                ),
                if(secondColor != null)
                  Expanded(
                      child: Container(
                        color: secondColor,
                      )
                  )
              ],
            ),
          ),
        ),
        UIHelper.horizontalSpaceSmall,
        Text(title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.normal),
        )
      ],
    );
  }
}

