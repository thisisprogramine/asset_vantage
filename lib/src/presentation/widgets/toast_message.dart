import 'package:asset_vantage/src/config/constants/size_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/theme/theme_color.dart';
import 'package:asset_vantage/src/utilities/helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../utilities/helper/flash_helper.dart';

class ToastMessage extends StatefulWidget {
  final String message;
  final ToastType type;

  const ToastMessage({
    Key? key,
    required this.message,
    required this.type,
  }) : super(key: key);

  @override
  State<ToastMessage> createState() => _ToastMessageState();
}


class _ToastMessageState extends State<ToastMessage> {
  double _opacity = 0.0;
  
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => _opacity = 1.0);
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) setState(() => _opacity = 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 500),
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.none,
        onDismissed: (_) {
          OverlaySupportEntry.of(context)?.dismiss();
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: Sizes.dimen_16.w, vertical: Sizes.dimen_8.h),
          padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_12.w, vertical: Sizes.dimen_3.h),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: _getBorderColor(widget.type), width: Sizes.dimen_1),
            borderRadius: BorderRadius.circular(Sizes.dimen_8),
            boxShadow: [
              BoxShadow(
                color: _getBorderColor(widget.type).withValues(alpha: 0.2),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              SvgPicture.asset(_getIcon(widget.type), width: Sizes.dimen_20.w,),
              UIHelper.horizontalSpaceSmall,
              Expanded(
                child: Semantics(
                  identifier: "toastMsg",
                  container: true,
                  explicitChildNodes: true,
                  child: Text(
                    widget.message,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _opacity = 0.0;
                  });
                  Future.delayed(const Duration(seconds: 1), () {
                    OverlaySupportEntry.of(context)?.dismiss();
                  });
                },
                child: SvgPicture.asset("assets/svgs/cross.svg", width: Sizes.dimen_24.w,),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBorderColor(ToastType type) {
    if(type == ToastType.info) {
      return AppColor.primary;
    }else if(type == ToastType.success) {
      return AppColor.green;
    }else if(type == ToastType.error) {
      return AppColor.red;
    }else if(type == ToastType.warning) {
      return AppColor.orange;
    }
    return AppColor.primary;
  }

  String _getIcon(ToastType type) {
    if(type == ToastType.info) {
      return "assets/svgs/toast_info.svg";
    }else if(type == ToastType.success) {
      return "assets/svgs/toast_success.svg";
    }else if(type == ToastType.error) {
      return "assets/svgs/toast_error.svg";
    }else if(type == ToastType.warning) {
      return "assets/svgs/toast_warning.svg";
    }
    return "assets/svgs/toast_info.svg";
  }
}