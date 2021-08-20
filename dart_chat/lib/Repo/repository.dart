import 'dart:async';
import 'dart:convert';

import 'package:dart_chat/API/api.dart' as api;
import 'package:dart_chat/objects/message.dart';
import 'package:dart_chat/objects/streamList.dart';
import 'package:dart_chat/objects/user.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Repo {
  late IO.Socket server;
  late final String nickname;
  String _host;
  int _chatPort;
  bool loggedIn = false;

  
  late final StreamList<User> userStream;
  late final StreamList<Message> globalChat;

  Repo(this._host, this._chatPort) {
    connectToServer();
  }

  bool get connected => server.connected;

  void connectToServer() {
    server = IO.io('http://$_host:$_chatPort',
      IO.OptionBuilder()
        .disableAutoConnect()
        .setTransports(['websocket'])
        .build()
    );
    server.connect();

    server.on('users', (data) => api.setUsers(data, userStream));
    server.on('newConnect', (user) => api.addUser(user, userStream));
    server.on('broadcast', (data) => api.handleBroadcast(data, globalChat));

    server.on('connect', (_) {
      print('Connected to server');
    });

    server.on('reject', (_) => loggedIn = false);

    server.on('accept', (_) => loggedIn = true);

    this.nickname = nickname;
    globalChat = StreamList<Message>([]);
  }

  void dispose() {
    server.destroy();
  }
}