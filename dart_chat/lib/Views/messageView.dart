import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dart_chat/Bloc/bloc.dart';

class MessageView extends StatefulWidget {
  final String nickname;

  MessageView(this.nickname);

  @override
  _MessageViewState createState() => _MessageViewState(nickname);
}

class _MessageViewState extends State<MessageView> {
  String _nickname;
  final TextEditingController _messageController = TextEditingController();

  _MessageViewState(this._nickname);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: ClientList(context),
          ),
          Expanded(
            flex: 2,
            child: MessageInput(context),
          )
        ],
      ),
    );
  }

  Widget MessageInput(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.66,
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
              child: Container(),
            ),
            Container(
              height: 100,
              child: Row(
                children: [
                  SizedBox(width: 5,),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter Message',
                        border: OutlineInputBorder(),
                      ),
                      controller: _messageController,
                      onSubmitted: (msg) {
                        bloc.broadcast(_nickname, msg);
                        _messageController.clear();
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.green,),
                    iconSize: 40,
                    onPressed: () {
                      bloc.broadcast(_nickname, _messageController.text);
                      _messageController.clear();
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget ClientList(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width * 0.33,
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: StreamBuilder(
        stream: bloc.clientStream,
        builder: (context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            List clients = snapshot.data!;
            return ListView.builder(
              itemCount: clients.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text('${clients[index]}'),
                  ),
                );
              },
            );
          } else {
            bloc.sinkClients();
            return Text('No other clients');
          }
        },
      ),
    );
  }}