import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterchat/models/user.dart';

abstract class BaseFirestore {
  Future<User> signUp(FirebaseUser firebaseUser);
  Future<User> getUserByUid(String uid);
}

class FirestoreService extends BaseFirestore {
  Future<User> signUp(FirebaseUser firebaseUser) async {
    final querySnapshot = await Firestore.instance
        .collection('users')
        .where('id', isEqualTo: firebaseUser.uid)
        .getDocuments();
    final documentSnapshot = querySnapshot.documents;
    final now = DateTime.now();
    User user;
    if (documentSnapshot.isEmpty) {
      Firestore.instance
          .collection('users')
          .document(firebaseUser.uid)
          .setData({
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

  Future<User> getUserByUid(String uid) async{
    final querySnapshot = await Firestore.instance
        .collection('users')
        .where('id', isEqualTo: uid)
        .getDocuments();
    final documentSnapshot = querySnapshot.documents;
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
