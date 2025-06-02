import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/constants/size_constants.dart';

class BlueDotIcon extends StatelessWidget {
  const BlueDotIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      top: 0,
      child: SvgPicture.asset(
        "assets/svgs/blue_dot.svg",
        height: Sizes.dimen_6.sp,
      ),
    );
  }
}
