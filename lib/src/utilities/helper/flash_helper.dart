import 'dart:developer';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:asset_vantage/src/config/app_config.dart';
import 'package:asset_vantage/src/config/constants/size_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/theme/theme_color.dart';
import 'package:asset_vantage/src/utilities/helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../presentation/widgets/toast_message.dart';

enum ToastType{warning, error, success, info}

class FlashHelper {

  static showToastMessage(BuildContext context, {required String message, required ToastType type, bool shouldDelay = true}) {

    showSimpleNotification(
      ToastMessage(
        message: message,
        type: type,
      ),
      background: Colors.transparent,
      duration: const Duration(seconds: 5),
      elevation: 0,
      contentPadding: EdgeInsets.zero,
    );
  }

  static showSnackBar({required String title, required String body, required ReportTile reportTile}) {
    if(currentTile == reportTile) {
      log("On Another Context");
    }else {
      Get.snackbar(title, body);
    }
  }
}