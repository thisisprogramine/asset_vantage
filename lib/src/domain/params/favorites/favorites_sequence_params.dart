import 'package:asset_vantage/src/config/constants/favorite_constants.dart';
import 'package:flutter/cupertino.dart';

class FavoritesSequenceParams{
  final BuildContext context;
  final String action;
  final int? id;
  final String? userId;
  final String? systemName;
  final List<int>? sequence;

  const FavoritesSequenceParams({
    required this.context,
    required this.action,
    this.id,
    this.userId,
    this.systemName,
    this.sequence,
  });

  Map<String, dynamic> toJson() {
    return {
      "action": action,
      "data": {
        if(id != null)
          "id": id,
        if(userId != null)
          "user_id": userId,
        if(systemName != null)
          "system_name": systemName,
        if(sequence!=null)
          "sequence_data": {
              FavoriteConstants.sequence: sequence,
          },
      },
    };
  }
}