import 'dart:async';
import 'dart:io';

import 'package:dart_chat/API/api.dart' as api;
import 'package:dart_chat/exceptions/custExceptions.dart';

class Repo {
  late Socket server;
  final String _nickname;
  InternetAddress _host;
  int _requestPort, _chatPort;
  
  late final StreamList clientList;

  Repo(this._nickname, this._host, this._requestPort, this._chatPort);
  
  Future<void> initStream() async {
    clientList = StreamList(await api.getClients(_host, _requestPort));
  }

  Future<void> connectToServer() async {
    await api.validate(_nickname, _host, _requestPort);

    await Socket.connect(_host, _chatPort).then((Socket s) {
      server = s;
      s.listen(dataHandler, onError: errorHandler, onDone: doneHandler, cancelOnError: false);
    }).catchError((e) {
      throw ServerConnectFailedException('Unable to connect to server');
    });
  }

  void doneHandler() {

  }

  void errorHandler(error, StackTrace trace) {
    print(error);
  }

  void dataHandler(data) {
    print(String.fromCharCodes(data));
  }

  void dispose() {
    server.destroy();
  }
}

class StreamList<T> {
  late StreamController<List<T>> _controller;
  late List<T> _list;
  
  StreamList(List<T> list) {
    _list = list;
    
    _controller = StreamController.broadcast(
      onListen: () {
        _controller.sink.add(this._list);
      }
    );
  }

  Stream<List<T>> get stream => _controller.stream;
  
  void setList(List<T> list) {
    _list = list;
    sinkList();
  }
  
  void addToList(T value) {
    _list.add(value);
    sinkList();
  }
  
  void sinkList() {
    _controller.sink.add(_list);
  }
  
  void dispose() {
    _controller.close();
  }
}