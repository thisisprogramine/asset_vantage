
import 'package:asset_vantage/src/config/constants/size_constants.dart';
import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/theme/theme_color.dart';
import 'package:flutter/material.dart';

class LoginLabel extends StatelessWidget {
  final bool isIpad;
  const LoginLabel({
    Key? key,
    required this.isIpad
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Sizes.dimen_8.h, horizontal: Sizes.dimen_0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(StringConstants.login.toUpperCase(),
            style: isIpad ? Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold) : Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(StringConstants.pleaseSignIn,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColor.grey),
          ),
        ],
      ),
    );
  }
}
