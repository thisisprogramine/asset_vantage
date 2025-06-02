import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/constants/size_constants.dart';

class DrillDownBackArrow extends StatelessWidget {
  final void Function()? onTap;
  const DrillDownBackArrow({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onTap,
        icon: Semantics(
          identifier: "DrillDownBackIcon",
            child: SvgPicture.asset("assets/svgs/arrow_back.svg", width: Sizes.dimen_22,))
    );
  }
}
