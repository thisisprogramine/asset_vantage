import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/constants/size_constants.dart';
import '../../utilities/helper/ui_helper.dart';
import 'crossSign.dart';

class FilterNameWithCross extends StatelessWidget {
  final String text;
  final bool isSubHeader;
  final VoidCallback? onDone;

  const FilterNameWithCross({super.key,
    required this.text,
    this.isSubHeader=false,
    this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    if(isSubHeader){
      return Row(
        children: [
          GestureDetector(
            onTap: onDone,
            child: Semantics(
              identifier: "backButton",
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_6.w),
                  child: SvgPicture.asset("assets/svgs/filter_back_arrow.svg", )
              ),
            ),
          ),
          UIHelper.horizontalSpaceSmall,
          Expanded(child: Text(text, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),)),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Semantics(
              identifier: "subFilterCrossIcon",
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_4.w, vertical:  Sizes.dimen_2.h),
                  child: SvgPicture.asset("assets/svgs/cross.svg", )
              ),
            )
          )
        ],
      );
    }
    return Row(
      children: [
        Expanded(child: Text(text, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),)),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            HapticFeedback.heavyImpact();
            SystemSound.play(SystemSoundType.click);
            Navigator.of(context).pop();
          },
          child: Semantics(
            container: true,
            explicitChildNodes: true,
            identifier: "CrossIcon",
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_4.w, vertical:  Sizes.dimen_2.h),
                child: SvgPicture.asset("assets/svgs/cross.svg", )
            ),
          )
        )
      ],
    );
  }
}
