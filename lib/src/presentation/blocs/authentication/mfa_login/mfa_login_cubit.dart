
import 'dart:developer';

import 'package:asset_vantage/src/domain/params/authentication/verify_otp_params.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/authentication/token.dart';
import '../../../../data/models/preferences/user_preference.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/params/preference/user_preference_params.dart';
import '../../../../domain/usecases/authentication/verify_otp.dart';
import '../../../../domain/usecases/preferences/save_user_preference.dart';
import '../../loading/loading_cubit.dart';

part "mfa_login_state.dart";

class MfaLoginCubit extends Cubit<MfaLoginState> {
    final LoadingCubit loadingCubit;
    final VerifyOtp verify;
    final SaveUserPreference setUserPreference;

    MfaLoginCubit({
        required this.loadingCubit,
        required this.verify,
        required this.setUserPreference,

    }):super(
        MfaLoginInitial(),
    );

    void verifyOtp({required String username, required String awssession, required String challenge,required String systemName,required String otp,required String password}) async {
        loadingCubit.show();
        emit(MfaLoginInitial());
        final Either<AppError, Token> either = await verify(VerifyOtpParams(challenge: challenge,awssession: awssession,smsmfacode: otp,username: username,systemName: systemName));
        either.fold((error) {
            final message = error.appErrorType.name;
            log(message);
            emit(MfaLoginError(message));
        }, (data) async {
            if(data.token?.isNotEmpty ?? false){
                await setUserPreference(UserPreferenceParams(
                    preference: UserPreference(
                      username: username,
                      password: password,
                      loginStatus: true,
                      idToken: data.token,
                      systemName: systemName,
                    )));
                return emit(const MfaLoginSuccess(true));
            }
            emit(const MfaLoginSuccess(true));
        });
        loadingCubit.hide();
    }
}



