import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/constants/size_constants.dart';

class CrossSign extends StatelessWidget {
  const CrossSign({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_4.w, vertical:  Sizes.dimen_2.h),
        child: SvgPicture.asset("assets/svgs/cross.svg", )
    );
  }
}

