//


import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/constants/size_constants.dart';
import '../../../injector.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../arguments/login_argument.dart';
import '../../blocs/app_theme/theme_cubit.dart';
import '../../blocs/authentication/login/login_cubit.dart';
import '../../blocs/authentication/user/user_cubit.dart';
import '../../theme/theme_color.dart';
import '../../widgets/logo.dart';
import 'biomatric_options.dart';
import 'login_form.dart';
import 'login_label.dart';

class LoginScreen extends StatefulWidget {
  final LoginArgument argument;
  const LoginScreen({
    Key? key,
    required this.argument
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginCubit loginCubit;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,]);
    });
    context.read<AppThemeCubit>().state?.brandName = null;
    loginCubit = getItInstance<LoginCubit>();
  }

  @override
  void dispose() {
    super.dispose();

    loginCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          return OrientationBuilder(
              builder: (context, orientation) {
                return Scaffold(
                  resizeToAvoidBottomInset: true,
                  bottomNavigationBar: SafeArea(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: Sizes.dimen_4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset('assets/svgs/Powered_by_AV.svg',height: Sizes.dimen_6.h,  fit: BoxFit.contain,),
                            UIHelper.verticalSpace(Sizes.dimen_2.h),
                            SvgPicture.asset("assets/svgs/AV_LOGO_new.svg"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  body: MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => loginCubit,
                      ),
                    ],
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                            padding: EdgeInsets.symmetric(vertical: Sizes.dimen_0.h, horizontal: Sizes.dimen_20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                UIHelper.verticalSpaceMedium,
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Welcome to", style: Theme.of(context).textTheme.titleMedium),
                                      UIHelper.verticalSpace(Sizes.dimen_4.h),
                                      Hero(
                                        tag: 'av_pro',
                                        child: Logo(
                                          isDark: true,
                                          width: ScreenUtil().screenWidth * 0.5,
                                          showBrandLogo: false,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    flex: 8,
                                    child: LoginForm(isIpad: !(constraints.maxWidth < 600))
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                  ),
                );
              }
          );
        }
    );
  }
}
