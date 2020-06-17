import 'package:flutter/material.dart';
import 'package:flutter_chat/pages/sign_in_page.dart';
import 'package:flutter_chat/services/auth.dart';
import 'package:flutter_chat/services/firestore.dart';
import 'package:flutter_chat/models/user.dart';

@immutable
class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  @override
  State createState() => HomePageState();
}

class HomePageArguments {
  const HomePageArguments(this.auth, this.firestore, this.userId);

  final BaseAuth auth;
  final BaseFirestore firestore;
  final String userId;
}

class HomePageState extends State<HomePage> {
  Widget _build(HomePageArguments args) {
    final BaseAuth auth = args.auth;
    final BaseFirestore firestore = args.firestore;
    final String userId = args.userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter_chat'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<User>(
              future: firestore.getUserByUid(userId),
              builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasData) {
                  return Text(snapshot.data.name);
                }
                return const Text('NOT_LOGGED_IN');
              },
            ),
            RaisedButton(
              onPressed: () async {
                await auth.signOut();
                Navigator.pushReplacementNamed(context, SignInPage.routeName,
                    arguments: SignInPageArguments(auth, firestore));
              },
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final HomePageArguments args =
        ModalRoute.of(context).settings.arguments as HomePageArguments;
    return _build(args);
  }
}
