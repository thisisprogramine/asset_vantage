// import 'package:asset_vantage/src/config/extensions/size_extensions.dart';

import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/theme/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/constants/size_constants.dart';
import '../blocs/app_theme/theme_cubit.dart';
import '../theme/theme_color.dart';

class Button extends StatelessWidget {
  final bool isIpad;
  final String text;
  final Function() onPressed;
  final bool isEnabled;

  const Button({
    Key? key,
    required this.isIpad,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: const ValueKey('main_button'),
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled ? AppColor.textGrey : AppColor.grey.withValues(alpha: 0.0),
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: onPressed,
      child: Container(
          width: ScreenUtil().screenWidth,
          padding: EdgeInsets.only(top: Sizes.dimen_4.h, bottom: Sizes.dimen_5.h,left: Sizes.dimen_1.h,right: Sizes.dimen_8.h),
          alignment: Alignment.center,
          child: Center(
            child: Text(text,
              style: Theme.of(context).textTheme.buttonStyle?.copyWith(
                fontWeight: FontWeight.bold,              fontSize: isIpad ? Sizes.dimen_16.sp : Sizes.dimen_16.sp,              color: Theme.of(context).scaffoldBackgroundColor,          ),        textAlign: TextAlign.center,      ),    ))
    );
  }
}
