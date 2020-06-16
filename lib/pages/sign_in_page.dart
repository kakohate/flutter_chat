import 'package:flutter/material.dart';
import 'package:flutterchat/services/auth.dart';
import 'package:flutterchat/services/firestore.dart';

class SignInPage extends StatefulWidget {
  final BaseAuth auth;
  final BaseFirestore firestore;
  final VoidCallback loginCallback;

  SignInPage(this.auth, this.firestore, this.loginCallback);

  @override
  State createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  Widget _showSignInWithGoogleButton() {
    return RaisedButton(
      onPressed: () async {
        final firebaseUser = await widget.auth.signInWithGoogle();
        widget.firestore.signUp(firebaseUser);
        widget.loginCallback();
      },
      child: Text('Sign in with Google'),
    );
  }

  Widget _build() {
    return Container(
      alignment: Alignment.center,
      child: _showSignInWithGoogleButton(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('新規登録/ログイン'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: _build(),
    );
  }
}
