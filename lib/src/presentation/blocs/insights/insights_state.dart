
part of "insights_cubit.dart";

abstract class InSightsState extends Equatable {
  final List<ChatEntity>? chats;

  const InSightsState({this.chats});

  @override
  List<Object?> get props => [];
}

class InSightsInitial extends InSightsState {
  const InSightsInitial();
}

class ServerConnectedAndFeededInitialChats extends InSightsState {
  const ServerConnectedAndFeededInitialChats();
}

class InSightsWaitingForResponse extends InSightsState {
  const InSightsWaitingForResponse();
}

class InSightsMessageReceived extends InSightsState {
  const InSightsMessageReceived();
}

class InSightsError
    extends InSightsState {
  final AppErrorType errorType;

  const InSightsError({
    required this.errorType,
  }) : super();
}
