
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/blocs/authentication/token/token_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_app/restart_app.dart';
import '../../config/constants/route_constants.dart';
import '../../config/constants/size_constants.dart';
import '../../utilities/helper/ui_helper.dart';
import '../blocs/authentication/login/login_cubit.dart';
import '../blocs/stealth/stealth_cubit.dart';
import 'package:restart/restart.dart';
import 'button.dart';

class TokenExpireDialog extends StatefulWidget {
  final Function() back;
  const TokenExpireDialog({super.key, required this.back});

  @override
  State<TokenExpireDialog> createState() => _TokenExpireDialogState();
}

class _TokenExpireDialogState extends State<TokenExpireDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor.withOpacity(0.2)),
      child: Center(
          child:Card(
            margin: EdgeInsets.symmetric(horizontal: Sizes.dimen_32.w),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)
                )
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h,),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UIHelper.verticalSpaceSmall,
                  Text("Session Expired!",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  UIHelper.verticalSpaceSmall,
                  Text("Your session has expired due to inactivity or security reasons. Please log out and log in again to continue using the app.",
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  UIHelper.verticalSpaceSmall,
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
                            context.read<TokenCubit>().emitAsLogout().then((value) {
                              print("DDD");
                              restart();
                            });

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
          )
      ),
    );
  }
}
