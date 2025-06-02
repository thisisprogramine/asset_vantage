part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginSuccess extends LoginState {
  final bool? login;
  final bool? resetPasswordReq;
  final bool? mfaLoginReq;
  final String? awssession;
  final String? challenge;

  const LoginSuccess({this.login, this.resetPasswordReq, this.mfaLoginReq,this.awssession,this.challenge});

  @override
  List<Object> get props => [];
}

class LogoutSuccess extends LoginState {}

class LoginFailed extends LoginState {
  final String message;

  const LoginFailed(this.message);

  @override
  List<Object> get props => [message];
}

class LoginError extends LoginState {
  final String message;

  const LoginError(this.message);

  @override
  List<Object> get props => [message];
}
