import 'dart:developer';

import 'package:asset_vantage/src/domain/params/chatParams.dart';
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:asset_vantage/src/domain/usecases/insights/connect_chat.dart';
import 'package:asset_vantage/src/domain/usecases/insights/disconnect_chat.dart';
import 'package:asset_vantage/src/domain/usecases/insights/get_chat_list.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/chat_remote_datasource.dart';
import '../../../domain/entities/app_error.dart';
import '../../../domain/entities/insights/chat_message_entity.dart';
import '../../../domain/usecases/insights/chat_stream.dart';
import '../../../domain/usecases/insights/send_message.dart';

part "insights_state.dart";

class ChatCubit extends Cubit<InSightsState> {
  final ConnectServer connectServer;
  final DisConnectServer disConnectServer;
  final SendChatMessage sendChatMessage;
  final GetAllChats getAllChats;
  ChatDataSource? chatDataSource;
  final ChatStream chatStream;

  ChatCubit(
      {required this.connectServer,
      required this.getAllChats,
      required this.sendChatMessage,
      required this.chatStream,
      required this.disConnectServer})
      : super(const InSightsInitial());

  Future<void> startPage({required String? authToken, required String? subId,}) async {
    final eitherConnect = await connectServer(ChatConnectionParams(authToken: authToken,subId: subId));
    eitherConnect.fold((l) {
      log('${l.appErrorType}');
    }, (r) async {
      log("connected");
      final eitherChats = await getAllChats(NoParams());
      eitherChats.fold((l) {
        log('${l.appErrorType}');
      }, (r) async {
        log('initialChats: $r');
        chatDataSource = ChatDataSource([], false);
        chatStream(EstablishStreamParams(chatDataSource: chatDataSource!,subId: subId,authToken: authToken,));
        emit(const ServerConnectedAndFeededInitialChats());
      });
    });
  }

  Future<void> sendMessage(
      {required String question, required String entityId, required String entityType}) async {
    final eitherMsg = await sendChatMessage(ChatParams(
      question: question,
      chatDataSource: chatDataSource,
      entityId: entityId,
      entityType: entityType
    ));
    eitherMsg.fold((l) {
      log('${l.appErrorType}');
    }, (r) {
      log('success');
      emit(const InSightsWaitingForResponse());
    });
  }

  Future<void> endPage() async {
    final eitherConnect = await disConnectServer(NoParams());
    eitherConnect.fold((l) {
      log('${l.appErrorType}');
    }, (r) async {
      chatDataSource?.dispose();
      log('disconnected');
    });
  }
}
