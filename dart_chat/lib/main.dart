import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

late Socket server;
late var clients;

void main() {
  runApp(DartChat());
}

class DartChat extends StatefulWidget {
  @override
  _DartChatState createState() => _DartChatState();
}

class _DartChatState extends State<DartChat> {
  late Future<String> _nickname;

  Future<dynamic> getClients() async {
    var url = Uri.parse('http://localhost:4568/clients');
    final response = await http.get(url);
    final decoded = jsonDecode(response.body) as Map;
    clients = decoded.values.toList()[0];
    return clients;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: getClients(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return startView(context);
          } else {
            return loadingView();
          }
        }
      ),
    );
  }

  Widget loadingView() {
    return Scaffold(
      body: Center(
        child: Container(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(),
        ),
      )
    );
  }
}

class NicknameInput extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print('test');
    return AlertDialog(
      title: Text('Choose a nickname'),
      content: Form(
        key: _formKey,
        child: Container(
          height: 200,
          width: 300,
          child: Center(
            child: TextFormField(
              maxLines: 1,
              controller: nameController,
              keyboardType: TextInputType.name,
              validator: (name) {
                if (name == null || name.isEmpty) {
                  return 'Please enter a nickname';
                } else if (clients.contains(name)) {
                  return 'Nickname already exists';
                } else {
                  return null;
                }
              },
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text('Enter'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(nameController.text);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please try again')),
              );
            }
          },
        ),
      ],
    );
  }
}
