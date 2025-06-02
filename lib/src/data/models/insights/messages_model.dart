import 'package:asset_vantage/src/domain/entities/insights/chat_message_entity.dart';

class ChatList extends ChatListEntity {
  final List<ChatMsg>? chats;

  const ChatList({
    this.chats,
}):super(chatList: chats);

  factory ChatList.fromJson(Map<dynamic, dynamic> res) => ChatList(
    chats: res['chats']!=null?(res['chats'] as List).map((e) => ChatMsg.fromJson(res: e)).toList():null,
  );
}

class ChatMsg extends ChatEntity {
  final MsgVariant? typ;
  final Payload? data;

  const ChatMsg({
    this.typ,
    this.data,
  }): super(payload: data,type: typ,);

  String get toJsonType {
    if(typ==MsgVariant.command){
      if(data?.name=='pong'){
        return "commandOutput";
      }else {
        return "commandInput";
      }
    }else if(typ==MsgVariant.notification){
      return "notification";
    }else if(typ==MsgVariant.message){
      if(data?.entity!=null){
        return "messageOutput";
      }else {
        return "messageInput";
      }
    }else {
      return "error";
    }
  }

  factory ChatMsg.fromJson({required Map<dynamic, dynamic> res}) => ChatMsg(
    data: res["payload"]!=null?Payload.fromJson(res['payload']):null,
    typ: res['type']!=null?MsgVariant.values.where((element) => element.name==res['type']).toList()[0]:null,
  );

  Map<String, dynamic> toJson() => {
    "type": MsgVariant.values[typ?.index ?? 0].name,
    "payload": data?.toJson(type: toJsonType),
  };
}

class TextStyling extends TextStylingEntity {
  final StylingWeight? fntWgt;
  final StylingColor? txtColor;

  const TextStyling({this.fntWgt, this.txtColor}):super(color: txtColor,fontWeight: fntWgt,);

  factory TextStyling.fromJson({required Map<dynamic, dynamic> res}) => TextStyling(
    fntWgt: res['fontWeight']!=null?res['fontWeight']=='bold'?StylingWeight.bold:StylingWeight.italic:null,
    txtColor: res['color']!=null?res['color']=='red'?StylingColor.red:StylingColor.green:null,
  );

  Map<String, dynamic> toJson() => {
    "color": StylingColor.values[txtColor?.index ?? 0].name,
    "fontWeight": StylingWeight.values[fntWgt?.index ?? 0].name,
  };
}

class MessageRespContent extends MessageRespContentEntity {
  final String? txt;
  final TextStyling? styling;

  const MessageRespContent({
    this.txt,this.styling
  }):super(text: txt,styles: styling,);

  factory MessageRespContent.fromJson({required Map<dynamic, dynamic> res}) => MessageRespContent(
    styling: res["style"]!=null?TextStyling.fromJson(res: res['style']):null,
    txt: res['text'],
  );

  Map<String, dynamic> toJson() => {
    "text": txt,
    "style": styling?.toJson(),
  };
}

class MessageReqContent extends MessageReqContentEntity {
  final String? message;
  final int? entity;
  final String? data;

  const MessageReqContent({
    this.message,
    this.entity,
    this.data,
  }):super(content: data,entityId: entity,messageId: message,);

  factory MessageReqContent.fromJson({required Map<dynamic, dynamic> res}) => MessageReqContent(
    entity: res['entityId'],
    data: res['content'],
    message: res['messageId'],
  );

  Map<String, dynamic> toJson() => {
    "content": data,
    "entityId": entity,
    "messageId": message,
  };
}

class NotificationResData extends NotificationResDataEntity {
  final String? task;
  final String? msg;

  const NotificationResData({
    this.msg,
    this.task
  }):super(message: msg,taskId: task,);

  factory NotificationResData.fromJson({required Map<dynamic, dynamic> res}) => NotificationResData(
    task: res['task_id'],
    msg: res['message'],
  );

  Map<String, dynamic> toJson() => {
    "task_id": task,
    "message": msg,
  };
}

class Payload extends PayloadEntity {
  final String? payloadName;
  final Object? payloadArguments;
  final NotificationResData? payloadOutput;
  final MessageReqContent? payloadData;
  final String? payloadEntity;
  final List<MessageRespContent>? payloadMsgResp;

  const Payload({
    this.payloadArguments,
    this.payloadData,
    this.payloadEntity,
    this.payloadMsgResp,
    this.payloadName,
    this.payloadOutput,
  }):super(name: payloadName,entity: payloadEntity,data: payloadData,arguments: payloadArguments,msgResp: payloadMsgResp,output: payloadOutput,);

  factory Payload.fromJson(Map<dynamic, dynamic> res) => Payload(
    payloadArguments: res['arguments'],
    payloadData: res['data']!=null && (res['data'] as Map).isNotEmpty? MessageReqContent.fromJson(res: res['data']) :null,
    payloadEntity: res['entity'],
    payloadMsgResp: res['content']!=null && (res['content'] as List).isNotEmpty? (res['content'] as List).map((e) => MessageRespContent.fromJson(res: e)).toList() :null,
    payloadName: res['name'],
    payloadOutput: res['output']!=null?NotificationResData.fromJson(res: res['output']):null,
  );

  Map<String, dynamic> toJson({required String type}) {
    if(type=="commandInput"){
      return {
        "name": payloadName,
        "arguments": payloadArguments,
      };
    }else if(type=="commandOutput"){
      return {
        "name": payloadName,
        "output": payloadOutput?.toJson(),
      };
    }else if(type=="notification"){
      return {
        "name": payloadName,
        "output": payloadOutput?.toJson(),
      };
    }else if(type=="messageInput"){
      return {
        "name": payloadName,
        "data": payloadData?.toJson(),
      };
    }else if(type=="messageOutput"){
      return {
    "entity": payloadEntity,
    "content": payloadMsgResp?.map((e) => e.toJson()).toList(),
    };
    }else{
      return {
        "arguments": payloadArguments,
        "data": payloadData?.toJson(),
        "entity": payloadEntity,
        "content": payloadMsgResp?.map((e) => e.toJson()).toList(),
        "name": payloadName,
        "output": payloadOutput?.toJson(),
      };
    }
  }
}