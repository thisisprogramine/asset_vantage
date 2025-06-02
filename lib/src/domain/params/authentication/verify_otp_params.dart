import 'package:equatable/equatable.dart';

class VerifyOtpParams extends Equatable {
  final String smsmfacode;
  final String username;
  final String awssession;
  final String challenge;
  final String systemName;

  const VerifyOtpParams({
    required this.smsmfacode,
    required this.username,
    required this.awssession,
    required this.challenge,
    required this.systemName,
});

  Map<String, dynamic> toJson() => {
    "smsmfacode": smsmfacode,
    "username": username,
    "awssession": awssession,
    "challenge": challenge,
    "systemName": systemName,
  };

  @override
  List<Object> get props => [smsmfacode,username,awssession,challenge,systemName];
}