import 'dart:io';
import 'dart:async';
import 'package:dart_chat/pages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:dart_chat/Bloc/bloc.dart';

late Socket server;
late var clients;

void main() {
  runApp(DartChat());
}

class DartChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: (bloc.connectedToServer) ? HomeView() : FailedConnectionView(),
    );
  }

  Widget FailedConnectionView() {
    return Text('Failed to connect to server');
  }
}


