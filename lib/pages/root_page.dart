import 'package:flutter/material.dart';
import 'package:flutterchat/pages/home_page.dart';
import 'package:flutterchat/pages/sign_in_page.dart';
import 'package:flutterchat/services/auth.dart';
import 'package:flutterchat/services/firestore.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
  final BaseAuth auth;
  final BaseFirestore firestore;

  RootPage(this.auth, this.firestore);

  @override
  State createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  var authStatus = AuthStatus.NOT_DETERMINED;
  var _userId = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) => setState(() {
          if (user != null) {
            _userId = user?.uid;
          }
          authStatus = user?.uid == null
              ? AuthStatus.NOT_LOGGED_IN
              : AuthStatus.LOGGED_IN;
        }));
  }

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) => setState(() {
      _userId = user?.uid;
    }));
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      _userId = "";
      authStatus = AuthStatus.NOT_LOGGED_IN;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_LOGGED_IN:
        return SignInPage(widget.auth, widget.firestore, loginCallback);
        break;
      case AuthStatus.LOGGED_IN:
        return HomePage(widget.auth, widget.firestore, logoutCallback, _userId);
        break;
      default:
        return Scaffold(
          body: Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
        );
    }
  }
}
