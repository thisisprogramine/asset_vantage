import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:flutter/material.dart';
import '../../config/constants/size_constants.dart';
import '../theme/theme_color.dart';

class NavigationArrow extends StatelessWidget {
  final bool isFav;
  const NavigationArrow({super.key,this.isFav=false});

  @override
  Widget build(BuildContext context) {
    if(isFav){
      return Transform.translate(
        offset: Offset(0, -8),
        child: Semantics(
          identifier: "favNavigationArrow",
          child: Icon(Icons
              .arrow_forward,
            size: Sizes.dimen_26
                .w,
            color: AppColor.lightGrey,),
        ),
      );
    }

    return Semantics(
      identifier: "navigationArrow",
      child: Icon(Icons
          .arrow_forward,
        size: Sizes.dimen_24
            .w,
        color: AppColor.lightGrey,),
    );
  }
}
