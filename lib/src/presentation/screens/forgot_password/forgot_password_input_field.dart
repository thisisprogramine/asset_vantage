import 'package:asset_vantage/src/config/constants/size_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:flutter/material.dart';


class ForgotPasswordInputField extends StatefulWidget {
  final Key? key;
  final bool? isPassword;
  final String inputHint;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final String? Function(String? string) validator;

  const ForgotPasswordInputField({
    this.key,
    required this.inputHint,
    this.isPassword = false,
    required this.validator,
    required this.controller,
    required this.focusNode,
    required this.textInputAction,

  }) : super(key: key);

  @override
  _ForgotPasswordInputFieldState createState() => _ForgotPasswordInputFieldState();
}

class _ForgotPasswordInputFieldState extends State<ForgotPasswordInputField> {
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
          ),
        ),
      ),
    );
  }
}
