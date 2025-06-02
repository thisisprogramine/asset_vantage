import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ChatListEntity extends Equatable {
  final List<ChatEntity>? chatList;

  const ChatListEntity({this.chatList});

  @override
  List<Object?> get props => [];
}

enum ResponseFormat {
  text,
  image
}

class ChatEntity extends Equatable {
  final MsgVariant? type;
  final PayloadEntity? payload;

  const ChatEntity({
    this.type,
    this.payload,
  });

  @override
  List<Object?> get props => [type, payload];
}

class TextStylingEntity extends Equatable {
  final StylingWeight? fontWeight;
  final StylingColor? color;

  const TextStylingEntity({this.fontWeight, this.color});

  dynamic get weight {
    if(fontWeight==StylingWeight.bold){
      return FontWeight.bold;
    }else if(fontWeight == StylingWeight.italic){
      return FontStyle.italic;
    }
  }

  Color? get textColor {
    if(color==StylingColor.red){
      return Colors.red;
    }else if(color==StylingColor.green){
      return Colors.green;
    }
    return null;
  }

  @override
  List<Object?> get props => [fontWeight, color];
}

class MessageRespContentEntity extends Equatable {
  final String? text;
  final TextStylingEntity? styles;

  const MessageRespContentEntity({
    this.text,this.styles
});

  @override
  List<Object?> get props => [text, styles];
}

class MessageReqContentEntity extends Equatable {
  final String? messageId;
  final int? entityId;
  final String? content;

  const MessageReqContentEntity({
    this.content,
    this.entityId,
    this.messageId,
  });

  @override
  List<Object?> get props => [content,entityId,messageId];
}

class NotificationResDataEntity extends Equatable {
  final String? taskId;
  final String? message;

  const NotificationResDataEntity({
    this.message,
    this.taskId
});

  @override
  List<Object?> get props => [taskId, message];
}

class PayloadEntity extends Equatable {
  final String? name;
  final Object? arguments;
  final NotificationResDataEntity? output;
  final MessageReqContentEntity? data;
  final String? entity;
  final List<MessageRespContentEntity>? msgResp;

  const PayloadEntity({
    this.data,
    this.name,
    this.entity,
    this.arguments,
    this.msgResp,
    this.output,
});

  @override
  List<Object?> get props => [data, name, entity, arguments, msgResp, output];
}

enum StylingColor { red, green }

enum StylingWeight { bold, italic }

enum MsgMethods { send, delete, edit }

enum MsgVariant { command, message, error, notification }