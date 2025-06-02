
import 'package:asset_vantage/src/data/models/insights/messages_model.dart';
import 'package:asset_vantage/src/data/repositories/chat_remote_datasource.dart';
import 'package:asset_vantage/src/domain/entities/app_error.dart';
import 'package:asset_vantage/src/domain/params/chatParams.dart';
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:asset_vantage/src/domain/usecases/insights/chat_stream.dart';
import 'package:asset_vantage/src/domain/usecases/insights/connect_chat.dart';
import 'package:asset_vantage/src/domain/usecases/insights/disconnect_chat.dart';
import 'package:asset_vantage/src/domain/usecases/insights/send_message.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'insights_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<ConnectServer>()])
@GenerateMocks([], customMocks: [MockSpec<DisConnectServer>()])
@GenerateMocks([], customMocks: [MockSpec<SendChatMessage>()])
@GenerateMocks([], customMocks: [MockSpec<ChatStream>()])
void main() async {
  ChatDataSource chatDataSource = ChatDataSource(<ChatMsg>[], false);
  group('Hey Av websocket server', ()
  {
    test('Connects to the websocket server', () async {
      final connectServer = MockConnectServer();

      when(connectServer(const ChatConnectionParams(subId: "",authToken: "",)))
          .thenAnswer((_) async => const Right(null));

      final result = await connectServer(const ChatConnectionParams(subId: "",authToken: "",));

      result.fold((error) {
        expect(error, isA<void>());
      }, (response) {
        expect(result.isRight(), true);
      });
    });

    test(
        'AppError should be returned on websocket connection failure', () async {
      final connectServer = MockConnectServer();

      when(connectServer(const ChatConnectionParams(subId: "",authToken: "",)))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result = await connectServer(const ChatConnectionParams(subId: "",authToken: "",));

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(result.isRight(), true);
      });
    });

    test('Void should be returned on successful api call', () async {
      final sendMessage = MockSendChatMessage();

      when(sendMessage(ChatParams(entityId: "",
        chatDataSource: chatDataSource,
        question: "",)))
          .thenAnswer((_) async => const Right(null));

      final result = await sendMessage(ChatParams(entityId: "",
        chatDataSource: chatDataSource,
        question: "",));

      result.fold((error) {
        expect(error, isA<void>());
      }, (response) {
        expect(result.isRight(), true);
      });
    });

    test('AppError should be returned on send message failure', () async {
      final sendMessage = MockSendChatMessage();

      when(sendMessage(ChatParams(entityId: "",
        chatDataSource: chatDataSource,
        question: "",)))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result = await sendMessage(ChatParams(entityId: "",
        chatDataSource: chatDataSource,
        question: "",));

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(result.isRight(), true);
      });
    });

    test('Void should be returned for successful establishment of chat stream', () async {
      final chatStream = MockChatStream();

      when(chatStream(EstablishStreamParams(chatDataSource: chatDataSource, authToken: "",subId: "",)))
          .thenAnswer((_) async => const Right(null));

      final result = await chatStream(EstablishStreamParams(chatDataSource: chatDataSource, authToken: "",subId: "",));

      result.fold((error) {
        expect(error, isA<void>());
      }, (response) {
        expect(result.isRight(), true);
      });
    });

    test('AppError should be returned for failure in establishing chat stream', () async {
      final chatStream = MockChatStream();

      when(chatStream(EstablishStreamParams(chatDataSource: chatDataSource, authToken: "",subId: "",)))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result = await chatStream(EstablishStreamParams(chatDataSource: chatDataSource, authToken: "",subId: "",));

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(result.isRight(), true);
      });
    });

    test('Returns void on successful disconnection', () async {
      final disConnectServer = MockDisConnectServer();

      when(disConnectServer(NoParams()))
          .thenAnswer((_) async => const Right(null));

      final result = await disConnectServer(NoParams());

      result.fold((error) {
        expect(error, isA<void>());
      }, (response) {
        expect(result.isRight(), true);
      });
    });

    test('AppError should be returned on websocket connection close', () async {
      final disConnectServer = MockDisConnectServer();

      when(disConnectServer(NoParams()))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result = await disConnectServer(NoParams());

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(result.isRight(), true);
      });
    });
  });
}
