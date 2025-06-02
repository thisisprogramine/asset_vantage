import 'dart:io';

import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/arguments/user_profile_argument.dart';
import 'package:asset_vantage/src/presentation/screens/navigation_drawer/NavigationDrawer.dart';
import 'package:asset_vantage/src/presentation/screens/user_profile/profile_widget.dart';
import 'package:asset_vantage/src/presentation/widgets/av_app_bar.dart';
import 'package:asset_vantage/src/utilities/helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/constants/route_constants.dart';
import '../../../config/constants/size_constants.dart';
import '../../blocs/app_theme/theme_cubit.dart';
import '../../theme/theme_color.dart';
import 'PreferenceList.dart';

class UserProfileScreen extends StatefulWidget {
  UserProfileArgument argument;
  UserProfileScreen({Key? key, required this.argument}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late String _profilePic;

  String buildProfilePic() {
    final Color? color =
        context.read<AppThemeCubit>().state?.dashboard?.iconColor != null
            ? Color(int.parse(
                context.read<AppThemeCubit>().state!.dashboard!.iconColor!))
            : Theme.of(context).iconTheme.color;
    final Color bodyColor = context
                .read<AppThemeCubit>()
                .state
                ?.scaffoldBackground !=
            null
        ? Color(
            int.parse(context.read<AppThemeCubit>().state!.scaffoldBackground!))
        : Theme.of(context).scaffoldBackgroundColor;
    final String colorHex = "#${color?.value.toRadixString(16).substring(2)}";
    final String bodyColorHex =
        "#${bodyColor.value.toRadixString(16).substring(2)}";
    final String rawSvg =
        """<svg width="154" height="154" viewBox="0 0 154 154" fill="none" xmlns="http://www.w3.org/2000/svg">
                             <circle cx="77" cy="77" r="77" fill="$colorHex"/>
                             <ellipse cx="77" cy="76.9589" rx="65" ry="65.9125" stroke="$bodyColorHex" stroke-width="9.11215"/>
                             <ellipse cx="76.8481" cy="61.7128" rx="25.3621" ry="25.7182" fill="$bodyColorHex"/>
                             <path d="M108.741 137.635C108.741 129 129.616 128.057 126.357 120.079C123.099 112.101 128.724 120.498 122.703 114.391C116.681 108.285 109.532 103.441 101.664 100.137C93.7966 96.8319 85.364 95.131 76.8481 95.131C68.3321 95.131 59.8995 96.8319 52.0318 100.137C44.164 103.441 37.0152 108.285 30.9935 114.391C24.9718 120.498 26.8009 107.943 23.542 115.921C20.2831 123.899 25.8201 113.908 25.8201 122.543L68.1916 142.871L108.741 137.635Z" fill="$bodyColorHex"/>
                             </svg>
""";
    return rawSvg;
  }

  @override
  Widget build(BuildContext context) {
    _profilePic = buildProfilePic();
    return Scaffold(
      drawer: const AVNavigationDrawer(),
      drawerEnableOpenDragGesture: false,
      body: LayoutBuilder(builder: (context, constraints) {
        return OrientationBuilder(builder: (context, orientation) {
          return Column(
            children: [
              AVAppBar(),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Sizes.dimen_4.h,
                  horizontal: Sizes.dimen_12.w,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    crossAxisAlignment: Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.arrow_back_ios_rounded,
                        size: Sizes.dimen_24.w,
                        color: AppColor.lightGrey,
                      ),
                      UIHelper.horizontalSpaceSmall,
                      Text(
                        'Profile',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              ProfileWidget(profile: _profilePic),
              Expanded(child: PreferenceList(() => setState(() {})))
            ],
          );
        });
      }),
    );
  }
}
