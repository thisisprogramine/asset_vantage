import 'package:asset_vantage/src/domain/params/authentication/reset_password_params.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

import '../../../../data/models/authentication/token.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/usecases/authentication/reset_password.dart';
import '../../../../domain/usecases/preferences/save_user_preference.dart';
import '../../loading/loading_cubit.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final LoadingCubit loadingCubit;
  final ResetPassword reset;
  final SaveUserPreference setUserPreference;

  ResetPasswordCubit({
    required this.loadingCubit,
    required this.reset,
    required this.setUserPreference,
  }) : super(ResetPasswordInitial());

  void startResetPassword({
    required String? username,
    required String? newPassword,
    required String? systemName,
    required String? awssession,
    required String? challenge,
  }) async {
    loadingCubit.show();
    emit(ResetPasswordInitial());
    final Either<AppError, Token> eitherPass =
        await reset(ResetPasswordParams(
          username: username,
          newpassword: newPassword,
          awssession: awssession,
          challenge: challenge,
          systemName: systemName
    ));

    eitherPass.fold((error) {
      final message = error.appErrorType.name;
      return emit(ResetPasswordError(message));
    }, (data) async {
      print(data);
      if(data.token?.isNotEmpty ?? false){

        return emit(const ResetPasswordSuccess(true));
      }
      return emit(const ResetPasswordSuccess(true));
    });

    loadingCubit.hide();
  }
}
