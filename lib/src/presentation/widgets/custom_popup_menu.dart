import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/constants/size_constants.dart';
import '../../utilities/helper/ui_helper.dart';
import '../theme/theme_color.dart';

class CustomPopupMenu extends StatefulWidget {
  final Function(int) onSelect;
  final bool showCopy;
  final bool isLoading;
  final bool isNetWorth;
  const CustomPopupMenu({
    super.key,
    required this.onSelect,
    this.showCopy = true, this.isLoading=false,  this.isNetWorth=false,
  });

  @override
  State<CustomPopupMenu> createState() => _CustomPopupMenuState();
}

class _CustomPopupMenuState extends State<CustomPopupMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
        onOpened: () {
          HapticFeedback.heavyImpact();
          SystemSound.play(SystemSoundType.click);
        },
        itemBuilder: (context) => widget.showCopy ? [
          PopupMenuItem(
            key: const Key("copy"),
            value: 1,
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset("assets/svgs/copy_icon.svg", height: Sizes.dimen_7.h,),
                      UIHelper.horizontalSpaceSmall,
                      Expanded(
                        child: Text(
                          StringConstants.favCopy,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          PopupMenuItem(
            key: const Key("delete"),
            value: 2,
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset("assets/svgs/delete_icon.svg", height: Sizes.dimen_7.h,),
                      UIHelper.horizontalSpaceSmall,
                      Expanded(
                        child: Text(
                          StringConstants.favDelete,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                              fontWeight: FontWeight.bold),
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
        ] : [
          PopupMenuItem(
            key: const Key("delete"),
            value: 1,
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset("assets/svgs/delete_icon.svg", height: Sizes.dimen_7.h,),
                      UIHelper.horizontalSpaceSmall,
                      Expanded(
                        child: Text(
                          StringConstants.favDelete,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                              fontWeight: FontWeight.bold),
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
        onSelected: widget.onSelect,
        offset: const Offset(0, 30),
        child: Semantics(
          identifier: "FavThreeDotIcon",
          child: Material(
            child: Container(
              color: widget.isLoading ? AppColor.threeDotColor: null,
              padding: const EdgeInsets.only(left: Sizes.dimen_15,right: Sizes.dimen_7,bottom: Sizes.dimen_4,top: Sizes.dimen_4),
              child: Transform.translate(
                offset: widget.isNetWorth ? Offset(0, -5):Offset(0, -8),
                child: SvgPicture.asset(
                  'assets/svgs/menu_icon.svg',
                  color: AppColor.lightGrey,
                ),
              ),
            ),
          ),
        )
    );
  }
}
