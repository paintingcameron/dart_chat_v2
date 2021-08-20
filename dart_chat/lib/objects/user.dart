import 'package:dart_chat/objects/message.dart';
import 'streamList.dart';

class User {
  late String nickname;
  late StreamList<Message> chats;

  User(String nickname) {
    this.nickname = nickname;
    this.chats = StreamList<Message>([]);
  }
}