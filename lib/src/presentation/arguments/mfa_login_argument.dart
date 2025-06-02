
class MfaLoginArgument {
  final String? username;
  final String? awssession;
  final String? challenge;
  final String? systemName;
  final String? password;
  MfaLoginArgument({
    required this.username,
    required this.awssession,
    required this.challenge,
    required this.systemName,
    required this.password,
  });
}