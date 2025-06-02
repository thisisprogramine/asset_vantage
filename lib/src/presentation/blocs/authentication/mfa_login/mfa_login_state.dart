
part of "mfa_login_cubit.dart";

abstract class MfaLoginState extends Equatable {
  const MfaLoginState();

  @override
  List<Object> get props => [];
}

class MfaLoginInitial extends MfaLoginState {}

class MfaLoginSuccess extends MfaLoginState {
  final bool success;
  const MfaLoginSuccess(this.success);

  @override
  List<Object> get props => [success];
}

class MfaLoginFailed extends MfaLoginState {
  final String message;

  const MfaLoginFailed(this.message);

  @override
  List<Object> get props => [message];
}

class MfaLoginError extends MfaLoginState {
  final String message;

  const MfaLoginError(this.message);

  @override
  List<Object> get props => [message];
}
