part of 'user_guide_assets_cubit.dart';

abstract class UserGuideAssetsState extends Equatable {
  final UserGuideAssetsEntity? assetsEntity;

  const UserGuideAssetsState({
    this.assetsEntity
  });

  @override
  List<Object> get props => [];
}

class UserGuideAssetsInitial extends UserGuideAssetsState {
  const UserGuideAssetsInitial();
}

class UserGuideAssetsLoaded extends UserGuideAssetsState {
  final UserGuideAssetsEntity? assetsEntity;

  const UserGuideAssetsLoaded({
    required this.assetsEntity,
  }) : super(
    assetsEntity: assetsEntity,
  );
}

class UserGuideAssetsLoading extends UserGuideAssetsState {
  const UserGuideAssetsLoading();
}

class UserGuideAssetsError extends UserGuideAssetsState {
  final AppErrorType errorType;

  const UserGuideAssetsError(this.errorType);

  @override
  List<Object> get props => [errorType];
}