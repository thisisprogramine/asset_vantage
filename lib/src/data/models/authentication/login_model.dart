
import '../../../domain/entities/authentication/login_entity.dart';

class LoginModel extends LoginEntity{
  const LoginModel({
    this.success,
    this.error,

    this.message,
    this.id,
    this.userExist,
    this.token,
    this.defaultLanguage,
    this.cart,
  }) : super(
    success: success,
    error: error,

    message: message,
    id: id,
    userExist: userExist,
    token: token,
    defaultLanguage: defaultLanguage,
  );

  final bool? success;
  final String? error;

  final String? message;
  final String? id;
  final bool? userExist;
  final String? token;
  final String? defaultLanguage;
  final dynamic cart;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    success: json["success"] == null ? null : json["success"],
    error: json["error"] == null ? null : json["error"],

    message: json["message"] == null ? null : json["message"],
    id: json["id"] == null ? null : json["id"],
    userExist: json["userExist"] == null ? null : json["userExist"],
    token: json["token"] == null ? null : json["token"],
    defaultLanguage: json["defaultLanguage"] == null ? null : json["defaultLanguage"],
    cart: json["cart"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "error": error == null ? null : error,

    "message": message == null ? null : message,
    "id": id == null ? null : id,
    "userExist": userExist == null ? null : userExist,
    "token": token == null ? null : token,
    "defaultLanguage": defaultLanguage == null ? null : defaultLanguage,
    "cart": cart,
  };
}
