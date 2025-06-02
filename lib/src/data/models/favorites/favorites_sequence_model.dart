import 'package:asset_vantage/src/domain/entities/favorites/favorites_sequence_enitity.dart';

class FavoritesSequenceModel extends FavoritesSequenceEntity {
  final List<int>? sequence;
  final int? id;

  const FavoritesSequenceModel({
    this.sequence,
    this.id,
  }) : super(
          sequence: sequence,
          id: id,
        );

  factory FavoritesSequenceModel.fromJson(
          Map<String, dynamic> json) =>
      FavoritesSequenceModel(
        id: json["id"],
        sequence: (json["sequence_data"] != null &&
                    (json["sequence_data"] as Map).isNotEmpty)
                ? json["sequence_data"]["sequence"] != null
                    ? (json["sequence_data"]["sequence"] as List)
                        .map((e) => e as int)
                        .toList()
                    : null
                : null,
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "id": id,
        "sequence_data": {"sequence": sequence}
      };
}