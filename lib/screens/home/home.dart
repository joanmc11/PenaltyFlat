// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:penalty_flat_app/services/auth.dart';


class Home extends StatelessWidget {
   Home({ Key? key }) : super(key: key);

final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      appBar: AppBar(
        title: const Text("Inicio"),
        backgroundColor: Colors.blue[600],
        actions: <Widget> [
          FlatButton.icon(
            icon: const Icon(Icons.person),
            onPressed: () async{
                await _auth.signOut();
            },
            label: const Text("logOut"),
          )]
      ),
    );
  }
}