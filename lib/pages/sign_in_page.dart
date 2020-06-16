import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/services/auth.dart';
import 'package:flutterchat/services/firestore.dart';

class SignInPage extends StatefulWidget {
  const SignInPage(this.auth, this.firestore, this.loginCallback);

  final BaseAuth auth;
  final BaseFirestore firestore;
  final VoidCallback loginCallback;

  @override
  State createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  Widget _showSignInWithGoogleButton() {
    return RaisedButton(
      onPressed: () async {
        final FirebaseUser firebaseUser = await widget.auth.signInWithGoogle();
        widget.firestore.signUp(firebaseUser);
        widget.loginCallback();
      },
      child: const Text('Sign in with Google'),
    );
  }

  Widget _build() {
    return Center(
      child: _showSignInWithGoogleButton(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新規登録/ログイン'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: _build(),
    );
  }
}
