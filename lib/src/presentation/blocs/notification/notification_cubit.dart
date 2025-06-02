
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/app_error.dart';
import '../../../domain/entities/notification/notification_entity.dart';
import '../../../domain/params/no_params.dart';
import '../../../domain/usecases/notifications/get_notifications.dart';
import '../authentication/login_check/login_check_cubit.dart';

part 'notification_state.dart';

class NotificationCubit
    extends Cubit<NotificationState> {
  final GetNotifications getNotifications;
  final LoginCheckCubit loginCheckCubit;

  NotificationCubit({
    required this.getNotifications,
    required this.loginCheckCubit,
  }): super(NotificationInitial());

  void loadNotification() async {

    emit(NotificationLoading());

    final Either<AppError, NotificationsEntity> eitherNotification = await getNotifications(NoParams());

    eitherNotification.fold((error) {
      if(error.appErrorType==AppErrorType.unauthorised){
        loginCheckCubit.loginCheck();
      }
      emit(NotificationError(errorType: error.appErrorType));
    }, (notification) {
      emit(NotificationLoaded(notifications: notification.notifications ?? []));
    });
  }
}
