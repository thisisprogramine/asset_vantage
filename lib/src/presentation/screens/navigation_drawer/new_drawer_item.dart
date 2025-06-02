import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/theme/theme_color.dart';
import 'package:asset_vantage/src/utilities/helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../config/constants/size_constants.dart';

class NewDrawerItem extends StatelessWidget {
  final String icon_img;
  final String title;
  final Function() onPressed;
  const NewDrawerItem({super.key,
    required this.icon_img,
    required this.title,
    required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.dimen_21),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.dimen_24,vertical: Sizes.dimen_2),
          child: Row(
           mainAxisSize: MainAxisSize.max,
            children: [
             SvgPicture.asset(icon_img,width: Sizes.dimen_24.w,color: AppColor.textGrey,),
              SizedBox(width: Sizes.dimen_12.w,),
              Expanded(child: Text(title,style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700,),))
            ],
          ),
        ),
      ),
    );
  }
}
