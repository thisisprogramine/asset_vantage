
import 'dart:io';

import 'package:asset_vantage/src/domain/entities/authentication/user_entity.dart';
import 'package:asset_vantage/src/domain/usecases/preferences/get_user_preference.dart';
import 'package:asset_vantage/src/utilities/helper/app_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/models/authentication/user_model.dart';
import '../../../../data/models/preferences/user_preference.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/params/authentication/get_user_data_params.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/params/preference/user_preference_params.dart';
import '../../../../domain/usecases/authentication/get_user_data.dart';
import '../../../../domain/usecases/preferences/save_user_preference.dart';
import '../../app_theme/theme_cubit.dart';
import '../../dashboard_datepicker/dashboard_datepicker_cubit.dart';
import '../../favorites/favorites_cubit.dart';
import '../login_check/login_check_cubit.dart';
import '../token/token_cubit.dart';

class UserCubit extends Cubit<UserEntity?> {
  final FavoritesCubit favoritesCubit;
  final GetUserData getUserData;
  final SaveUserPreference saveUserPreference;
  final GetUserPreference getUserPreference;
  final AppThemeCubit appThemeCubit;
  final LoginCheckCubit loginCheckCubit;
  final TokenCubit tokenCubit;

  UserCubit({
    required this.favoritesCubit,
    required this.getUserData,
    required this.saveUserPreference,
    required this.appThemeCubit,
    required this.getUserPreference,
    required this.loginCheckCubit,
    required this.tokenCubit,
  }) : super(null);

  Future<void> updateUser({required BuildContext context, DashboardDatePickerCubit? datePickerCubit, void Function()? onCollapsed}) async{
    emit(null);
    final Either<AppError, UserEntity> eitherUserData = await getUserData(GetUserDataParams(context: context));
    eitherUserData.fold((l) {
      if(l.appErrorType==AppErrorType.unauthorised){
        loginCheckCubit.loginCheck();
      }
    }, (user) async{
      try {
        datePickerCubit?.changeAsOnDate(asOnDate: AppHelpers.getDateLimit(dateLimit: user.dateLimit ?? '').toString());
      }catch(e){}

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic>? data;
      if(Platform.isIOS){
        if(data?.containsKey('cobranding') ?? false) {
          final appPath = await getApplicationDocumentsDirectory();
          data = user.toJson();
          data["cobranding"]["brandLogo"] = '${appPath.path}/darkLogo.png';
          data["cobrandingLight"]["brandLogo"] = '${appPath.path}/lightLogo.png';
        }
      }
      await saveUserPreference(UserPreferenceParams(
          preference: UserPreference(
            user: data!=null?UserModel.fromJson(data):user,
          )));
      getUserPreference(NoParams()).then((response) {

      });
      favoritesCubit.loadFavorites(context: context, onCollapsed: onCollapsed);
      emit(user);
    });
  }

}
