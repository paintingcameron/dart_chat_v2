import 'package:flutter/cupertino.dart';

class HomeView extends StatelessWidget {
  final TextEditingController nicknameController = new TextEditingController();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

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
                  child: ListView.builder(
                    itemCount: clients.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text('${clients[index]}'),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20,),
                Form(
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
                          print('Name: $name');
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
                    if (_formKey.currentState!.validate()) {
                      print('value nickname');
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
}