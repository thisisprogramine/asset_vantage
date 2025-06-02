import 'dart:developer';

import 'package:asset_vantage/src/domain/entities/authentication/forgot_password_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/app_error.dart';
import '../../../../domain/params/authentication/forget_password_params.dart';
import '../../../../domain/usecases/authentication/forgot_password.dart';
import '../../loading/loading_cubit.dart';


part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPassword forgotPassword;
  final LoadingCubit loadingCubit;

  ForgotPasswordCubit({
    required this.forgotPassword,
    required this.loadingCubit,
  }) : super(ForgotPasswordInitial());

  void generateOtpWithMobileNumber(
      {required String email}) async {
    loadingCubit.show();

    emit(ForgotPasswordInitial());

    final Either<AppError, ForgotPasswordEntity> eitherForgotPassword =
    await forgotPassword(
      ForgetPasswordParams(
        email: email,
      ),
    );

    emit(eitherForgotPassword.fold(
          (l) {
        var message = l.appErrorType.name;
        log(message);
        return ForgotPasswordError(message);
      },
          (r) => ForgotPasswordSuccess(),
    ));

    loadingCubit.hide();
  }

}
