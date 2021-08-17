import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dart_chat/API/api.dart' as api;
import 'package:dart_chat/exceptions/custExceptions.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Repo {
  late IO.Socket server;
  late final String _nickname;
  String _host;
  int _requestPort, _chatPort;
  
  late final StreamList clientList;
  late final StreamList<String> globalChat;

  Repo(this._host, this._requestPort, this._chatPort);

  Future<void> connectToServer(String nickname) async {

    await api.validate(nickname, _host, _requestPort);

    server = IO.io('http://localhost:3000');
    server.onConnect((_) {
      print('connect');
      server.emit('msg', 'this is a test');
    });

    server.on('event', (data) => print(data));
    server.onDisconnect((_) => print('disconnected'));

    // await Socket.connect(_host, _chatPort).then((Socket s) {
    //   server = s;
    //   s.listen(dataHandler, onError: errorHandler, onDone: doneHandler, cancelOnError: false);
    // }).catchError((e) {
    //   throw ServerConnectFailedException('Unable to connect to server');
    // });

    _nickname = nickname;
  }
  //
  // void doneHandler() {
  //
  // }
  //
  // void errorHandler(error, StackTrace trace) {
  //   print(error);
  // }
  //
  // void dataHandler(Uint8List data) {
  //   globalChat.addToList(String.fromCharCodes(data));
  // }
  //
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