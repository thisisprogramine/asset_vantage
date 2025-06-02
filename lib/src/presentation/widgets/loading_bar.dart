
import 'package:asset_vantage/src/config/constants/size_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/theme/theme_color.dart';
import 'package:asset_vantage/src/utilities/helper/ui_helper.dart';
import 'package:flutter/material.dart';

class LoadingBar extends StatelessWidget {
  const LoadingBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/animations/loading_bar.gif',
          height: Sizes.dimen_32.h,
          color: AppColor.primary,
        ),
        UIHelper.horizontalSpaceSmall,
        Text('Loading...',
          style: Theme.of(context).textTheme.bodyMedium,
        )
      ],
    );
  }
}
