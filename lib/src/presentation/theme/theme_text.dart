import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:flutter/material.dart';

import '../../config/constants/size_constants.dart';
import 'theme_color.dart';

class ThemeText {
  const ThemeText._();

  static TextTheme get _effraTextTheme => ThemeData(fontFamily: 'Inter').textTheme;

  static TextStyle? get _displayLarge =>
      _effraTextTheme.displayLarge?.copyWith(
        fontSize: Sizes.dimen_72.sp,
        color: AppColor.lightGrey,
      );

  static TextStyle? get _displayMedium =>
      _effraTextTheme.displayMedium?.copyWith(
        fontSize: Sizes.dimen_60.sp,
        color: AppColor.lightGrey,
      );

  static TextStyle? get _displaySmall =>
      _effraTextTheme.displaySmall?.copyWith(
        fontSize: Sizes.dimen_48.sp,
        color: AppColor.lightGrey,
      );

  static TextStyle? get _headlineLarge =>
      _effraTextTheme.headlineLarge?.copyWith(
        fontSize: Sizes.dimen_34.sp,
        color: AppColor.lightGrey,
      );

  static TextStyle? get _headlineMedium =>
      _effraTextTheme.headlineMedium?.copyWith(
        fontSize: Sizes.dimen_22.sp,
        color: AppColor.lightGrey,
      );

  static TextStyle? get _headlineSmall =>
      _effraTextTheme.headlineSmall?.copyWith(
        fontSize: Sizes.dimen_19.sp,
        color: AppColor.lightGrey,
      );

  static TextStyle? get _titleLarge =>
      _effraTextTheme.titleLarge?.copyWith(
        fontSize: Sizes.dimen_16.sp,
        color: AppColor.lightGrey,
        wordSpacing: 0.25,
        letterSpacing: 0.25,
        height: 1.5,
      );

  static TextStyle? get _titleMedium =>
      _effraTextTheme.titleMedium?.copyWith(
        fontSize: Sizes.dimen_14.sp,
        color: AppColor.lightGrey,
        wordSpacing: 0.25,
        letterSpacing: 0.25,
        height: 1.5,
      );

  static TextStyle? get _titleSmall =>
      _effraTextTheme.titleSmall?.copyWith(
        fontSize: Sizes.dimen_14.sp,
        color: AppColor.lightGrey,
        wordSpacing: 0.25,
        letterSpacing: 0.25,
        height: 1.5,
      );

  static TextStyle? get _bodyLarge =>
      _effraTextTheme.bodyLarge?.copyWith(
        fontSize: Sizes.dimen_10.sp,
        color: AppColor.lightGrey,
        wordSpacing: 0.25,
        letterSpacing: 0.25,
        height: 1.5,
      );

  static TextStyle? get _bodyMedium =>
      _effraTextTheme.bodyMedium?.copyWith(
        fontSize: Sizes.dimen_9.sp,
        color: AppColor.lightGrey,
        wordSpacing: 0.25,
        letterSpacing: 0.25,
        height: 1.5,
      );

  static TextStyle? get _bodySmall =>
      _effraTextTheme.bodySmall?.copyWith(
        fontSize: Sizes.dimen_8.sp,
        color: AppColor.lightGrey,
        wordSpacing: 0.25,
        letterSpacing: 0.25,
        height: 1.5,
      );

  static TextStyle? get _labelLarge =>
      _effraTextTheme.labelLarge?.copyWith(
        fontSize: Sizes.dimen_7.sp,
        color: AppColor.lightGrey,
        wordSpacing: 0.25,
        letterSpacing: 0.25,
        height: 1.5,
      );

  static TextStyle? get _labelMedium =>
      _effraTextTheme.labelMedium?.copyWith(
        fontSize: Sizes.dimen_6.sp,
        color: AppColor.lightGrey,
        wordSpacing: 0.25,
        letterSpacing: 0.25,
        height: 1.5,
      );

  static TextStyle? get _labelSmall =>
      _effraTextTheme.labelSmall?.copyWith(
        fontSize: Sizes.dimen_4.sp,
        color: AppColor.lightGrey,
        wordSpacing: 0.25,
        letterSpacing: 0.25,
        height: 1.5,
      );

  static getTextTheme(String? color) => TextTheme(
        displayLarge: _displayLarge?.copyWith(color: (color?.isNotEmpty ?? false) ? Color(int.parse(color!)) : null),
        displayMedium: _displayMedium?.copyWith(color: (color?.isNotEmpty ?? false) ? Color(int.parse(color!)) : null),
        displaySmall: _displaySmall?.copyWith(color: (color?.isNotEmpty ?? false) ? Color(int.parse(color!)) : null),
        headlineLarge: _headlineLarge?.copyWith(color: (color?.isNotEmpty ?? false) ? Color(int.parse(color!)) : null),
        headlineMedium: _headlineMedium?.copyWith(color: (color?.isNotEmpty ?? false) ? Color(int.parse(color!)) : null),
        headlineSmall: _headlineSmall?.copyWith(color: (color?.isNotEmpty ?? false) ? Color(int.parse(color!)) : null),
        titleLarge: _titleLarge?.copyWith(color: (color?.isNotEmpty ?? false) ? Color(int.parse(color!)) : null),
        titleMedium: _titleMedium?.copyWith(color: (color?.isNotEmpty ?? false) ? Color(int.parse(color!)) : null),
        titleSmall: _titleSmall?.copyWith(color: (color?.isNotEmpty ?? false) ? Color(int.parse(color!)) : null),
        bodyLarge: _bodyLarge?.copyWith(color: (color?.isNotEmpty ?? false) ? Color(int.parse(color!)) : null),
        bodyMedium: _bodyMedium?.copyWith(color: (color?.isNotEmpty ?? false) ? Color(int.parse(color!)) : null),
        bodySmall: _bodySmall?.copyWith(color: (color?.isNotEmpty ?? false) ? Color(int.parse(color!)) : null),
        labelLarge: _labelLarge?.copyWith(color: (color?.isNotEmpty ?? false) ? Color(int.parse(color!)) : null),
        labelMedium: _labelMedium?.copyWith(color: (color?.isNotEmpty ?? false) ? Color(int.parse(color!)) : null),
        labelSmall: _labelSmall?.copyWith(color: (color?.isNotEmpty ?? false) ? Color(int.parse(color!)) : null),
      );

  static getIPadTextTheme(String? color) => TextTheme(
    displayLarge: _displayLarge?.copyWith(fontSize: Sizes.dimen_68.sp, color: (color?.isNotEmpty ?? false) ? Color(int.parse(color!)) : null),
    displayMedium: _displayMedium?.copyWith(fontSize: Sizes.dimen_56.sp, color: (color?.isNotEmpty ?? false) ? Color(int.parse(color!)) : null),
    displaySmall: _displaySmall?.copyWith(fontSize: Sizes.dimen_44.sp, color: (color?.isNotEmpty ?? false) ? Color(int.parse(color!)) : null),
    headlineLarge: _headlineLarge?.copyWith(fontSize: Sizes.dimen_32.sp, color: (color?.isNotEmpty ?? false) ? Color(int.parse(color!)) : null),
    headlineMedium: _headlineMedium?.copyWith(fontSize: Sizes.dimen_20.sp, color: (color?.isNotEmpty ?? false) ? Color(int.parse(color!)) : null),
    headlineSmall: _headlineSmall?.copyWith(fontSize: Sizes.dimen_17.sp, color: (color?.isNotEmpty ?? false) ? Color(int.parse(color!)) : null),
    titleLarge: _titleLarge?.copyWith(fontSize: Sizes.dimen_14.sp, color: (color?.isNotEmpty ?? false) ? Color(int.parse(color!)) : null),
    titleMedium: _titleMedium?.copyWith(fontSize: Sizes.dimen_12.sp, color: (color?.isNotEmpty ?? false) ? Color(int.parse(color!)) : null),
    titleSmall: _titleSmall?.copyWith(fontSize: Sizes.dimen_10.sp, color: (color?.isNotEmpty ?? false) ? Color(int.parse(color!)) : null),
    bodyLarge: _bodyLarge?.copyWith(fontSize: Sizes.dimen_9.sp, color: (color?.isNotEmpty ?? false) ? Color(int.parse(color!)) : null),
    bodyMedium: _bodyMedium?.copyWith(fontSize: Sizes.dimen_8.sp, color: (color?.isNotEmpty ?? false) ? Color(int.parse(color!)) : null),
    bodySmall: _bodySmall?.copyWith(fontSize: Sizes.dimen_6.sp, color: (color?.isNotEmpty ?? false) ? Color(int.parse(color!)) : null),
    labelLarge: _labelLarge?.copyWith(fontSize: Sizes.dimen_6.sp, color: (color?.isNotEmpty ?? false) ? Color(int.parse(color!)) : null),
    labelMedium: _labelMedium?.copyWith(fontSize: Sizes.dimen_6.sp, color: (color?.isNotEmpty ?? false) ? Color(int.parse(color!)) : null),
    labelSmall: _labelSmall?.copyWith(fontSize: Sizes.dimen_6.sp, color: (color?.isNotEmpty ?? false) ? Color(int.parse(color!)) : null),
  );
}

extension ThemeTextExtension on TextTheme {
  TextStyle? get greyCaption => titleMedium?.copyWith(color: AppColor.grey, fontSize: Sizes.dimen_14.sp);

  TextStyle? get buttonStyle => labelLarge?.copyWith(color: AppColor.vulcan, fontSize: Sizes.dimen_22.sp);
}
