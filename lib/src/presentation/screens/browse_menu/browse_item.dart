import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:flutter/material.dart';

import '../../../config/constants/size_constants.dart';
import '../../theme/theme_color.dart';

class BrowseItem extends StatelessWidget {
  final void Function() onPressed;
  final String title;
  const BrowseItem({super.key, required this.onPressed,required this.title,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_16.w, vertical: Sizes.dimen_8.h),
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
