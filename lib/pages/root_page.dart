import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/services/auth.dart';
import 'package:flutter_chat/services/firestore.dart';
import 'package:flutter_chat/pages/sign_in_page.dart';
import 'package:flutter_chat/pages/home_page.dart';

class RootPage extends StatefulWidget {
  const RootPage(this.auth, this.firestore);

  static const String routeName = '/';

  final BaseAuth auth;
  final BaseFirestore firestore;

  @override
  State createState() => RootPageState();
}

class RootPageState extends State<RootPage> {
  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then<void>((FirebaseUser user) => user == null
        ? Navigator.pushReplacementNamed(context, SignInPage.routeName,
            arguments: SignInPageArguments(widget.auth, widget.firestore))
        : Navigator.pushReplacementNamed(context, HomePage.routeName,
            arguments:
                HomePageArguments(widget.auth, widget.firestore, user.uid)));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
