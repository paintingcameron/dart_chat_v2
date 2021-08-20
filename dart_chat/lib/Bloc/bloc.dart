import 'dart:io';

import 'package:dart_chat/Repo/repository.dart';
import 'package:dart_chat/API/api.dart' as api;
import 'package:dart_chat/objects/user.dart';

late Bloc bloc;

class Bloc {
  final _host = '0.0.0.0';
  final int _chatPort    = 4567;
  late final Repo repo;

  Stream<List> get clientStream => repo.userStream.stream;
  
  Bloc() {
    repo = Repo(_host, _chatPort);
  }
  
  bool get connectedToServer => repo.connected;

  void joinChat(String nickname) {
    api.joinChat(nickname, repo.userStream.list as List<User>);
  }
  
  void whisper(String from, String to, String msg) {
    api.whisper(from, to, msg, repo.server);
  }
  
  void broadcast(String from, String msg) {
    api.broadcast(from, msg, repo.server);
  }


  void sinkClients() {
    repo.userStream.sinkList();
  }

  void closeConnection() {
    repo.dispose();
  }
}