import 'package:flutter/material.dart';
import 'package:flutterchat/pages/root_page.dart';
import 'package:flutterchat/services/auth.dart';
import 'package:flutterchat/services/firestore.dart';

void main() => runApp(FlutterChat());

class FlutterChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RootPage(AuthService(), FirestoreService()),
    );
  }
}
