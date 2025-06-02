import 'package:equatable/equatable.dart';

class ResetPasswordParams extends Equatable {
  final String? username;
  final String? newpassword;
  final String? awssession;
  final String? challenge;
  final String? systemName;

  const ResetPasswordParams({
    required this.username,
    required this.newpassword,
    required this.awssession,
    required this.challenge,
    required this.systemName,
});

  Map<String, dynamic> toJson() => {
    "username": username,
    "newpassword": newpassword,
    "awssession": awssession,
    "systemName": systemName,
    "challenge": challenge,
  };

  @override
  List<Object?> get props => [username, newpassword, awssession,systemName,challenge];
}