import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/services/auth.dart';
import 'package:flutterchat/services/firestore.dart';
import 'package:flutterchat/models/user.dart';

class HomePage extends StatefulWidget {
  final BaseAuth auth;
  final BaseFirestore firestore;
  final VoidCallback logoutCallback;
  final String userId;

  HomePage(this.auth, this.firestore, this.logoutCallback, this.userId);

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _showUserProfile() {
    return StreamBuilder<QuerySnapshot>(
    );
  }

  Widget _showSignOutButton() {
    return RaisedButton(
      onPressed: () async {
        await widget.auth.signOut();
        widget.logoutCallback();
      },
      child: Text('Sign out'),
    );
  }

  Widget _build() {
    return Container(
      alignment: Alignment.center,
      child: ListView(
        children: <Widget>[
          _showUserProfile(),
          _showSignOutButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlutterChat'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Container(
        alignment: Alignment.center,
        child: _build(),
      ),
    );
  }
}
