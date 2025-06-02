
import 'package:asset_vantage/src/domain/entities/user_guide_assets/user_guide_assets_entity.dart';
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:asset_vantage/src/domain/usecases/preferences/get_user_preference.dart';
import 'package:asset_vantage/src/domain/usecases/preferences/save_user_preference.dart';
import 'package:asset_vantage/src/domain/usecases/user_guide_assets/get_user_guide_assets.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/preferences/user_preference.dart';
import '../../../domain/entities/app_error.dart';

part 'user_guide_assets_state.dart';

class UserGuideAssetsCubit extends Cubit<UserGuideAssetsState> {
  final GetUserPreference getUserPreference;
  final SaveUserPreference saveUserPreference;
  final GetUserGuideAssets getUserGuideAssets;

  UserGuideAssetsCubit({
    required this.getUserPreference,
    required this.saveUserPreference,
    required this.getUserGuideAssets,
  }) : super(const UserGuideAssetsInitial());

  Future<bool> loadUserGuideAssets() async{
    bool isFirstOpened = false;

    emit(const UserGuideAssetsLoading());

    final Either<AppError, UserGuideAssetsEntity> eitherUserGuideAssets = await getUserGuideAssets(NoParams());

    final Either<AppError, UserPreference> userPreference = await getUserPreference(NoParams());

    eitherUserGuideAssets.fold((error) {
      if(error.appErrorType==AppErrorType.unauthorised) {

      }
      emit(UserGuideAssetsError(error.appErrorType));
    }, (userGuideAssets) {
      emit(UserGuideAssetsLoaded(assetsEntity: userGuideAssets));
    });

    userPreference.fold((error) {

    }, (userPreference) {
      isFirstOpened = userPreference.isFirstOpen ?? true;
    });
    return isFirstOpened;
  }
}