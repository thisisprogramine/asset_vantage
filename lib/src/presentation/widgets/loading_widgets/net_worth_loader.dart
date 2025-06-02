import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/constants/size_constants.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../theme/theme_color.dart';
import 'loading_bg.dart';

class NetWorthLoader extends StatelessWidget {
  final bool isFavorite;
  final bool isError;
  final bool noPositionFound;
  final void Function()? onRetry;
  final Widget? menu;
  const NetWorthLoader({
    super.key,
    this.isFavorite = false,
    this.noPositionFound = false,
    this.isError = false,
    this.onRetry,
    this.menu,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_14.w,),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Container(
                decoration: !isFavorite ? BoxDecoration(
                  border: Border(
                      top: BorderSide(
                        color: AppColor.textGrey.withValues(alpha: 0.2),
                        width: 0.6,
                      )),
                ):null ,
                padding: EdgeInsets.only(
                  top: Sizes.dimen_4.h,
                  bottom: Sizes.dimen_1.h,
                ),
              ))
            ],
          ),
          if(!isFavorite)
            Expanded(
                child: LoadingBg(
                  message: (isError && noPositionFound) ? Message.noPositionFound : isError ? Message.error : Message.loading,
                  onRetry: onRetry,
                )
            )
          else
            LoadingBg(
              height: isFavorite ? ScreenUtil().screenHeight * 0.30 : ScreenUtil().screenHeight * 0.20,
              message: (isError && noPositionFound) ? Message.noPositionFound : isError ? Message.error : Message.loading,
              onRetry: onRetry,
              menu: menu,
            ),

          UIHelper.verticalSpaceSmall,
          Column(
            children: [
              SizedBox(
                height: Sizes.dimen_16.h,
                child: Row(
                  children: [
                    Expanded(child: LoadingBg()),
                    UIHelper.horizontalSpaceMedium,
                    Expanded(child: LoadingBg()),
                    UIHelper.horizontalSpaceMedium,
                    Expanded(child: LoadingBg()),
                  ],
                ),
              ),
              UIHelper.verticalSpaceSmall,
              SizedBox(
                height: Sizes.dimen_16.h,
                child: Row(
                  children: [
                    Expanded(child: LoadingBg()),
                    UIHelper.horizontalSpaceMedium,
                    Expanded(child: LoadingBg()),
                    UIHelper.horizontalSpaceMedium,
                    Expanded(child: LoadingBg()),
                  ],
                ),
              ),
              UIHelper.verticalSpaceSmall,
            ],
          ),
        ],
      ),
    );
  }
}
