
import '../../../domain/entities/authentication/forgot_password_entity.dart';

class ForgotPasswordModel extends ForgotPasswordEntity{
  ForgotPasswordModel({
    this.success,
    this.data,
  }) : super(
    id: data?.id,
    otpValue: data?.otpValue,
    otpExpiration: data?.otpExpiration,
    otpFor: data?.otpFor,
    createdAt: data?.createdAt,
    updatedAt: data?.updatedAt,
    v: data?.v,
    dataId: data?.dataId,
  );

  final bool? success;
  final Data? data;

  factory ForgotPasswordModel.fromJson(Map<String, dynamic> json) => ForgotPasswordModel(
    success: json["success"] == null ? null : json["success"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "data": data == null ? null : data?.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.otpValue,
    this.otpExpiration,
    this.otpFor,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.dataId,
  });

  final String? id;
  final String? otpValue;
  final int? otpExpiration;
  final String? otpFor;
  final dynamic createdAt;
  final dynamic updatedAt;
  final int? v;
  final String? dataId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"] == null ? null : json["_id"],
    otpValue: json["otp_value"] == null ? null : json["otp_value"],
    otpExpiration: json["otp_expiration"] == null ? null : json["otp_expiration"],
    otpFor: json["otp_for"] == null ? null : json["otp_for"],
    createdAt: json["createdAt"] == null ? null : json["createdAt"],
    updatedAt: json["updatedAt"] == null ? null : json["updatedAt"],
    v: json["__v"] == null ? null : json["__v"],
    dataId: json["id"] == null ? null : json["id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "otp_value": otpValue == null ? null : otpValue,
    "otp_expiration": otpExpiration == null ? null : otpExpiration,
    "otp_for": otpFor == null ? null : otpFor,
    "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
    "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
    "__v": v == null ? null : v,
    "id": dataId == null ? null : dataId,
  };
}
