import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Model/InstaUserModel.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<InstaUserModel> register({
    required String email,
    required String username,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    try {
      final user = InstaUserModel(
        uid: credential.user!.uid,
        email: email,
        username: username,
        createdAt: DateTime.now().toIso8601String(),
      );
      await _firestore
          .collection('insta_users')
          .doc(credential.user!.uid)
          .set(user.toFirestore());
      return user;
    } catch (e) {
      // Rollback auth user if Firestore write fails
      await credential.user?.delete();
      rethrow;
    }
  }

  Future<InstaUserModel?> login({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final doc = await _firestore
        .collection('insta_users')
        .doc(credential.user!.uid)
        .get();
    if (!doc.exists) return null;
    return InstaUserModel.fromFirestore(credential.user!.uid, doc.data()!);
  }
}
