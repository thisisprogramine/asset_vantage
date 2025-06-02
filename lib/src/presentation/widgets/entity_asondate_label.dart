import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../config/constants/size_constants.dart';
import '../../utilities/helper/ui_helper.dart';
import '../theme/theme_color.dart';

class EntityAsonDateLabels extends StatelessWidget {
  final String text;
  const EntityAsonDateLabels({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Semantics(
          container: true,
          explicitChildNodes: true,
          child: Container(
              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_1.h, horizontal: Sizes.dimen_8.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Sizes.dimen_6),
                  border: Border.all(width: Sizes.dimen_1, color: AppColor.primary.withValues(alpha: 0.5))
              ),
              child: Text(text, style: Theme.of(context).textTheme.bodyLarge,)
          ),
        ),
        UIHelper.verticalSpace(Sizes.dimen_2.h),
      ],
    );
  }
}
