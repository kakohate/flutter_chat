import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    final BaseFirestore firestore = args.firestore;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ユーザー一覧'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Container(
          child: StreamBuilder<QuerySnapshot>(
        stream: firestore.getUsersStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              final User user =
                  User.fromJson(snapshot.data.documents[index].data);
              return Container(
                margin: const EdgeInsets.all(10.0),
                child: FlatButton(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Material(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadius.circular(25.0),
                        child: user.photoUrl == ''
                            ? Icon(
                                Icons.account_circle,
                                size: 50.0,
                              )
                            : CachedNetworkImage(
                                imageUrl: user.photoUrl,
                                placeholder:
                                    (BuildContext context, String url) =>
                                        const CircularProgressIndicator(),
                                height: 50.0,
                                width: 50.0,
                              ),
                      ),
                      Container(
                        child: Text(user.name),
                        margin: const EdgeInsets.all(10.0),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).push<Object>(
                      MaterialPageRoute<Object>(
                        builder: (BuildContext context) {
                          return Scaffold(
                            appBar: AppBar(),
                            body: Container(
                              alignment: Alignment.center,
                              child: Text(user.name),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            },
            itemCount: snapshot.data.documents.length,
          );
        },
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final HomePageArguments args =
        ModalRoute.of(context).settings.arguments as HomePageArguments;
    return _build(args);
  }
}
