

import 'dart:io';

import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/constants/size_constants.dart';
import '../blocs/app_theme/theme_cubit.dart';

class Logo extends StatelessWidget {
  final double height;
  final double? width;
  final bool isDark;
  final bool showBrandLogo;

  const Logo({
    Key? key,
    this.height = 20,
    this.width,
    this.isDark = false,
    this.showBrandLogo = true,
  })   : assert(height > 0, 'height should be greater than 0'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_24.w),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          width != null ?
        Image.asset('assets/pngs/av_pro.png',
          width: ScreenUtil().screenWidth * 0.5,
        )
              : Expanded(
            child: (context.read<AppThemeCubit>().state?.brandLogo != null && showBrandLogo)
                ? Image.file(
              File(
                  context.read<AppThemeCubit>().state?.brandLogo ?? ''),
              key: const ValueKey('logo_image_key'),
              errorBuilder: (context, error, stackTrace) => Image.asset(
                isDark ? 'assets/pngs/av_pro_dark.png' : 'assets/pngs/av_pro_light.png',
                key: const ValueKey('logo_image_key'),
              ),
            )
                : Image.asset('assets/pngs/av_pro.png',
              key: const ValueKey('logo_image_key'),
            ),
          ),
        ],
      ),
    );
  }
}
