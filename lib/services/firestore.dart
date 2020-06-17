import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat/models/user.dart';

abstract class BaseFirestore {
  Future<void> signUp(FirebaseUser firebaseUser);
  Future<User> getUserByUid(String uid);
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
        .where('id', isEqualTo: uid)
        .getDocuments();
    final List<DocumentSnapshot> documentSnapshot = querySnapshot.documents;
    if (documentSnapshot.isNotEmpty) {
      final Map<String, dynamic> data =
          documentSnapshot[0] as Map<String, dynamic>;
      return User.fromJson(data);
    }
    return null;
  }
}
