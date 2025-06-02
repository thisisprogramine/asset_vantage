import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/constants/size_constants.dart';
import '../theme/theme_color.dart';

class ApplyButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final bool isEnabled;

  const ApplyButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: Sizes.dimen_0.w,
        right: Sizes.dimen_0.w,
        bottom: Sizes.dimen_6.h
      ),

      //padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_0.w),
      child: ElevatedButton(
        key: const ValueKey('apply_button'),
        style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled ? AppColor.textGrey : AppColor.grey,
            elevation: 0.2,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.dimen_8),
          ),
        ),
        onPressed: isEnabled ? onPressed : null,
        child: Container(
            width: ScreenUtil().screenWidth,
            child: Center(
              child: Text(text.toUpperCase(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColor.white, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
        ),
      ),
    );
  }
}
