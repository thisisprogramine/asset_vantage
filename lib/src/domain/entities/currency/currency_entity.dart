
import 'package:equatable/equatable.dart';

class CurrencyEntity extends Equatable {
  List<Currency>? list;

  CurrencyEntity({
    this.list
  });

  @override
  List<Object?> get props => [list];
}

class Currency extends Equatable {
  String? id;
  String? code;
  String? format;

  Currency({
    this.id,
    this.code,
    this.format,
  });

  @override
  List<Object?> get props => [id, code];

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "format": format,
  };
}