import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/blocs/authentication/token/token_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/internet_connectivity/internet_connectivity_cubit.dart';
import 'package:asset_vantage/src/presentation/widgets/token_expire_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/constants/size_constants.dart';
import '../../blocs/loading/loading_cubit.dart';
import '../../widgets/no_internet_dialog.dart';
import 'loading_circle.dart';

class LoadingScreen extends StatelessWidget {
  final Widget screen;
  final Function() back;

  const LoadingScreen({Key? key, required this.screen, required this.back}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetConnectivityCubit, bool>(
      builder: (context, connected) {
        return BlocBuilder<LoadingCubit, bool>(
          builder: (context, showLoading) {
            return BlocBuilder<TokenCubit, bool>(
              builder: (context, isTokenExpired) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    screen,
                    if (showLoading)
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).secondaryHeaderColor.withOpacity(0.2)),
                        child: Center(
                          child: LoadingCircle(
                            size: Sizes.dimen_200.w,
                          ),
                        ),
                      ),
                    if(!connected)
                      const NoInternetDialog(),
                    if(isTokenExpired)
                      TokenExpireDialog(back: back)

                  ],
                );
              }
            );
          },
        );
      }
    );
  }
}
