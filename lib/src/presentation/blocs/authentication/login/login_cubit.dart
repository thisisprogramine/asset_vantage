
import 'package:asset_vantage/src/data/models/authentication/credentials.dart';
import 'package:asset_vantage/src/data/models/authentication/token.dart';
import 'package:asset_vantage/src/data/models/preferences/user_preference.dart';
import 'package:asset_vantage/src/domain/params/preference/user_preference_params.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/app_error.dart';
import '../../../../domain/params/authentication/login_request_params.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/usecases/authentication/login_user.dart';
import '../../../../domain/usecases/authentication/logout_user.dart';
import '../../../../domain/usecases/preferences/get_user_preference.dart';
import '../../../../domain/usecases/preferences/save_user_preference.dart';
import '../../loading/loading_cubit.dart';


part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUser loginUser;
  final LogoutUser logoutUser;
  final LoadingCubit loadingCubit;
  final SaveUserPreference setUserPreference;
  final GetUserPreference getUserPreference;

  LoginCubit({
    required this.loginUser,
    required this.logoutUser,
    required this.loadingCubit,
    required this.setUserPreference,
    required this.getUserPreference,
  }) : super(LoginInitial());

  void initiateLogin(
      {required String username, required String password, required String systemName}) async {
    loadingCubit.show();

    emit(LoginInitial());
    final Either<AppError, Token> eitherLogin = await loginUser(
      LoginRequestParams(
        username: username,
        password: password,
        systemName: systemName,
      ),
    );

    eitherLogin.fold(
      (error) {
        var message = error.appErrorType.name;
        print(message);
        return emit(LoginError(message));
      },
      (success) async {
        if (success.token?.isNotEmpty ?? false) {
          await setUserPreference(UserPreferenceParams(
              preference: UserPreference(
                region: success.region,
                username: username,
                password: password,
                systemName: systemName,
                credential: Credentials(
                  systemName: systemName,
                  username: username,
                  password: password
                ).toJson(),
                loginStatus: true,
                idToken: success.token,
                lastUserUpdate: DateTime.now().toString(),
              )));
        }else if (success.challenge?.isNotEmpty ?? false) {
          if(success.challenge=="NEW_PASSWORD_REQUIRED"){
            return emit(LoginSuccess(resetPasswordReq: true,awssession: success.awssession,challenge: success.challenge));
          }else if (success.challenge=="SMS_MFA") {
            return emit(LoginSuccess(mfaLoginReq: true,awssession: success.awssession, challenge: success.challenge));
          }
        }else if(success.statusCode==406 || success.message=='System not Found'){
          return emit(LoginError('${success.statusCode}'));
        }

        return emit(const LoginSuccess(login: true));
      },
    );

    loadingCubit.hide();
  }

  Future<void> logout() async {
    final user = await getUserPreference(NoParams());
    await logoutUser(NoParams());

    user.fold((l) {

    }, (user) async{
    });


    emit(LogoutSuccess());
  }
}
