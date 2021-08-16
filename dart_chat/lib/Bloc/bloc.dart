import 'dart:io';

import 'package:dart_chat/Repo/repository.dart';
import 'package:dart_chat/API/api.dart' as api;

class Bloc {
  final InternetAddress _host = InternetAddress.anyIPv4;
  final int _requestPort = 4568;
  final int _chatPort    = 4567;
  late final Repo repo;

  Stream<List> get clientStream => repo.clientList.stream;

  Future<void> initRepo(String nickname) async {
    repo = Repo(nickname, _host, _requestPort, _chatPort); 
    
    await repo.connectToServer();
    await repo.initStream();
  }
  
  void whisper(String from, String to, String msg) {
    api.whisper(from, to, msg, repo.server);
  }
  
  void broadcast(String from, String msg) {
    api.broadcast(from, msg, repo.server);
  }

  void closeConnection() {
    repo.dispose();
  }
}