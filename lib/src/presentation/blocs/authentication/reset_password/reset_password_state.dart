part of "reset_password_cubit.dart";


abstract class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object> get props => [];
}

class ResetPasswordInitial extends ResetPasswordState{}

class ResetPasswordSuccess extends ResetPasswordState{
  final bool success;

  const ResetPasswordSuccess(this.success);

  @override
  List<Object> get props => [success];
}

class ResetPasswordFailed extends ResetPasswordState{
  final String message;

  const ResetPasswordFailed(this.message);

  @override
  List<Object> get props => [message];
}

class ResetPasswordError extends ResetPasswordState{
  final String message;

  const ResetPasswordError(this.message);

  @override
  List<Object> get props => [message];
}