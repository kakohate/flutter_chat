import 'package:flutter/material.dart';
import 'package:flutter_chat/pages/root_page.dart';
import 'package:flutter_chat/pages/home_page.dart';
import 'package:flutter_chat/pages/sign_in_page.dart';
import 'package:flutter_chat/services/auth.dart';
import 'package:flutter_chat/services/firestore.dart';

void main() => runApp(FlutterChat());

class FlutterChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        RootPage.routeName: (BuildContext context) =>
            RootPage(AuthService(), FirestoreService()),
        SignInPage.routeName: (BuildContext context) => SignInPage(),
        HomePage.routeName: (BuildContext context) => HomePage(),
      },
    );
  }
}
