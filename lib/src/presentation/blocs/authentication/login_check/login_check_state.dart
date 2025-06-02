part of 'login_check_cubit.dart';

abstract class LoginCheckState extends Equatable {
  const LoginCheckState();

  @override
  List<Object> get props => [];
}

class LoginCheckInitial extends LoginCheckState {}

class LoggedIn extends LoginCheckState {}

class LoggedOut extends LoginCheckState {}

class LoginCheckError extends LoginCheckState {
  final String message;

  const LoginCheckError(this.message);

  @override
  List<Object> get props => [message];
}
