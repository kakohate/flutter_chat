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
  Widget _showUserProfile(BaseFirestore firestore, String userId) {
    return FutureBuilder<User>(
      future: firestore.getUserByUid(userId),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data.name);
        }
        return const Text('NOT_LOGGED_IN');
      },
    );
  }

  Widget _showSignOutButton(BaseAuth auth, BaseFirestore firestore) {
    return RaisedButton(
      onPressed: () async {
        await auth.signOut();
        Navigator.pushReplacementNamed(context, SignInPage.routeName,
            arguments: SignInPageArguments(auth, firestore));
      },
      child: const Text('Sign out'),
    );
  }

  Widget _build(HomePageArguments args) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter_chat'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _showUserProfile(args.firestore, args.userId),
            _showSignOutButton(args.auth, args.firestore),
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
