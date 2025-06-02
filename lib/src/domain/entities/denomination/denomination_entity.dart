import 'package:equatable/equatable.dart';

class DenominationEntity extends Equatable {
  List<DenominationData>? denominationData;

  DenominationEntity({this.denominationData});

  @override
  List<Object?> get props =>[ denominationData];
}

class DenominationData extends Equatable{
  final int? id;
  final String? key;
  final String? title;
  final int? denomination;
  final String? suffix;

  DenominationData({this.id, this.key, this.title, this.denomination, this.suffix});

  @override
  List<Object?> get props => [id, title, key, denomination,suffix];

  Map<String, dynamic> toJson() => {
    "id": id,
    "key": key,
    "title": title,
    "suffix": suffix,
    "denomination": denomination,
  };
}