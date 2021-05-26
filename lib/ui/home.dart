import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:todoapp/constants/constants.dart';
import 'package:todoapp/ui/signin.dart';
import 'package:todoapp/ui/signup.dart';
import 'package:todoapp/ui/splashscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late final User user;
  late final String uid;
  late String title2;
  Map<String, dynamic> m = {};
  late int index;
  CollectionReference users = FirebaseFirestore.instance.collection('users');


  final List<String> _todoList = <String>[];

  // text field
  final TextEditingController _textFieldController = TextEditingController();


  @override
  void initState() {
    super.initState();
    //Getting current user
    user = auth.currentUser;
    uid = user.uid;
  }

  @override
  Widget build(BuildContext context) {
    Stream<DocumentSnapshot> cs = users.doc(uid).snapshots();


    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        backgroundColor: Colors.orange,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Logout', 'Clear all todos'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],

      ),

       body:StreamBuilder<DocumentSnapshot>(

          stream: cs,
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Text(
                  "Loading...",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal
                  ),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.active) {
              var userdata = snapshot.data!.data();
              if (userdata != null) {
                _todoList.clear();
                for (int i = 0; i < userdata!.length; i++) {
                  _todoList.add(userdata[i.toString()]);
                }
              }
              else {
                return Container();
              }
              // get sections from the document

              return ListView.builder(
                  itemCount: _todoList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 1.0, horizontal: 4.0),
                      child: Card(
                        child: ListTile(
                          onTap: () {},
                          title: Text(_todoList[index].toString()),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              setState(() async {
                                Map<String, dynamic> m2 = {};
                                int count = 0;
                                for (int i = 0; i < _todoList.length; i++) {
                                  if (i == index) {
                                    count += 1;
                                  }
                                  else {
                                    m2.putIfAbsent((i - count)
                                        .toString(), () => _todoList[i]);
                                  }
                                }
                                users.doc(uid).set(m2).then((value) =>
                                    print("User deleted")).catchError((error) =>
                                    print("Failed to delete user: $error"));
                                m = m2;
                              });
                            },),
                        ),
                      ),
                    );
                  }
              );
            } else {
              return Container();
            }
          }),
      // add items to the to-do list
      floatingActionButton: FloatingActionButton(
          onPressed: () => _displayDialog(context),
          tooltip: 'Add Item',
          backgroundColor: Colors.orange,
          child: Icon(Icons.add)),
    );
  }

  //handling pop-up
  Future<void> handleClick(String value) async {
    switch (value) {
      case 'Logout':
        auth.signOut();
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => SignInPage(),
          ),
        );
        break;
      case 'Clear all todos':
        setState(() {
          m = {};
          _todoList.clear();
          users.doc(uid).delete()
              .then((value) => print("User Deleted"))
              .catchError((error) => print("Failed to delete user: $error"));
          users = FirebaseFirestore.instance.collection('users');
        });
        break;
    }
  }

  // display a dialog for the user to enter items
  Future<dynamic> _displayDialog(BuildContext context) async {
    // alter the app state to show a dialog

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add a task to your list'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: 'Enter task here'),
              onChanged: (value) => title2 = value,
            ),
            actions: <Widget>[
              // add button
              FlatButton(
                child: const Text('ADD'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  index = _todoList.length;
                  if (index != 0) {
                    for (int i = 0; i < index; i++) {
                      m.putIfAbsent(i.toString(), () => _todoList[i]);
                    }
                  }
                  m.putIfAbsent(index.toString(), () => title2.toString());
                  users.doc(uid).set(m)
                      .then((value) => print("User Added"))
                      .catchError((error) =>
                      print("Failed to add user: $error"));
                  _textFieldController.clear();
                },
              ),
              // Cancel button
              FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }
}
