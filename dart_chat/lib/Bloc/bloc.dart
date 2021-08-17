import 'dart:io';

import 'package:dart_chat/Repo/repository.dart';
import 'package:dart_chat/API/api.dart' as api;

late Bloc bloc;

class Bloc {
  final _host = '0.0.0.0';
  final int _requestPort = 4568;
  final int _chatPort    = 4567;
  late final Repo _repo;

  Stream<List> get clientStream => _repo.clientList.stream;
  
  Bloc() {
    _repo = Repo(_host, _requestPort, _chatPort);
  }

  Future<void> initClientStream() async {
    _repo.clientList = StreamList(await api.getClients(_host, _requestPort));;
  }

  Future<void> connectToServer(String nickname) async {
    await _repo.connectToServer(nickname);
  }
  
  void whisper(String from, String to, String msg) {
    api.whisper(from, to, msg, _repo.server);
  }
  
  void broadcast(String from, String msg) {
    api.broadcast(from, msg, _repo.server);
  }


  void sinkClients() {
    _repo.clientList.sinkList();
  }

  void closeConnection() {
    _repo.dispose();
  }
}