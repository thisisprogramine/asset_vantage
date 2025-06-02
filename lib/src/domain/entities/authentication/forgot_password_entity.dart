
import 'package:equatable/equatable.dart';

class ForgotPasswordEntity extends Equatable{
  const ForgotPasswordEntity({
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

  @override
  List<Object?> get props => [id, otpValue];
}
