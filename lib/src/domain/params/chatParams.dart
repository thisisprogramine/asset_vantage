import 'package:asset_vantage/src/data/repositories/chat_remote_datasource.dart';
import 'package:equatable/equatable.dart';

class ChatParams extends Equatable {
  final String? question;
  final String? entityId;
  final String? entityType;
  final ChatDataSource? chatDataSource;

  const ChatParams({this.question,this.chatDataSource, this.entityId, this.entityType});

  @override
  List<Object?> get props => [question,entityId,chatDataSource, entityType];
}

class ChatConnectionParams extends Equatable {
  final String? authToken;
  final String? subId;

  const ChatConnectionParams({this.authToken, this.subId});

  @override
  List<Object?> get props => [authToken, subId];
}

class EstablishStreamParams extends Equatable {
  final ChatDataSource chatDataSource;
  final String? authToken;
  final String? subId;

  const EstablishStreamParams({required this.chatDataSource,this.authToken, this.subId});

  @override
  List<Object?> get props => [chatDataSource,authToken, subId];
}