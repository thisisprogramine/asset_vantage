import 'package:asset_vantage/src/config/constants/size_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../theme/theme_color.dart';
import '../../widgets/animated_tooltip.dart';

class LoginInputField extends StatefulWidget {
  final Key? key;
  final bool? isPassword;
  final bool? isUsername;
  final String inputHint;
  final String? stringKey;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final String? Function(String? string) validator;
  final ValueChanged<String>? onChanged;
  final void Function()? onTap;
  final TextStyle? hintStyle;
  final TextStyle? prefixStyle;
  final TextStyle? errorStyle;
  final TextStyle? labelStyle;
  final TextStyle? style;
  final String? identifier;


  const LoginInputField({
    this.key,
    required this.inputHint,
    this.isPassword = false,
    this.isUsername = false,
    required this.validator,
    required this.stringKey,
    this.onChanged,
    this.onTap,
    required this.controller,
    required this.focusNode,
    required this.textInputAction,
    this.hintStyle,
    this.prefixStyle,
    this.errorStyle,
    this.labelStyle,
    this.style, required this.identifier,
  }) : super(key: key);

  @override
  _LoginInputFieldState createState() => _LoginInputFieldState();
}

class _LoginInputFieldState extends State<LoginInputField> {
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              label: widget.stringKey,
              identifier: widget.identifier,
              child: SizedBox(
                height: Sizes.dimen_21.h,
                child: TextFormField(
                  key: widget.key,
                  obscureText: widget.isPassword ?? false ? hidePassword : false,
                  obscuringCharacter: '*',
                  validator: widget.validator,
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  textInputAction: widget.textInputAction,
                  onTap: widget.onTap,
                  style: widget.style ?? Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: Sizes.dimen_15.sp
                  ),
                  onChanged: widget.onChanged,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                      hintText: widget.inputHint,
                      hintStyle: widget.hintStyle,
                      prefixStyle: widget.prefixStyle,
                      errorStyle: widget.errorStyle,
                      labelStyle: widget.labelStyle,
                      contentPadding: EdgeInsets.only(left: Sizes.dimen_6.h,top: Sizes.dimen_4.h,bottom: Sizes.dimen_4.h)

                  ),
                ),
              ),
            ),
          ),
          if(widget.isPassword ?? false)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_14.w),
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                  child: hidePassword ? SvgPicture.asset('assets/svgs/eye_close_icon.svg', color: AppColor.textGrey.withValues(alpha: 0.9), width: Sizes.dimen_19.w,)    : SvgPicture.asset('assets/svgs/eye.svg', color: AppColor.textGrey.withValues(alpha: 0.9), width: Sizes.dimen_19.w)
              ),
            )
          else if(widget.isUsername ?? false)
            AnimatedTooltip(
              delay: const Duration(milliseconds: 5000),
              content: Text('Use the same username as you do for the web system. Please note, your username is case-sensitive!', style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: Sizes.dimen_14.sp ),),
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_14.w),
                  child: SvgPicture.asset('assets/svgs/info_icon.svg',height: Sizes.dimen_17.w, color: AppColor.textGrey.withValues(alpha: 0.9),)
              ),
            )
          else
            AnimatedTooltip(
              delay: const Duration(milliseconds: 5000),
              content: RichText(
                text: TextSpan(
                  text: 'If your URL is in the format ',
                  style: Theme.of(context).textTheme.titleSmall,
                  children: <TextSpan>[
                    TextSpan(text: '[yourdomain].assetvantage.com', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700,fontSize: Sizes.dimen_14.sp)),
                    TextSpan(text: ', your system name will be', style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: Sizes.dimen_14.sp
                    )),
                    TextSpan(text: ' [yourdomain].', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700,fontSize: Sizes.dimen_14.sp)),
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_14.w),
                child: SvgPicture.asset('assets/svgs/info_icon.svg',height: Sizes.dimen_17.w, color: AppColor.textGrey.withValues(alpha: 0.9),),
              ),
            )
        ],
      ),
    );
  }
}
