import 'dart:convert';
import 'dart:io';
import 'package:dart_chat/exceptions/custExceptions.dart';
import 'package:http/http.dart' as http;


Future<List<dynamic>> getClients(InternetAddress host, int requestPort) async {
  var url = Uri.parse('http://${host.address}:$requestPort/clients');
  var response = await http.get(url);
  // print(jsonDecode(response.body)['clients'][0].runtimeType);
  List<dynamic> clients = jsonDecode(response.body)['clients'];
  return clients;
}

Future<void> validate(String nickname, InternetAddress host, int requestPort) async {
  List clients = await getClients(host, requestPort);

  if (clients.contains(nickname)) {
    throw InvalidNicknameException('Nickname: $nickname already taken');
  }
}

void whisper(String from, String to, String msg, Socket server) {
  server.write(msg);
}

void broadcast(String from, String msg, Socket server) {
  server.write(msg);
}