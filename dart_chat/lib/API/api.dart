import 'dart:convert';
import 'dart:io';
import 'package:dart_chat/exceptions/custExceptions.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_common_client/socket_io_client_for_browser.dart' as IO;


Future<List<dynamic>> getClients(String host, int requestPort) async {
  var url = Uri.parse('http://$host:$requestPort/clients');
  var response = await http.get(url);
  // print(jsonDecode(response.body)['clients'][0].runtimeType);
  List<dynamic> clients = jsonDecode(response.body)['clients'];
  return clients;
}

Future<void> validate(String nickname, String host, int requestPort) async {
  List clients = await getClients(host, requestPort);

  if (clients.contains(nickname)) {
    throw InvalidNicknameException('Nickname: $nickname already taken');
  }
}

void whisper(String from, String to, String msg, IO.Socket server) {
  server.emit('msg', msg);
}

void broadcast(String from, String msg, IO.Socket server) {
  server.emit('msg', msg);
}