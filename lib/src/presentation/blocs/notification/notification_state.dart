part of 'notification_cubit.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationData> notifications;
  const NotificationLoaded({
    required this.notifications
  });

  @override
  List<Object> get props => [];
}

class NotificationLoading extends NotificationState {}

class NotificationError extends NotificationState {
  final AppErrorType errorType;

  const NotificationError({
    required this.errorType,
  });
}
