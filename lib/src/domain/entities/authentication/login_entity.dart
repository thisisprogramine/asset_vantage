
import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable{
  const LoginEntity({
    this.success,
    this.error,

    this.message,
    this.id,
    this.userExist,
    this.token,
    this.defaultLanguage,
  });

  final bool? success;
  final String? error;
  final String? message;
  final String? id;
  final bool? userExist;
  final String? token;
  final String? defaultLanguage;

  @override
  List<Object?> get props => [success, error, message];

}
