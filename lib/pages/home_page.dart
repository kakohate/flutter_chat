import 'package:flutter/material.dart';
import 'package:flutterchat/services/auth.dart';
import 'package:flutterchat/services/firestore.dart';
import 'package:flutterchat/models/user.dart';

@immutable
class HomePage extends StatefulWidget {
  const HomePage(this.auth, this.firestore, this.logoutCallback, this.userId);

  final BaseAuth auth;
  final BaseFirestore firestore;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _showUserProfile() {
    User user;
    widget.firestore
        .getUserByUid(widget.userId)
        .then((User value) => user = value);
    if (user == null) {
      widget.auth.signOut();
      widget.logoutCallback();
      return const Text('');
    }
    return Text(user.name);
  }

  Widget _showSignOutButton() {
    return RaisedButton(
      onPressed: () async {
        await widget.auth.signOut();
        widget.logoutCallback();
      },
      child: const Text('Sign out'),
    );
  }

  Widget _build() {
    return Column(
      children: <Widget>[
        _showUserProfile(),
        _showSignOutButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterChat'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Container(
        alignment: Alignment.center,
        child: _build(),
      ),
    );
  }
}
