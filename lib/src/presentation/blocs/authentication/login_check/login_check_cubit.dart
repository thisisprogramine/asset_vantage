
import 'package:asset_vantage/src/data/models/preferences/user_preference.dart';
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:asset_vantage/src/services/biomatric_service.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../../domain/entities/app_error.dart';
import '../../../../domain/usecases/preferences/get_user_preference.dart';
import '../login/login_cubit.dart';


part 'login_check_state.dart';

class LoginCheckCubit extends Cubit<LoginCheckState> {
  final GetUserPreference getUserPreference;
  final BiometricService biometricService;
  final LoginCubit loginCubit;

  LoginCheckCubit({
    required this.getUserPreference,
    required this.biometricService,
    required this.loginCubit,
  }) : super(LoginCheckInitial());

  void loginCheck() async {

    final eitherUserPref = await getUserPreference(NoParams());
    eitherUserPref.fold((l) {

    }, (pref) async{

      if((pref.loginStatus ?? false) && !(JwtDecoder.isExpired(pref.idToken ?? ''))) {
        if(pref.isOnBiometric ?? false) {
          if(await biometricService.checkBiometrics()) {
            if(!await biometricService.authenticate()) {
              FlutterExitApp.exitApp(iosForceExit: true);
              return;
            }
          }
        }else {

        }
      }

      await Future.delayed(const Duration(milliseconds: 2500));

      final Either<AppError,
          UserPreference> eitherUserPreference = await getUserPreference(
          NoParams());

      eitherUserPreference.fold((l) {
        var message = l.appErrorType.name;
        print(message);
        return LoginCheckError(message);
      }, (userPreference) async {

        try {
          final bool isTokenExpired = JwtDecoder.isExpired(userPreference.idToken ?? '');
          if(isTokenExpired || !(pref.isOnBiometric ?? false)) {

            loginCubit.logout().then((value) {
              emit(LoggedOut());
            });

          }else {
            if (userPreference.loginStatus == true) {
              emit(LoggedIn());
            } else {
              emit(LoggedOut());
            }
          }
        }catch(e){
          loginCubit.logout().then((value) {
            emit(LoggedOut());
          });
        }
      });
    });
  }
}