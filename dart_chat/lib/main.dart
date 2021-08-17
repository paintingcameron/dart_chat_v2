import 'dart:io';
import 'dart:async';
import 'package:dart_chat/Views/homeView.dart';
import 'package:flutter/material.dart';
import 'package:dart_chat/Bloc/bloc.dart';

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
  late Future<Bloc> _blocInit;
  
  Future<Bloc> _initiateBloc() async {
    Bloc b = Bloc();
    await b.initClientStream();
    return b;
  }

    @override
  void initState() {
    super.initState();
    _blocInit = _initiateBloc();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<Bloc>(
        future: _blocInit,
        builder: (context, AsyncSnapshot<Bloc> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data is Bloc) {
              bloc = snapshot.data!;
              return HomeView();
            } else {
              print('something went wrong');
              return loadingView();
            }
          } else {
            return loadingView();
          }
        },
      )
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


