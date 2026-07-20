import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String role,
    required List<String> subjects,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final user = UserModel(
      uid: credential.user!.uid,
      name: name.trim(),
      phone: phone.trim(),
      email: email.trim(),
      role: role,
      subjects: role == "teacher" ? subjects : [],
      createdAt: Timestamp.now(),
    );

    await _firestore
        .collection("users")
        .doc(user.uid)
        .set(user.toJson());

    return credential;
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<UserModel?> getUser() async {
    final current = _auth.currentUser;

    if (current == null) return null;

    final doc = await _firestore
        .collection("users")
        .doc(current.uid)
        .get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return UserModel.fromJson(doc.data()!);
  }

  bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  Future<String?> getUserRole() async {
    final current = _auth.currentUser;

    if (current == null) return null;

    final doc = await _firestore
        .collection("users")
        .doc(current.uid)
        .get();

    if (!doc.exists) {
      return null;
    }

    return doc.data()?["role"];
  }
}