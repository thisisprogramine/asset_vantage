
import 'package:asset_vantage/src/domain/entities/favorites/favorites_sequence_enitity.dart';
import 'package:equatable/equatable.dart';

class FavoritesEntity extends Equatable{
  final String? message;
  final int? id;
  final List<Favorite>? favoriteList;
  final FavoritesSequenceEntity? sequenceData;

  const FavoritesEntity({
    this.message,
    this.favoriteList,
    this.id,
    this.sequenceData,
  });

  @override
  List<Object?> get props => [message, favoriteList,id,sequenceData];
}

class Favorite {
  final int? id;
  final int? userId;
  final String? systemName;
  final String? reportname;
  final String? reportId;
  final Map<dynamic, dynamic>? filter;
  final int? level;
  final int? itemid;
  final bool? isPined;
  final String? createdAt;
  final String? updatedAt;

  Favorite({
    this.id,
    this.userId,
    this.reportId,
    this.systemName,
    this.reportname,
    this.filter,
    this.level,
    this.itemid,
    this.isPined,
    this.createdAt,
    this.updatedAt,
  });
}
