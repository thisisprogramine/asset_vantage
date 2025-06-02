
import 'package:equatable/equatable.dart';

class FavoritesSequenceEntity extends Equatable{
  final String? message;
  final int? id;
  final List<int>? sequence;

  const FavoritesSequenceEntity({
    this.message,
    this.sequence,
    this.id,
  });

  @override
  List<Object?> get props => [message, sequence,id];
}