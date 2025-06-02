import 'package:asset_vantage/src/config/constants/size_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../theme/theme_color.dart';

class PasswordInputField extends StatefulWidget {
  final Key? key;
  final bool? isPassword;
  final String inputHint;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final void Function(String)? onFinish;
  final String? Function(String? string) validator;

  const PasswordInputField({
    this.key,
    required this.inputHint,
    this.isPassword = false,
    required this.validator,
    required this.controller,
    required this.focusNode,
    required this.textInputAction,
    required this.textInputType,
    required this.onFinish,
  }) : super(key: key);

  @override
  _PasswordInputFieldState createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
        elevation: 6,
        child: TextFormField(
          key: widget.key,
          obscureText: widget.isPassword ?? false ? hidePassword : false,
          validator: widget.validator,
          controller: widget.controller,
          focusNode: widget.focusNode,
          textInputAction: widget.textInputAction,
          keyboardType: widget.textInputType,
          onFieldSubmitted: widget.onFinish,
          decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide.none,
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide.none,
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide.none,
              ),
              errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide.none,
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide.none,
              ),
              disabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide.none,
              ),
              hintText: widget.inputHint,
              suffixIcon: (widget.isPassword ?? false)
                  ? Padding(
                      padding: const EdgeInsets.all(Sizes.dimen_12),
                      child: GestureDetector(
                          onTap: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          child: hidePassword
                              ? SvgPicture.asset(
                                  'assets/svgs/eye_off.svg',
                                  color: AppColor.grey,
                                  width: Sizes.dimen_24,
                                )
                              : SvgPicture.asset('assets/svgs/eye_on.svg',
                                  color: AppColor.grey, width: Sizes.dimen_24)),
                    )
                  : null
              ),
        ),
      ),
    );
  }
}
