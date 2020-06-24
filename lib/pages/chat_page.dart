import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/models/message.dart';
import 'package:flutter_chat/models/user.dart';
import 'package:flutter_chat/services/firestore.dart';

@immutable
class ChatPage extends StatefulWidget {
  static const String routeName = '/chat';
  @override
  State createState() => ChatPageState();
}

class ChatPageArguments {
  const ChatPageArguments(
      this.firestore, this.userId, this.partnerId, this.roomId);

  final BaseFirestore firestore;
  final String userId;
  final String partnerId;
  final String roomId;
}

class ChatPageState extends State<ChatPage> {
  final TextEditingController textEditingController = TextEditingController();

  void onSendMessage(ChatPageArguments args, String msg) {
    // メッセージが空の時はボタンを押しても何も起こらない
    if (msg.trim() == '') {
      return;
    }
    textEditingController.clear();
    final Message message = Message(args.userId, DateTime.now(), msg);
    args.firestore.setMessage(args.roomId, message);
  }

  Widget buildChatMessages(ChatPageArguments args) {
    return Flexible(
      child: StreamBuilder<QuerySnapshot>(
        stream: args.firestore.getMessagesStream(args.roomId),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final List<DocumentSnapshot> documents = snapshot.data.documents;
          return ListView.builder(
            reverse: true,
            itemBuilder: (BuildContext context, int index) {
              final Message message = Message.fromJson(documents[index].data);
              if (message.from == args.userId) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        child: Text(message.message),
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(220, 220, 220, 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.fromLTRB(20, 0, 12, 12),
                      ),
                    ),
                  ],
                );
              } else {
                // message.from == args.partnerId
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        child: Text(message.message),
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.fromLTRB(12, 0, 20, 12),
                      ),
                    ),
                  ],
                );
              }
            },
            itemCount: documents != null ? documents.length : 0,
          );
        },
      ),
    );
  }

  Widget buildTextInput(ChatPageArguments args) {
    return Container(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Flexible(
            child: Container(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: TextField(
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'メッセージを入力',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          Container(
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: () => onSendMessage(args, textEditingController.text),
            ),
          ),
        ],
      ),
    );
  }

  Widget _build(BuildContext context, ChatPageArguments args) {
    final Future<User> partner = args.firestore.getUserByUid(args.partnerId);
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<User>(
          future: partner,
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            return Text(snapshot.data.name);
          },
        ),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Column(
        children: <Widget>[
          buildChatMessages(args),
          buildTextInput(args),
        ],
      ),
      backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ChatPageArguments args =
        ModalRoute.of(context).settings.arguments as ChatPageArguments;
    return _build(context, args);
  }
}
