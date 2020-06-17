import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat/models/user.dart';

abstract class BaseFirestore {
  Future<User> signUp(FirebaseUser firebaseUser);
  Future<User> getUserByUid(String uid);
}

class FirestoreService extends BaseFirestore {
  @override
  Future<User> signUp(FirebaseUser firebaseUser) async {
    final QuerySnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .where('id', isEqualTo: firebaseUser.uid)
        .getDocuments();
    final List<DocumentSnapshot> documentSnapshot = querySnapshot.documents;
    final DateTime now = DateTime.now();
    User user;
    if (documentSnapshot.isEmpty) {
      Firestore.instance
          .collection('users')
          .document(firebaseUser.uid)
          .setData(<String, dynamic>{
        'id': firebaseUser.uid,
        'name': firebaseUser.displayName,
        'photoUrl': firebaseUser.photoUrl,
        'createdAt': now.millisecondsSinceEpoch.toString(),
      });
      user = User(
        firebaseUser.uid,
        firebaseUser.displayName,
        firebaseUser.photoUrl,
        now,
      );
    } else {
      user = User(
        documentSnapshot[0]['id'].toString(),
        documentSnapshot[0]['name'].toString(),
        documentSnapshot[0]['photoUrl'].toString(),
        DateTime.fromMillisecondsSinceEpoch(
            int.parse(documentSnapshot[0]['createdAt'].toString())),
      );
    }
    return user;
  }

  @override
  Future<User> getUserByUid(String uid) async {
    final QuerySnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .where('id', isEqualTo: uid)
        .getDocuments();
    final List<DocumentSnapshot> documentSnapshot = querySnapshot.documents;
    if (documentSnapshot.isNotEmpty) {
      return User(
        documentSnapshot[0]['id'].toString(),
        documentSnapshot[0]['name'].toString(),
        documentSnapshot[0]['photoUrl'].toString(),
        DateTime.fromMillisecondsSinceEpoch(
            int.parse(documentSnapshot[0]['createdAt'].toString())),
      );
    }
    return null;
  }
}
