import '../../../domain/entities/user_guide_assets/user_guide_assets_entity.dart';

class UserGuidAssetsModel extends UserGuideAssetsEntity{
  final List<String>? assets;

  UserGuidAssetsModel({
    this.assets,
  }) : super(assets: assets);

  factory UserGuidAssetsModel.fromJson(Map<String, dynamic> json) => UserGuidAssetsModel(
    assets: json["assets"] == null ? [] : List<String>.from(json["assets"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "assets": assets == null ? [] : List<dynamic>.from(assets!.map((x) => x)),
  };
}
