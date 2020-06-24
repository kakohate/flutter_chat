import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat/models/message.dart';
import 'package:flutter_chat/models/user.dart';

abstract class BaseFirestore {
  Future<void> signUp(FirebaseUser firebaseUser);
  Future<User> getUserByUid(String uid);
  Stream<QuerySnapshot> getUsersStream();
  Stream<QuerySnapshot> getMessagesStream(String roomId);
  void setMessage(String roomId, Message message);
}

class FirestoreService extends BaseFirestore {
  @override
  Future<void> signUp(FirebaseUser firebaseUser) async {
    final QuerySnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .where('id', isEqualTo: firebaseUser.uid)
        .getDocuments();
    final List<DocumentSnapshot> documentSnapshot = querySnapshot.documents;
    if (documentSnapshot.isEmpty) {
      final DateTime now = DateTime.now();
      final User user = User(
        firebaseUser.uid.toString(),
        now,
        firebaseUser.displayName.toString(),
        photoUrl: firebaseUser.photoUrl.toString(),
        email: firebaseUser.email.toString(),
        phoneNumber: firebaseUser.phoneNumber.toString(),
      );
      Firestore.instance
          .collection('users')
          .document(firebaseUser.uid)
          .setData(user.toJson());
    }
    return;
  }

  @override
  Future<User> getUserByUid(String uid) async {
    final QuerySnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    final List<DocumentSnapshot> documentSnapshot = querySnapshot.documents;
    if (documentSnapshot.isNotEmpty) {
      return User.fromJson(documentSnapshot[0].data);
    }
    return null;
  }

  @override
  Stream<QuerySnapshot> getUsersStream() {
    return Firestore.instance.collection('users').snapshots();
  }

  @override
  Stream<QuerySnapshot> getMessagesStream(String roomId) {
    return Firestore.instance
        .collection('rooms')
        .document(roomId)
        .collection('messages')
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  @override
  void setMessage(String roomId, Message message) {
    Firestore.instance
        .collection('rooms')
        .document(roomId)
        .collection('messages')
        .add(message.toJson());
  }
}
