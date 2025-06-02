import 'package:asset_vantage/src/data/models/insights/messages_model.dart';
import 'package:rxdart/rxdart.dart';

class ChatDataSource {
  List<ChatMsg> chats= [];
  bool resAdded;
  ChatMsg? currentChatNotification;

  BehaviorSubject<bool>? _waitingIndicator;
  BehaviorSubject<List<ChatMsg>>? _subject;
  BehaviorSubject<ChatMsg?>? _notificationChat;


  ChatDataSource(this.chats,this.resAdded) {
    _subject = BehaviorSubject<List<ChatMsg>>.seeded(chats);
    _waitingIndicator = BehaviorSubject<bool>.seeded(resAdded);
    _notificationChat = BehaviorSubject<ChatMsg?>.seeded(currentChatNotification);
  }

  Stream<List<ChatMsg>>? get chatObservable => _subject?.stream;

  Stream<bool>? get waitObservable => _waitingIndicator?.distinct();

  Stream<ChatMsg?>? get currentChatNotifier => _notificationChat?.distinct();

  void addChat(List<ChatMsg>? chat){
    if(chat==null) return;
    chats.addAll(chat);
    _subject?.sink.add(chats);
    if(chat[0].payload?.data!=null){
      resAdded = true;
      _waitingIndicator?.sink.add(resAdded);
    }else {
      resAdded = false;
      _waitingIndicator?.sink.add(resAdded);
    }
  }

  void changeNotification(ChatMsg? chat){
    if(chat==null) return;
    _notificationChat?.sink.add(chat);
  }

  void dispose() {
    _subject?.close();
    _waitingIndicator?.close();
  }
}