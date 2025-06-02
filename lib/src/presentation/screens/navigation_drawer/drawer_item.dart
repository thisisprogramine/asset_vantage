
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/constants/size_constants.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../blocs/app_theme/theme_cubit.dart';

class DrawerItem extends StatelessWidget {
  final String title;
  final String icon;
  final bool showComingSoon;
  final Function() onPressed;

  const DrawerItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.showComingSoon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_22.w, vertical: Sizes.dimen_2.h),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Text(title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColor.grey),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: Sizes.dimen_14.w, color: AppColor.grey,)
          ],
        ),
      ),
    );
  }
}
