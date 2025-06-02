import 'dart:ui';

import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/data/models/preferences/app_theme.dart';
import 'package:asset_vantage/src/presentation/theme/theme_color.dart';
import 'package:asset_vantage/src/presentation/theme/theme_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';

import '../../config/constants/size_constants.dart';

class AppTheme {
  AppTheme._();

  static material.ThemeData getAppDarkTheme(
      {required material.BuildContext context,
      AppThemeModel? theme,
      bool isIpad = false}) {
    return material.ThemeData(
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      }),
      unselectedWidgetColor: AppColor.secondary,
      primaryColor: AppColor.primary,
      colorScheme: material.ColorScheme.fromSwatch().copyWith(
          secondary: AppColor.secondary,
          primary: AppColor.primary,
          brightness: material.Brightness.light),
      scaffoldBackgroundColor: theme?.scaffoldBackground != null
          ? Color(int.parse(theme!.scaffoldBackground!))
          : AppColor.vulcan,
      cardTheme: material.CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.dimen_10),
        ),
        color: theme?.card?.color != null
            ? Color(int.parse(theme!.card!.color!))
            : AppColor.white,
      ),
      datePickerTheme: material.DatePickerThemeData(
        yearStyle: material.Theme.of(context).textTheme.titleMedium,
        weekdayStyle: material.Theme.of(context).textTheme.titleSmall,
        dayStyle: material.Theme.of(context).textTheme.bodyMedium,
      ),
      visualDensity: material.VisualDensity.adaptivePlatformDensity,
      textTheme: isIpad
          ? ThemeText.getIPadTextTheme(theme?.textColor)
          : ThemeText.getTextTheme(theme?.textColor),
      bottomSheetTheme: material.BottomSheetThemeData(
          backgroundColor: theme?.bottomSheet?.color != null
              ? Color(int.parse(theme!.bottomSheet!.color!))
              : AppColor.onVulcan),
      drawerTheme: material.DrawerThemeData(
          backgroundColor: theme?.navigationDrawer?.color != null
              ? Color(int.parse(theme!.navigationDrawer!.color!))
              : AppColor.vulcan),
      popupMenuTheme: material.PopupMenuThemeData(
          color: theme?.popupMenu?.color != null
              ? Color(int.parse(theme!.popupMenu!.color!))
              : AppColor.onVulcan,
          elevation: 2),
      listTileTheme: const material.ListTileThemeData(
        iconColor: AppColor.primary,
      ),
      iconTheme: material.IconThemeData(
          color: theme?.appBar?.iconColor != null
              ? Color(int.parse(theme!.appBar!.iconColor!))
              : AppColor.primary),
      appBarTheme: material.AppBarTheme(
        elevation: 0,
        color: theme?.appBar?.color != null
            ? Color(int.parse(theme!.appBar!.color!))
            : AppColor.transparent,
        iconTheme: material.IconThemeData(
            color: theme?.appBar?.iconColor != null
                ? Color(int.parse(theme!.appBar!.iconColor!))
                : AppColor.white),
      ),
      textSelectionTheme: material.TextSelectionThemeData(
          cursorColor: theme?.filter?.iconColor != null
              ? Color(int.parse(theme!.filter!.iconColor!))
              : AppColor.primary,
          selectionHandleColor: theme?.filter?.iconColor != null
              ? Color(int.parse(theme!.filter!.iconColor!))
              : AppColor.primary,
          selectionColor: AppColor.grey.withOpacity(0.5)),
      cupertinoOverrideTheme: CupertinoThemeData(
          primaryColor: theme?.filter?.iconColor != null
              ? Color(int.parse(theme!.filter!.iconColor!))
              : AppColor.primary),
      inputDecorationTheme: material.InputDecorationTheme(
        errorMaxLines: 2,
        contentPadding: material.EdgeInsets.symmetric(
            vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_18.w),
        hintStyle: material.Theme.of(context).textTheme.greyCaption,
        prefixStyle: material.Theme.of(context).textTheme.greyCaption,
        errorStyle: material.Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: material.Colors.red, fontSize: Sizes.dimen_10.sp),
        labelStyle: material.Theme.of(context).textTheme.bodySmall,
        alignLabelWithHint: true,
        border: material.OutlineInputBorder(
          borderRadius: material.BorderRadius.circular(Sizes.dimen_6),
          borderSide: const material.BorderSide(
            color: AppColor.white,
          ),
        ),
        focusedBorder: material.InputBorder.none,
        focusedErrorBorder: material.InputBorder.none,
        errorBorder: material.InputBorder.none,
        enabledBorder: material.InputBorder.none,
        disabledBorder: material.InputBorder.none,
      ),
    );
  }
}
