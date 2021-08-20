import 'package:dart_chat/pages/messagePage.dart';
import 'package:dart_chat/pages/messagePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:dart_chat/Bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:dart_chat/exceptions/custExceptions.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController nicknameController = new TextEditingController();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List clients = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height/2,
            width: MediaQuery.of(context).size.width/2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Logged in users:'),
                Container(
                  height: MediaQuery.of(context).size.height/2-200,
                  width: MediaQuery.of(context).size.width/2,
                  child: StreamBuilder(
                    stream: bloc.clientStream,
                    builder: (context, AsyncSnapshot<List> snapshot) {
                      if (snapshot.hasData) {
                        clients = snapshot.data!;
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
                        return Text('No clients connected');
                      }
                    },
                  ),
                ),
                SizedBox(height: 20,),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Nickname',
                          border: OutlineInputBorder(),
                        ),
                        controller: nicknameController,
                        maxLines: 1,
                        validator: (name) {
                          if (name == null || name.isEmpty) {
                            return 'Please enter a nickname';
                          } else if (clients.contains(name)) {
                            return 'Name already taken';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                ElevatedButton(
                  onPressed: () {
                    String nickname = nicknameController.text;
                    if (_formKey.currentState!.validate()) {
                      try {
                        bloc.joinChat(nicknameController.text);

                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => MessagePage(nicknameController.text))
                        );
                      } on InvalidNicknameException {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('The nickname: $nickname already exists'))
                        );
                      } on ServerRejectedRequestException {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Server rejected the nickname: $nickname'))
                        );
                      }
                    } else {
                      print('${nicknameController.text} rejected');
                    }
                  },
                  child: Text('Enter DartChat'),
                ),
              ],
            ),
          )
      ),
    );
  }
}