
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/constants/size_constants.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../theme/theme_color.dart';

class PreferenceListItem extends StatelessWidget {
  final String title;
  final String? icon;
  final bool isTitleSelectable;
  final Widget? action;
  final Function() onPressed;

  const PreferenceListItem({
    Key? key,
    required this.title,
    this.icon,
    this.isTitleSelectable = false,
    this.action,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_24.w, vertical: action != null ? Sizes.dimen_5.h : Sizes.dimen_7.h),
        child: Row(
          children: [
            if(icon != null)
              SvgPicture.asset(icon ?? '', color: AppColor.primary, width: Sizes.dimen_24.w,),
            if(icon != null)
              UIHelper.horizontalSpace(Sizes.dimen_22.w),
            Text(title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: isTitleSelectable ? FontWeight.bold : FontWeight.normal, color: isTitleSelectable ? Theme.of(context).primaryColor : AppColor.grey),
            ),

          if(action != null)
            Expanded(child: Container()),
          if(action != null)
            action ?? const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
