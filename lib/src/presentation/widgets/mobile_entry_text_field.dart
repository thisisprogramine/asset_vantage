import 'dart:io';

import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../config/constants/size_constants.dart';
import '../theme/theme_color.dart';


class MobileEntryField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? image;
  final String? initialValue;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int? maxLines;
  final String? hint;
  final IconData? suffixIcon;
  final Function? onTap;
  final Function? onChanged;
  final TextCapitalization? textCapitalization;
  final Function? onSuffixPressed;
  final Function? onSubmitted;
  final bool showCountryCode;
  final bool obscureText;
  final bool showWithoutSpace;
  final String? text;
  final String? counterText;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Color? suffixIconColor;
  final Color barColor;
  final bool validator;
  final String? errorText;
  final EdgeInsets? contentPadding;
  final Color textColor;
  final Widget? counterWidget;
  final List<FilteringTextInputFormatter>? inputFormatters;

  MobileEntryField({
    this.controller,
    this.label,
    this.image,
    this.initialValue,
    this.readOnly,
    this.keyboardType,
    this.maxLength,
    this.hint,
    this.suffixIcon,
    this.maxLines,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.text,
    this.textCapitalization,
    this.onSuffixPressed,
    this.showCountryCode = false,
    this.obscureText = false,
    this.showWithoutSpace = false,
    this.focusNode,
    this.textInputAction,
    this.suffixIconColor,
    this.validator = false,
    this.barColor = Colors.black,
    this.textColor = Colors.black,
    this.errorText,
    this.counterText,
    this.contentPadding,
    this.counterWidget,
    this.inputFormatters
  });

  @override
  _MobileEntryFieldState createState() => _MobileEntryFieldState();
}

class _MobileEntryFieldState extends State<MobileEntryField> {
  Color get suffixIconColor => widget.suffixIconColor ?? AppColor.secondary;
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Card(
        elevation: 6,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_10.w),
                child: Image.asset("assets/pngs/indian_flag.png",
                  width: Sizes.dimen_24.sp)
            ),
            Text(
              "+91",
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(
              width: Sizes.dimen_6.w,
            ),
            Expanded(
              child: TextFormField(
                style: Theme.of(context).textTheme.bodyLarge,
                inputFormatters: widget.inputFormatters,
                focusNode: widget.focusNode,
                textCapitalization:
                widget.textCapitalization ?? TextCapitalization.sentences,
                cursorColor: Theme.of(context).indicatorColor,
                autofocus: false,
                onTap: widget.onTap as void Function()? ?? null,
                onFieldSubmitted: widget.onSubmitted as void Function(String)? ?? null,
                textInputAction: widget.textInputAction ?? TextInputAction.done,
                controller: widget.controller,
                onChanged: widget.onChanged as void Function(String)?,
                readOnly: widget.readOnly ?? false,
                keyboardType: Platform.isIOS ? TextInputType.text : widget.keyboardType,
                minLines: 1,
                initialValue: widget.initialValue,
                maxLength: widget.maxLength,
                maxLines: widget.maxLines ?? 1,
                obscureText: widget.obscureText,
                enableInteractiveSelection: true,
                decoration: InputDecoration(
                  prefixText: widget.showCountryCode ? '+91 ' : '',
                  counter: widget.counterWidget,
                  errorText: widget.validator
                      ? widget.errorText != null && widget.errorText!.isNotEmpty
                      ? widget.errorText
                      : "Please provide a value"
                      : null,
                  labelText: widget.label != null ? widget.label : null,
                  counterText: widget.counterText,
                  contentPadding: widget.contentPadding,
                  labelStyle: Theme.of(context).textTheme.bodyLarge,
                  alignLabelWithHint: true,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  suffixIcon: widget.onSuffixPressed != null ? IconButton(
                    icon: Icon(
                      widget.suffixIcon,
                      size: Sizes.dimen_24.sp,
                      color: suffixIconColor,
                    ),
                    onPressed: widget.onSuffixPressed != null
                        ? widget.onSuffixPressed!()
                        : null,
                  ) : null,
                  hintText: widget.hint,
                  prefixStyle: TextStyle(
                    color: widget.textColor,
                    fontSize: Sizes.dimen_16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
