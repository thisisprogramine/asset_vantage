import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/constants/size_constants.dart';

class DeleteFavoriteDialog extends StatelessWidget {
  final void Function()? onCancel;
  final void Function()? onDelete;
  DeleteFavoriteDialog({super.key,
  required this.onCancel,
  required this.onDelete});

  static Future<void> show({
    required BuildContext context,
    void Function()? onCancel,
    void Function()? onDelete,
  })async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => DeleteFavoriteDialog(
        onCancel: onCancel,
        onDelete: onDelete,),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.dimen_8.r)),

      insetPadding: EdgeInsets.symmetric(
          horizontal: (ScreenUtil().screenWidth * 0.15).w),

      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: Sizes.dimen_6.h,
            horizontal: Sizes.dimen_12.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                StringConstants.favBlankWidgetPopup,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onCancel,
                  child: Text(
                    StringConstants.favCancel,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                        color:
                        Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: onDelete,
                  child: Text(
                    StringConstants.favPopUpDelete,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                        color:
                        Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

