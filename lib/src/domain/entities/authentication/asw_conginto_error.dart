class AWSCognitoError {
  final int? statusCode;
  final String? code;
  final String? name;
  final String message;

  const AWSCognitoError({
    this.statusCode,
    this.code,
    this.name,
    this.message = 'Authentication Error',
  });

  factory AWSCognitoError.fromJson(Map<String, dynamic> json) {
    return AWSCognitoError(
      statusCode: json['statusCode'] != null ? json['statusCode']! : null,
      code: json['code'] != null ? json['code']! : null,
      name: json['name'] != null ? json['name']! : null,
      message: json['message'] != null ? json['message']! : 'Authentication Error'
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': message,
      'code': code,
      'name': name,
      'message': message,
    };
  }
}