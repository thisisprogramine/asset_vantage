

import 'dart:io';
import 'dart:ui';

import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/domain/entities/authentication/user_entity.dart';
import 'package:asset_vantage/src/presentation/arguments/document_argument.dart';
import 'package:asset_vantage/src/presentation/blocs/authentication/user/user_cubit.dart';
import 'package:asset_vantage/src/presentation/theme/theme_color.dart';
import 'package:asset_vantage/src/presentation/widgets/button.dart';
import 'package:asset_vantage/src/utilities/helper/ui_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../config/app_config.dart';
import '../../../config/constants/route_constants.dart';
import '../../../config/constants/size_constants.dart';
import '../../../data/models/preferences/user_preference.dart';
import '../../../domain/params/no_params.dart';
import '../../../domain/usecases/preferences/get_user_preference.dart';
import '../../../domain/usecases/preferences/save_user_preference.dart';
import '../../../injector.dart';
import '../../arguments/user_profile_argument.dart';
import '../../blocs/app_theme/theme_cubit.dart';
import '../../blocs/authentication/login/login_cubit.dart';
import '../../blocs/dashboard_filter/dashboard_filter_cubit.dart';
import '../../blocs/stealth/stealth_cubit.dart';
import '../../widgets/user_guide_widget.dart';
import 'drawer_item.dart';

class AVNavigationDrawer extends StatefulWidget {
  const AVNavigationDrawer({Key? key}) : super(key: key);

  @override
  State<AVNavigationDrawer> createState() => _AVNavigationDrawerState();
}

class _AVNavigationDrawerState extends State<AVNavigationDrawer> {
  bool defaultTheme = true;
  UserPreference? userPreference;
  late GetUserPreference getUserPreference;
  late SaveUserPreference saveUserPreference;
  late String _profilePic;

  @override
  void initState() {
    getUserPreference = getItInstance<GetUserPreference>();
    saveUserPreference = getItInstance<SaveUserPreference>();
    getUserPreference(NoParams()).then((value) {
      value.fold((l) {
        debugPrint(l.toString());
      }, (r) {
        setState(() {
          defaultTheme = r.defaultTheme ?? false;
          userPreference = r;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _profilePic = buildProfilePic();
    return Drawer(
        width: ScreenUtil().screenWidth * 0.75,
        child: SafeArea(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).drawerTheme.backgroundColor?.withOpacity(0.5)
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_12.w),
                              child: SvgPicture.asset('assets/svgs/back_arrow.svg',
                                key: const Key("close"),
                                width: Sizes.dimen_24.w,
                                color: AppColor.grey,
                              ),
                            ),
                          ),
                          GestureDetector(
                            key: const Key("profile_widget"),
                            onTap: () async{

                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_8.h, horizontal: Sizes.dimen_4.w),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                    EdgeInsets.only(left: Sizes.dimen_12.w, top: Sizes.dimen_6.h),
                                    child: Image.asset("assets/pngs/account.png", width: Sizes.dimen_56, color: AppColor.primary,),
                                  ),
                                  Expanded(
                                    child: BlocBuilder<UserCubit, UserEntity?>(
                                        builder: (context, user) {
                                          if(user?.username != null) {
                                            return Padding(
                                                padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_16.w),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(user?.displayname ?? '--',
                                                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: Sizes.dimen_26.sp, fontWeight: FontWeight.bold),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    Text(userPreference?.systemName ?? '--',
                                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: Sizes.dimen_16.sp, fontWeight: FontWeight.bold, color: AppColor.grey),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    )
                                                  ],
                                                )
                                            );
                                          }else {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_12.w),
                                              child: Card(
                                                child: Shimmer.fromColors(
                                                  baseColor: AppColor.white.withOpacity(0.1),
                                                  highlightColor: AppColor.white.withOpacity(0.2),
                                                  direction: ShimmerDirection.ltr,
                                                  period: const Duration(seconds: 1),
                                                  child: Container(
                                                    height: Sizes.dimen_14.h,
                                                    decoration: BoxDecoration(
                                                      color: AppColor.grey,
                                                      borderRadius: BorderRadius.circular(5.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_22.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Last Login: ${userPreference?.lastUserUpdate != null ? DateFormat('dd MMM yy hh:mm aa').format(DateTime.parse(userPreference?.lastUserUpdate ?? '')) : ''}',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Divider(color: AppColor.lightGrey.withOpacity(0.2)),
                              ],
                            ),
                          ),
                          Expanded(
                              child: ListView(
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  DrawerItem(
                                    key: const Key("profile"),
                                    title: 'Profile',
                                    icon: 'assets/svgs/document.svg',
                                    showComingSoon: false,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.pushNamed(context, RouteList.userProfile, arguments: UserProfileArgument(dashboardFilterCubit: context.read<DashboardFilterCubit>()));
                                    },
                                  ),
                                  DrawerItem(
                                    key: const Key("user_guide"),
                                    title: 'App User Guide',
                                    icon: 'assets/svgs/document.svg',
                                    showComingSoon: false,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return UserGuideWidget();
                                          });
                                      },
                                  ),
                                ],
                              )
                          )

                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h, horizontal: Sizes.dimen_24.w),
                      child: Button(
                        key: const Key('logout'),
                        isIpad: false,
                        text: 'Logout',
                        onPressed: () {
                          try {
                            BlocProvider.of<LoginCubit>(context).logout().then((value) {
                              BlocProvider.of<StealthCubit>(context).hide();
                              SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
                              BlocProvider.of<StealthCubit>(context).hide();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                RouteList.initial,
                                    (route) => false,
                              );
                            });

                          }catch(e) {
                            print('ERROR: $e');
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

        )
    );
  }

  String buildProfilePic() {
    final Color? color = context
        .read<AppThemeCubit>()
        .state
        ?.dashboard
        ?.iconColor !=
        null
        ? Color(int.parse(context
        .read<AppThemeCubit>()
        .state!
        .dashboard!
        .iconColor!))
        : Theme.of(context).iconTheme.color;
    final Color bodyColor = context
        .read<AppThemeCubit>()
        .state?.scaffoldBackground !=
        null
        ? Color(int.parse(context
        .read<AppThemeCubit>()
        .state!.scaffoldBackground!))
        : Theme.of(context).scaffoldBackgroundColor;
    final String colorHex = "#${color?.value.toRadixString(16).substring(2)}";
    final String bodyColorHex = "#${bodyColor.value.toRadixString(16).substring(2)}";
    final String rawSvg = """<svg width="154" height="154" viewBox="0 0 154 154" fill="none" xmlns="http://www.w3.org/2000/svg">
<circle cx="77" cy="77" r="77" fill="$colorHex"/>
<ellipse cx="77" cy="76.9589" rx="65" ry="65.9125" stroke="$bodyColorHex" stroke-width="9.11215"/>
<ellipse cx="76.8481" cy="61.7128" rx="25.3621" ry="25.7182" fill="$bodyColorHex"/>
<path d="M108.741 137.635C108.741 129 129.616 128.057 126.357 120.079C123.099 112.101 128.724 120.498 122.703 114.391C116.681 108.285 109.532 103.441 101.664 100.137C93.7966 96.8319 85.364 95.131 76.8481 95.131C68.3321 95.131 59.8995 96.8319 52.0318 100.137C44.164 103.441 37.0152 108.285 30.9935 114.391C24.9718 120.498 26.8009 107.943 23.542 115.921C20.2831 123.899 25.8201 113.908 25.8201 122.543L68.1916 142.871L108.741 137.635Z" fill="$bodyColorHex"/>
</svg>
""";
    return rawSvg;
  }
}
