import 'package:equatable/equatable.dart';

class LoginRequestParams extends Equatable{
  final String username;
  final String password;
  final String systemName;

  const LoginRequestParams({
    required this.username,
    required this.password,
    required this.systemName,
  });

  Map<String, String> toJson() => {
        'username': username,
        'password': password,
        'systemName': systemName,
      };

  @override
  List<Object?> get props => [username, password, systemName];
}
