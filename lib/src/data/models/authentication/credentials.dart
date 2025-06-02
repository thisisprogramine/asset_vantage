class Credentials{
  final String? username;
  final String? password;
  final String? systemName;

  Credentials({
    this.username,
    this.password,
    this.systemName
  });

  factory Credentials.fromJson(Map<dynamic, dynamic> json) => Credentials(
    username: json['username'],
    password: json['password'],
    systemName: json['systemName'],
  );

  Credentials copyWith({
    final String? username,
    final String? password,
    final String? systemName,
  }) => Credentials(
    username: username ?? this.username,
    password: password ?? this.password,
    systemName: systemName ?? this.systemName
  );

  Map<dynamic, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
      "systemName": systemName,
    };
  }
}