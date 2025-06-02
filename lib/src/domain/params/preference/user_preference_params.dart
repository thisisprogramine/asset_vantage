import 'package:asset_vantage/src/data/models/preferences/user_preference.dart';
import 'package:equatable/equatable.dart';

class UserPreferenceParams extends Equatable{
  final UserPreference preference;

  const UserPreferenceParams({
    required this.preference,
  });

  Map<String, dynamic> toJson() => {
    'preference': preference,
  };

  @override
  List<Object> get props => [preference];
}
