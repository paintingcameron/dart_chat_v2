import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dart_chat/API/api.dart' as api;
import 'package:dart_chat/exceptions/custExceptions.dart';
import 'package:socket_io_common_client/socket_io_client_for_browser.dart' as IO;

class Repo {
  late IO.Socket server;
  late final String nickname;
  String _host;
  int _requestPort, _chatPort;
  
  late final StreamList clientList;
  late final StreamList<String> globalChat;

  Repo(this._host, this._requestPort, this._chatPort);

  Future<void> connectToServer(String nickname) async {

    await api.validate(nickname, _host, _requestPort);

    server = IO.ioBrowser('http://localhost:$_chatPort', {
      'transports': ['polling', 'websocket'],
      'nickname': nickname,
    });

    // server = IO.io('http://localhost:$_chatPort',
    //   IO.OptionBuilder()
    //     .setTransports(['websocket'])
    //     .setExtraHeaders({'nickname': nickname})
    //     .disableAutoConnect()
    //     .build()
    // );

    server = server.connect();
    print('Server connected: ${server.connected}');

    server.on('connect', (_) {
      print('Connected to server');
      server.emit('msg', 'this is a test');
    });

    server.on('msg', (data) {
      print(data);
      globalChat.addToList(data);
    });

    server.on('reject', (data) {
      throw ServerRejectedRequestException(data);
    });

    server.on('disconnect', (_) => print('disconnected'));

    this.nickname = nickname;
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