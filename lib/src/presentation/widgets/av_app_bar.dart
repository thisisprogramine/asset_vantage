//

import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/blocs/stealth/stealth_cubit.dart';
import 'package:asset_vantage/src/presentation/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';

import '../../config/constants/size_constants.dart';
import '../../injector.dart';
import '../../services/biomatric_service.dart';
import '../blocs/app_theme/theme_cubit.dart';

class AVAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool useLogo;
  final bool elevation;
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;

  const AVAppBar({
    super.key,
    this.useLogo = false,
    this.elevation = false,
    this.title,
    this.leading,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<AVAppBar> createState() => _AVAppBarState();
}

class _AVAppBarState extends State<AVAppBar> {
  late BiometricService biometricService;

  @override
  void initState() {
    biometricService = getItInstance<BiometricService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColor.scaffoldBackground,
      scrolledUnderElevation: 0,
      centerTitle: false,
      title: widget.title != null
          ? Transform.translate(
              offset: const Offset(-18, 0),
              child: Text(
                "${widget.title}",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ))
          : Transform.translate(
              offset: const Offset(-12, 0),
              child: Image.asset(
                "assets/pngs/av_pro.png",
                height: kToolbarHeight - Sizes.dimen_12.h,
                errorBuilder: (context, error, stackTrace) => Text(
                  widget.title ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
      leading: widget.leading ??
          IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Semantics(
                identifier: "menuBar",
                  child: SvgPicture.asset("assets/svgs/menu.svg"))),
      actions: [
        BlocBuilder<StealthCubit, bool>(builder: (ctx, stealthValue) {
          return TextButton(
            onPressed: () async {
              if(!stealthValue){
                context.read<StealthCubit>().show();
              }else{
                if(await biometricService.checkBiometrics()){
                  if(await biometricService.authenticate()){
                    context.read<StealthCubit>().hide();
                  }
                }
              }
              setState(() {});
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_16.w),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: Size.zero,
              overlayColor: Colors.transparent
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: Sizes.dimen_64,
                  height: Sizes.dimen_12.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: Sizes.dimen_6.h,
                        width: Sizes.dimen_30,
                        decoration: BoxDecoration(
                          color: stealthValue ? AppColor.primary : AppColor.grey.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(Sizes.dimen_12),
                        ),
                      ),
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 600),
                        left: !stealthValue ? 0 : null,
                        right: stealthValue ? 0 : null,
                        child: Container(
                            height: Sizes.dimen_28.h,
                            width: Sizes.dimen_28.w,
                            child: Card(
                              elevation: 1,
                              margin: EdgeInsets.symmetric(horizontal: Sizes.dimen_2, vertical: Sizes.dimen_2),
                              shape: const CircleBorder(),
                              child: Semantics(
                                identifier: "stealthText",
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Sizes.dimen_6.w),
                                  child: SvgPicture.asset(
                                    stealthValue
                                        ? "assets/svgs/stealth_icon_on.svg"
                                        : "assets/svgs/stealth_icon_off.svg",
                                    color: stealthValue ? AppColor.primary : null,
                                  ),
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
                SizedBox(height: Sizes.dimen_1.h),
                Text(
                  StringConstants.stealth,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
