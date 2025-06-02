
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:flutter/material.dart';

import '../../../config/constants/size_constants.dart';
import '../../../config/constants/strings_constants.dart';

class BiometricOptions extends StatelessWidget {
  const BiometricOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: Sizes.dimen_16.h, horizontal: Sizes.dimen_8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/pngs/face_id.png', height: Sizes.dimen_16.h, color: Theme.of(context).scaffoldBackgroundColor),
              Text(StringConstants.faceId,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).scaffoldBackgroundColor),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: Sizes.dimen_8.h, horizontal: Sizes.dimen_8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/pngs/fingerprint.png', height: Sizes.dimen_16.h, color: Theme.of(context).scaffoldBackgroundColor),
              Text(StringConstants.touchId,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).scaffoldBackgroundColor),
              ),
            ],
          ),
        )
      ],
    );
  }
}
