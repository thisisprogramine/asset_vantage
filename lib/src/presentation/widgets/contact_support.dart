import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/blocs/app_theme/theme_cubit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/constants/size_constants.dart';
import '../../config/constants/strings_constants.dart';
import '../../utilities/helper/flash_helper.dart';
import '../theme/theme_color.dart';


class SupportDialog extends StatefulWidget {
  final String? title;
  final String description;
  final bool showContactMail;
  final void Function()? onClicked;
  const SupportDialog({
    super.key,
    this.title,
    required this.description,
    this.showContactMail = true,
    required this.onClicked,
  });

  @override
  State<SupportDialog> createState() => _SupportDialogState();
}

class _SupportDialogState extends State<SupportDialog> {
  Future<void> launchEmail() async {
    const uri = 'mailto:support@assetvantage.com';
    if (await (canLaunchUrl(Uri.parse(uri)))) {
      await launchUrl(Uri.parse(uri));
    } else {
      FlashHelper.showToastMessage(context,
          message: StringConstants.failedToOpenLink, type: ToastType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: context.read<AppThemeCubit>().state?.card?.color != null
          ? Color(int.parse(context.read<AppThemeCubit>().state!.card!.color!))
          : AppColor.onVulcan,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.dimen_12.w)),
      title: Text(
        widget.title ?? '',
        textAlign: TextAlign.center,
      ),
      contentPadding: EdgeInsets.symmetric(
          vertical: Sizes.dimen_0.h, horizontal: Sizes.dimen_14.w),
      titlePadding: EdgeInsets.symmetric(
          vertical: Sizes.dimen_6.h, horizontal: Sizes.dimen_4.w),
      titleTextStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
      children: [
        SizedBox(
            height: ScreenUtil().screenHeight * 0.1,
            width: ScreenUtil().screenWidth * 0.6,
            child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                    style: Theme.of(context).textTheme.titleSmall,
                    children: [
                      TextSpan(
                          text:
                          widget.description),
                      TextSpan(
                          text: widget.showContactMail ? ' support@assetvantage.com' : '',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              widget.showContactMail ? launchEmail() : null;
                            },
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                              color: Colors.blue)),
                    ]))),
        Align(
          alignment: Alignment.bottomRight,
          child: TextButton(
            onPressed: widget.onClicked,
            child: Text(
              'OK',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }
}