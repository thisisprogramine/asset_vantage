

import '../../../domain/entities/denomination/denomination_entity.dart';

class DenominationModel extends DenominationEntity{
  List<DenData>? data;

  DenominationModel({
    this.data
  }) : super(
      denominationData: data
  );

  factory DenominationModel.fromJson(Map<String, dynamic> json) {
    final list = <DenData>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        list.add(DenData.fromJson(v));
      });
    }
    return DenominationModel(
      data: list
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DenData extends DenominationData{
  final int? id;
  final String? key;
  final String? title;
  final int? denomination;
  final String? suffix;

  DenData({
    this.id,
    this.key,
    this.title,
    this.suffix,
    this.denomination,
  }) : super(
    id: id,
    key: key,
    title: title,
    denomination: denomination,
    suffix: suffix,
  );

  factory DenData.fromJson(Map<dynamic, dynamic> json) {
    return DenData(
      id: json['id'] != null ? json['id']! : null,
      key: json['key'] != null ? json['key']! : null,
      title: json['title'] != null ? json['title']! : null,
      suffix: json['suffix'] != null ? json['suffix']! : null,
      denomination: json['denomination'] != null ? json['denomination']! : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id != null ? id! : null,
      'key': key != null ? key! : null,
      'title': title != null ? title! : null,
      'suffix': suffix != null ? suffix! : null,
      'denomination': denomination != null ? denomination! : null,
    };
  }

}