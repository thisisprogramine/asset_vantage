
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/utilities/helper/ui_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../config/constants/size_constants.dart';

class NoInternetDialog extends StatefulWidget {
  const NoInternetDialog({super.key});

  @override
  State<NoInternetDialog> createState() => _NoInternetDialogState();
}

class _NoInternetDialogState extends State<NoInternetDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor.withOpacity(0.2)),
      child: Center(
        child:Card(
          margin: EdgeInsets.symmetric(horizontal: Sizes.dimen_32.w),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)
              )
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h,),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_8.h),
                  child: Image.asset("assets/pngs/no_internet.png",
                    height: Sizes.dimen_32.h,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text("No Internet",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                UIHelper.verticalSpaceSmall,
                Text("Please check if Wi-Fi or mobile data is enabled and connected.",
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                UIHelper.verticalSpaceSmall,
              ],
            ),
          ),
        )
      ),
    );
  }
}
