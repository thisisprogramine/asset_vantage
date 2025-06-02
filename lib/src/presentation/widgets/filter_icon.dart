import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/constants/size_constants.dart';
import '../theme/theme_color.dart';

class FilterIcon extends StatelessWidget {
  final bool isSummary;
  final bool isNetworthFav;
  const FilterIcon({super.key, this.isSummary=false,this.isNetworthFav=false});

  static Widget getFilterIcon(){
    return Semantics(
      identifier: "FilterIcon",
      child: SvgPicture.asset(
        "assets/svgs/universal_filter_icon.svg",
        height: Sizes.dimen_18.sp,
      ),
    );
  }

  static Widget getFilterIconForBlankWidget(){
    return SvgPicture.asset("assets/svgs/universal_filter_icon.svg", color: AppColor.white,);
  }

  @override
  Widget build(BuildContext context) {
    if(isSummary){
      return Transform.translate(
        offset:Offset(0,-8),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Semantics(
            identifier: "AllFavFilterIcon",
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2_5.h, horizontal: Sizes.dimen_5.w),
              child: SvgPicture.asset(
                "assets/svgs/universal_filter_icon.svg",
                height: Sizes.dimen_18.sp,
              ),
            ),
          ),
        ),
      );
    }
    else if(isNetworthFav){
      print("isNetworthFavtrue");
      return Transform.translate(
        offset:Offset(0,-10),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Semantics(
            identifier: "netWorthFavFilterIcon",
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_5.w,vertical: Sizes.dimen_4.h),
              child: SvgPicture.asset(
                "assets/svgs/universal_filter_icon.svg",
                height: Sizes.dimen_19.sp,
              ),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Semantics(
        identifier: "carousalFilterIcon",
        child: Container(
          padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2_5.h, horizontal: Sizes.dimen_5.w),
          child: SvgPicture.asset(
            "assets/svgs/universal_filter_icon.svg",
            height: Sizes.dimen_18.sp,
          ),
        ),
      ),
    );
  }
}
