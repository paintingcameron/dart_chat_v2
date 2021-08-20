import 'dart:convert';
import 'package:dart_chat/Bloc/bloc.dart';
import 'package:dart_chat/exceptions/custExceptions.dart';
import 'package:dart_chat/objects/message.dart';
import 'package:dart_chat/objects/streamList.dart';
import 'package:dart_chat/objects/user.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void joinChat(String nickname, List<User> users) {
  if (users.contains(nickname)) {
    throw InvalidNicknameException('Nickname: $nickname already taken');
  }

  bloc.repo.server.emit('nickname', nickname);

  if (bloc.repo.loggedIn == false) {
    throw ServerRejectedRequestException('Server rejected the request for $nickname to connect');
  }
}

void setUsers(data, StreamList<User> users) {
  List<String> newUsers = jsonDecode(data)['clients'];
  users.setList(newUsers.map((name) => User(name)).toList());
}

void addUser(String name, StreamList<User> users) {
  var user = User(name);

  users.addToList(user);
}

void removeUser(String name, StreamList<User> users) {
  users.list.removeWhere((user) => user.nickname == name);
  users.sinkList();
}

void handleWhisper(whisper, StreamList<User> users, String nickname) {
  var data = jsonDecode(whisper);

  String from = data['from'];
  String to   = data['to'];
  String msg  = data['message'];

  if (to != nickname) {
    return;
  }

  var user = users.list.singleWhere((user) => user.nickname == from);
  user.chats.addToList(Message(to, from, msg));
}

void handleBroadcast(broadcast, StreamList<Message> globalChat) {
  var data = jsonDecode(broadcast);

  String from = data['from'];
  String msg  = data['message'];

  globalChat.addToList(Message('global', from, msg));
}

void handleDisconnect(data, StreamList<User> users) {
  String name = jsonDecode(data)['nickname'];

  users.list.removeWhere((user) => user.nickname == name);
  users.sinkList();
}

void whisper(String from, String to, String msg, IO.Socket server) {
  var data = {'from': from, 'to': to, 'message': msg};

  server.emit('whisper', jsonEncode(data));
}

void broadcast(String from, String msg, IO.Socket server) {
  var data = {'from': from, 'message': msg};

  server.emit('bcast', jsonEncode(data));
}