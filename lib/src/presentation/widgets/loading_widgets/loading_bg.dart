import 'package:asset_vantage/src/config/constants/size_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/theme/theme_color.dart';
import 'package:asset_vantage/src/utilities/helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum Message{loading, error, noPositionFound}
class LoadingBg extends StatelessWidget {
  final void Function()? onRetry;
  final double? height;
  final double? width;
  final Message? message;
  final Widget? menu;
  const LoadingBg({
    super.key,
    this.onRetry,
    this.height,
    this.width,
    this.message,
    this.menu,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(
        color: AppColor.faintGrey
      ),
      child: message != null ? Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(message == Message.loading)
                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: Sizes.dimen_54,
                              height: Sizes.dimen_54,
                              child: CircularProgressIndicator(
                                strokeCap: StrokeCap.round,
                                color: AppColor.grey.withValues(alpha: 0.4),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_12.w, vertical: Sizes.dimen_12.w),
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColor.white
                              ),
                              child: SvgPicture.asset(
                                width: Sizes.dimen_17,
                                height: Sizes.dimen_17,
                                "assets/svgs/personalise_bar.svg",
                                color: AppColor.grey.withValues(alpha: 0.2),
                              ),
                            )
                          ],
                        ),
                        UIHelper.verticalSpaceSmall,
                        Text("Syncing your data. Please wait.",
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      ],
                    ),

                  if(message == Message.error && onRetry != null)
                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_8.w, vertical: Sizes.dimen_8.w),
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColor.white
                              ),
                              child: SvgPicture.asset(
                                width: Sizes.dimen_32,
                                height: Sizes.dimen_32,
                                "assets/svgs/error_icon.svg",
                                color: AppColor.grey.withValues(alpha: 0.2),
                              ),
                            )
                          ],
                        ),
                        UIHelper.verticalSpaceSmall,
                        Text("Error fetching data. Check filters and retry.",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        UIHelper.verticalSpace(Sizes.dimen_2.h),
                        GestureDetector(
                          onTap: onRetry,
                          child: Text("Retry",
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                              fontSize: Sizes.dimen_13,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationThickness: 1.0,
                            ),
                          ),
                        )
                      ],
                    ),

                  if(message == Message.noPositionFound && onRetry != null)
                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_8.w, vertical: Sizes.dimen_8.w),
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColor.white
                              ),
                              child: SvgPicture.asset(
                                width: Sizes.dimen_32,
                                height: Sizes.dimen_32,
                                "assets/svgs/error_icon.svg",
                                color: AppColor.grey.withValues(alpha: 0.2),
                              ),
                            )
                          ],
                        ),
                        UIHelper.verticalSpaceSmall,
                        Text("No Position Found. Check filters and retry.",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        UIHelper.verticalSpace(Sizes.dimen_2.h),
                        GestureDetector(
                          onTap: onRetry,
                          child: Text("Retry",
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                              fontSize: Sizes.dimen_13,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationThickness: 1.0,
                            ),
                          ),
                        )
                      ],
                    ),
                ],)
            ],
          ),
          if(menu != null)
            Positioned(
                top: 10,
                right: 10,
                child: menu ?? const SizedBox.shrink()
            )
        ],
      ) : null
    );
  }
}
