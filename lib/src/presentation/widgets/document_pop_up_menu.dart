import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/constants/size_constants.dart';
import '../../config/constants/strings_constants.dart';
import '../../utilities/helper/ui_helper.dart';
import '../theme/theme_color.dart';

class DocumentPopUpMenu extends StatelessWidget {
  void Function()? onTapView;
  void Function()? onTapShare;
  void Function()? onTapDownload;
   DocumentPopUpMenu({super.key,
     required this.onTapView,
   required this.onTapShare,
     required this.onTapDownload});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
        padding: EdgeInsets.zero,
        constraints: BoxConstraints.tightFor(width: Sizes.dimen_130.w),
        onOpened: () {
          HapticFeedback.heavyImpact();
          SystemSound.play(SystemSoundType.click);
        },
        itemBuilder: (context)=> [
          PopupMenuItem(
            key: const Key("view"),
            value: 1,
            onTap: onTapView,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset("assets/svgs/eye.svg", height: Sizes.dimen_7.h,),
                UIHelper.horizontalSpaceSmall,
                Expanded(
                  child: Text(
                    StringConstants.documentView,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ),
          PopupMenuItem(
            height: 1,
            enabled: false,
            padding: EdgeInsets.zero,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 9.0),
              child: Divider(
                height: 1,
                thickness: 0.5,
                color: Colors.grey.withValues(alpha: 0.4),
              ),
            ),
          ),
          PopupMenuItem(
              key: const Key("share"),
              value: 2,
              onTap:onTapShare,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset("assets/svgs/share_icon.svg", height: Sizes.dimen_7.h,),
                  UIHelper.horizontalSpaceSmall,
                  Expanded(
                    child: Text(
                      StringConstants.documentShare,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
          ),
          PopupMenuItem(
            height: 1,
            enabled: false,
            padding: EdgeInsets.zero,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 9.0),
              child: Divider(
                height: 1,
                thickness: 0.5,
                color: Colors.grey.withValues(alpha: 0.4),
              ),
            ),
          ),
          PopupMenuItem(
            key: const Key("download"),
            value: 3,
            onTap: onTapDownload,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset("assets/svgs/download_icon.svg", height: Sizes.dimen_7.h,),
                UIHelper.horizontalSpaceSmall,
                Expanded(
                  child: Text(
                    StringConstants.documentDownload,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ),
        ],
        offset: const Offset(20, 40),
        child: SvgPicture.asset('assets/svgs/more_vertical.svg', width: Sizes.dimen_24.w, color: AppColor.lightGrey,));
  }
}
