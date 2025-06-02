
import 'package:asset_vantage/src/data/models/favorites/favorites_sequence_model.dart';
import 'package:asset_vantage/src/domain/entities/favorites/favorites_entity.dart';

class FavoritesModel extends FavoritesEntity{
  final String? message;
  final List<FavoriteItem>? favorite;
  final FavoritesSequenceModel? sequence;
  final int? id;

  FavoritesModel({
    this.message,
    this.favorite,
    this.sequence,
    this.id,
  }) : super(
    message: message,
    favoriteList: favorite,
      id: id,
    sequenceData: sequence,
  );

  factory FavoritesModel.fromJson(Map<String, dynamic> json) => FavoritesModel(
    message: json["message"],
    id: json["id"],
    favorite: json["data"] == null ? [] : List<FavoriteItem>.from(json["data"]!.map((x) => FavoriteItem.fromJson(x))),
    sequence: json["sequence_data"]!=null && (json["sequence_data"] as List).isNotEmpty?FavoritesSequenceModel.fromJson(json["sequence_data"][0]):null,
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "id": id,
    "data": favorite == null ? [] : List<dynamic>.from(favorite!.map((x) => x.toJson())),
    "sequence_data": sequence?.toJson(),
  };
}

class FavoriteItem extends Favorite{
  final int? id;
  final int? userId;
  final String? systemName;
  final String? reportname;
  final String? reportid;
  final Map<dynamic, dynamic>? filter;
  final int? level;
  final int? itemid;
  final bool? isPined;
  final String? createdAt;
  final String? updatedAt;

  FavoriteItem({
    this.id,
    this.userId,
    this.systemName,
    this.reportname,
    this.reportid,
    this.filter,
    this.level,
    this.itemid,
    this.isPined,
    this.createdAt,
    this.updatedAt,
  }) : super(
    id: id,
    userId: userId,
    systemName: systemName,
    reportname: reportname,
    filter: filter,
    level: level,
    itemid: itemid,
    isPined: isPined,
    createdAt: createdAt,
    updatedAt: updatedAt,
    reportId: reportid
  );

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json["id"],
      userId: json["user_id"] is int ? json["user_id"] : int.tryParse("${json["user_id"]}"),
      systemName: json["system_name"],
      reportname: json["reportname"],
      reportid: json["reportid"],
      filter: json["filter"] != null ? json["filter"]["message"] != "empty" ? json["filter"] : null : null,
      level: json["level"],
      itemid: json["itemid"],
      isPined: json["isPined"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "system_name": systemName,
    "reportname": reportname,
    "reportid": reportid,
    "filter": filter,
    "level": level,
    "itemid": itemid,
    "isPined": isPined,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}
