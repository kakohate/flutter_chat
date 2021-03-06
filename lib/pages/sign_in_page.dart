import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/services/auth.dart';
import 'package:flutter_chat/services/firestore.dart';
import 'package:flutter_chat/pages/home_page.dart';

class SignInPage extends StatefulWidget {
  static const String routeName = '/signIn';
  @override
  State createState() => SignInPageState();
}

class SignInPageArguments {
  const SignInPageArguments(this.auth, this.firestore);

  final BaseAuth auth;
  final BaseFirestore firestore;
}

class SignInPageState extends State<SignInPage> {
  Widget _build(BuildContext context, SignInPageArguments args) {
    final BaseAuth auth = args.auth;
    final BaseFirestore firestore = args.firestore;

    return Scaffold(
        appBar: AppBar(
          title: const Text('新規登録/ログイン'),
          backgroundColor: Colors.deepOrangeAccent,
        ),
        body: Container(
          alignment: Alignment.center,
          child: RaisedButton(
            onPressed: () async {
              final FirebaseUser firebaseUser = await auth.signInWithGoogle();
              firestore.signUp(firebaseUser);
              Navigator.pushReplacementNamed(context, HomePage.routeName,
                  arguments:
                      HomePageArguments(auth, firestore, firebaseUser.uid));
            },
            child: const Text('Sign in with Google'),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final SignInPageArguments args =
        ModalRoute.of(context).settings.arguments as SignInPageArguments;
    return _build(context, args);
  }
}
